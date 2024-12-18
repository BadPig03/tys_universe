local BeggarMask = TYU:NewModItem("Beggar Mask", "BEGGAR_MASK")
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local PrivateField = {}

do
    function PrivateField.IsBeggarValid(beggar)
        local variant = beggar.Variant
        return variant == SlotVariant.BEGGAR or variant == SlotVariant.DEVIL_BEGGAR or variant == SlotVariant.BOMB_BUM or variant == SlotVariant.KEY_MASTER or variant == SlotVariant.BATTERY_BUM or variant == SlotVariant.ROTTEN_BEGGAR or variant == ModEntityIDs.HEALING_BEGGAR.Variant or variant == ModEntityIDs.CHEF_BEGGAR.Variant
    end

    function PrivateField.GetPositionFromRoomShape(shape)
        local positions = {
            [RoomShape.ROOMSHAPE_IV] = Vector(360, 360),
            [RoomShape.ROOMSHAPE_IH] = Vector(440, 280),
            [RoomShape.ROOMSHAPE_2x1] = Vector(1000, 360)
        }
        return positions[shape] or Vector(520, 360)
    end

    function PrivateField.GetBeggarVariantFromRoomType(roomType)
        local variants = {
            [RoomType.ROOM_ANGEL] = ModEntityIDs.HEALING_BEGGAR.Variant,
            [RoomType.ROOM_DEVIL] = SlotVariant.DEVIL_BEGGAR,
            [RoomType.ROOM_TREASURE] = SlotVariant.BEGGAR,
            [RoomType.ROOM_SECRET] = SlotVariant.BOMB_BUM,
            [RoomType.ROOM_SUPERSECRET] = SlotVariant.KEY_MASTER,
            [RoomType.ROOM_SHOP] = SlotVariant.BATTERY_BUM,
            [RoomType.ROOM_CURSE] = SlotVariant.ROTTEN_BEGGAR,
            [RoomType.ROOM_ISAACS] = ModEntityIDs.CHEF_BEGGAR.Variant
        }
        return variants[roomType]
    end
end

function BeggarMask:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.BEGGAR_MASK) or not Utils.IsRoomFirstVisit() then
        return
    end
    local room = TYU.GAME:GetRoom()
    local variant = PrivateField.GetBeggarVariantFromRoomType(room:GetType())
    if not variant then
        return
    end
    local pos = Utils.FindFreePickupSpawnPosition(PrivateField.GetPositionFromRoomShape(room:GetRoomShape()))
    local slot = Entities.Spawn(EntityType.ENTITY_SLOT, variant, 0, pos)
    Entities.SpawnPoof(slot.Position)
end
BeggarMask:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BeggarMask.PostNewRoom)

function BeggarMask:PostSlotUpdate(slot)
    if not Players.AnyoneHasCollectible(ModItemIDs.BEGGAR_MASK) or not PrivateField.IsBeggarValid(slot) or slot:GetState() ~= 4 or slot:GetDropRNG():RandomInt(100) >= 50 then
        return
    end
    local sprite = slot:GetSprite()
    if sprite:GetAnimation() ~= "Teleport" or sprite:GetFrame() ~= 20 then
        return
    end
    Entities.Spawn(EntityType.ENTITY_SLOT, slot.Variant, 0, slot.Position)
    Entities.SpawnPoof(slot.Position)
end
BeggarMask:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, BeggarMask.PostSlotUpdate)

return BeggarMask