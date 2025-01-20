local Order = TYU:NewModItem("Order", "ORDER")

local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Order", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Order", ...)
end

do
    PrivateField.ItemPoolFlag = true

    PrivateField.ItemPoolName = {
        [1] = {
            [ItemPoolType.POOL_TREASURE] = "宝箱房",
            [ItemPoolType.POOL_SHOP] = "商店",
            [ItemPoolType.POOL_BOSS] = "头目房", 
            [ItemPoolType.POOL_DEVIL] = "恶魔房",
            [ItemPoolType.POOL_ANGEL] = "天使房",
            [ItemPoolType.POOL_DEMON_BEGGAR] = "恶魔乞丐",
            [ItemPoolType.POOL_SECRET] = "隐藏房",
            [ItemPoolType.POOL_LIBRARY] = "图书馆",
            [ItemPoolType.POOL_RED_CHEST] = "红箱子",
            [ItemPoolType.POOL_CURSE] = "诅咒房",
            [ItemPoolType.POOL_CRANE_GAME] = "夹娃娃机",
            [ItemPoolType.POOL_ULTRA_SECRET] = "究极隐藏房",
            [ItemPoolType.POOL_PLANETARIUM] = "星象房"
        },
        [2] = {
            [ItemPoolType.POOL_TREASURE] = "Treasure Room",
            [ItemPoolType.POOL_SHOP] = "Shop",
            [ItemPoolType.POOL_BOSS] = "Boss Room", 
            [ItemPoolType.POOL_DEVIL] = "Devil Room",
            [ItemPoolType.POOL_ANGEL] = "Angel Room",
            [ItemPoolType.POOL_DEMON_BEGGAR] = "Demon Beggar",
            [ItemPoolType.POOL_SECRET] = "Secret Room",
            [ItemPoolType.POOL_LIBRARY] = "Library",
            [ItemPoolType.POOL_RED_CHEST] = "Red Chest",
            [ItemPoolType.POOL_CURSE] = "Curse Room",
            [ItemPoolType.POOL_CRANE_GAME] = "Crane Game",
            [ItemPoolType.POOL_ULTRA_SECRET] = "Ultra Secret",
            [ItemPoolType.POOL_PLANETARIUM] = "Planetarium"
        }
    }

    function PrivateField.DisplayItemPool()
        local stage = TYU.LEVEL:GetStage()
        local itemPoolList = GetGlobalLibData()
        if Options.Language == "zh" then
            TYU.HUD:ShowFortuneText("本层道具池为"..PrivateField.ItemPoolName[1][itemPoolList[stage]])
        else
            TYU.HUD:ShowFortuneText("The item pool is", PrivateField.ItemPoolName[2][itemPoolList[stage]])
        end
    end

    function PrivateField.GetItemPools()
        local itemPoolList = { ItemPoolType.POOL_TREASURE, ItemPoolType.POOL_SHOP, ItemPoolType.POOL_BOSS, ItemPoolType.POOL_DEVIL, ItemPoolType.POOL_ANGEL, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_SECRET, ItemPoolType.POOL_LIBRARY, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_CURSE, ItemPoolType.POOL_CRANE_GAME, ItemPoolType.POOL_ULTRA_SECRET, ItemPoolType.POOL_PLANETARIUM }
        local list = {}
        local rng = RNG(TYU.SEEDS:GetStartSeed())
        for stage = 1, 13 do
            local type = rng:RandomInt(#itemPoolList) + 1
            list[stage] = itemPoolList[type]
            table.remove(itemPoolList, type)
            rng:Next()
        end
        return list
    end
end

function Order:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, Utils.FindFreePickupSpawnPosition(player.Position))
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, Utils.FindFreePickupSpawnPosition(player.Position))
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, Utils.FindFreePickupSpawnPosition(player.Position))
    Utils.CreateTimer(function()
        PrivateField.DisplayItemPool()
    end, 30, 0, false)
end
Order:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Order.PostAddCollectible, ModItemIDs.ORDER)

function Order:PostPlayerNewRoomTempEffects(player)
    if not player:HasCollectible(ModItemIDs.ORDER) or not Utils.IsStartingRoom() or not Utils.IsRoomFirstVisit() then
        return
    end
    Utils.CreateTimer(function()
        PrivateField.DisplayItemPool()
    end, 30, 0, false)
end
Order:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Order.PostPlayerNewRoomTempEffects)

function Order:PostGameStarted(continue)
    if continue then
        return
    end
    local list = PrivateField.GetItemPools()
    SetGlobalLibData(list)
end
Order:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Order.PostGameStarted)

function Order:PreGetCollectible(itemPoolType, decrease, seed)
    if not Players.AnyoneHasCollectible(ModItemIDs.ORDER) or Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
        return
    end
    local stage = TYU.LEVEL:GetStage()
    local itemPoolList = GetGlobalLibData() or PrivateField.GetItemPools()
    if not PrivateField.ItemPoolFlag or itemPoolType == itemPoolList[stage] then
        return
    end
    PrivateField.ItemPoolFlag = false
    local id = TYU.ITEMPOOL:GetCollectible(itemPoolList[stage], decrease, seed)
    PrivateField.ItemPoolFlag = true
    return id
end
Order:AddPriorityCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, CallbackPriority.LATE, Order.PreGetCollectible)

return Order