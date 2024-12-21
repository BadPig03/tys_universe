local ProjectileProtection = TYU:NewModEnchantment("Projectile Protection", "PROJECTILE_PROTECTION")
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    function PrivateField.IsSourceRelatedToProjectile(source, flags)
        if Utils.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
            return true
        end
        if source.Entity == nil then
            return false
        elseif source.Entity:ToProjectile() or source.Entity:ToLaser() then
            return true
        end
        return false
    end
end

function ProjectileProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if Utils.HasCurseMist() or not player then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(ModEnchantmentIDs.PROJECTILE_PROTECTION)
    if not PrivateField.IsSourceRelatedToProjectile(source, flags) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 20 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
ProjectileProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ProjectileProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return ProjectileProtection