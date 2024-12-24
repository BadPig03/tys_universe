local BrokenVision = TYU:NewModTrinket("Broken Vision", "BROKEN_VISION")
local ModTrinketIDs = TYU.ModTrinketIDs
local PrivateField = {}

do
    function PrivateField.GetLastPassiveItem(player)
        local historyItems = player:GetHistory():GetCollectiblesHistory()
        local lastItemID = CollectibleType.COLLECTIBLE_NULL
        for i = #historyItems, 1, -1 do
            if not historyItems[i]:IsTrinket() then
                local itemID = historyItems[i]:GetItemID()
                local itemConfig = TYU.ITEMCONFIG:GetCollectible(itemID)
                if not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Type ~= ItemType.ITEM_ACTIVE then
                    lastItemID = itemID
                    break
                end
            end
        end
        return lastItemID
    end
end

function BrokenVision:PreAddCollectible(type, charge, firstTime, slot, varData, player)
    if type <= 0 or TYU.ITEMCONFIG:GetCollectible(type).Type == ItemType.ITEM_ACTIVE or TYU.ITEMCONFIG:GetCollectible(type):HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.BROKEN_VISION)
    if multiplier == 0 then
        return
    end
    local rng = player:GetTrinketRNG(ModTrinketIDs.BROKEN_VISION)
    if not (rng:RandomInt(100) < 60 + multiplier * 10) then
        return
    end
    local lastItemID = PrivateField.GetLastPassiveItem(player)
    if lastItemID == CollectibleType.COLLECTIBLE_NULL then
        return
    end
    return { lastItemID, 0, false, slot, 0 }
end
BrokenVision:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, BrokenVision.PreAddCollectible)

return BrokenVision