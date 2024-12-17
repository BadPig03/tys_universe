local Lib = TYU
local TwilightFox = Lib:NewModItem("Twilight Fox", "TWILIGHTFOX")

function TwilightFox:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.TWILIGHTFOX) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.TWILIGHTFOX)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.TWILIGHTFOX)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.TWILIGHTFOX.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.TWILIGHTFOX))) do
        local sprite = familiar:GetSprite()
        sprite:Play("Idle", true)
        familiar:AddToFollowers()
        familiar.DepthOffset = 9998
    end
end
TwilightFox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TwilightFox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return TwilightFox