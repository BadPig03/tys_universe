local Lib = TYU
local Rewind = Lib:RegisterNewClass()

Rewind.LastGlowingHourglassData = {}
Rewind.LastRewindData = {}
Rewind.GlowingHourglassUsed = false

local function GetRewindData()
    return {
        GlobalData = Lib.GlobalData,
        PlayersData = Lib.PlayersData,
        TempGlobalData = Lib.TempGlobalData,
        EntitiesData = Lib.EntitiesData,
        TempPlayersData = Lib.TempPlayersData
    }
end

local function RestoreData(data)
    Lib.Table.ReplaceContent(Lib.GlobalData, data.GlobalData)
    Lib.Table.ReplaceContent(Lib.PlayersData, data.PlayersData)
    Lib.Table.ReplaceContent(Lib.TempGlobalData, data.TempGlobalData)
    Lib.Table.ReplaceContent(Lib.EntitiesData, data.EntitiesData)
    Lib.Table.ReplaceContent(Lib.TempPlayersData, data.TempPlayersData)
end

function Rewind:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    Lib.Rewind.GlowingHourglassUsed = true
end
Rewind:AddCallback(ModCallbacks.MC_USE_ITEM, Rewind.UseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

function Rewind:PostGlowingHourglassSave(slot)
    if slot == 0 then
        Rewind.LastGlowingHourglassData = Lib.Table.Clone(GetRewindData())
    end
    if slot == 1 then
        Rewind.LastRewindData = Lib.Table.Clone(GetRewindData())
    end
end
Rewind:AddCallback(ModCallbacks.MC_POST_GLOWING_HOURGLASS_SAVE, Rewind.PostGlowingHourglassSave)

function Rewind:PostGlowingHourglassLoad(slot)
    if slot == 0 then
        Lib.Rewind.GlowingHourglassUsed = false
        RestoreData(Lib.Table.Clone(Rewind.LastGlowingHourglassData))
    end
    if slot == 1 then
        RestoreData(Lib.Table.Clone(Rewind.LastRewindData))
    end
end
Rewind:AddCallback(ModCallbacks.MC_POST_GLOWING_HOURGLASS_LOAD, Rewind.PostGlowingHourglassLoad)

return Rewind