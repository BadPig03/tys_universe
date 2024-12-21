local SpikeProtection = TYU:NewModEnchantment("Spike Protection", "SPIKE_PROTECTION")
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    function PrivateField.IsSourceRelatedToSpike(source, flags)
        if Utils.HasFlags(flags, DamageFlag.DAMAGE_SPIKES) or Utils.HasFlags(flags, DamageFlag.DAMAGE_CURSED_DOOR) or Utils.HasFlags(flags, DamageFlag.DAMAGE_CHEST) then
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
end

function SpikeProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if Utils.HasCurseMist() or not player then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(ModEnchantmentIDs.SPIKE_PROTECTION)
    if not PrivateField.IsSourceRelatedToSpike(source, flags) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 25 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
SpikeProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SpikeProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return SpikeProtection