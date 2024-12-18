local Lib = TYU
local FireProtection = Lib:NewModEnchantment("Fire Protection", "FIRE_PROTECTION")

function FireProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or player:HasCurseMistEffect() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.FIRE_PROTECTION)
    if flags & DamageFlag.DAMAGE_FIRE ~= DamageFlag.DAMAGE_FIRE or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 25 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
FireProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FireProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return FireProtection