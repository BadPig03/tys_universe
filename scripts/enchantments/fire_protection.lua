local FireProtection = TYU:NewModEnchantment("Fire Protection", "FIRE_PROTECTION")
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs

function FireProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if Utils.HasCurseMist() or not player then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(ModEnchantmentIDs.FIRE_PROTECTION)
    if Utils.HasFlags(flags, DamageFlag.DAMAGE_FIRE, true) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 25 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
FireProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FireProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return FireProtection