local Lib = TYU
local BlastProtection = Lib:NewModEnchantment("Blast Protection", "BLAST_PROTECTION")

function BlastProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or player:HasCurseMistEffect() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.BLAST_PROTECTION)
    if (flags & DamageFlag.DAMAGE_EXPLOSION ~= DamageFlag.DAMAGE_EXPLOSION and flags & DamageFlag.DAMAGE_TNT ~= DamageFlag.DAMAGE_TNT) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 25 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
BlastProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BlastProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return BlastProtection