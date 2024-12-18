local AbsenceNote = TYU:NewModItem("Absence Note", "ABSENCE_NOTE")
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    function PrivateField.GetBedPositionInChallengeRoom()
        return Utils.FindFreePickupSpawnPosition(Vector(520, 200))
    end

    function PrivateField.GetBedPositionInBossRushRoom()
        return Vector(580, 220)
    end

    function PrivateField.SetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(1)
        TYU.AMBUSH.SetMaxBossrushWaves(8)
        TYU.AMBUSH.SetMaxChallengeWaves(2)    
    end

    function PrivateField.ResetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(2)
        TYU.AMBUSH.SetMaxBossrushWaves(15)
        TYU.AMBUSH.SetMaxChallengeWaves(3)   
    end
end

function AbsenceNote:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.ABSENCE_NOTE) or not Utils.IsRoomFirstVisit() then
        return
    end
    local room = TYU.GAME:GetRoom()
    if Utils.IsRoomType(RoomType.ROOM_CHALLENGE) then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED, 0, PrivateField.GetBedPositionInChallengeRoom())
    elseif Utils.IsRoomBossChallenge() then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED, 0, PrivateField.GetBedPositionInBossRushRoom())
    end
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, AbsenceNote.PostNewRoom)

function AbsenceNote:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    PrivateField.SetWaves()
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AbsenceNote.PostAddCollectible, ModItemIDs.ABSENCE_NOTE)

function AbsenceNote:PostTriggerCollectibleRemoved(player, collectibleType)
    PrivateField.ResetWaves()
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, AbsenceNote.PostTriggerCollectibleRemoved, ModItemIDs.ABSENCE_NOTE)    

return AbsenceNote