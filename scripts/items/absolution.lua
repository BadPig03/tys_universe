local Absolution = TYU:NewModItem("Absolution", "ABSOLUTION")

local Players = TYU.Players
local Table = TYU.Table
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do -- 私有方法
    -- 定义自伤表
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

    -- 判断是否为自伤
    function PrivateField.IsSelfDamage(damageFlags)
        for _, flags in ipairs(PrivateField.SelfDamageFlags) do
            if Utils.HasFlags(damageFlags, flags) then
                return true
            end
        end
        return false
    end
end

do -- 公有方法
    -- 允许外部加入新的 DamageFlags 到自伤表
    function Absolution.AddToSelfDamageFlags(flags)
        if not Table.Contain(PrivateField.SelfDamageFlags, flags) then
            table.insert(PrivateField.SelfDamageFlags, flags)
        end
    end
end

-- 回调：检测玩家受到的伤害
-- 如果是自伤，则降低自伤（最低半颗心）；否则将伤害修改为自伤
function Absolution:EntityTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.ABSOLUTION) then
        return -- 如果并非玩家，或者玩家没有赦罪，则返回
    end

    if PrivateField.IsSelfDamage(flags) then
        if amount > 0 then
            return { Damage = math.max(1, math.floor(amount / 2)) } -- 最低伤害保证为半颗心
        end
    else
        return { DamageFlags = flags | DamageFlag.DAMAGE_NO_PENALTIES } -- 将伤害转换为自伤
    end
end
Absolution:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Absolution.EntityTakeDamage, EntityType.ENTITY_PLAYER)

-- 回调：检测达摩克里斯之剑跟班的状态
-- 阻止达摩克里斯之剑伤害玩家，并提供1秒护盾
function Absolution:FamiliarUpdate(familiar)
    if familiar.State ~= 2 then
        return -- 如果达摩克里斯之剑跟班不处于掉落状态，则返回
    end

    local player = familiar.Player
    if not player or player:HasInvincibility() or not player:HasCollectible(ModItemIDs.ABSOLUTION) or not player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
        return -- 如果跟班没有玩家对象，或玩家处于无敌，或者玩家没有赦罪，或者玩家没有达摩克利斯之剑的被动道具形态，则返回
    end

    Players.AddShield(player, 30)
end
Absolution:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Absolution.FamiliarUpdate, FamiliarVariant.DAMOCLES)

return Absolution