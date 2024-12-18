local Lib = TYU
local Cornucopia = Lib:NewModItem("Cornucopia", "CORNUCOPIA")

local pickupCharge = {
    [PickupVariant.PICKUP_HEART] = {
        [HeartSubType.HEART_HALF] = 1,
        [HeartSubType.HEART_HALF_SOUL] = 2,
        [HeartSubType.HEART_FULL] = 2,
        [HeartSubType.HEART_SCARED] = 2,
        [HeartSubType.HEART_ROTTEN] = 3,
        [HeartSubType.HEART_SOUL] = 4,
        [HeartSubType.HEART_DOUBLEPACK] = 4,
        [HeartSubType.HEART_BLACK] = 5,
        [HeartSubType.HEART_GOLDEN] = 5,
        [HeartSubType.HEART_BONE] = 5,
        [HeartSubType.HEART_ETERNAL] = 5,
        [HeartSubType.HEART_BLENDED] = 6
    },
    [PickupVariant.PICKUP_COIN] = {
        [CoinSubType.COIN_PENNY] = 1,
        [CoinSubType.COIN_DOUBLEPACK] = 2,
        [CoinSubType.COIN_NICKEL] = 3,
        [CoinSubType.COIN_STICKYNICKEL] = 3,
        [CoinSubType.COIN_DIME] = 5,
        [CoinSubType.COIN_GOLDEN] = 7,
        [CoinSubType.COIN_LUCKYPENNY] = 8
    },
    [PickupVariant.PICKUP_KEY] = {
        [KeySubType.KEY_NORMAL] = 2,
        [KeySubType.KEY_DOUBLEPACK] = 4,
        [KeySubType.KEY_CHARGED] = 5,
        [KeySubType.KEY_GOLDEN] = 7
    },
    [PickupVariant.PICKUP_BOMB] = {
        [BombSubType.BOMB_NORMAL] = 2,
        [BombSubType.BOMB_DOUBLEPACK] = 4,
        [BombSubType.BOMB_GOLDEN] = 7,
        [BombSubType.BOMB_GIGA] = 10
    },
    [PickupVariant.PICKUP_PILL] = {
        [PillColor.PILL_GOLD] = 7
    },
    [PickupVariant.PICKUP_LIL_BATTERY] = {
        [BatterySubType.BATTERY_MICRO] = 2,
        [BatterySubType.BATTERY_NORMAL] = 4,
        [BatterySubType.BATTERY_MEGA] = 8,
        [BatterySubType.BATTERY_GOLDEN] = 7
    },
    [PickupVariant.PICKUP_TAROTCARD] = {
        [Card.CARD_CRACKED_KEY] = 2,
        [Card.CARD_DICE_SHARD] = 4
    },
    [PickupVariant.PICKUP_POOP] = {
        [PoopPickupSubType.POOP_SMALL] = 1
    },
    [Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant] = {
        [Lib.ModFoodItemIDs.GOLDEN_APPLE] = 3,
        [Lib.ModFoodItemIDs.GOLDEN_CARROT] = 3,
        [Lib.ModFoodItemIDs.MONSTER_MEAT] = 1
    }
}
setmetatable(pickupCharge[PickupVariant.PICKUP_HEART], {__index = function() return 2 end})
setmetatable(pickupCharge[PickupVariant.PICKUP_COIN], {__index = function() return 1 end})
setmetatable(pickupCharge[PickupVariant.PICKUP_KEY], {__index = function() return 2 end})
setmetatable(pickupCharge[PickupVariant.PICKUP_BOMB], {__index = function() return 2 end})
setmetatable(pickupCharge[PickupVariant.PICKUP_PILL], {__index = function(k, v)
    if v & PillColor.PILL_GIANT_FLAG == PillColor.PILL_GIANT_FLAG then
        return 4
    else
        return 2
    end
end})
setmetatable(pickupCharge[PickupVariant.PICKUP_LIL_BATTERY], {__index = function() return 4 end})
setmetatable(pickupCharge[PickupVariant.PICKUP_TAROTCARD], {__index = function(k, v)
    if (v >= Card.RUNE_HAGALAZ and v <= Card.RUNE_BLACK) or (v >= Card.CARD_SOUL_ISAAC and v <= Card.CARD_SOUL_JACOB) then
        return 4
    else
        return 2
    end
end})
setmetatable(pickupCharge[PickupVariant.PICKUP_POOP], {__index = function() return 2 end})
setmetatable(pickupCharge[Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant], {__index = function() return 2 end})

local function GetPickupCharge(pickup)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        if pickup.SubType == CollectibleType.COLLECTIBLE_NULL then
            return nil
        end
        local cycleList = pickup:GetCollectibleCycle()
        table.insert(cycleList, pickup.SubType)
        local charge = 0
        for _, item in pairs(cycleList) do
            if item > 0 then
                charge = charge + math.max(math.min(24, 6 * Lib.ITEMCONFIG:GetCollectible(item).Quality), 3)
            end
        end
        charge = math.min(24, charge)
        if Lib.Collectibles.IsBlind(pickup) then
            charge = -charge
        end
        return charge
    elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
        if Lib.ITEMCONFIG:GetTrinket(pickup.SubType):IsTrinket() then
            if pickup.SubType & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG then
                return 12
            else
                return 6
            end
        end
    else
        return pickupCharge[pickup.Variant] and pickupCharge[pickup.Variant][pickup.SubType]
    end
end

local function IsAnyoneHoldingItem()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:HasCollectible(Lib.ModItemIDs.CORNUCOPIA) and Lib:GetPlayerLibData(player, "Cornucopia", "Lifted") then
            return true
        end
    end
    return false
end

function Cornucopia:PlayerGetActiveMinUsableCharge(slot, player, currentMinUsableCharge)
    return 0
end
Cornucopia:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, Cornucopia.PlayerGetActiveMinUsableCharge, Lib.ModItemIDs.CORNUCOPIA)

local chargeSprite = Sprite("gfx/ui/ui_cornucopia_charge.anm2", true)
chargeSprite:Play("Charge1", true)

function Cornucopia:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(Lib.ModItemIDs.CORNUCOPIA) then
        return
    end
    local hudOffset = Options.HUDOffset
    if slot == ActiveSlot.SLOT_PRIMARY and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Lib.ModItemIDs.CORNUCOPIA then
        chargeSprite:Play("Charge"..player:GetActiveCharge(slot), true)
        chargeSprite.Scale = Vector(1, 1)
        chargeSprite:Render(Vector(38 + 20 * hudOffset, 16 + 12 * hudOffset))
    end
    if slot == ActiveSlot.SLOT_SECONDARY and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == Lib.ModItemIDs.CORNUCOPIA then
        chargeSprite:Play("Charge"..player:GetActiveCharge(slot), true)
        chargeSprite.Scale = Vector(0.5, 0.5)
        chargeSprite:Render(Vector(12 + 20 * hudOffset, 8 + 12 * hudOffset))
    end
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, Cornucopia.PostPlayerHUDRenderActiveItem)

function Cornucopia:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or useFlags & UseFlag.USE_OWNED ~= UseFlag.USE_OWNED or useFlags & UseFlag.USE_VOID == UseFlag.USE_VOID or Lib.Levels.IsInDeathCertificate() or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local room = Lib.GAME:GetRoom()
    local currentCharge = player:GetActiveCharge(activeSlot)
    if currentCharge < 24 then
        if player:IsHoldingItem() then
            Lib:SetPlayerLibData(player, false, "Cornucopia", "Lifted")
            player:AnimateCollectible(Lib.ModItemIDs.CORNUCOPIA, "HideItem")
        else
            Lib:SetPlayerLibData(player, true, "Cornucopia", "Lifted")
            player:AnimateCollectible(Lib.ModItemIDs.CORNUCOPIA, "LiftItem")
        end
    else
        local anyItemFound = false
        for _, item in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            if item.SubType > 0 and not item:ToPickup():IsShopItem() then
                local pickup = item:ToPickup()
                local newItem = Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
                pickup:AddCollectibleCycle(newItem)
                Lib.Entities.SpawnPoof(pickup.Position)
                anyItemFound = true    
            end
        end
        if anyItemFound then
            return { Discharge = true, Remove = false, ShowAnim = true }
        else
            local newItem = Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
            local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, room:FindFreePickupSpawnPosition(player.Position, 0, true, false)):ToPickup()
            item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
            item.Price = 0
            Lib:SetGlobalLibData(true, "WarfarinItems", tostring(item.InitSeed))
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 10 then
                local angelItem = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_ANGEL, true, rng:Next()), room:FindFreePickupSpawnPosition(player.Position, 0, true)):ToPickup()
                angelItem:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
                angelItem.Price = 0
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 10 then
                local devilItem = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, true, rng:Next()), room:FindFreePickupSpawnPosition(player.Position, 0, true)):ToPickup()
                devilItem:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
                devilItem.Price = 0
            end
        end
        return { Discharge = true, Remove = false, ShowAnim = true }
    end
    return { Discharge = false, Remove = false, ShowAnim = false }
end
Cornucopia:AddCallback(ModCallbacks.MC_USE_ITEM, Cornucopia.UseItem, Lib.ModItemIDs.CORNUCOPIA)

function Cornucopia:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.CORNUCOPIA) then
        return
    end
    if Lib:GetPlayerLibData(player, "Cornucopia", "Lifted") and (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= Lib.ModItemIDs.CORNUCOPIA or not player:IsHoldingItem()) then
        Lib:SetPlayerLibData(player, false, "Cornucopia", "Lifted")
        player:AnimateCollectible(Lib.ModItemIDs.CORNUCOPIA, "HideItem")
    end
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Cornucopia.PostPlayerUpdate, 0)

function Cornucopia:PostPickupRender(pickup)
    if pickup:IsShopItem() or not Lib.HUD:IsVisible() or not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CORNUCOPIA) then
        return
    end
    if not IsAnyoneHoldingItem() then
        return
    end
    local room = Lib.GAME:GetRoom()
    local pickupPosition = Isaac.WorldToScreen(pickup.Position)
    local charge = GetPickupCharge(pickup)
    if charge then
        if charge < 0 then
            charge = "?"
        end
        Lib.Fonts.PFTempestaSevenCondensed:DrawString(charge, pickupPosition.X - 3, pickupPosition.Y - 3, Lib.KColors.WHITE, 5, true)
    end
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, Cornucopia.PostPickupRender)

function Cornucopia:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not Lib:GetPlayerLibData(player, "Cornucopia", "Lifted") or pickup.SubType <= 0 or pickup:IsShopItem() then
        return
    end
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    local charge = GetPickupCharge(pickup)
    if not charge then
        return
    else
        charge = math.abs(charge)
    end
    player:AddActiveCharge(charge, ActiveSlot.SLOT_PRIMARY, true, false, true)
    if player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 24 then
        Lib:SetPlayerLibData(player, false, "Cornucopia", "Lifted")
        player:AnimateCollectible(Lib.ModItemIDs.CORNUCOPIA, "HideItem")
    end
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.6)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE or pickup.Variant == PickupVariant.PICKUP_TRINKET then
        Lib.Entities.SpawnPoof(pickup.Position)
    else
        Lib.Entities.SpawnFakePickupSprite(pickup)
    end
    pickup:TriggerTheresOptionsPickup()
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    if (roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_BOSSRUSH) and not room:IsAmbushDone() and not room:IsAmbushActive() then
        Lib.AMBUSH:StartChallenge()
    end
    pickup:Remove()
    return true
end
Cornucopia:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Cornucopia.PrePickupCollision)

return Cornucopia