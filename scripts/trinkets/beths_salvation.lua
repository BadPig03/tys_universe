local BethsSalvation = TYU:NewModTrinket("Beth's Salvation", "BETHS_SALVATION")
local Players = TYU.Players
local Utils = TYU.Utils
local ModTrinketIDs = TYU.ModTrinketIDs
local PrivateField = {}

do
    function PrivateField.CanNotTeleportToAngelRoom(player)
        if Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_EUCHARIST) then
            return false
        elseif player:GetTrinketRNG(ModTrinketIDs.BETHS_SALVATION):RandomInt(100) < 50 then
            return false
        end
        return true
    end
end

function BethsSalvation:PostPlayerNewRoomTempEffects(player)
    if not Utils.IsStartingRoom() or not Utils.IsRoomFirstVisit() or Utils.IsAscent() or Isaac.GetChallenge() == Challenge.CHALLENGE_BACKASSWARDS then
        return
    end
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.BETHS_SALVATION)
    if multiplier == 0 then
        return
    end
    if PrivateField.CanNotTeleportToAngelRoom(player) then
        return
    end
    Utils.CreateTimer(function()
        TYU.LEVEL:InitializeDevilAngelRoom(true, false)
        TYU.GAME:StartRoomTransition(GridRooms.ROOM_DEVIL_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, Dimension.CURRENT)
    end, 1, 0, false)
end
BethsSalvation:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, BethsSalvation.PostPlayerNewRoomTempEffects)

return BethsSalvation