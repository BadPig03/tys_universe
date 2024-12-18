local BoneInFishSteak = TYU:NewModItem("Bone-in Fish Steak", "BONE_IN_FISH_STEAK")
local Stat = TYU.Stat

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "BoneInFishSteak", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "BoneInFishSteak", ...)
end

function BoneInFishSteak:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(TYU.ModItemIDs.BONE_IN_FISH_STEAK)
    if count == 0 then
        return
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local count = GetPlayerLibData(player, "Counts")
        if count and count > 0 then
            Stat:AddFlatTears(player, 0.5 * count)
        end
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            Stat:AddSpeedUp(player, -0.03 * count)
        end
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            Stat:AddFlatDamage(player, count)
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + count
        end
    end
end
BoneInFishSteak:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BoneInFishSteak.EvaluateCache)

function BoneInFishSteak:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if firstTime then
        player:AddBoneHearts(1)
        player:AddHearts(2)
    end
end
BoneInFishSteak:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, BoneInFishSteak.PostAddCollectible, TYU.ModItemIDs.BONE_IN_FISH_STEAK)

function BoneInFishSteak:PostTrinketSmelted(player, count)
    if not player:HasCollectible(TYU.ModItemIDs.BONE_IN_FISH_STEAK) or count < 0 then
        return
    end
    local count = GetPlayerLibData(player, "Counts") or 0
    SetPlayerLibData(player, count + 1, "Counts")
    player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE, EntityRef(player), 15)
    player:StopExtraAnimation()
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
BoneInFishSteak:AddCallback(TYU.Callbacks.TYU_POST_TRINKET_SMELTED, BoneInFishSteak.PostTrinketSmelted)

return BoneInFishSteak