local BlazeFly = TYU:NewModItem("Blaze Fly", "BLAZE_FLY")
local Collectibles = TYU.Collectibles
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

function BlazeFly:EvaluateCache(player, cacheFlag)
    Collectibles.CheckFamiliarFromCollectible(player, ModItemIDs.BLAZE_FLY, ModEntityIDs.BLAZE_FLY.Variant)
end
BlazeFly:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BlazeFly.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return BlazeFly