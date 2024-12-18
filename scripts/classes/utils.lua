local Utils = TYU:RegisterNewClass()

function Utils.FindFreePickupSpawnPosition(position, initialStep, avoidActiveEntities, allowPits)
    initialStep = initialStep or 0
    if avoidActiveEntities == nil then
        avoidActiveEntities = true
    end
    allowPits = allowPits or false

    local room = TYU.GAME:GetRoom()
    return room:FindFreePickupSpawnPosition(position, initialStep, avoidActiveEntities, allowPits)
end
    

function Utils.IsRoomFirstVisit()
    local room = TYU.GAME:GetRoom()
    return room:IsFirstVisit()
end

function Utils.IsRoomType(type)
    local room = TYU.GAME:GetRoom()
    return room:GetType() == type
end

function Utils.IsRoomIndex(index)
    return TYU.LEVEL:GetCurrentRoomIndex() == index
end

function Utils.IsRoomBossChallenge()
    local room = TYU.GAME:GetRoom()
    return Utils.IsRoomType(RoomType.ROOM_CHALLENGE) and TYU.LEVEL:HasBossChallenge() and TYU.LEVEL:GetCurrentRoomDesc().Data.Variant >= 16
end

function Utils.IsInDeathCertificate()
    return TYU.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE
end

function Utils.IsInKnifePuzzle()
    return TYU.LEVEL:HasAbandonedMineshaft() and TYU.LEVEL:GetDimension() == Dimension.KNIFE_PUZZLE
end

function Utils.IsCathedral()
    return TYU.LEVEL:GetStage() == LevelStage.STAGE5 and TYU.LEVEL:GetStageType() == StageType.STAGETYPE_WOTL
end

function Utils.HasUseFlags(useFlags, flag)
    return useFlags & flag == flag
end

function Utils.CreateTimer(...)
    local timer = Isaac.CreateTimer(...)
    timer:AddEntityFlags(TYU.ModEntityFlags.FLAG_NO_PAUSE)
end

return Utils