local StickyBall = TYU:NewModItem("Sticky Ball", "STICKY_BALL")

local Entities = TYU.Entities

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModTearFlags = TYU.ModTearFlags

local PrivateField = {}

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "StickyBall", ...)
end

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "StickyBall", ...)
end

do
    PrivateField.LevelSprite = Sprite("gfx/effects/sticky_ball_level_text.anm2", true)
    PrivateField.LevelSprite:Play("Idle", true)

    PrivateField.TearVariantPriority = {
        [TearVariant.BOBS_HEAD] = 99999,
        [TearVariant.CHAOS_CARD] = 99999,
        [TearVariant.STONE] = 99999,
        [TearVariant.MULTIDIMENSIONAL] = 99999,
        [TearVariant.BELIAL] = 99999,
        [TearVariant.BALLOON] = 99999,
        [TearVariant.BALLOON_BRIMSTONE] = 99999,
        [TearVariant.BALLOON_BOMB] = 99999,
        [TearVariant.GRIDENT] = 99999,
        [TearVariant.KEY] = 99999,
        [TearVariant.KEY_BLOOD] = 99999,
        [TearVariant.ERASER] = 99999,
        [TearVariant.FIRE] = 99999,
        [TearVariant.SWORD_BEAM] = 99999,
        [TearVariant.TECH_SWORD_BEAM] = 99999,
        [TearVariant.FETUS] = 99999,
        [ModEntityIDs.STICKY_BALL_TEAR.Variant] = 4,
        [TearVariant.EGG] = 3,
        [TearVariant.COIN] = 3,
        [TearVariant.NEEDLE] = 3,
        [TearVariant.TOOTH] = 2,
        [TearVariant.RAZOR] = 2,
        [TearVariant.BLACK_TOOTH] = 2,
        [TearVariant.FIST] = 2,
        [TearVariant.GODS_FLESH] = 1,
        [TearVariant.GODS_FLESH_BLOOD] = 1,
        [TearVariant.EXPLOSIVO] = 1,
        [TearVariant.BOOGER] = 1,
        [TearVariant.SPORE] = 1,
        [TearVariant.EYE] = 0.5,
        [TearVariant.EYE_BLOOD] = 0.5,
        [TearVariant.BLUE] = 0,
        [TearVariant.BLOOD] = 0,
        [TearVariant.METALLIC] = 0,
        [TearVariant.FIRE_MIND] = 0,
        [TearVariant.DARK_MATTER] = 0,
        [TearVariant.MYSTERIOUS] = 0,
        [TearVariant.SCHYTHE] = 0,
        [TearVariant.LOST_CONTACT] = 0,
        [TearVariant.CUPID_BLUE] = 0,
        [TearVariant.CUPID_BLOOD] = 0,
        [TearVariant.NAIL] = 0,
        [TearVariant.PUPULA] = 0,
        [TearVariant.PUPULA_BLOOD] = 0,
        [TearVariant.DIAMOND] = 0,
        [TearVariant.NAIL_BLOOD] = 0,
        [TearVariant.GLAUCOMA] = 0,
        [TearVariant.GLAUCOMA_BLOOD] = 0,
        [TearVariant.BONE] = 0,
        [TearVariant.HUNGRY] = 0,
        [TearVariant.ICE] = 0,
        [TearVariant.ROCK] = 0
    }
end

do
    function PrivateField.ValidatePossibility(player, rng, multiplier)
        rng = rng or player:GetCollectibleRNG(ModItemIDs.STICKY_BALL)
        multiplier = multiplier or 1
        return rng:RandomFloat() < multiplier / math.max(1, 4 - math.floor(player.Luck / 4))
    end
    
    function PrivateField.IsNotColorApplicable(player)
        return player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) or player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) or player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) or player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) or player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE)
    end
end

function StickyBall:PostFireTear(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) then
        return
    end
    if not PrivateField.ValidatePossibility(player) then
        return
    end
    if (PrivateField.TearVariantPriority[tear.Variant] or 0) <= PrivateField.TearVariantPriority[ModEntityIDs.STICKY_BALL_TEAR.Variant] then
        tear:ChangeVariant(ModEntityIDs.STICKY_BALL_TEAR.Variant)
    end
    tear:AddTearFlags(ModTearFlags.TEAR_STICKYBALL)
end
StickyBall:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, StickyBall.PostFireTear)

function StickyBall:PostNPCUpdate(npc)
    local data = GetTempEntityLibData(npc)
    if not data then
        return
    end
    local hitCooldown = data.HitCooldown
    if hitCooldown > 0 then
        SetTempEntityLibData(npc, hitCooldown - 1, "HitCooldown")
    end
    local level = data.Level
    if level == 0 then
        return
    end
    local timeout = data.Timeout
    if timeout > 0 then
        SetTempEntityLibData(npc, timeout - 1, "Timeout")
        npc:SetColor(Color(1, 0.65, 0.8, 0.8, 0, 0, 0), 2, 1, false, true)
    else
        SetTempEntityLibData(npc, 0, "Level")
    end
end
StickyBall:AddCallback(ModCallbacks.MC_NPC_UPDATE, StickyBall.PostNPCUpdate)

function StickyBall:PostNPCRender(npc, offset)
    local data = GetTempEntityLibData(npc)
    if not data or data.Level == 0 then
        return
    end
    local sprite = npc:GetSprite()
    if not sprite or not sprite:GetNullFrame("OverlayEffect") or (sprite:GetNullFrame("OverlayEffect"):GetPos():Length() == 0) then
        return
    end
    local renderPosition = Isaac.WorldToScreen(npc.Position) + sprite:GetNullFrame("OverlayEffect"):GetPos() + Vector(0, 2)
    PrivateField.LevelSprite:SetFrame(data.Level - 1)
    PrivateField.LevelSprite:Render(renderPosition)
end
StickyBall:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, StickyBall.PostNPCRender)

function StickyBall:PreLaserUpdate(laser)
    local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) or PrivateField.IsNotColorApplicable(player) then
        return
    end
    laser.Color = Color(1, 1, 1, 1, 0, 0, 0, 4, 1, 2.6, 1)
end
StickyBall:AddCallback(ModCallbacks.MC_PRE_LASER_UPDATE, StickyBall.PreLaserUpdate)

function StickyBall:PostBombUpdate(bomb)
	local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) or bomb:GetExplosionCountdown() > 0 or bomb:GetSprite():GetFrame() == 58 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(bomb.Position, bomb.RadiusMultiplier * player.TearRange / 4, EntityPartition.ENEMY)) do
        if Entities.IsValidEnemy(enemy) and PrivateField.ValidatePossibility(player, bomb:GetDropRNG(), (bomb.IsFetus and 2.5) or 100) then
            TYU.ModEntities.StickyBallTear:ApplyStickyLevel(enemy:ToNPC(), player, enemy:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, StickyBall.PostBombUpdate)

function StickyBall:PostRocketEffectUpdate(rocket)
	local player = rocket.SpawnerEntity and rocket.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) or rocket.PositionOffset.Y ~= 0 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(rocket.Position, player.TearRange / 4, EntityPartition.ENEMY)) do
        if Entities.IsValidEnemy(enemy) and PrivateField.ValidatePossibility(player, rocket:GetDropRNG(), 2.5) then
            TYU.ModEntities.StickyBallTear:ApplyStickyLevel(enemy:ToNPC(), player, enemy:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, StickyBall.PostRocketEffectUpdate, EffectVariant.ROCKET)

function StickyBall:PostLaserCollision(laser, collider, low)
    local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) or not Entities.IsValidEnemy(collider) then
        return
    end
    if not PrivateField.ValidatePossibility(player, laser:GetDropRNG()) then
        return
    end
    TYU.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
end
StickyBall:AddCallback(ModCallbacks.MC_POST_LASER_COLLISION, StickyBall.PostLaserCollision)

function StickyBall:PostKnifeCollision(knife, collider, low)
    local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(ModItemIDs.STICKY_BALL) or not Entities.IsValidEnemy(collider) then
        return
    end
    if knife.Variant == KnifeVariant.MOMS_KNIFE or knife.Variant == KnifeVariant.SUMPTORIUM then
        local triggerChance = (knife:IsFlying() and knife:GetKnifeDistance() / knife.MaxDistance < 0.8 and 1) or 0.6
        if PrivateField.ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            TYU.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
        end
    else
        local triggerChance = (knife:GetIsSwinging() and 1) or 0
        if PrivateField.ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            TYU.ModEntities.StickyBallTear:ApplyStickyLevel(collider:ToNPC(), player, collider:GetDropRNG())
        end
    end
end
StickyBall:AddCallback(ModCallbacks.MC_POST_KNIFE_COLLISION, StickyBall.PostKnifeCollision)

return StickyBall