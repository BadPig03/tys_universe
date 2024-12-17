local Lib = TYU
local BoneInFishSteak = Lib:NewModItem("Bone-in Fish Steak", "BONEINFISHSTEAK")

function BoneInFishSteak:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if firstTime then
        player:AddBoneHearts(1)
        player:AddHearts(2)
    end
end
BoneInFishSteak:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, BoneInFishSteak.PostAddCollectible, Lib.ModItemIDs.BONEINFISHSTEAK)

function BoneInFishSteak:EvaluateCache(player, cacheFlag)
    local itemCount = player:GetCollectibleNum(Lib.ModItemIDs.BONEINFISHSTEAK)
    if itemCount == 0 then
        return
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            Lib.Stat:AddSpeedUp(player, -0.03 * itemCount)
        end
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            Lib.Stat:AddFlatDamage(player, itemCount)
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + itemCount
        end
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local count = Lib:GetPlayerLibData(player, "BoneInFishSteak", "Counts")
        if count and count > 0 then
            Lib.Stat:AddFlatTears(player, 0.5 * count)
        end
    end
end
BoneInFishSteak:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BoneInFishSteak.EvaluateCache)

function BoneInFishSteak:PostTrinketSmelted(player, count)
    if not player:HasCollectible(Lib.ModItemIDs.BONEINFISHSTEAK) or count < 0 then
        return
    end
    local count = Lib:GetPlayerLibData(player, "BoneInFishSteak", "Counts") or 0
    Lib:SetPlayerLibData(player, count + 1, "BoneInFishSteak", "Counts")
    player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_FAKE, EntityRef(player), 15)
    player:StopExtraAnimation()
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
end
BoneInFishSteak:AddCallback(Lib.Callbacks.TYU_POST_TRINKET_SMELTED, BoneInFishSteak.PostTrinketSmelted)

return BoneInFishSteak