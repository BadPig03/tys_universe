local ToolBox = TYU:NewModItem("Tool Box", "TOOL_BOX")

local Collectibles = TYU.Collectibles

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

function ToolBox:EvaluateCache(player, cacheFlag)
    Collectibles.CheckFamiliarFromCollectible(player, ModItemIDs.TOOL_BOX, ModEntityIDs.TOOL_BOX.Variant)
end
ToolBox:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ToolBox.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

return ToolBox