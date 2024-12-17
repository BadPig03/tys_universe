local Lib = TYU
local Levels = Lib:RegisterNewClass()

function Levels.AtHome()
    return Lib.LEVEL:GetStage() == LevelStage.STAGE8
end

function Levels.IsInDebugRoom()
    return Lib.LEVEL:GetCurrentRoomIndex() == GridRooms.ROOM_DEBUG_IDX
end

function Levels.IsInGenesisRoom()
    return Lib.LEVEL:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
end

function Levels.IsInOverworld()
    return Lib.LEVEL:GetDimension() == Dimension.NORMAL
end

function Levels.IsInKnifePuzzle()
    return Lib.LEVEL:HasAbandonedMineshaft() and Lib.LEVEL:GetDimension() == Dimension.KNIFE_PUZZLE
end

function Levels.IsInDeathCertificate()
    return Lib.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE
end

function Levels.IsSatanicBibleUsedBossRoom()
    return Lib.GAME:GetRoom():GetType() == RoomType.ROOM_BOSS and Lib.LEVEL:GetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED)
end

function Levels.IsDarkRoomStartingRoom()
    return Lib.LEVEL:GetAbsoluteStage() == LevelStage.STAGE6 and Lib.LEVEL:GetStageType() == StageType.STAGETYPE_ORIGINAL and Lib.LEVEL:GetCurrentRoomIndex() == Lib.LEVEL:GetStartingRoomIndex()
end

function Levels.IsBossChallengeRoom()
    local room = Lib.GAME:GetRoom()
    return room:GetType() == RoomType.ROOM_CHALLENGE and Lib.LEVEL:GetCurrentRoomDesc().Data.Variant >= 16 and Lib.LEVEL:HasBossChallenge()
end

function Levels.IsBossRushRoom()
    local room = Lib.GAME:GetRoom()
    return room:GetType() == RoomType.ROOM_BOSSRUSH
end

function Levels.IsLevelCathedral()
    return Lib.LEVEL:GetStage() == LevelStage.STAGE5 and Lib.LEVEL:GetStageType() == StageType.STAGETYPE_WOTL
end

function Levels.IsRoomDevilTreasureRoom()
    local room = Lib.GAME:GetRoom()
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
    local room = Lib.GAME:GetRoom()
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity and gridEntity:ToDecoration() then
            room:RemoveGridEntityImmediate(i, 0, false)
        end
    end
end

return Levels