local BeggarMask = TYU:NewModItem("Beggar Mask", "BEGGARMASK")
local Players = TYU.Players
local Utils = TYU.Utils
local PrivateField = {}

do
    function PrivateField.IsBeggarValid(beggar)
        local variant = beggar.Variant
        return variant == SlotVariant.BEGGAR or variant == SlotVariant.DEVIL_BEGGAR or variant == SlotVariant.BOMB_BUM or variant == SlotVariant.KEY_MASTER or variant == SlotVariant.BATTERY_BUM or variant == SlotVariant.ROTTEN_BEGGAR or variant == TYU.ModEntityIDs.HEALINGBEGGAR.Variant or variant == TYU.ModEntityIDs.CHEFBEGGAR.Variant
    end
end

function BeggarMask:PostNewRoom()
    local room = TYU.GAME:GetRoom()
    local roomType = room:GetType()
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.BEGGARMASK) or not Utils.IsRoomFirstVisit() then
        return
    end
    local roomType = room:GetType()
    local positions = {
        [RoomShape.ROOMSHAPE_IV] = Vector(360, 360),
        [RoomShape.ROOMSHAPE_IH] = Vector(440, 280),
        [RoomShape.ROOMSHAPE_2x1] = Vector(1000, 360)
    }
    local pos = positions[room:GetRoomShape()] or Vector(520, 360)
    pos = room:FindFreePickupSpawnPosition(pos, 0, true, false)
    local roomTypeToVariant = {
        [RoomType.ROOM_ANGEL] = TYU.ModEntityIDs.HEALINGBEGGAR.Variant,
        [RoomType.ROOM_DEVIL] = SlotVariant.DEVIL_BEGGAR,
        [RoomType.ROOM_TREASURE] = SlotVariant.BEGGAR,
        [RoomType.ROOM_SECRET] = SlotVariant.BOMB_BUM,
        [RoomType.ROOM_SUPERSECRET] = SlotVariant.KEY_MASTER,
        [RoomType.ROOM_SHOP] = SlotVariant.BATTERY_BUM,
        [RoomType.ROOM_CURSE] = SlotVariant.ROTTEN_BEGGAR,
        [RoomType.ROOM_ISAACS] = TYU.ModEntityIDs.CHEFBEGGAR.Variant
    }
    local variant = roomTypeToVariant[roomType]
    if variant then
        local slot = TYU.Entities.Spawn(EntityType.ENTITY_SLOT, variant, 0, pos)
        TYU.Entities.SpawnPoof(slot.Position)
    end
end
BeggarMask:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BeggarMask.PostNewRoom)

function BeggarMask:PostSlotUpdate(slot)
    if TYU.Players.AnyoneHasCollectible(TYU.ModItemIDs.BEGGARMASK) and IsValidBeggar(slot) and slot:GetState() == 4 and slot:GetDropRNG():RandomInt(100) < 40 then
        local slotSprite = slot:GetSprite()
        if slotSprite:GetAnimation() == "Teleport" and slotSprite:GetFrame() == 20 then
            TYU.Entities.Spawn(EntityType.ENTITY_SLOT, slot.Variant, 0, slot.Position)
            TYU.Entities.SpawnPoof(slot.Position)
        end
    end
end
BeggarMask:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, BeggarMask.PostSlotUpdate)

return BeggarMask