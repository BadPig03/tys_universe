local Lib = TYU

Lib.GlobalData = _TYU_DATA and _TYU_DATA.GlobalData or {}
Lib.PlayersData = _TYU_DATA and _TYU_DATA.PlayersData or {}
Lib.TempGlobalData = _TYU_DATA and _TYU_DATA.TempGlobalData or {}
Lib.TempPlayersData = _TYU_DATA and _TYU_DATA.TempPlayersData or {}
Lib.EntitiesData = _TYU_DATA and _TYU_DATA.EntitiesData or {}
_TYU_DATA = {
    GlobalData = Lib.GlobalData,
    PlayersData = Lib.PlayersData,
    TempGlobalData = Lib.TempGlobalData,
    TempPlayersData = Lib.TempPlayersData,
    EntitiesData = Lib.EntitiesData
}
Lib.DataName = "_TYU"

function Lib:GetGlobalLibData(...)
    return Lib.Table.GetField(Lib.GlobalData, Lib.DataName, ...)
end

function Lib:SetGlobalLibData(value, ...)
    Lib.Table.SetField(Lib.GlobalData, value, Lib.DataName, ...)
end

function Lib:GetTempGlobalLibData(...)
    return Lib.Table.GetField(Lib.TempGlobalData, Lib.DataName, ...)
end

function Lib:SetTempGlobalLibData(value, ...)
    Lib.Table.SetField(Lib.TempGlobalData, value, Lib.DataName, ...)
end

function Lib:GetPlayerLibData(player, ...)
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    return Lib.Table.GetField(Lib.PlayersData, tostring(Lib.Players.GetPlayerID(player)), Lib.DataName, ...)
end

function Lib:SetPlayerLibData(player, value, ...)
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
        player = player:GetOtherTwin()
    end
    Lib.Table.SetField(Lib.PlayersData, value, tostring(Lib.Players.GetPlayerID(player)), Lib.DataName, ...)
end

function Lib:GetTempEntityLibData(entity, ...)
    local data = entity:ToPlayer() and Lib.TempPlayersData or Lib.EntitiesData
    return Lib.Table.GetField(data, tostring(Lib.Entities.GetEntityID(entity)), Lib.DataName, ...)
end

function Lib:SetTempEntityLibData(entity, value, ...)
    local data = entity:ToPlayer() and Lib.TempPlayersData or Lib.EntitiesData
    Lib.Table.SetField(data, value, tostring(Lib.Entities.GetEntityID(entity)), Lib.DataName, ...)
end

function Lib:CleanEntitiesData()
    local safeIDList = {}
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        local id = Lib.Entities.GetEntityID(ent) 
        safeIDList[tostring(id)] = true
    end
    for k, v in pairs(Lib.EntitiesData) do
        if not safeIDList[k] then
            Lib.EntitiesData[k] = nil
        end
    end
end

function Lib:ClearAllData()
    Lib.Table.Clear(Lib.GlobalData)
    Lib.Table.Clear(Lib.PlayersData)
    Lib.Table.Clear(Lib.TempGlobalData)
    Lib.Table.Clear(Lib.EntitiesData)
    Lib.Table.Clear(Lib.TempPlayersData)
end