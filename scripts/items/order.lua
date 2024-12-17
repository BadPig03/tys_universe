local Lib = TYU
local Order = Lib:NewModItem("Order", "ORDER")

local itemPoolFlag = true

local itemPoolName = {
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

local function DisplayItemPool()
    local language = Options.Language
    local stage = Lib.LEVEL:GetStage()
    local itemPoolList = Lib:GetGlobalLibData("Order")
    if language == "zh" then
        Lib.HUD:ShowFortuneText("本层道具池为"..itemPoolName[1][itemPoolList[stage]])
    else
        Lib.HUD:ShowFortuneText("The item pool is", itemPoolName[2][itemPoolList[stage]])
    end
end

local function GetItemPools()
    local itemPoolList = { ItemPoolType.POOL_TREASURE, ItemPoolType.POOL_SHOP, ItemPoolType.POOL_BOSS, ItemPoolType.POOL_DEVIL, ItemPoolType.POOL_ANGEL, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_SECRET, ItemPoolType.POOL_LIBRARY, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_CURSE, ItemPoolType.POOL_CRANE_GAME, ItemPoolType.POOL_ULTRA_SECRET, ItemPoolType.POOL_PLANETARIUM }
    local list = {}
    local rng = RNG(Lib.SEEDS:GetStartSeed())
    for stage = 1, 13 do
        local type = rng:RandomInt(#itemPoolList) + 1
        list[stage] = itemPoolList[type]
        table.remove(itemPoolList, type)
        rng:Next()
    end
    return list
end

function Order:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    local room = Lib.GAME:GetRoom()
    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, room:FindFreePickupSpawnPosition(player.Position, 0, true))
    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, room:FindFreePickupSpawnPosition(player.Position, 0, true))
    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, room:FindFreePickupSpawnPosition(player.Position, 0, true))
    Lib.Entities.CreateTimer(function() DisplayItemPool() end, 30, 0, false)
end
Order:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Order.PostAddCollectible, Lib.ModItemIDs.ORDER)

function Order:PostPlayerNewRoomTempEffects(player)
    if not player:HasCollectible(Lib.ModItemIDs.ORDER) or Lib.LEVEL:GetCurrentRoomIndex() ~= Lib.LEVEL:GetStartingRoomIndex() or not Lib.GAME:GetRoom():IsFirstVisit() then
        return
    end
    Lib.Entities.CreateTimer(function() DisplayItemPool() end, 30, 0, false)
end
Order:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Order.PostPlayerNewRoomTempEffects)

function Order:PostGameStarted(continue)
    if continue then
        return
    end
    local list = GetItemPools()
    Lib:SetGlobalLibData(list, "Order")
end
Order:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Order.PostGameStarted)

function Order:PreGetCollectible(itemPoolType, decrease, seed)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.ORDER) or Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
        return
    end
    local stage = Lib.LEVEL:GetStage()
    local itemPoolList = Lib:GetGlobalLibData("Order") or GetItemPools()
    if itemPoolFlag and itemPoolType ~= itemPoolList[stage] then
        itemPoolFlag = false
        local id = Lib.ITEMPOOL:GetCollectible(itemPoolList[stage], decrease, seed)
        itemPoolFlag = true
        return id
    end
end
Order:AddPriorityCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, CallbackPriority.LATE, Order.PreGetCollectible)

return Order