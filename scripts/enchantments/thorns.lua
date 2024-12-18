local Lib = TYU
local Thorns = Lib:NewModEnchantment("Thorns", "THORNS")

local function GetEnemyFromSource(source)
    local directEntity = source.Entity
    if directEntity then
        if directEntity.SpawnerEntity and directEntity.SpawnerEntity:ToNPC() and not directEntity.SpawnerEntity:IsDead() then
            return directEntity.SpawnerEntity and directEntity.SpawnerEntity:ToNPC()
        end
        if directEntity:ToNPC() then
            return directEntity:ToNPC()
        end
    end
    return nil
end

function Thorns:PostEntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    local enemy = GetEnemyFromSource(source)
    if not player or player:HasCurseMistEffect() or not enemy then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.THORNS)
    if count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(90) < 30 * count then
        enemy:TakeDamage(player.Damage * (1.2 + 0.6 * count) + 6 + 3 * count, DamageFlag.DAMAGE_SPIKES, EntityRef(player), 0)
    end
end
Thorns:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, Thorns.PostEntityTakeDamage, EntityType.ENTITY_PLAYER)

return Thorns