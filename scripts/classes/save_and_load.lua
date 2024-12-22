local SaveAndLoad = TYU:RegisterNewClass()
local Callbacks = TYU.Callbacks
local ModRoomIDs = TYU.ModRoomIDs

function SaveAndLoad:PreGameExit(shouldSave)
    if shouldSave then
        SaveAndLoad.SaveGameState()
    else
        SaveAndLoad.RemoveGameState()
        Isaac.RunCallback(Callbacks.TYU_POST_RESTART)
    end
    TYU:ClearAllData()
    Isaac.RunCallback(Callbacks.TYU_POST_EXIT, shouldSave)
end
SaveAndLoad:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveAndLoad.PreGameExit)

function SaveAndLoad:PostGameStarted(continued)
    if continued then
        SaveAndLoad.LoadGameState()
    else
        SaveAndLoad.RemoveGameState()
        TYU.AMBUSH.SetMaxBossChallengeWaves(2)
        TYU.AMBUSH.SetMaxChallengeWaves(3)
    end
    TYU.SetTempGlobalLibData(true, "_SAVEDATA", "GameStateSafe")
end
SaveAndLoad:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.IMPORTANT, SaveAndLoad.PostGameStarted)

function SaveAndLoad:PostNewRoom()
    Isaac.RunCallbackWithParam(Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, nil, false)
end
SaveAndLoad:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SaveAndLoad.PostNewRoom)

function SaveAndLoad.SaveGameState()
    local data = {}
    data.Global = TYU:GetGlobalLibData()
    data.TYU.Players = {}
    for _, player in pairs(TYU.Players.GetPlayers(true)) do
        local id = TYU.Players.GetPlayerID(player)
        data.TYU.Players[tostring(id)] = TYU:GetPlayerLibData(player)
    end
    SaveAndLoad.WriteGameStateData(data)
    Isaac.RunCallback(Callbacks.TYU_POST_SAVE)
end

function SaveAndLoad.LoadGameState()
    if not TYU:HasData() then
        return
    end
    local data = SaveAndLoad.ReadGameStateData()
    if not data then
        return
    end
    TYU:SetGlobalLibData(data.Global)
    for _, player in pairs(TYU.Players.GetPlayers(true)) do
        local id = tostring(TYU.Players.GetPlayerID(player))
        local playerData = TYU.Table.First(data.TYU.Players, function(k, v) return id == v end)
        if playerData then
            TYU:SetPlayerLibData(player, playerData)
        end
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end
    Isaac.RunCallback(Callbacks.TYU_POST_LOAD)
    Isaac.RunCallbackWithParam(Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, nil, true)
end

function SaveAndLoad.WriteGameStateData(data)
    local jsonText = TYU.JSON.encode(data)
    TYU:SaveData(jsonText)
end

function SaveAndLoad.ReadGameStateData()
    if not TYU:HasData() then
        return
    end
    local jsonData = TYU:LoadData()
    local loadedData
    local success = pcall(function() loadedData = TYU.JSON.decode(jsonData) end)
    if success and loadedData then
        return loadedData
    end
end

function SaveAndLoad.RemoveGameState()
    SaveAndLoad.WriteGameStateData(nil)
end

function SaveAndLoad.IsGameStateSafe()
    return TYU.GetTempGlobalLibData("_SAVEDATA", "GameStateSafe")
end

function SaveAndLoad.ReloadRoomData()
    local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0)
    for i = 0, #roomConfigStage - 1 do
        local roomConfigRoom = roomConfigStage:Get(i)
        local type = roomConfigRoom.Type
        local name = roomConfigRoom.Name
        local variant = roomConfigRoom.Variant
        if type == RoomType.ROOM_DEVIL and name == "Guilt Devil Room" then
            table.insert(ModRoomIDs.GUILT_DEVIL_ROOMS, variant)
        end
        if type == RoomType.ROOM_SECRET_EXIT then
            if name == "ICU Room" then
                table.insert(ModRoomIDs.ICU_ROOMS, variant)
            elseif name == "Warfarin Blackmarket" then
                table.insert(ModRoomIDs.WARFARIN_BLACK_MARKETS, variant)
            end
        end
        if type == RoomType.ROOM_ERROR and name == "Wake-up Main Room" then
            ModRoomIDs.WAKE_UP_MAIN_ROOM = variant
        end
    end
end
SaveAndLoad:AddPriorityCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, CallbackPriority.EARLY, SaveAndLoad.ReloadRoomData)

return SaveAndLoad