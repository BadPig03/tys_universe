local Bleh = TYU:NewModPill("Bleh", "BLEH")

local Entities = TYU.Entities
local Utils = TYU.Utils

local PrivateField = {}

local ModPillEffectIDs = TYU.ModPillEffectIDs

function PrivateField.GetRandomHistoryIndex(player)
    local rng = player:GetPillRNG(ModPillEffectIDs.BLEH)
    local restartTime = 0
    while restartTime < 3 do
        local history = player:GetHistory():GetCollectiblesHistory()
        local index = rng:RandomInt(1, #history)
        local item = history[index]
        local itemID = item:GetItemID()
        if item:IsTrinket() then
            return itemID, -1, true
        end
        local itemConfig = TYU.ITEMCONFIG:GetCollectible(itemID)
        if itemConfig.Type ~= ItemType.ITEM_ACTIVE and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
            return itemID, index, false
        end
        restartTime = restartTime + 1
    end
    return -1, -1, nil
end

function PrivateField.DropItemOrTrinket(player)
    local itemID, index, isTrinket = PrivateField.GetRandomHistoryIndex(player)
    if isTrinket then
        player:TryRemoveSmeltedTrinket(itemID)
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, itemID, Utils.FindFreePickupSpawnPosition(player.Position))
    elseif isTrinket == false then
        player:DropCollectibleByHistoryIndex(index - 1)
    end
    player:AnimateSad()
end

function Bleh:UsePill(pillEffect, player, useFlags, pillColor)
    PrivateField.DropItemOrTrinket(player)
    if Utils.HasFlags(pillColor, PillColor.PILL_GIANT_FLAG) then
        PrivateField.DropItemOrTrinket(player)
    end
end
Bleh:AddCallback(ModCallbacks.MC_USE_PILL, Bleh.UsePill, ModPillEffectIDs.BLEH)

return Bleh