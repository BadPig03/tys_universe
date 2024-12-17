local Lib = TYU
local ProjectileProtection = Lib:NewModEnchantment("Projectile Protection", "PROJECTILEPROTECTION")

local function IsSourceRelatedToProjectile(source, flags)
    if flags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER then
        return true
    end
    if source.Entity == nil then
        return false
    elseif source.Entity:ToProjectile() or source.Entity:ToLaser() then
        return true
    end
    return false
end

function ProjectileProtection:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or player:HasCurseMistEffect() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.PROJECTILEPROTECTION)
    if not IsSourceRelatedToProjectile(source, flags) or amount == 0 or count == 0 then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTEDBOOK)
    if rng:RandomInt(100) < 20 * count then
        return { Damage = 0, DamageCountdown = 30 }
    end
end
ProjectileProtection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ProjectileProtection.EntityTakeDamage, EntityType.ENTITY_PLAYER)

return ProjectileProtection