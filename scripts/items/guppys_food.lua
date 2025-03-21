local GuppysFood = TYU:NewModItem("Guppy's Food", "GUPPYS_FOOD")

local Stat = TYU.Stat

local ModItemIDs = TYU.ModItemIDs

function GuppysFood:EvaluateCache(player, cacheFlag)
    local num = player:GetCollectibleNum(ModItemIDs.GUPPYS_FOOD)
    if num == 0 or not player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + num
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Stat:AddSpeedUp(player, -0.03 * num)
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + num * 0.2
    end
end
GuppysFood:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, GuppysFood.EvaluateCache)

return GuppysFood