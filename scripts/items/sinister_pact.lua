local SinisterPact = TYU:NewModItem("Sinister Pact", "SINISTER_PACT")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    function PrivateField.IsRoomDevilTreasureRoom()
        if Utils.IsRoomType(RoomType.ROOM_TREASURE) then
            return false
        end
        local room = TYU.GAME:GetRoom()
        for i = 0, 7 do
            local door = room:GetDoor(i)
            if door and door:GetSprite():GetFilename() == "gfx/grid/Door_02_TreasureRoomDoor_Devil.anm2" then
                return true
            end
        end
        return false
    end
end

function SinisterPact:PostPickupShopPurchase(pickup, player, moneySpent)
    if not player:HasCollectible(ModItemIDs.SINISTER_PACT) or player:GetHealthType() == HealthType.LOST or Players.IsInLostCurse(player) or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE or moneySpent >= 0 or moneySpent <= PickupPrice.PRICE_FREE then
        return
    end
    if not Utils.IsRoomType(RoomType.ROOM_DEVIL) and not Utils.IsRoomType(RoomType.ROOM_BLACK_MARKET) and not PrivateField.IsRoomDevilTreasureRoom() then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.SINISTER_PACT)
    Utils.CreateTimer(function()
        local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Collectibles.GetCollectibleFromCurrentRoom(nil, rng), pickup.Position):ToPickup()
        item:MakeShopItem(-2)
        item.Price = TYU.ITEMCONFIG:GetCollectible(item.SubType).DevilPrice
    end, 29, 0, false)
    if pickup.SubType > 0 then
        local oldItem = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pickup.SubType, Utils.FindFreePickupSpawnPosition(pickup.Position), Vector(0, 0), nil, pickup.InitSeed):ToPickup()
        oldItem:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE | EntityFlag.FLAG_APPEAR)
        oldItem.Touched = pickup.Touched
        oldItem.Charge = pickup.Charge
        oldItem:SetNewOptionsPickupIndex(pickup.OptionsPickupIndex)
        oldItem:SetVarData(pickup:GetVarData())
        pickup:Remove()
    end
end
SinisterPact:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, SinisterPact.PostPickupShopPurchase)

return SinisterPact