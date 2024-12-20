local Collectibles = TYU:RegisterNewClass()

local wakeUpBannedItems = {
    [CollectibleType.COLLECTIBLE_SKELETON_KEY] = true,
    [CollectibleType.COLLECTIBLE_DOLLAR] = true,
    [CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = true,
    [CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = true,
    [CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = true,
    [CollectibleType.COLLECTIBLE_PYRO] = true,
    [CollectibleType.COLLECTIBLE_MOMS_KEY] = true,
    [CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = true,
    [CollectibleType.COLLECTIBLE_GOAT_HEAD] = true,
    [CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW] = true,
    [CollectibleType.COLLECTIBLE_THERES_OPTIONS] = true,
    [CollectibleType.COLLECTIBLE_BLACK_CANDLE] = true,
    [CollectibleType.COLLECTIBLE_D100] = true,
    [CollectibleType.COLLECTIBLE_MIND] = true,
    [CollectibleType.COLLECTIBLE_DIPLOPIA] = true,
    [CollectibleType.COLLECTIBLE_CAR_BATTERY] = true,
    [CollectibleType.COLLECTIBLE_CHARGED_BABY] = true,
    [CollectibleType.COLLECTIBLE_RUNE_BAG] = true,
    [CollectibleType.COLLECTIBLE_CHAOS] = true,
    [CollectibleType.COLLECTIBLE_MORE_OPTIONS] = true,
    [CollectibleType.COLLECTIBLE_TELEPORT_2] = true,
    [CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS] = true,
    [CollectibleType.COLLECTIBLE_SACK_HEAD] = true,
    [CollectibleType.COLLECTIBLE_EDENS_SOUL] = true,
    [CollectibleType.COLLECTIBLE_EUCHARIST] = true,
    [CollectibleType.COLLECTIBLE_SACK_OF_SACKS] = true,
    [CollectibleType.COLLECTIBLE_MYSTERY_GIFT] = true,
    [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = true,
    [CollectibleType.COLLECTIBLE_MR_ME] = true,
    [CollectibleType.COLLECTIBLE_SCHOOLBAG] = true,
    [CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = true,
    [CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = true,
    [CollectibleType.COLLECTIBLE_RED_KEY] = true,
    [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = true,
    [CollectibleType.COLLECTIBLE_STAIRWAY] = true,
    [CollectibleType.COLLECTIBLE_MERCURIUS] = true,
    [CollectibleType.COLLECTIBLE_ETERNAL_D6] = true,
    [CollectibleType.COLLECTIBLE_BIRTHRIGHT] = true,
    [CollectibleType.COLLECTIBLE_GENESIS] = true,
    [CollectibleType.COLLECTIBLE_CARD_READING] = true,
    [CollectibleType.COLLECTIBLE_ECHO_CHAMBER] = true,
    [CollectibleType.COLLECTIBLE_ISAACS_TOMB] = true,
    [CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING] = true,
    [CollectibleType.COLLECTIBLE_KEEPERS_SACK] = true,
    [CollectibleType.COLLECTIBLE_EVERYTHING_JAR] = true,
    [CollectibleType.COLLECTIBLE_ANIMA_SOLA] = true,
    [CollectibleType.COLLECTIBLE_D6] = true,
    [CollectibleType.COLLECTIBLE_VOID] = true,
    [CollectibleType.COLLECTIBLE_D_INFINITY] = true,
    [CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1] = true,
    [CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_2] = true,
    [CollectibleType.COLLECTIBLE_MOMS_SHOVEL] = true,
    [CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE] = true,
    [CollectibleType.COLLECTIBLE_R_KEY] = true,
    [CollectibleType.COLLECTIBLE_URN_OF_SOULS] = true,
    [CollectibleType.COLLECTIBLE_GLITCHED_CROWN] = true,
    [CollectibleType.COLLECTIBLE_SACRED_ORB] = true,
    [CollectibleType.COLLECTIBLE_ABYSS] = true,
    [CollectibleType.COLLECTIBLE_FLIP] = true,
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = true,
    [TYU.ModItemIDs.BEGGAR_MASK] = true,
    [TYU.ModItemIDs.CROWN_OF_KINGS] = true,
    [TYU.ModItemIDs.ORDER] = true,
    [TYU.ModItemIDs.HADES_BLADE] = true,
    [TYU.ModItemIDs.MIRRORING] = true,
    [TYU.ModItemIDs.MIRRORING_SHARD] = true,
    [TYU.ModItemIDs.PLANETARIUM_TELESCOPE] = true,
    [TYU.ModItemIDs.THE_GOSPEL_OF_JOHN] = true,
    [TYU.ModItemIDs.WAKE_UP] = true
}

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
        itemPoolType = TYU:GetGlobalLibData("Order")[TYU.LEVEL:GetStage()]
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
    maxCount = maxCount or math.maxinteger
    local count = math.min(maxCount, player:GetCollectibleNum(id) + player:GetEffects():GetCollectibleEffectNum(id))
    local rng = player:GetCollectibleRNG(id)
    player:CheckFamiliar(variant, count, RNG(rng:Next()), TYU.ITEMCONFIG:GetCollectible(id))
end

function Collectibles.GetNearestDevilDeal(position, distance)
    local minDistance = distance or 192
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



function Collectibles.GetAngelRoomCollectible(rng)
    local itemID = CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL
    local itemList = {}
    for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(ItemPoolType.POOL_ANGEL)) do
        local itemID = itemTable.itemID
        if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID).Quality >= 3 and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
            table.insert(itemList, itemID)
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
    return itemID
end

function Collectibles.GetOffensiveCollectible(rng)
    local itemID = CollectibleType.COLLECTIBLE_BREAKFAST
    local itemList = {}
    for i = 1, TYU.ITEMCONFIG:GetCollectibles().Size - 1 do
        if ItemConfig.Config.IsValidCollectible(i) and TYU.ITEMCONFIG:GetCollectible(i).Quality >= 3 and TYU.ITEMCONFIG:GetCollectible(i):HasTags(ItemConfig.TAG_OFFENSIVE) and TYU.ITEMCONFIG:GetCollectible(i).Type ~= ItemType.ITEM_ACTIVE and not wakeUpBannedItems[i] and TYU.ITEMPOOL:CanSpawnCollectible(i, false) then
            table.insert(itemList, i)
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
    if itemID == CollectibleType.COLLECTIBLE_BREAKFAST then
        return CollectibleType.COLLECTIBLE_PENTAGRAM
    end
    TYU.ITEMPOOL:RemoveCollectible(itemID)
    return itemID
end

function Collectibles.GetOffensiveCollectibleEx(rng, angel)
    local itemPoolType = (angel and ItemPoolType.POOL_ANGEL) or ItemPoolType.POOL_DEVIL
    local itemID = CollectibleType.COLLECTIBLE_BREAKFAST
    local itemList = {}
    for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(itemPoolType)) do
        local itemID = itemTable.itemID
        if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID).Quality >= 3 and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_OFFENSIVE) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and not wakeUpBannedItems[itemID] and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
            table.insert(itemList, itemID)
        end
    end
    itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
    if itemID == CollectibleType.COLLECTIBLE_BREAKFAST then
        return (angel and CollectibleType.COLLECTIBLE_IMMACULATE_HEART) or CollectibleType.COLLECTIBLE_PENTAGRAM
    end
    return itemID
end

return Collectibles