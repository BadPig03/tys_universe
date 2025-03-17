local NoticeOfCriticalCondition = TYU:NewModItem("Notice of Critical Condition", "NOTICE_OF_CRITICAL_CONDITION")

local Callbacks = TYU.Callbacks
local Entities = TYU.Entities
local Players = TYU.Players
local SaveAndLoad = TYU.SaveAndLoad
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs
local ModRoomIDs = TYU.ModRoomIDs
local ModItemPoolIDs = TYU.ModItemPoolIDs
local ModBackdropIDs = TYU.ModBackdropIDs

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "NoticeOfCriticalCondition", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("NoticeOfCriticalCondition", ...)
end

do
    PrivateField.ItemPoolFlag = true

    function PrivateField.IsInvalid()
        return Utils.IsAscent() or Utils.IsInDeathCertificate() or TYU.LEVEL:GetStage() >= LevelStage.STAGE7
    end
end

function NoticeOfCriticalCondition:PostNewLevel()
    if not Players.AnyoneHasCollectible(ModItemIDs.NOTICE_OF_CRITICAL_CONDITION) or PrivateField.IsInvalid() then
        return
    end
    SetGlobalLibData({ RoomIndex = -1, Spawned = false })
    for _, player in ipairs(Players.GetPlayers(true)) do
		if player:HasCollectible(ModItemIDs.NOTICE_OF_CRITICAL_CONDITION) then
            local type = player:GetPlayerType()
            if type == PlayerType.PLAYER_THEFORGOTTEN or type == PlayerType.PLAYER_THESOUL then
                player:AddBrokenHearts(1)
            else
                player:AddBrokenHearts(2)
            end
        end
    end
    if ModRoomIDs.ICUROOMEMPTY == -1 then
        SaveAndLoad.ReloadRoomData()
    end
    local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.NOTICE_OF_CRITICAL_CONDITION)
    local roomList = WeightedOutcomePicker()
    for _, id in ipairs(ModRoomIDs.ICU_ROOMS) do
        roomList:AddOutcomeWeight(id, 1)
    end
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET_EXIT, roomList:PickOutcome(rng))
    if not newRoom then
        return
    end
    local gridIndices = TYU.LEVEL:FindValidRoomPlacementLocations(newRoom, -1, false, false)
    if #gridIndices == 0 then
        return
    end
    local gridIndex = gridIndices[1]
    TYU.LEVEL:TryPlaceRoom(newRoom, gridIndex, -1, 0, false, false, false)
    SetGlobalLibData({ RoomIndex = gridIndex, Spawned = true })
    NoticeOfCriticalCondition:ReplaceICUDoorSprite()
end
NoticeOfCriticalCondition:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, NoticeOfCriticalCondition.PostNewLevel)

function NoticeOfCriticalCondition:PreNewRoom(room, roomDesc)
    if not GetGlobalLibData("Spawned") or PrivateField.IsInvalid() then
        return
    end
    local roomIndex = GetGlobalLibData("RoomIndex")
    if not Utils.IsRoomIndex(roomIndex) then
        return
    end
    local itemPool = ModItemPoolIDs.ICU_ROOM
    if Players.AnyoneHasCollectible(ModItemIDs.ORDER) then
        itemPool = Utils.GetOrderItemPool()
    end
    room:SetItemPool(itemPool)
end
NoticeOfCriticalCondition:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, 50, NoticeOfCriticalCondition.PreNewRoom)

function NoticeOfCriticalCondition:ReplaceICUDoorSprite()
    if not GetGlobalLibData("Spawned") or PrivateField.IsInvalid() then
        return
    end
    local room = TYU.GAME:GetRoom()
    local ICURoomIndex = GetGlobalLibData("RoomIndex")
    for slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
        local door = room:GetDoor(slot)
        if door and ((door.TargetRoomIndex == ICURoomIndex and door.CurrentRoomType ~= RoomType.ROOM_SECRET and door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET and door.CurrentRoomType ~= RoomType.ROOM_ULTRASECRET) or (Utils.IsRoomIndex(ICURoomIndex) and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET)) then
            local doorSprite = door:GetSprite()
            doorSprite:Load("gfx/grid/icu_door.anm2", true)
            if door:IsLocked() then
                door:SetLocked(false)
            end
            if door:IsOpen() then
                doorSprite:Play("Opened")
            else
                doorSprite:Play("Closed")
            end
        end
    end
    if not Utils.IsRoomIndex(ICURoomIndex) then
        return
    end
    room:SetBackdropType(ModBackdropIDs.ICU, 1)
    if not Utils.IsRoomFirstVisit() then
        return
    end
    for _, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.MOMS_DRESSING_TABLE)) do
        Entities.Spawn(ModEntityIDs.HEALING_BEGGAR.Type, ModEntityIDs.HEALING_BEGGAR.Variant, ModEntityIDs.HEALING_BEGGAR.SubType, slot.Position)
        slot:Remove()
    end
    for _, bed in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED)) do
        Entities.Spawn(ModEntityIDs.ICU_BED.Type, ModEntityIDs.ICU_BED.Variant, ModEntityIDs.ICU_BED.SubType, bed.Position)
        bed:Remove()
    end
    Utils.RemoveAllDecorations()
end
NoticeOfCriticalCondition:AddCallback(Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, NoticeOfCriticalCondition.ReplaceICUDoorSprite)

function NoticeOfCriticalCondition:UsePill(pillEffect, player, useFlags, pillColor)
    if not player:HasCollectible(ModItemIDs.NOTICE_OF_CRITICAL_CONDITION) or pillColor == PillColor.PILL_NULL then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.NOTICE_OF_CRITICAL_CONDITION)
    local pillConfig = TYU.ITEMCONFIG:GetPillEffect(pillEffect)
    if pillConfig.EffectSubClass ~= 1 or player:GetBrokenHearts() == 0 or rng:RandomInt(100) >= 25 then
        return
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.6)
    player:AddBrokenHearts(-1)
end
NoticeOfCriticalCondition:AddCallback(ModCallbacks.MC_USE_PILL, NoticeOfCriticalCondition.UsePill)

return NoticeOfCriticalCondition