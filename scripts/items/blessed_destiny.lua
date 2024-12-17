local Lib = TYU
local BlessedDestiny = Lib:NewModItem("Blessed Destiny", "BLESSEDDESTINY")

local itemPoolFlag = true

local function IsValidRoom()
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    local dimension = Lib.LEVEL:GetDimension()
    local roomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    if Lib.Levels.IsInDeathCertificate() or Lib.Levels.IsInKnifePuzzle() or Lib.LEVEL:GetStage() >= LevelStage.STAGE8 then
        return false
    end
    if roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_DUNGEON then
        return false
    end
    if Lib.ModRoomIDs.WAKEUPMAINROOM == -1 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    if roomIndex == GridRooms.ROOM_DUNGEON_IDX or roomIndex == GridRooms.ROOM_MEGA_SATAN_IDX or roomIndex == GridRooms.ROOM_SECRET_EXIT_IDX or roomIndex == GridRooms.ROOM_GIDEON_DUNGEON_IDX or roomIndex == GridRooms.ROOM_GENESIS_IDX or roomIndex == GridRooms.ROOM_SECRET_SHOP_IDX or roomIndex == GridRooms.ROOM_ROTGUT_DUNGEON1_IDX or roomIndex == GridRooms.ROOM_ROTGUT_DUNGEON2_IDX then
        return false
    end
    if roomIndex == GridRooms.ROOM_EXTRA_BOSS_IDX and Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data and Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data.Variant == Lib.ModRoomIDs.WAKEUPMAINROOM then
        return false
    end
    return true
end

local function CalculateChance()
    local count = 0
    local chance = 33
    for _, item in ipairs(Lib.ITEMCONFIG:GetTaggedItems(ItemConfig.TAG_ANGEL)) do
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            count = count + player:GetCollectibleNum(item.ID)
        end
    end
    if Lib.GAME:IsGreedMode() then
        chance = chance * 1.5
    end
    return math.min(chance + count * 3, 66)
end

function BlessedDestiny:PreNewRoom(room, roomDesc)
    Lib:SetGlobalLibData({}, "BlessedDestiny")
    if roomDesc.VisitedCount > 0 or not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.BLESSEDDESTINY) or not IsValidRoom() then
        return
    end
    local spawnSeed = Lib.LEVEL:GetCurrentRoomDesc().SpawnSeed
    local rng = RNG(spawnSeed)
    if not (rng:RandomInt(100) < CalculateChance()) then
        return
    end
    Lib:SetGlobalLibData(true, "BlessedDestiny", tostring(spawnSeed))
    room:SetItemPool(ItemPoolType.POOL_ANGEL)
end
BlessedDestiny:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, CallbackPriority.LATE, BlessedDestiny.PreNewRoom)

function BlessedDestiny:PostNewRoom()
    local spawnSeed = Lib.LEVEL:GetCurrentRoomDesc().SpawnSeed
    if not Lib:GetGlobalLibData("BlessedDestiny", tostring(spawnSeed)) then
        return
    end
    local room = Lib.GAME:GetRoom()
    if not Lib.Levels.IsLevelCathedral() then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_SUPERHOLY, 0.6)
        Lib.GAME:GetRoom():SetBackdropType(BackdropType.CATHEDRAL, 1)
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        player:GetEffects():AddNullEffect(Lib.ModNullItemIDs.BLESSEDDESTINYEFFECT)
    end
end
BlessedDestiny:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, BlessedDestiny.PostNewRoom)

function BlessedDestiny:AddAngelRoomChance()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.BLESSEDDESTINY) or Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DUALITY) or Lib.LEVEL:GetAngelRoomChance() == 100 then
        return
    end
    Lib.LEVEL:AddAngelRoomChance(100 - Lib.LEVEL:GetAngelRoomChance())
end
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BlessedDestiny.AddAngelRoomChance)
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, BlessedDestiny.AddAngelRoomChance, Lib.ModItemIDs.BLESSEDDESTINY)

function BlessedDestiny:PostTriggerCollectibleRemoved(player, id)
    if not player:HasCollectible(Lib.ModItemIDs.BLESSEDDESTINY) or Lib.LEVEL:GetAngelRoomChance() ~= 100 then
        return
    end
    Lib.LEVEL:AddAngelRoomChance(-100)
end
BlessedDestiny:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, BlessedDestiny.PostTriggerCollectibleRemoved, Lib.ModItemIDs.BLESSEDDESTINY)


return BlessedDestiny