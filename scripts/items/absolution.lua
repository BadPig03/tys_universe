local Absolution = TYU:NewModItem("Absolution", "ABSOLUTION")

local Players = TYU.Players
local Table = TYU.Table
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    PrivateField.SelfDamageFlags = {
        DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_IGNORE_ARMOR, -- Kamikaze
        DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE, -- BloodRights, DemonBeggar, BloodDonationMachine, HellGame
        DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG, -- IVBag, BloodBombs
        DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_NO_MODIFIERS, -- SharpPlug
        DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES, -- BreathOfLife, APoundOfFlesh
        DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE, -- DullRazor
        DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CURSED_DOOR, -- CurseRoom
        DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, -- MausoleumDoor
        DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES, -- SacrificeRoom
        DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE -- BloodSacrifice
    }

    function PrivateField.IsSelfDamage(damageFlags)
        for _, flags in ipairs(PrivateField.SelfDamageFlags) do
            if Utils.HasFlags(damageFlags, flags) then
                return true
            end
        end
        return false
    end
end

do
    function Absolution.AddToSelfDamageFlags(flags)
        if not Table.Contain(PrivateField.SelfDamageFlags, flags) then
            table.insert(PrivateField.SelfDamageFlags, flags)
        end
    end
end

function Absolution:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.ABSOLUTION) then
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
    if familiar.State ~= 2 then
        return
    end
    local player = familiar.Player
    if not player or player:HasInvincibility() or not player:HasCollectible(ModItemIDs.ABSOLUTION) or not player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
        return
    end
    Players.AddShield(player, 30)
end
Absolution:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Absolution.FamiliarUpdate, FamiliarVariant.DAMOCLES)

return Absolution