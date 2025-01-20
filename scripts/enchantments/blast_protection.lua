local BlastProtection = TYU:NewModEnchantment("Blast Protection", "BLAST_PROTECTION")

local Utils = TYU.Utils

local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs

function BlastProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if Utils.HasCurseMist() or not player then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(ModEnchantmentIDs.BLAST_PROTECTION)
    if (Utils.HasFlags(flags, DamageFlag.DAMAGE_EXPLOSION, true) and Utils.HasFlags(flags, DamageFlag.DAMAGE_TNT, true)) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) >= 25 * count then
        return
    end
    return { Damage = 0, DamageCountdown = 30 }
end
BlastProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BlastProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return BlastProtection