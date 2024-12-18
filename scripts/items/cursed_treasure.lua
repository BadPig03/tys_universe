local Lib = TYU
local CursedTreasure = Lib:NewModItem("Cursed Treasure", "CURSED_TREASURE")

function CursedTreasure:PostPickupUpdate(pickup)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CURSED_TREASURE)  then
        return
    end
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.EXPIRED_GLUE) and pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType ~= Lib.ModEntityIDs.CURSED_PENNY.SubType then
        Lib.Entities.Morph(pickup, nil, nil, Lib.ModEntityIDs.CURSED_PENNY.SubType)
    end
    if Lib.GAME:GetRoom():GetType() == RoomType.ROOM_SHOP and pickup:IsShopItem() and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        Lib.Entities.Morph(pickup, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_SHOP, true, pickup.InitSeed))
    end
end
CursedTreasure:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CursedTreasure.PostPickupUpdate)

return CursedTreasure