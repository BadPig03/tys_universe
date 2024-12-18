local Cornucopia = TYU:NewModItem("Cornucopia", "CORNUCOPIA")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Fonts = TYU.Fonts
local Players = TYU.Players
local Utils = TYU.Utils
local ModFoodItemIDs = TYU.ModFoodItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "Cornucopia", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "Cornucopia", ...)
end

do
    local function SetDefaultCharge(pickupTable, default)
        setmetatable(pickupTable, { __index = function() return default end })
    end

    local function GetPillCharge(_, v)
        if Utils.HasFlags(v, PillColor.PILL_GIANT_FLAG) then
            return 4
        end
        return 2
    end

    local function GetCardCharge(_, v)
        if (v >= Card.RUNE_HAGALAZ and v <= Card.RUNE_BLACK) or (v >= Card.CARD_SOUL_ISAAC and v <= Card.CARD_SOUL_JACOB) then
            return 4
        end
        return 2
    end

    local charges = {
        [PickupVariant.PICKUP_HEART] = { Default = 2, Values = {
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
        }},
        [PickupVariant.PICKUP_COIN] = { Default = 1, Values = {
            [CoinSubType.COIN_PENNY] = 1,
            [CoinSubType.COIN_DOUBLEPACK] = 2,
            [CoinSubType.COIN_NICKEL] = 3,
            [CoinSubType.COIN_STICKYNICKEL] = 3,
            [CoinSubType.COIN_DIME] = 5,
            [CoinSubType.COIN_GOLDEN] = 7,
            [CoinSubType.COIN_LUCKYPENNY] = 8
        }},
        [PickupVariant.PICKUP_KEY] = { Default = 2, Values = {
            [KeySubType.KEY_NORMAL] = 2,
            [KeySubType.KEY_DOUBLEPACK] = 4,
            [KeySubType.KEY_CHARGED] = 5,
            [KeySubType.KEY_GOLDEN] = 7
        }},
        [PickupVariant.PICKUP_BOMB] = { Default = 2, Values = {
            [BombSubType.BOMB_NORMAL] = 2,
            [BombSubType.BOMB_DOUBLEPACK] = 4,
            [BombSubType.BOMB_GOLDEN] = 7,
            [BombSubType.BOMB_GIGA] = 10
        }},
        [PickupVariant.PICKUP_PILL] = { Special = GetPillCharge },
        [PickupVariant.PICKUP_LIL_BATTERY] = { Default = 4, Values = {
            [BatterySubType.BATTERY_MICRO] = 2,
            [BatterySubType.BATTERY_NORMAL] = 4,
            [BatterySubType.BATTERY_MEGA] = 8,
            [BatterySubType.BATTERY_GOLDEN] = 7
        }},
        [PickupVariant.PICKUP_TAROTCARD] = { Special = GetCardCharge, Values = {
            [Card.CARD_CRACKED_KEY] = 2,
            [Card.CARD_DICE_SHARD] = 4
        }},
        [PickupVariant.PICKUP_POOP] = { Default = 2, Values = {
            [PoopPickupSubType.POOP_SMALL] = 1
        }},
        [ModEntityIDs.FOODS_FOOD_ITEM.Variant] = { Default = 2, Values = {
            [ModFoodItemIDs.GOLDEN_APPLE] = 3,
            [ModFoodItemIDs.GOLDEN_CARROT] = 3,
            [ModFoodItemIDs.MONSTER_MEAT] = 1
        }}
    }

    PrivateField.PickupCharge = {}

    for pickupType, data in pairs(charges) do
        PrivateField.PickupCharge[pickupType] = data.Values or {}
        if data.Special then
            setmetatable(PrivateField.PickupCharge[pickupType], { __index = data.Special })
        else
            SetDefaultCharge(PrivateField.PickupCharge[pickupType], data.Default)
        end
    end
end

do
    PrivateField.ChargeSprite = Sprite("gfx/ui/ui_cornucopia_charge.anm2", true)
    PrivateField.ChargeSprite:Play("Charge1", true)

    function PrivateField.GetPickupCharge(pickup)
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if pickup.SubType == CollectibleType.COLLECTIBLE_NULL then
                return nil
            end
            local cycleList = pickup:GetCollectibleCycle()
            table.insert(cycleList, pickup.SubType)
            local charge = 0
            for _, item in pairs(cycleList) do
                if item > 0 then
                    charge = charge + math.max(math.min(24, 6 * TYU.ITEMCONFIG:GetCollectible(item).Quality), 3)
                end
            end
            charge = math.min(24, charge)
            if Collectibles.IsBlind(pickup) then
                charge = -charge
            end
            return charge
        elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
            if TYU.ITEMCONFIG:GetTrinket(pickup.SubType):IsTrinket() then
                if pickup.SubType & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG then
                    return 12
                else
                    return 6
                end
            end
        else
            return PrivateField.PickupCharge[pickup.Variant] and PrivateField.PickupCharge[pickup.Variant][pickup.SubType]
        end
    end

    function PrivateField.IsAnyoneHoldingItem()
        for _, player in pairs(Players.GetPlayers(true)) do
            if player:HasCollectible(ModItemIDs.CORNUCOPIA) and GetPlayerLibData(player, "Lifted") then
                return true
            end
        end
        return false
    end
end

function Cornucopia:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(ModItemIDs.CORNUCOPIA) then
        return
    end
    local hudOffset = Options.HUDOffset
    if slot == ActiveSlot.SLOT_PRIMARY and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == ModItemIDs.CORNUCOPIA then
        PrivateField.ChargeSprite:Play("Charge"..player:GetActiveCharge(slot), true)
        PrivateField.ChargeSprite.Scale = Vector(1, 1)
        PrivateField.ChargeSprite:Render(Vector(38 + 20 * hudOffset, 16 + 12 * hudOffset))
    end
    if slot == ActiveSlot.SLOT_SECONDARY and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == ModItemIDs.CORNUCOPIA then
        PrivateField.ChargeSprite:Play("Charge"..player:GetActiveCharge(slot), true)
        PrivateField.ChargeSprite.Scale = Vector(0.5, 0.5)
        PrivateField.ChargeSprite:Render(Vector(12 + 20 * hudOffset, 8 + 12 * hudOffset))
    end
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, Cornucopia.PostPlayerHUDRenderActiveItem)

function Cornucopia:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_OWNED, true) or Utils.HasFlags(useFlags, UseFlag.USE_VOID) or Utils.IsInDeathCertificate() or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local currentCharge = player:GetActiveCharge(activeSlot)
    if currentCharge < 24 then
        if player:IsHoldingItem() then
            SetPlayerLibData(player, false, "Lifted")
            player:AnimateCollectible(ModItemIDs.CORNUCOPIA, "HideItem")
        else
            SetPlayerLibData(player, true, "Lifted")
            player:AnimateCollectible(ModItemIDs.CORNUCOPIA, "LiftItem")
        end
    else
        local anyItemFound = false
        for _, item in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            if item.SubType > 0 and not item:ToPickup():IsShopItem() then
                local pickup = item:ToPickup()
                local newItem = Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
                pickup:AddCollectibleCycle(newItem)
                Entities.SpawnPoof(pickup.Position)
                anyItemFound = true    
            end
        end
        if anyItemFound then
            return { Discharge = true, Remove = false, ShowAnim = true }
        else
            local newItem = Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
            local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
            item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
            item.Price = 0
            Utils.AddToWarfarinItemList(item.InitSeed)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 10 then
                local angelItem = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_ANGEL, true, rng:Next()), Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
                angelItem:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
                angelItem.Price = 0
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 10 then
                local devilItem = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, true, rng:Next()), Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
                devilItem:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
                devilItem.Price = 0
            end
        end
        return { Discharge = true, Remove = false, ShowAnim = true }
    end
    return { Discharge = false, Remove = false, ShowAnim = false }
end
Cornucopia:AddCallback(ModCallbacks.MC_USE_ITEM, Cornucopia.UseItem, ModItemIDs.CORNUCOPIA)

function Cornucopia:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.CORNUCOPIA) or not GetPlayerLibData(player, "Lifted") or (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == ModItemIDs.CORNUCOPIA and player:IsHoldingItem()) then
        return
    end
    SetPlayerLibData(player, false, "Lifted")
    player:AnimateCollectible(ModItemIDs.CORNUCOPIA, "HideItem")
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Cornucopia.PostPlayerUpdate, 0)

function Cornucopia:PostPickupRender(pickup)
    if pickup:IsShopItem() or not TYU.HUD:IsVisible() or not Players.AnyoneHasCollectible(ModItemIDs.CORNUCOPIA) or not PrivateField.IsAnyoneHoldingItem() then
        return
    end
    local pos = Isaac.WorldToScreen(pickup.Position)
    local charge = PrivateField.GetPickupCharge(pickup)
    if charge then
        if charge < 0 then
            charge = "?"
        end
        Fonts.PFTempestaSevenCondensed:DrawString(charge, pos.X - 3, pos.Y - 3, KColor(1, 1, 1, 1), 5, true)
    end
end
Cornucopia:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, Cornucopia.PostPickupRender)

function Cornucopia:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not GetPlayerLibData(player, "Lifted") or pickup.SubType <= 0 or pickup:IsShopItem() then
        return
    end
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    local charge = PrivateField.GetPickupCharge(pickup)
    if not charge then
        return
    else
        charge = math.abs(charge)
    end
    player:AddActiveCharge(charge, ActiveSlot.SLOT_PRIMARY, true, false, true)
    if player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 24 then
        SetPlayerLibData(player, false, "Lifted")
        player:AnimateCollectible(ModItemIDs.CORNUCOPIA, "HideItem")
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.6)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE or pickup.Variant == PickupVariant.PICKUP_TRINKET then
        Entities.SpawnPoof(pickup.Position)
    else
        Entities.SpawnFakePickupSprite(pickup)
    end
    local room = TYU.GAME:GetRoom()
    if (Utils.IsRoomType(RoomType.ROOM_CHALLENGE) or Utils.IsRoomType(RoomType.ROOM_BOSSRUSH)) and not room:IsAmbushDone() and not room:IsAmbushActive() then
        TYU.AMBUSH:StartChallenge()
    end
    pickup:TriggerTheresOptionsPickup()
    pickup:Remove()
    return true
end
Cornucopia:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Cornucopia.PrePickupCollision)

function Cornucopia:PlayerGetActiveMinUsableCharge(slot, player, currentMinUsableCharge)
    return 0
end
Cornucopia:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, Cornucopia.PlayerGetActiveMinUsableCharge, ModItemIDs.CORNUCOPIA)

return Cornucopia