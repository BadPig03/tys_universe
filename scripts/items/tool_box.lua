local Lib = TYU
local ToolBox = Lib:NewModItem("Tool Box", "TOOL_BOX")

function ToolBox:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.TOOL_BOX) + player:GetEffects():GetCollectibleEffectNum(Lib.ModItemIDs.TOOL_BOX)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.TOOL_BOX)
    for _, familiar in pairs(player:CheckFamiliarEx(Lib.ModEntityIDs.TOOL_BOX.Variant, count, RNG(rng:Next()), Lib.ITEMCONFIG:GetCollectible(Lib.ModItemIDs.TOOL_BOX))) do
        local sprite = familiar:GetSprite()
        sprite:Play("Appear", true)
        familiar:AddToFollowers()
    end
end
ToolBox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ToolBox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return ToolBox