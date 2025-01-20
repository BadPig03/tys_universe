local BlazeFly = TYU:NewModEntity("Blaze Fly", "BLAZE_FLY")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs

function BlazeFly:FamiliarInit(familiar)
    local sprite = familiar:GetSprite()
    sprite:Play("Appear", true)
end
BlazeFly:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BlazeFly.FamiliarInit, ModEntityIDs.BLAZE_FLY.Variant)

function BlazeFly:FamiliarUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()
    local rng = familiar:GetDropRNG()
    if sprite:IsFinished("Appear") then
        sprite:Play("Fly", true)
    end
    if sprite:IsFinished("Attack") or sprite:IsFinished("Attack2") then
        sprite:Play("Fly", true)
    end
    if familiar.FrameCount % 45 == 0 and sprite:IsPlaying("Fly") then
        if rng:RandomInt(100) < 55 then
            sprite:Play("Attack", true)
        else
            sprite:Play("Attack2", true)
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_FLAMETHROWER_START, 0.6)
        end
    end
    if sprite:IsEventTriggered("Shoot") then
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, familiar.Position, Vector(0, 0), player)
    end
    if sprite:IsEventTriggered("ShootWave") then
        for i = 0, 3 do
            local fireWave = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0, familiar.Position, Vector(0, 0), player):ToEffect()
            fireWave.Rotation = 90 * i + ((familiar.Coins % 2 == 0 and 45) or 0)
        end
        familiar:AddCoins(1)
    end
    if familiar.Coins >= 64 then
        familiar.Coins = 0
    end
    familiar:MoveDiagonally(1 / math.sqrt(2))
end
BlazeFly:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BlazeFly.FamiliarUpdate, ModEntityIDs.BLAZE_FLY.Variant)

function BlazeFly:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not source or not source.Entity or not source.Entity:ToEffect() or source.Entity.Variant ~= EffectVariant.FIRE_JET or not source.Entity.SpawnerEntity or not source.Entity.SpawnerEntity:ToPlayer() then
		return
	end
    return false
end
BlazeFly:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, BlazeFly.PrePlayerTakeDamage)

function BlazeFly:EntityTakeDamage(entity, amount, flags, source, countdown)
	if not source or not source.Entity or not source.Entity:ToEffect() or source.Entity.Variant ~= EffectVariant.FIRE_JET or not source.Entity.SpawnerEntity or not source.Entity.SpawnerEntity:ToPlayer() or entity.Variant ~= FamiliarVariant.LOST_SOUL then
        return
    end
    return false
end
BlazeFly:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BlazeFly.EntityTakeDamage, EntityType.ENTITY_FAMILIAR)

function BlazeFly:PreFamiliarCollision(familiar, collider, low)
    local player = familiar.Player
    local multiplier = familiar:GetMultiplier()
    if not Entities.IsValidEnemy(collider) then
        return
    end
    if collider.FrameCount % 5 ~= 0 then
        return
    end
    collider:TakeDamage(7 * multiplier, DamageFlag.DAMAGE_FIRE, EntityRef(familiar), 0)
    collider:AddBurn(EntityRef(player), 63, player.Damage * 2)
end
BlazeFly:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, BlazeFly.PreFamiliarCollision, ModEntityIDs.BLAZE_FLY.Variant)

return BlazeFly