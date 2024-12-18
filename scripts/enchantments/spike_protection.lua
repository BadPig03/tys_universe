local Lib = TYU
local SpikeProtection = Lib:NewModEnchantment("Spike Protection", "SPIKE_PROTECTION")

local function IsSourceRelatedToSpike(source, flags)
    if flags & DamageFlag.DAMAGE_SPIKES == DamageFlag.DAMAGE_SPIKES or flags & DamageFlag.DAMAGE_CURSED_DOOR == DamageFlag.DAMAGE_CURSED_DOOR or flags & DamageFlag.DAMAGE_CHEST == DamageFlag.DAMAGE_CHEST then
        return true
    end
    if source.Entity == nil then
        if source.Type == 0 and source.Variant == 25 then
            return true
        end
        return false
    end
    if source.Type == EntityType.ENTITY_POKY or source.Type == EntityType.ENTITY_WALL_HUGGER or source.Type == EntityType.ENTITY_GRUDGE or source.Type == EntityType.ENTITY_SPIKEBALL or source.Type == EntityType.ENTITY_MORNINGSTAR or (source.Type == EntityType.ENTITY_SINGE and source.Variant == 1) then
        return true
    end
    return false
end

function SpikeProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or player:HasCurseMistEffect() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.SPIKE_PROTECTION)
    if not IsSourceRelatedToSpike(source, flags) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 25 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
SpikeProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SpikeProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return SpikeProtection