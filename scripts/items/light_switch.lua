local LightSwitch = TYU:NewModItem("Light Switch", "LIGHT_SWITCH")

local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.GetActiveScale()
        local active = 0.9
        if Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_NIGHT_LIGHT) then
            active = active - 0.15
        end
        return active
    end

    function PrivateField.IsRoomValid()
        if Utils.IsInDeathCertificate() or Utils.IsInKnifePuzzle() or Utils.IsRoomType(RoomType.ROOM_DUNGEON) then
            return false
        end
        if Utils.IsRoomIndex(GridRooms.ROOM_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_MEGA_SATAN_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_SECRET_EXIT_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_GIDEON_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_GENESIS_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_SECRET_SHOP_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON1_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON2_IDX) then
            return false
        end
        return true
    end

    function PrivateField.IsValidEnemy(enemy)
        return enemy and enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM)
    end
end

function LightSwitch:GetShaderParams(shaderName)
    if shaderName ~= "LightSwitchDarkness" then
        return
    end
    local pos, pos2 = Isaac.GetPlayer().Position, Isaac.GetPlayer(1).Position
    local distances = {192, 192, 96, 96}
    local active = 0
	if not PrivateField.IsRoomValid() or not Players.AnyoneHasCollectible(ModItemIDs.LIGHT_SWITCH) then
        return { ActiveIn = 0 }
    end
    local room = TYU.GAME:GetRoom()
    local roomIndex = TYU.LEVEL:GetRoomByIdx(TYU.LEVEL:GetCurrentRoomIndex()).SafeGridIndex
    if roomIndex >= 0 then
        TYU.GAME:Darken(1, 1)
        active = 1 * PrivateField.GetActiveScale()
    end
    local edgePos = Isaac.WorldToScreen(pos + Vector(distances[1], 0))
    local edgePos2 = Isaac.WorldToScreen(pos2 + Vector(distances[2], 0))
    local fadePos = Isaac.WorldToScreen(pos + Vector(distances[3], 0))
    local fadePos2 = Isaac.WorldToScreen(pos2 + Vector(distances[4], 0))
    pos, pos2 = Isaac.WorldToScreen(pos), Isaac.WorldToScreen(pos2)
    return {
        ActiveIn = active,
        TargetPositionOne = {pos.X, pos.Y, edgePos.X, edgePos.Y},
        TargetPositionTwo = {pos2.X, pos2.Y, edgePos2.X, edgePos2.Y},
        FadePositions = {fadePos.X, fadePos.Y, fadePos2.X, fadePos2.Y},
        WarpCheck = {pos.X + 1, pos.Y + 1}
    }
end
LightSwitch:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, LightSwitch.GetShaderParams)

function LightSwitch:PostUpdate()
    if not Players.AnyoneHasCollectible(ModItemIDs.LIGHT_SWITCH) or not PrivateField.IsRoomValid() then
        return
    end
    for _, ent in pairs(Isaac.GetRoomEntities()) do
        local npc = ent:ToNPC()
        if not npc or not PrivateField.IsValidEnemy(npc) then
            goto continue
        end
        for _, player in ipairs(Players.GetPlayers(true)) do
            if npc.Position:Distance(player.Position) > 192 then
                local cooldown = npc:GetBossStatusEffectCooldown()
                if npc:IsBoss() and cooldown > 0 then
                    npc:SetBossStatusEffectCooldown(0)
                end
                npc:AddFreeze(EntityRef(player), 1, true)
                if npc:IsBoss() and cooldown > 0 then
                    npc:SetBossStatusEffectCooldown(cooldown)
                end
            end
        end
        ::continue::
    end

end
LightSwitch:AddCallback(ModCallbacks.MC_POST_UPDATE, LightSwitch.PostUpdate)

return LightSwitch