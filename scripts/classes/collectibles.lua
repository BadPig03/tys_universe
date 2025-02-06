local Collectibles = TYU:RegisterNewClass()

function Collectibles.GetCollectibleFromCurrentRoom(excludeTags, rng)
    if excludeTags == nil then
        excludeTags = ItemConfig.TAG_QUEST
    else
        excludeTags = excludeTags | ItemConfig.TAG_QUEST
    end
    local itemID
    local itemList = {}
    local room = TYU.GAME:GetRoom()
    local itemPoolType = room:GetItemPool(rng:Next(), false)
    if TYU.Players.AnyoneHasCollectible(TYU.ModItemIDs.ORDER) then
        itemPoolType = TYU.Utils.GetOrderItemPool()
    end
    for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(itemPoolType)) do
        local itemID = itemTable.itemID
        if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(excludeTags) and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
            table.insert(itemList, itemID)
        end
    end
    if #itemList == 0 then
        for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(ItemPoolType.POOL_TREASURE)) do
            local itemID = itemTable.itemID
            if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(excludeTags) and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
                table.insert(itemList, itemID)
            end
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
    TYU.ITEMPOOL:RemoveCollectible(itemID)
    return itemID
end

function Collectibles.CheckFamiliarFromCollectible(player, id, variant, maxCount)
    maxCount = maxCount or 64
    local count = math.min(maxCount, player:GetCollectibleNum(id) + player:GetEffects():GetCollectibleEffectNum(id))
    local rng = player:GetCollectibleRNG(id)
    player:CheckFamiliar(variant, count, RNG(rng:Next()), TYU.ITEMCONFIG:GetCollectible(id))
end

function Collectibles.GetNearestDevilDeal(position, distance)
    local minDistance = distance
    local collectible = nil
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = ent:ToPickup()
        if pickup:IsShopItem() and pickup.Price < 0 and pickup.Price ~= PickupPrice.PRICE_FREE and (pickup.Position - position):Length() < minDistance then
            minDistance = (pickup.Position - position):Length()
            collectible = pickup
        end
    end
    return collectible
end

function Collectibles.IsBlind(pickup)
    return pickup:IsBlind() or pickup:GetSprite():GetLayer("head"):GetSpritesheetPath() == "gfx/Items/Collectibles/questionmark.png"
end

function Collectibles.GetFamiliarsFromItemPool(itemPoolType, rng, defaultItem)
    local itemID = 1
    local itemList = {}
    for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(itemPoolType)) do
        local itemID = itemTable.itemID
        if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID).Type == ItemType.ITEM_FAMILIAR and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
            table.insert(itemList, itemID)
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next(), defaultItem, false, true)
    TYU.ITEMPOOL:RemoveCollectible(itemID)
    return itemID
end

function Collectibles.GetCollectibleFromRandomPool(lowQuality, highQuality, rng)
    local itemID = CollectibleType.COLLECTIBLE_BREAKFAST
    local itemList = {}
    for i = 1, TYU.ITEMCONFIG:GetCollectibles().Size - 1 do
        if ItemConfig.Config.IsValidCollectible(i) and TYU.ITEMCONFIG:GetCollectible(i).Quality <= highQuality and TYU.ITEMCONFIG:GetCollectible(i).Quality >= lowQuality and not TYU.ITEMCONFIG:GetCollectible(i):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMPOOL:CanSpawnCollectible(i, false) then
            table.insert(itemList, i)
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
    TYU.ITEMPOOL:RemoveCollectible(itemID)
    return itemID
end

return Collectibles