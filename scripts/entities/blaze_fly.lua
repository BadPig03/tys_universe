local Lib = TYU
local BlazeFly = Lib:NewModEntity("Blaze Fly", "BLAZEFLY")

function BlazeFly:FamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()
    local player = familiar.Player
    local rng = familiar:GetDropRNG()
    local multiplier = familiar:GetMultiplier()
    if sprite:IsFinished("Appear") then
        sprite:Play("Fly", true)
    end
    if sprite:IsFinished("Attack") or sprite:IsFinished("Attack2") then
        sprite:Play("Fly", true)
    end
    if familiar.FrameCount % 30 == 0 and sprite:IsPlaying("Fly") then
        if rng:RandomInt(90) < 60 then
            sprite:Play("Attack", true)
        else
            sprite:Play("Attack2", true)
            player:PlayDelayedSFX(SoundEffect.SOUND_FLAMETHROWER_START, 2, 0, 0.6)
        end
    end
    if sprite:IsEventTriggered("Shoot") then
        Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, familiar.Position, Vector(0, 0), player)
    end
    if sprite:IsEventTriggered("ShootWave") then
        for i = 0, 3 do
            local fireWave = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0, familiar.Position, Vector(0, 0), player):ToEffect()
            fireWave.Rotation = 90 * i + ((familiar.Coins % 2 == 0 and 45) or 0)
        end
        familiar:AddCoins(1)
    end
    if familiar.Coins >= 64 then
        familiar.Coins = 0
    end
    familiar:MoveDiagonally(1 / math.sqrt(2))
end
BlazeFly:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BlazeFly.FamiliarUpdate, Lib.ModEntityIDs.BLAZEFLY.Variant)

function BlazeFly:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not source or not source.Entity or not source.Entity:ToEffect() or source.Entity.Variant ~= EffectVariant.FIRE_JET or not source.Entity.SpawnerEntity or not source.Entity.SpawnerEntity:ToPlayer() then
		return
	end
    return false
end
BlazeFly:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, BlazeFly.PrePlayerTakeDamage)

function BlazeFly:PreFamiliarCollision(familiar, collider, low)
    local player = familiar.Player
    local multiplier = familiar:GetMultiplier()
    if not Lib.Entities.IsValidEnemy(collider) then
        return
    end
    if collider.FrameCount % 5 == 0 then
        collider:TakeDamage(7 * multiplier, DamageFlag.DAMAGE_FIRE, EntityRef(familiar), 0)
        collider:AddBurn(EntityRef(player), 63, player.Damage * 2)
    end
end
BlazeFly:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, BlazeFly.PreFamiliarCollision, Lib.ModEntityIDs.BLAZEFLY.Variant)

return BlazeFly