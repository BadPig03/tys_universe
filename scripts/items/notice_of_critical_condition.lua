local Lib = TYU
local NoticeOfCriticalCondition = Lib:NewModItem("Notice of Critical Condition", "NOTICEOFCRITICALCONDITION")

local itemPoolFlag = true

function NoticeOfCriticalCondition:PostNewLevel()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.NOTICEOFCRITICALCONDITION) or Lib.LEVEL:IsAscent() or Lib.Levels.AtHome() or Lib.LEVEL:GetStage() == LevelStage.STAGE7 then
        return
    end
    Lib:SetGlobalLibData({ RoomIndex = -1, Spawned = false }, "NoticeOfCriticalCondition")
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
		if player:HasCollectible(Lib.ModItemIDs.NOTICEOFCRITICALCONDITION) then
            local type = player:GetPlayerType()
            if type == PlayerType.PLAYER_THEFORGOTTEN or type == PlayerType.PLAYER_THESOUL then
                player:AddBrokenHearts(1)
            else
                player:AddBrokenHearts(2)
            end
        end
    end
    if Lib.ModRoomIDs.ICUROOMEMPTY == -1 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    local rng = Isaac.GetPlayer(0):GetCollectibleRNG(Lib.ModItemIDs.NOTICEOFCRITICALCONDITION)
    local roomList = WeightedOutcomePicker()
    for _, id in ipairs(Lib.ModRoomIDs.ICUROOMS) do
        roomList:AddOutcomeWeight(id, 1)
    end
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET_EXIT, roomList:PickOutcome(rng))
    local gridIndices = Lib.LEVEL:FindValidRoomPlacementLocations(newRoom, -1, false, false)
    if #gridIndices == 0 then
        return
    end
    local gridIndex = gridIndices[1]
    Lib.LEVEL:TryPlaceRoom(newRoom, gridIndex, -1, 0, false, false, false)
    Lib:SetGlobalLibData({ RoomIndex = gridIndex, Spawned = true }, "NoticeOfCriticalCondition")
    NoticeOfCriticalCondition:ReplaceICUDoorSprite()
end
NoticeOfCriticalCondition:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, NoticeOfCriticalCondition.PostNewLevel)

function NoticeOfCriticalCondition:PreNewRoom(room, roomDesc)
    if not Lib:GetGlobalLibData("NoticeOfCriticalCondition", "Spawned") or Lib.LEVEL:IsAscent() or Lib.Levels.IsInDeathCertificate() or Lib.Levels.AtHome() or Lib.LEVEL:GetStage() == LevelStage.STAGE7 then
        return
    end
    local roomIndex = Lib:GetGlobalLibData("NoticeOfCriticalCondition", "RoomIndex")
    if Lib.LEVEL:GetCurrentRoomIndex() ~= roomIndex then
        return
    end
    local itemPool = Lib.ModItemPoolIDs.ILLNESS
    if Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.ORDER) then
        itemPool = Lib:GetGlobalLibData("Order")[Lib.LEVEL:GetStage()]
    end
    room:SetItemPool(itemPool)
end
NoticeOfCriticalCondition:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, 50, NoticeOfCriticalCondition.PreNewRoom)

function NoticeOfCriticalCondition:ReplaceICUDoorSprite()
    if not Lib:GetGlobalLibData("NoticeOfCriticalCondition", "Spawned") or Lib.LEVEL:IsAscent() or Lib.Levels.IsInDeathCertificate() or Lib.Levels.AtHome() or Lib.LEVEL:GetStage() == LevelStage.STAGE7 then
        return
    end
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    local ICURoomIndex =  Lib:GetGlobalLibData("NoticeOfCriticalCondition", "RoomIndex")
    local currentRoomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    for slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
        local door = room:GetDoor(slot)
        if door and ((door.TargetRoomIndex == ICURoomIndex and door.CurrentRoomType ~= RoomType.ROOM_SECRET and door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET and door.CurrentRoomType ~= RoomType.ROOM_ULTRASECRET) or (currentRoomIndex == ICURoomIndex and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET)) then
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
    if currentRoomIndex == ICURoomIndex then
        room:SetBackdropType(Lib.ModBackdropIDs.ICU, 1)
        if room:IsFirstVisit() then
            for _, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.MOMS_DRESSING_TABLE)) do
                Lib.Entities.Spawn(Lib.ModEntityIDs.HEALINGBEGGAR.Type, Lib.ModEntityIDs.HEALINGBEGGAR.Variant, Lib.ModEntityIDs.HEALINGBEGGAR.SubType, slot.Position)
                slot:Remove()
            end
            for _, bed in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED)) do
                Lib.Entities.Spawn(Lib.ModEntityIDs.ICUBED.Type, Lib.ModEntityIDs.ICUBED.Variant, Lib.ModEntityIDs.ICUBED.SubType, bed.Position)
                bed:Remove()
            end
            Lib.Levels.RemoveAllDecorations()
        end
    end
end
NoticeOfCriticalCondition:AddCallback(Lib.Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, NoticeOfCriticalCondition.ReplaceICUDoorSprite)

function NoticeOfCriticalCondition:UsePill(pillEffect, player, useFlags, pillColor)
    if not player:HasCollectible(Lib.ModItemIDs.NOTICEOFCRITICALCONDITION) or pillColor == PillColor.PILL_NULL then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.NOTICEOFCRITICALCONDITION)
    local pillConfig = Lib.ITEMCONFIG:GetPillEffect(pillEffect)
    if pillConfig.EffectSubClass == 1 and player:GetBrokenHearts() >= 1 and rng:RandomInt(100) < 25 then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.6)
        player:AddBrokenHearts(-1)
    end
end
NoticeOfCriticalCondition:AddCallback(ModCallbacks.MC_USE_PILL, NoticeOfCriticalCondition.UsePill)

return NoticeOfCriticalCondition