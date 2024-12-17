local Lib = TYU
local BrokenVision = Lib:NewModTrinket("Broken Vision", "BROKENVISION")

local function GetLastPassiveItem(player)
    local historyItems = player:GetHistory():GetCollectiblesHistory()
    local lastItemID = CollectibleType.COLLECTIBLE_NULL
    for i = #historyItems, 1, -1 do
        if not historyItems[i]:IsTrinket() then
            local itemID = historyItems[i]:GetItemID()
            local itemConfig = Lib.ITEMCONFIG:GetCollectible(itemID)
            if not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Type ~= ItemType.ITEM_ACTIVE then
                lastItemID = itemID
                break
            end
        end
    end
    return lastItemID
end

function BrokenVision:PreAddCollectible(type, charge, firstTime, slot, varData, player)
    if type <= 0 or Lib.ITEMCONFIG:GetCollectible(type).Type == ItemType.ITEM_ACTIVE or Lib.ITEMCONFIG:GetCollectible(type):HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    local multiplier = player:GetTrinketMultiplier(Lib.ModTrinketIDs.BROKENVISION)
    if multiplier == 0 then
        return
    end
    local rng = player:GetTrinketRNG(Lib.ModTrinketIDs.BROKENVISION)
    if not (rng:RandomInt(100) < 60 + multiplier * 10) then
        return
    end
    local lastItemID = GetLastPassiveItem(player)
    if lastItemID == CollectibleType.COLLECTIBLE_NULL then
        return
    end
    return { lastItemID, 0, false, slot, 0 }
end
BrokenVision:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, BrokenVision.PreAddCollectible)

return BrokenVision