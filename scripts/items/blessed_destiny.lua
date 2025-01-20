local BlessedDestiny = TYU:NewModItem("Blessed Destiny", "BLESSED_DESTINY")

local Players = TYU.Players
local SaveAndLoad = TYU.SaveAndLoad
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModNullItemIDs = TYU.ModNullItemIDs
local ModRoomIDs = TYU.ModRoomIDs

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "BlessedDestiny", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("BlessedDestiny", ...)
end

do
    function PrivateField.IsRoomValid()
        if Utils.IsInDeathCertificate() or Utils.IsInKnifePuzzle() or TYU.LEVEL:GetStage() >= LevelStage.STAGE8 or Utils.IsRoomType(RoomType.ROOM_ANGEL) or Utils.IsRoomType(RoomType.ROOM_DEVIL) or Utils.IsRoomType(RoomType.ROOM_DUNGEON) then
            return false
        end
        if ModRoomIDs.WAKE_UP_MAIN_ROOM == -1 then
            SaveAndLoad.ReloadRoomData()
        end
        if Utils.IsRoomIndex(GridRooms.ROOM_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_MEGA_SATAN_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_SECRET_EXIT_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_GIDEON_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_GENESIS_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_SECRET_SHOP_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON1_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON2_IDX) then
            return false
        end
        if Utils.IsRoomIndex(GridRooms.ROOM_EXTRA_BOSS_IDX) and TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data and TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data.Variant == ModRoomIDs.WAKE_UP_MAIN_ROOM then
            return false
        end
        return true
    end

    function PrivateField.GetChance()
        local count = 0
        for _, item in ipairs(TYU.ITEMCONFIG:GetTaggedItems(ItemConfig.TAG_ANGEL)) do
            count = count + PlayerManager.GetNumCollectibles(item.ID)
        end
        local chance = 33
        if TYU.GAME:IsGreedMode() then
            chance = chance * 1.5
        end
        return math.min(chance + count * 3, 66)
    end
end

function BlessedDestiny:AddAngelRoomChance()
    if not Players.AnyoneHasCollectible(ModItemIDs.BLESSED_DESTINY) or Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DUALITY) or TYU.LEVEL:GetAngelRoomChance() == 100 then
        return
    end
    TYU.LEVEL:AddAngelRoomChance(100 - TYU.LEVEL:GetAngelRoomChance())
end
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BlessedDestiny.AddAngelRoomChance)
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, BlessedDestiny.AddAngelRoomChance, ModItemIDs.BLESSED_DESTINY)

function BlessedDestiny:PostTriggerCollectibleRemoved(player, id)
    if not player:HasCollectible(ModItemIDs.BLESSED_DESTINY) or TYU.LEVEL:GetAngelRoomChance() ~= 100 then
        return
    end
    TYU.LEVEL:AddAngelRoomChance(-100)
end
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, BlessedDestiny.PostTriggerCollectibleRemoved, ModItemIDs.BLESSED_DESTINY)

function BlessedDestiny:PreNewRoom(room, roomDesc)
    SetGlobalLibData({})
    if roomDesc.VisitedCount > 0 or not Players.AnyoneHasCollectible(ModItemIDs.BLESSED_DESTINY) or not PrivateField.IsRoomValid() then
        return
    end
    local spawnSeed = TYU.LEVEL:GetCurrentRoomDesc().SpawnSeed
    local rng = RNG(spawnSeed)
    local num = rng:RandomInt(100)
    if num >= PrivateField.GetChance() then
        return
    end
    room:SetItemPool(ItemPoolType.POOL_ANGEL)
    SetGlobalLibData(true, tostring(spawnSeed))
end
BlessedDestiny:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, CallbackPriority.LATE, BlessedDestiny.PreNewRoom)

function BlessedDestiny:PostNewRoom()
    local spawnSeed = TYU.LEVEL:GetCurrentRoomDesc().SpawnSeed
    if not GetGlobalLibData(tostring(spawnSeed)) then
        return
    end
    local room = TYU.GAME:GetRoom()
    if not Utils.IsCathedral() then
        room:SetBackdropType(BackdropType.CATHEDRAL, 1)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_SUPERHOLY, 0.6)
    end
    for _, player in ipairs(Players.GetPlayers(true)) do
        player:GetEffects():AddNullEffect(ModNullItemIDs.BLESSED_DESTINY_EFFECT)
    end
end
BlessedDestiny:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, BlessedDestiny.PostNewRoom)

return BlessedDestiny