local Lib = TYU
local ToolBox = Lib:NewModItem("Tool Box", "TOOLBOX")

function ToolBox:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.TOOLBOX) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.TOOLBOX)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.TOOLBOX)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.TOOLBOX.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.TOOLBOX))) do
        local sprite = familiar:GetSprite()
        sprite:Play("Appear", true)
        familiar:AddToFollowers()
    end
end
ToolBox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ToolBox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return ToolBox