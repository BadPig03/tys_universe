local Absolution = TYU:NewModItem("Absolution", "ABSOLUTION")
local Players = TYU.Players
local PrivateField = {}

do
    function PrivateField.IsSelfDamage(damageFlags)
        local selfDamageFlags = {
            ['Kamikaze'] = DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_IGNORE_ARMOR,
            ['BloodRights'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE,
            ['IVBag'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG,
            ['SharpPlug'] = DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_NO_MODIFIERS,
            ['BreathOfLife'] = DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES,
            ['APoundOfFlesh'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE,
            ['DullRazor'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE,
            ['BloodBombs'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG,
            ['Confessional'] = DamageFlag.DAMAGE_RED_HEARTS,
            ['DemonBeggar'] = DamageFlag.DAMAGE_RED_HEARTS,
            ['BloodDonationMachine'] = DamageFlag.DAMAGE_RED_HEARTS,
            ['HellGame'] = DamageFlag.DAMAGE_RED_HEARTS,
            ['CurseRoom'] = DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CURSED_DOOR,
            ['MausoleumDoor'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS,
            ['SacrificeRoom'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES,
            ['BloodSacrifice'] = DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE
        }
        for _, flags in pairs(selfDamageFlags) do
            if damageFlags & flags == flags then
                return true
            end
        end
        return false
    end
end

function Absolution:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(TYU.ModItemIDs.ABSOLUTION) then
        return
    end
    if PrivateField.IsSelfDamage(flags) then
        if amount > 0 then
            return { Damage = math.max(1, math.floor(amount / 2)) }
        end
    else
        return { DamageFlags = flags | DamageFlag.DAMAGE_NO_PENALTIES }
    end
end
Absolution:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Absolution.EntityTakeDamage, EntityType.ENTITY_PLAYER)

function Absolution:FamiliarUpdate(familiar)
    local player = familiar.Player
    if not player or not player:HasCollectible(TYU.ModItemIDs.ABSOLUTION) or not player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) or familiar.State ~= 2 or player:HasInvincibility() then
        return
    end
    Players.AddShield(player, 30)
end
Absolution:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Absolution.FamiliarUpdate, FamiliarVariant.DAMOCLES)

return Absolution