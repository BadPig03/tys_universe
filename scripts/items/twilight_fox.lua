local Lib = TYU
local TwilightFox = Lib:NewModItem("Twilight Fox", "TWILIGHT_FOX")

function TwilightFox:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.TWILIGHT_FOX) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.TWILIGHT_FOX)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.TWILIGHT_FOX)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.TWILIGHT_FOX.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.TWILIGHT_FOX))) do
        local sprite = familiar:GetSprite()
        sprite:Play("Idle", true)
        familiar:AddToFollowers()
        familiar.DepthOffset = 9998
    end
end
TwilightFox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TwilightFox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return TwilightFox