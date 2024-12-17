local Lib = TYU
local BethsSalvation = Lib:NewModTrinket("Beth's Salvation", "BETHSSALVATION")

local function CanNotTeleportToAngelRoom(player)
    if Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_EUCHARIST) then
        return false
    elseif player:GetTrinketRNG(Lib.ModTrinketIDs.BETHSSALVATION):RandomInt(100) < 50 then
        return false
    end
    return true
end

function BethsSalvation:PostPlayerNewRoomTempEffects(player)
    local room = Lib.GAME:GetRoom()
    if Lib.LEVEL:GetCurrentRoomIndex() ~= Lib.LEVEL:GetStartingRoomIndex() or not room:IsFirstVisit() or Lib.LEVEL:IsAscent() or Isaac.GetChallenge() == Challenge.CHALLENGE_BACKASSWARDS then
        return
    end
    local multiplier = player:GetTrinketMultiplier(Lib.ModTrinketIDs.BETHSSALVATION)
    if multiplier == 0 then
        return
    end
    if CanNotTeleportToAngelRoom(player) then
        return
    end
    Isaac.CreateTimer(function()
        Lib.LEVEL:InitializeDevilAngelRoom(true, false)
        Lib.GAME:StartRoomTransition(GridRooms.ROOM_DEVIL_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, Dimension.CURRENT)
    end, 1, 0, false)
end
BethsSalvation:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, BethsSalvation.PostPlayerNewRoomTempEffects)

return BethsSalvation