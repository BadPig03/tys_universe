local TheGospelOfJohn = TYU:NewModItem("The Gospel of John", "THE_GOSPEL_OF_JOHN")

local Entities = TYU.Entities
local Reverie = TYU.Reverie
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModGiantBookIDs = TYU.ModGiantBookIDs

local PrivateField = {}

do
    function PrivateField.GetAngelRoomCollectible(rng, quality)
        local itemID = CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL
        local itemList = {}
        for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(ItemPoolType.POOL_ANGEL)) do
            local itemID = itemTable.itemID
            if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID).Quality >= quality and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
                table.insert(itemList, itemID)
            end
        end
        itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
        return itemID
    end
end

function TheGospelOfJohn:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then   
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local foundAnyCollectible = false
    local morphedAnyCollectible = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if ent.SubType > 0 then
            foundAnyCollectible = true
            local pickup = ent:ToPickup()
            local quality = 3
            if Reverie.WillPlayerNerf(player) then
                quality = 4
            end
            local newType = PrivateField.GetAngelRoomCollectible(rng, quality)
            if newType == CollectibleType.COLLECTIBLE_BREAKFAST then
                return { Discharge = false, Remove = false, ShowAnim = true }
            end
            local brokenHearts = TYU.ITEMCONFIG:GetCollectible(newType).Quality - 2
            if player:GetHeartLimit() > brokenHearts * 2 then
                morphedAnyCollectible = true
                player:AddBrokenHearts(brokenHearts)
                Entities.Morph(pickup, nil, nil, newType, true, true, false, false)
                TYU.ITEMPOOL:RemoveCollectible(newType)
                Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(2, 2, 2, 1)    
            end
        end
    end
    if foundAnyCollectible and not morphedAnyCollectible then
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
    if Utils.HasFlags(useFlags, UseFlag.USE_VOID, true) then
        TYU.ITEMOVERLAY.Show(ModGiantBookIDs.THE_GOSPEL_OF_JOHN, 3, player)
    end
    if not foundAnyCollectible then
        player:AddBrokenHearts(-1)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            player:AddBrokenHearts(-1)
        end
        return { Discharge = true, Remove = false, ShowAnim = true }
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 25 then
        player:AddItemWisp(TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_ANGEL, false), player.Position, true)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 25 then
        player:AddItemWisp(TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, false), player.Position, true)
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
TheGospelOfJohn:AddCallback(ModCallbacks.MC_USE_ITEM, TheGospelOfJohn.UseItem, ModItemIDs.THE_GOSPEL_OF_JOHN)

return TheGospelOfJohn