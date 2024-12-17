local Lib = TYU
local BlazeFly = Lib:NewModItem("Blaze Fly", "BLAZEFLY")

function BlazeFly:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.BLAZEFLY) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.BLAZEFLY)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.BLAZEFLY)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.BLAZEFLY.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.BLAZEFLY))) do
        local sprite = familiar:GetSprite()
        sprite:Play("Appear", true)
    end
end
BlazeFly:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BlazeFly.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return BlazeFly