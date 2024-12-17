local BlazeFly = TYU:NewModItem("Blaze Fly", "BLAZEFLY")
local Collectibles = TYU.Collectibles

function BlazeFly:EvaluateCache(player, cacheFlag)
    Collectibles.CheckFamiliarFromCollectible(player, TYU.ModItemIDs.BLAZEFLY, TYU.ModEntityIDs.BLAZEFLY.Variant)
end
BlazeFly:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BlazeFly.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return BlazeFly