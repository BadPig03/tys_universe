do
    TYU.GlobalData = _TYU_DATA and _TYU_DATA.GlobalData or {}
    TYU.PlayersData = _TYU_DATA and _TYU_DATA.PlayersData or {}
    TYU.TempGlobalData = _TYU_DATA and _TYU_DATA.TempGlobalData or {}
    TYU.TempPlayersData = _TYU_DATA and _TYU_DATA.TempPlayersData or {}
    TYU.EntitiesData = _TYU_DATA and _TYU_DATA.EntitiesData or {}
    _TYU_DATA = {
        GlobalData = TYU.GlobalData,
        PlayersData = TYU.PlayersData,
        TempGlobalData = TYU.TempGlobalData,
        TempPlayersData = TYU.TempPlayersData,
        EntitiesData = TYU.EntitiesData
    }
    TYU.DataName = "_TYU"
end

function TYU:GetGlobalLibData(...)
    return TYU.Table.GetField(TYU.GlobalData, TYU.DataName, ...)
end

function TYU:SetGlobalLibData(value, ...)
    TYU.Table.SetField(TYU.GlobalData, value, TYU.DataName, ...)
end

function TYU:GetTempGlobalLibData(...)
    return TYU.Table.GetField(TYU.TempGlobalData, TYU.DataName, ...)
end

function TYU:SetTempGlobalLibData(value, ...)
    TYU.Table.SetField(TYU.TempGlobalData, value, TYU.DataName, ...)
end

function TYU:GetPlayerLibData(player, ...)
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    return TYU.Table.GetField(TYU.PlayersData, tostring(TYU.Players.GetPlayerID(player)), TYU.DataName, ...)
end

function TYU:SetPlayerLibData(player, value, ...)
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    TYU.Table.SetField(TYU.PlayersData, value, tostring(TYU.Players.GetPlayerID(player)), TYU.DataName, ...)
end

function TYU:GetTempEntityLibData(entity, ...)
    local data = entity:ToPlayer() and TYU.TempPlayersData or TYU.EntitiesData
    return TYU.Table.GetField(data, tostring(TYU.Entities.GetEntityID(entity)), TYU.DataName, ...)
end

function TYU:SetTempEntityLibData(entity, value, ...)
    local data = entity:ToPlayer() and TYU.TempPlayersData or TYU.EntitiesData
    TYU.Table.SetField(data, value, tostring(TYU.Entities.GetEntityID(entity)), TYU.DataName, ...)
end

function TYU:CleanEntitiesData()
    local safeIDList = {}
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        local id = TYU.Entities.GetEntityID(ent) 
        safeIDList[tostring(id)] = true
    end
    for k, v in pairs(TYU.EntitiesData) do
        if not safeIDList[k] then
            TYU.EntitiesData[k] = nil
        end
    end
end

function TYU:ClearAllData()
    TYU.Table.Clear(TYU.GlobalData)
    TYU.Table.Clear(TYU.PlayersData)
    TYU.Table.Clear(TYU.TempGlobalData)
    TYU.Table.Clear(TYU.EntitiesData)
    TYU.Table.Clear(TYU.TempPlayersData)
end