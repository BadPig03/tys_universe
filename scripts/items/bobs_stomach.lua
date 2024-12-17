local Lib = TYU
local BobsStomach = Lib:NewModItem("Bob's Stomach", "BOBSSTOMACH")

local function SpawnChargeBar(player)
    local chargeBar = Lib.Entities.Spawn(Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.Type, Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.Variant, Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.SubType, player.Position + Lib.Players.GetChargeBarPosition(player, 1), player.Velocity, player):ToEffect()
    chargeBar.Parent = player
    chargeBar:FollowParent(player)
    chargeBar.DepthOffset = 102
    chargeBar:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | Lib.ModEntityFlags.FLAG_NO_PAUSE)
    local sprite = chargeBar:GetSprite()
    sprite:Play("Charging", true)
    for i = 1, 6 do
        sprite:Update()
    end
    sprite.PlaybackSpeed = Lib.Constants.CHARGEBAR_PLAYBACKRATE
end

local function GetChargerBar(player)
    for _, effect in pairs(Isaac.FindByType(Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.Type, Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.Variant, Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.SubType)) do
        if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
            return effect:ToEffect()
        end
    end
    return nil
end

local function DisappearChargeBar(chargeBar, player)
    local sprite = chargeBar:GetSprite()
    if not sprite:IsPlaying("Disappear") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Disappear", true)    
    end
    if player and sprite:IsPlaying("Disappear") then
        Lib.Entities.CreateTimer(function() chargeBar.Visible = false SpawnChargeBar(player) end, 4, 0, false)
    end
end

local function FireExplosiveTear(player)
    local direction = Lib:GetTempEntityLibData(player, "BobsStomach", "LastDirection")
    local markTarget = player:GetMarkedTarget()
    if markTarget then
        direction = markTarget.Position - player.Position
    end
    local tear = Lib.Entities.Spawn(EntityType.ENTITY_TEAR, TearVariant.EXPLOSIVO, 0, player.Position, direction:Normalized():Resized(10) + player:GetTearMovementInheritance(direction), player):ToTear()
    tear.TearFlags = player.TearFlags | TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP
	if tear:HasTearFlags(TearFlags.TEAR_ABSORB) then
        tear:ClearTearFlags(TearFlags.TEAR_ABSORB)
    end
    tear.Color = Lib.Colors.GREEN
    tear.Scale = 1.5
    tear.FallingAcceleration = 0
    tear.FallingSpeed = 0
    tear.Height = player.TearHeight
    tear.CollisionDamage = 15 + 2.5 * player.Damage
    Lib:SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 }, "BobsStomach")
end

function BobsStomach:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.BOBSSTOMACH) then
        return
    end
    local chargeBar = GetChargerBar(player)
    local chargeTime = Lib:GetTempEntityLibData(player, "BobsStomach", "ChargeTime") or 0
    if player:GetMarkedTarget() then
        if chargeBar and chargeBar:GetSprite():IsPlaying("StartCharged") and chargeBar:GetSprite():GetFrame() >= 1 then
            FireExplosiveTear(player)
            DisappearChargeBar(chargeBar, player)
        end
        if not chargeBar and chargeTime > 7 then
            SpawnChargeBar(player)
        end
        Lib:SetTempEntityLibData(player, chargeTime + 1, "BobsStomach", "ChargeTime")
        Lib:SetTempEntityLibData(player, player:GetShootingInput(), "BobsStomach", "LastDirection")
    else
        if Lib.Players.IsPressingFiringButton(player) then
            if not chargeBar and chargeTime > 10 then
                SpawnChargeBar(player)
            end
            Lib:SetTempEntityLibData(player, chargeTime + 1, "BobsStomach", "ChargeTime")
            Lib:SetTempEntityLibData(player, player:GetShootingInput(), "BobsStomach", "LastDirection")
        elseif chargeBar then
            if Lib:GetTempEntityLibData(player, "BobsStomach", "FullyCharged") then
                FireExplosiveTear(player)
            end
            DisappearChargeBar(chargeBar)
        else
            Lib:SetTempEntityLibData(player, 0, "BobsStomach", "ChargeTime")
        end
    end
end
BobsStomach:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BobsStomach.PostPlayerUpdate, 0)

return BobsStomach