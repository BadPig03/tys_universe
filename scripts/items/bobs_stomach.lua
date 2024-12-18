local BobsStomach = TYU:NewModItem("Bob's Stomach", "BOBS_STOMACH")
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local Constants = TYU.Constants
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModEntityFlags = TYU.ModEntityFlags
local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "BobsStomach", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "BobsStomach", ...)
end

do
    function PrivateField.SpawnChargeBar(player)
        local chargeBar = Entities.Spawn(ModEntityIDs.BOBS_STOMACH_CHARGEBAR.Type, ModEntityIDs.BOBS_STOMACH_CHARGEBAR.Variant, ModEntityIDs.BOBS_STOMACH_CHARGEBAR.SubType, player.Position + Players.GetChargeBarPosition(player, 1), player.Velocity, player):ToEffect()
        chargeBar.Parent = player
        chargeBar:FollowParent(player)
        chargeBar.DepthOffset = 102
        chargeBar:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | ModEntityFlags.FLAG_NO_PAUSE)
        local sprite = chargeBar:GetSprite()
        sprite:Play("Charging", true)
        for i = 1, 6 do
            sprite:Update()
        end
        sprite.PlaybackSpeed = Constants.CHARGEBAR_PLAYBACKRATE
    end

    function PrivateField.GetChargeBar(player)
        for _, effect in pairs(Isaac.FindByType(ModEntityIDs.BOBS_STOMACH_CHARGEBAR.Type, ModEntityIDs.BOBS_STOMACH_CHARGEBAR.Variant, ModEntityIDs.BOBS_STOMACH_CHARGEBAR.SubType)) do
            if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
                return effect:ToEffect()
            end
        end
        return nil
    end

    function PrivateField.DisappearChargeBar(chargeBar, player)
        local sprite = chargeBar:GetSprite()
        if not sprite:IsPlaying("Disappear") then
            sprite.PlaybackSpeed = 1
            sprite:Play("Disappear", true)    
        end
        if player and sprite:IsPlaying("Disappear") then
            Utils.CreateTimer(function()
                chargeBar.Visible = false
                PrivateField.SpawnChargeBar(player)
            end, 4, 0, false)
        end
    end

    function PrivateField.FireExplosiveTear(player)
        local direction = GetTempEntityLibData(player, "LastDirection")
        local markTarget = player:GetMarkedTarget()
        if markTarget then
            direction = markTarget.Position - player.Position
        end
        local tear = Entities.Spawn(EntityType.ENTITY_TEAR, TearVariant.EXPLOSIVO, 0, player.Position, direction:Normalized():Resized(10) + player:GetTearMovementInheritance(direction), player):ToTear()
        tear.TearFlags = player.TearFlags | TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP
        if tear:HasTearFlags(TearFlags.TEAR_ABSORB) then
            tear:ClearTearFlags(TearFlags.TEAR_ABSORB)
        end
        tear.Color = Constants.COLOR_GREEN
        tear.Scale = 1.5
        tear.FallingAcceleration = 0
        tear.FallingSpeed = 0
        tear.Height = player.TearHeight
        tear.CollisionDamage = 15 + 2.5 * player.Damage
        SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 })
    end
end

function BobsStomach:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.BOBS_STOMACH) then
        return
    end
    local chargeBar = PrivateField.GetChargeBar(player)
    local chargeTime = GetTempEntityLibData(player, "ChargeTime") or 0
    if player:GetMarkedTarget() then
        if chargeBar and chargeBar:GetSprite():IsPlaying("StartCharged") and chargeBar:GetSprite():GetFrame() >= 1 then
            PrivateField.FireExplosiveTear(player)
            PrivateField.DisappearChargeBar(chargeBar, player)
        end
        if not chargeBar and chargeTime > 7 then
            PrivateField.SpawnChargeBar(player)
        end
        SetTempEntityLibData(player, chargeTime + 1, "ChargeTime")
        SetTempEntityLibData(player, player:GetShootingInput(), "LastDirection")
    else
        if Players.IsPressingFiringButton(player) then
            if not chargeBar and chargeTime > 10 then
                PrivateField.SpawnChargeBar(player)
            end
            SetTempEntityLibData(player, chargeTime + 1, "ChargeTime")
            SetTempEntityLibData(player, player:GetShootingInput(), "LastDirection")
        elseif chargeBar then
            if GetTempEntityLibData(player, "FullyCharged") then
                PrivateField.FireExplosiveTear(player)
            end
            PrivateField.DisappearChargeBar(chargeBar)
        else
            SetTempEntityLibData(player, 0, "ChargeTime")
        end
    end
end
BobsStomach:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BobsStomach.PostPlayerUpdate, 0)

return BobsStomach