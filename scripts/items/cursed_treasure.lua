local CursedTreasure = TYU:NewModItem("Cursed Treasure", "CURSED_TREASURE")

local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

function CursedTreasure:PostPickupUpdate(pickup)
    if not Players.AnyoneHasCollectible(ModItemIDs.CURSED_TREASURE) then
        return
    end
    if not Players.AnyoneHasCollectible(ModItemIDs.EXPIRED_GLUE) and pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType ~= ModEntityIDs.CURSED_PENNY.SubType then
        Entities.Morph(pickup, nil, nil, ModEntityIDs.CURSED_PENNY.SubType)
    end
    if Utils.IsRoomType(RoomType.ROOM_SHOP) and pickup:IsShopItem() and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        Entities.Morph(pickup, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_SHOP, true, pickup.InitSeed))
    end
end
CursedTreasure:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CursedTreasure.PostPickupUpdate)

return CursedTreasure