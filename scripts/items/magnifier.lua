local Magnifier = TYU:NewModItem("Magnifier", "MAGNIFIER")

local Collectibles = TYU.Collectibles

local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

function Magnifier:EvaluateCache(player, cacheFlag)
    Collectibles.CheckFamiliarFromCollectible(player, ModItemIDs.MAGNIFIER, ModEntityIDs.MAGNIFIER.Variant, 1)
end
Magnifier:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Magnifier.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return Magnifier