local AbsenceNote = TYU:NewModItem("Absence Note", "ABSENCENOTE")
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local PrivateField = {}

do
    function PrivateField.GetBedPositionInChallengeRoom()
        local room = TYU.GAME:GetRoom()
        return room:FindFreePickupSpawnPosition(Vector(520, 200), 0, true, false)
    end

    function PrivateField.GetBedPositionInBossRushRoom()
        return Vector(580, 220)
    end

    function PrivateField.SetWaves()
        Ambush.SetMaxBossChallengeWaves(1)
        Ambush.SetMaxBossrushWaves(8)
        Ambush.SetMaxChallengeWaves(2)    
    end

    function PrivateField.ResetWaves()
        Ambush.SetMaxBossChallengeWaves(2)
        Ambush.SetMaxBossrushWaves(15)
        Ambush.SetMaxChallengeWaves(3)   
    end
end

function AbsenceNote:PostNewRoom()
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.ABSENCENOTE) or not Utils.IsRoomFirstVisit() then
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
AbsenceNote:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AbsenceNote.PostAddCollectible, TYU.ModItemIDs.ABSENCENOTE)

function AbsenceNote:PostTriggerCollectibleRemoved(player, collectibleType)
    PrivateField.ResetWaves()
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, AbsenceNote.PostTriggerCollectibleRemoved, TYU.ModItemIDs.ABSENCENOTE)    

return AbsenceNote