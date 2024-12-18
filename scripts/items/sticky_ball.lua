local Lib = TYU
local StickyBall = Lib:NewModItem("Sticky Ball", "STICKY_BALL")

local levelSprite = Sprite("gfx/effects/sticky_ball_level_text.anm2", true)
levelSprite:Play("Idle", true)

local function ValidatePossibility(player, rng, multiplier)
    rng = rng or player:GetCollectibleRNG(Lib.ModItemIDs.STICKY_BALL)
    multiplier = multiplier or 1
    return rng:RandomFloat() < multiplier / math.max(1, 4 - math.floor(player.Luck / 4))
end

local function IsNotColorApplicable(player)
    return player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) or player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) or player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) or player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) or player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE)
end

function StickyBall:PostFireTear(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) then
        return
    end
    if not ValidatePossibility(player) then
        return
    end
    if (Lib.TearVariantPriority[tear.Variant] or 0) <= Lib.TearVariantPriority[Lib.ModEntityIDs.STICKY_BALL_TEAR.Variant] then
        tear:ChangeVariant(Lib.ModEntityIDs.STICKY_BALL_TEAR.Variant)
    end
    tear:AddTearFlags(Lib.ModTearFlags.TEAR_STICKYBALL)
end
StickyBall:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, StickyBall.PostFireTear)

function StickyBall:PostNPCUpdate(npc)
    local data = Lib:GetTempEntityLibData(npc, "StickyBall")
    if not data then
        return
    end
    local hitCooldown = data.HitCooldown
    if hitCooldown > 0 then
        Lib:SetTempEntityLibData(npc, hitCooldown - 1, "StickyBall", "HitCooldown")
    end
    local level = data.Level
    if level == 0 then
        return
    end
    local Timeout = data.Timeout
    if Timeout > 0 then
        Lib:SetTempEntityLibData(npc, Timeout - 1, "StickyBall", "Timeout")
        npc:SetColor(Lib.Colors.STICKY, 2, 1, false, true)
    else
        Lib:SetTempEntityLibData(npc, 0, "StickyBall", "Level")
    end
end
StickyBall:AddCallback(ModCallbacks.MC_NPC_UPDATE, StickyBall.PostNPCUpdate)

function StickyBall:PostNPCRender(npc, offset)
    local data = Lib:GetTempEntityLibData(npc, "StickyBall")
    if not data or data.Level == 0 then
        return
    end
    local sprite = npc:GetSprite()
    if not sprite or not sprite:GetNullFrame("OverlayEffect") or (sprite:GetNullFrame("OverlayEffect"):GetPos():Length() == 0) then
        return
    end
    local renderPosition = Isaac.WorldToScreen(npc.Position) + sprite:GetNullFrame("OverlayEffect"):GetPos() + Vector(0, 2)
    levelSprite:SetFrame(data.Level - 1)
    levelSprite:Render(renderPosition)
end
StickyBall:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, StickyBall.PostNPCRender)

function StickyBall:PreLaserUpdate(laser)
    local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) or IsNotColorApplicable(player) then
        return
    end
    laser.Color = Lib.Colors.PINK
end
StickyBall:AddCallback(ModCallbacks.MC_PRE_LASER_UPDATE, StickyBall.PreLaserUpdate)

function StickyBall:PostBombUpdate(bomb)
	local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) or bomb:GetExplosionCountdown() > 0 or bomb:GetSprite():GetFrame() == 58 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(bomb.Position, bomb.RadiusMultiplier * player.TearRange / 4, EntityPartition.ENEMY)) do
        if Lib.Entities.IsValidEnemy(enemy) and ValidatePossibility(player, bomb:GetDropRNG(), (bomb.IsFetus and 2.5) or 100) then
            Lib.ModEntities.StickyBallTear:ApplyStickyLevel(enemy:ToNPC(), player, enemy:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, StickyBall.PostBombUpdate)

function StickyBall:PostRocketEffectUpdate(rocket)
	local player = rocket.SpawnerEntity and rocket.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) or rocket.PositionOffset.Y ~= 0 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(rocket.Position, player.TearRange / 4, EntityPartition.ENEMY)) do
        if Lib.Entities.IsValidEnemy(enemy) and ValidatePossibility(player, rocket:GetDropRNG(), 2.5) then
            Lib.ModEntities.StickyBallTear:ApplyStickyLevel(enemy:ToNPC(), player, enemy:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, StickyBall.PostRocketEffectUpdate, EffectVariant.ROCKET)

function StickyBall:PostLaserCollision(laser, collider, low)
    local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) or not Lib.Entities.IsValidEnemy(collider) then
        return
    end
    if not ValidatePossibility(player, laser:GetDropRNG()) then
        return
    end
    Lib.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
end
StickyBall:AddCallback(ModCallbacks.MC_POST_LASER_COLLISION, StickyBall.PostLaserCollision)

function StickyBall:PostKnifeCollision(knife, collider, low)
    local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.STICKY_BALL) or not Lib.Entities.IsValidEnemy(collider) then
        return
    end
    if knife.Variant == KnifeVariant.MOMS_KNIFE or knife.Variant == KnifeVariant.SUMPTORIUM then
        local triggerChance = (knife:IsFlying() and knife:GetKnifeDistance() / knife.MaxDistance < 0.8) and 1 or 0.6
        if ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            Lib.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
        end
    else
        local triggerChance = knife:GetIsSwinging() and 1 or 0
        if ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            Lib.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_KNIFE_COLLISION, StickyBall.PostKnifeCollision)

return StickyBall