local SuspiciousStew = TYU:NewModItem("Suspicious Stew", "SUSPICIOUS_STEW")

local Foods = TYU.Foods
local Stat = TYU.Stat
local Utils = TYU.Utils

local ModNullItemIDs = TYU.ModNullItemIDs
local ModItemIDs = TYU.ModItemIDs

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "SuspiciousStew", ...)
end

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "SuspiciousStew", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Foods", ...)
end

function SuspiciousStew:EvaluateCache(player, cacheFlag)
    local stats = GetPlayerLibData(player)
    if stats == nil or not player:GetEffects():HasNullEffect(ModNullItemIDs.SUSPICIOUS_STEW_EFFECT) then
        return
    end
    local statsStandardValues = Foods.GetStatStandardValues()
    if cacheFlag == CacheFlag.CACHE_FIREDELAY and stats[1] > 0 then
        Stat:AddFlatTears(player, stats[1] * statsStandardValues[1])
    end
    if cacheFlag == CacheFlag.CACHE_DAMAGE and stats[2] > 0 then
        Stat:AddFlatDamage(player, stats[2] * statsStandardValues[2])
    end
    if cacheFlag == CacheFlag.CACHE_LUCK and stats[3] > 0 then
        player.Luck = player.Luck + stats[3] * statsStandardValues[3]
    end
    if cacheFlag == CacheFlag.CACHE_RANGE and stats[4] > 0 then
        player.TearRange = player.TearRange + stats[4] * statsStandardValues[4] * 40
    end
    if cacheFlag == CacheFlag.CACHE_SPEED and stats[5] > 0 then
        Stat:AddSpeedUp(player, stats[5] * statsStandardValues[5])
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED and stats[6] > 0 then
        player.ShotSpeed = player.ShotSpeed + stats[6] * statsStandardValues[6]
    end
end
SuspiciousStew:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SuspiciousStew.EvaluateCache)

function SuspiciousStew:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if itemID == ModItemIDs.SUSPICIOUS_STEW then
        if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_VOID) or activeSlot < ActiveSlot.SLOT_PRIMARY then
            return { Discharge = false, Remove = false, ShowAnim = false }
        end
        if GetPlayerLibData(player) == nil then
            SetPlayerLibData(player, { 0, 0, 0, 0, 0, 0 })
            player:GetEffects():AddNullEffect(ModNullItemIDs.SUSPICIOUS_STEW_EFFECT)
        end
        local combined = player:GetActiveItemDesc(activeSlot).VarData
        if combined == 0 then
            player:Die()
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_VAMP_GULP, 0.7)
            return { Discharge = true, Remove = true, ShowAnim = true }
        end
        local bank = Foods.ExtractValues(combined)
        for i = 1, 4 do
            local food = bank[i]
            local nourishmentValue = Foods.GetNourishmentValue(food)
            for j = 1, 6 do
                local value = GetPlayerLibData(player, j)
                SetPlayerLibData(player, value + nourishmentValue[j], j)    
            end
            Foods.ApplySpecialEffect(food, player, rng)
        end
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            player:AddSoulHearts(2)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            player:AddBlackHearts(2)
        end
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_VAMP_GULP, 0.7)
        return { Discharge = true, Remove = true, ShowAnim = true }    
    elseif itemID == CollectibleType.COLLECTIBLE_DIPLOPIA or itemID == CollectibleType.COLLECTIBLE_CROOKED_PENNY then
        for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ModItemIDs.SUSPICIOUS_STEW)) do
            local pickup = ent:ToPickup()
            if pickup:GetVarData() == 0 and pickup.FrameCount == 0 then
                local varData = GetGlobalLibData("Effects", tostring(pickup.InitSeed))
                pickup:SetVarData(varData)
            end
        end
    end
end
SuspiciousStew:AddCallback(ModCallbacks.MC_USE_ITEM, SuspiciousStew.UseItem)

return SuspiciousStew