local AbsenceNote = TYU:NewModItem("Absence Note", "ABSENCE_NOTE")

local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.GetWaves()
        return {
            BossChallenge = 2,
            Bossrush = 15,
            Challenge = 3
        }
    end

    function PrivateField.GetBedPosition()
        if Utils.IsRoomType(RoomType.ROOM_CHALLENGE) then
            return Utils.FindFreePickupSpawnPosition(Vector(520, 200))
        elseif Utils.IsRoomBossChallenge() then
            return Utils.FindFreePickupSpawnPosition(Vector(580, 220))
        elseif Utils.IsRoomType(RoomType.ROOM_BOSSRUSH) then
            return Utils.FindFreePickupSpawnPosition(Vector(900, 400)) 
        else
            return nil
        end
    end

    function PrivateField.CalculateNewWaves(num)
        return math.ceil(num / 2)
    end

    function PrivateField.SetWaves()
        local waves = PrivateField.GetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(PrivateField.CalculateNewWaves(waves.BossChallenge))
        TYU.AMBUSH.SetMaxBossrushWaves(PrivateField.CalculateNewWaves(waves.Bossrush))
        TYU.AMBUSH.SetMaxChallengeWaves(PrivateField.CalculateNewWaves(waves.Challenge))
    end

    function PrivateField.ResetWaves()
        local waves = PrivateField.GetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(waves.BossChallenge)
        TYU.AMBUSH.SetMaxBossrushWaves(waves.Bossrush)
        TYU.AMBUSH.SetMaxChallengeWaves(waves.Challenge)
    end
end

function AbsenceNote:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.ABSENCE_NOTE) or not Utils.IsRoomFirstVisit() then
        return
    end

    local bedPosition = PrivateField.GetBedPosition()
    if bedPosition then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED, 0, bedPosition)
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

function AbsenceNote:PostGameStarted(continued)
    if not continued then
        PrivateField.ResetWaves()
    end
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, AbsenceNote.PostGameStarted)

return AbsenceNote