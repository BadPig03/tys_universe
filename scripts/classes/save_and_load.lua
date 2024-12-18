local Lib = TYU
local SaveAndLoad = Lib:RegisterNewClass()

function SaveAndLoad:PreGameExit(shouldSave)
    if shouldSave then
        SaveAndLoad.SaveGameState()
    else
        SaveAndLoad.RemoveGameState()
        Isaac.RunCallback(Lib.Callbacks.TYU_POST_RESTART)
    end
    Lib:ClearAllData()
    Isaac.RunCallback(Lib.Callbacks.TYU_POST_EXIT, shouldSave)
end
SaveAndLoad:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveAndLoad.PreGameExit)

function SaveAndLoad:PostGameStarted(continued)
    if continued then
        SaveAndLoad.LoadGameState()
    else
        SaveAndLoad.RemoveGameState()
        Ambush.SetMaxBossChallengeWaves(2)
        Ambush.SetMaxChallengeWaves(3)
    end
    Lib.SetTempGlobalLibData(true, "_SAVEDATA", "GameStateSafe")
end
SaveAndLoad:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.IMPORTANT, SaveAndLoad.PostGameStarted)

function SaveAndLoad:PostNewRoom()
    Isaac.RunCallbackWithParam(Lib.Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, nil, false)
end
SaveAndLoad:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SaveAndLoad.PostNewRoom)

function SaveAndLoad.SaveGameState()
    local data = {}
    data.Global = Lib:GetGlobalLibData()
    data.Players = {}
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        local id = Lib.Players.GetPlayerID(player)
        data.Players[tostring(id)] = Lib:GetPlayerLibData(player)
    end
    SaveAndLoad.WriteGameStateData(data)
    Isaac.RunCallback(Lib.Callbacks.TYU_POST_SAVE)
end

function SaveAndLoad.LoadGameState()
    if not Lib:HasData() then
        return
    end
    local data = SaveAndLoad.ReadGameStateData()
    if not data then
        return
    end
    Lib:SetGlobalLibData(data.Global)
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        local id = tostring(Lib.Players.GetPlayerID(player))
        local playerData = Lib.Table.First(data.Players, function(k, v) return id == v end)
        if playerData then
            Lib:SetPlayerLibData(player, playerData)
        end
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end
    Isaac.RunCallback(Lib.Callbacks.TYU_POST_LOAD)
    Isaac.RunCallbackWithParam(Lib.Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, nil, true)
end

function SaveAndLoad.WriteGameStateData(data)
    local jsonText = Lib.JSON.encode(data)
    Lib:SaveData(jsonText)
end

function SaveAndLoad.ReadGameStateData()
    if not Lib:HasData() then
        return
    end
    local jsonData = Lib:LoadData()
    local loadedData
    local success = pcall(function() loadedData = Lib.JSON.decode(jsonData) end)
    if success and loadedData then
        return loadedData
    end
end

function SaveAndLoad.RemoveGameState()
    SaveAndLoad.WriteGameStateData(nil)
end

function SaveAndLoad.IsGameStateSafe()
    return Lib.GetTempGlobalLibData("_SAVEDATA", "GameStateSafe")
end

function SaveAndLoad.ReloadRoomData()
    local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(0)
    for i = 0, #roomConfigStage - 1 do
        local roomConfigRoom = roomConfigStage:Get(i)
        local type = roomConfigRoom.Type
        local name = roomConfigRoom.Name
        local variant = roomConfigRoom.Variant
        if type == RoomType.ROOM_DEVIL and name == "Guilt Devil Room" then
            table.insert(Lib.ModRoomIDs.GUILT_DEVIL_ROOMS, variant)
        end
        if type == RoomType.ROOM_SECRET_EXIT then
            if name == "ICU Room" then
                table.insert(Lib.ModRoomIDs.ICU_ROOMS, variant)
            elseif name == "Warfarin Blackmarket" then
                table.insert(Lib.ModRoomIDs.WARFARIN_BLACK_MARKETS, variant)
            end
        end
        if type == RoomType.ROOM_ERROR and name == "Wake-up Main Room" then
            Lib.ModRoomIDs.WAKE_UP_MAIN_ROOM = variant
        end
    end
end
SaveAndLoad:AddPriorityCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, CallbackPriority.EARLY, SaveAndLoad.ReloadRoomData)

return SaveAndLoad