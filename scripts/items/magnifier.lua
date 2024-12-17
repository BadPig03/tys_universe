local Lib = TYU
local Magnifier = Lib:NewModItem("Magnifier", "MAGNIFIER")

function Magnifier:EvaluateCache(player, cacheFlag)
    local count = math.min(1, player:GetCollectibleNum(Lib.ModItemIDs.MAGNIFIER) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.MAGNIFIER))
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.MAGNIFIER)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.MAGNIFIER.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.MAGNIFIER))) do
        familiar.DepthOffset = 9999
        local sprite = familiar:GetSprite()
        sprite:Play("Appear", true)
    end
end
Magnifier:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Magnifier.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return Magnifier