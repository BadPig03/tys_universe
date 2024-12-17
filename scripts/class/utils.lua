local Utils = TYU:RegisterNewClass()

function Utils.IsRoomFirstVisit()
    local room = TYU.GAME:GetRoom()
    return room:IsFirstVisit()
end

function Utils.IsRoomType(type)
    if type == nil then
        return false
    end

    local room = TYU.GAME:GetRoom()
    return room:GetType() == type
end

function Utils.IsRoomBossChallenge()
    local room = TYU.GAME:GetRoom()
    return Utils.IsRoomType(RoomType.ROOM_CHALLENGE) and TYU.LEVEL:HasBossChallenge() and TYU.LEVEL:GetCurrentRoomDesc().Data.Variant >= 16
end

function Utils.IsInDeathCertificate()
    return TYU.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE
end

return Utils