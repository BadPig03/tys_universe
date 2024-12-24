local TwilightFox = TYU:NewModItem("Twilight Fox", "TWILIGHT_FOX")
local Collectibles = TYU.Collectibles
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

function TwilightFox:EvaluateCache(player, cacheFlag)
    Collectibles.CheckFamiliarFromCollectible(player, ModItemIDs.TWILIGHT_FOX, ModEntityIDs.TWILIGHT_FOX.Variant)
end
TwilightFox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TwilightFox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return TwilightFox