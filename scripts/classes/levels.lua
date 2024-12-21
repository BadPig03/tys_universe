local Levels = TYU:RegisterNewClass()

function Levels.AtHome()
    return TYU.LEVEL:GetStage() == LevelStage.STAGE8
end

function Levels.IsInDebugRoom()
    return TYU.LEVEL:GetCurrentRoomIndex() == GridRooms.ROOM_DEBUG_IDX
end

function Levels.IsInGenesisRoom()
    return TYU.LEVEL:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
end

function Levels.IsInOverworld()
    return TYU.LEVEL:GetDimension() == Dimension.NORMAL
end

function Levels.IsInKnifePuzzle()
    return TYU.LEVEL:HasAbandonedMineshaft() and TYU.LEVEL:GetDimension() == Dimension.KNIFE_PUZZLE
end

function Levels.IsInDeathCertificate()
    return TYU.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE
end

function Levels.IsSatanicBibleUsedBossRoom()
    return TYU.GAME:GetRoom():GetType() == RoomType.ROOM_BOSS and TYU.LEVEL:GetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED)
end

function Levels.IsDarkRoomStartingRoom()
    return TYU.LEVEL:GetAbsoluteStage() == LevelStage.STAGE6 and TYU.LEVEL:GetStageType() == StageType.STAGETYPE_ORIGINAL and TYU.LEVEL:GetCurrentRoomIndex() == TYU.LEVEL:GetStartingRoomIndex()
end

function Levels.IsBossChallengeRoom()
    local room = TYU.GAME:GetRoom()
    return room:GetType() == RoomType.ROOM_CHALLENGE and TYU.LEVEL:GetCurrentRoomDesc().Data.Variant >= 16 and TYU.LEVEL:HasBossChallenge()
end

function Levels.IsBossRushRoom()
    local room = TYU.GAME:GetRoom()
    return room:GetType() == RoomType.ROOM_BOSSRUSH
end

function Levels.IsLevelCathedral()
    return TYU.LEVEL:GetStage() == LevelStage.STAGE5 and TYU.LEVEL:GetStageType() == StageType.STAGETYPE_WOTL
end

function Levels.IsRoomDevilTreasureRoom()
    local room = TYU.GAME:GetRoom()
    if room:GetType() ~= RoomType.ROOM_TREASURE then
        return false
    end
    for i = 0, 7 do
        local door = room:GetDoor(i)
        if door and door:GetSprite():GetFilename() == "gfx/grid/Door_02_TreasureRoomDoor_Devil.anm2" then
            return true
        end
    end
    return false
end

function Levels.RemoveAllDecorations()
    local room = TYU.GAME:GetRoom()
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity and gridEntity:ToDecoration() then
            room:RemoveGridEntityImmediate(i, 0, false)
        end
    end
end

return Levels