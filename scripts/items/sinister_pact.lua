local Lib = TYU
local SinisterPact = Lib:NewModItem("Sinister Pact", "SINISTER_PACT")

function SinisterPact:PostPickupShopPurchase(pickup, player, moneySpent)
    if not player:HasCollectible(Lib.ModItemIDs.SINISTER_PACT) or player:GetHealthType() == HealthType.LOST or Lib.Players.IsInLostCurse(player) or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE or moneySpent >= 0 or moneySpent <= PickupPrice.PRICE_FREE then
        return
    end
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    if roomType ~= RoomType.ROOM_DEVIL and roomType ~= RoomType.ROOM_BLACK_MARKET and not Lib.Levels.IsRoomDevilTreasureRoom() then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.SINISTER_PACT)
    Lib.Utils.CreateTimer(function()
        local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, rng), pickup.Position):ToPickup()
        item:MakeShopItem(-2)
        item.Price = Lib.ITEMCONFIG:GetCollectible(item.SubType).DevilPrice
    end, 29, 0, false)
    if pickup.SubType > 0 then
        local oldItem = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pickup.SubType, room:FindFreePickupSpawnPosition(pickup.Position, 0, true, false), Vector(0, 0), nil, pickup.InitSeed):ToPickup()
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