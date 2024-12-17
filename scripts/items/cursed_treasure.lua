local Lib = TYU
local CursedTreasure = Lib:NewModItem("Cursed Treasure", "CURSEDTREASURE")

function CursedTreasure:PostPickupUpdate(pickup)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CURSEDTREASURE)  then
        return
    end
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.EXPIREDGLUE) and pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType ~= Lib.ModEntityIDs.CURSEDPENNY.SubType then
        Lib.Entities.Morph(pickup, nil, nil, Lib.ModEntityIDs.CURSEDPENNY.SubType)
    end
    if Lib.GAME:GetRoom():GetType() == RoomType.ROOM_SHOP and pickup:IsShopItem() and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        Lib.Entities.Morph(pickup, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_SHOP, true, pickup.InitSeed))
    end
end
CursedTreasure:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CursedTreasure.PostPickupUpdate)

return CursedTreasure