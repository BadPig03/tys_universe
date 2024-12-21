local Rewind = TYU:RegisterNewClass()
local Table = TYU.Table
local PrivateField = {}

Rewind.LastGlowingHourglassData = {}
Rewind.LastRewindData = {}
Rewind.GlowingHourglassUsed = false

do
    function PrivateField.GetRewindData()
        return {
            GlobalData = TYU.GlobalData,
            PlayersData = TYU.PlayersData,
            TempGlobalData = TYU.TempGlobalData,
            EntitiesData = TYU.EntitiesData,
            TempPlayersData = TYU.TempPlayersData
        }
    end
    
    function PrivateField.RestoreData(data)
        Table.ReplaceContent(TYU.GlobalData, data.GlobalData)
        Table.ReplaceContent(TYU.PlayersData, data.PlayersData)
        Table.ReplaceContent(TYU.TempGlobalData, data.TempGlobalData)
        Table.ReplaceContent(TYU.EntitiesData, data.EntitiesData)
        Table.ReplaceContent(TYU.TempPlayersData, data.TempPlayersData)
    end
end

function Rewind:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    Rewind.GlowingHourglassUsed = true
end
Rewind:AddCallback(ModCallbacks.MC_USE_ITEM, Rewind.UseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

function Rewind:PostGlowingHourglassSave(slot)
    if slot == 0 then
        Rewind.LastGlowingHourglassData = Table.Clone(PrivateField.GetRewindData())
    end
    if slot == 1 then
        Rewind.LastRewindData = Table.Clone(PrivateField.GetRewindData())
    end
end
Rewind:AddCallback(ModCallbacks.MC_POST_GLOWING_HOURGLASS_SAVE, Rewind.PostGlowingHourglassSave)

function Rewind:PostGlowingHourglassLoad(slot)
    if slot == 0 then
        Rewind.GlowingHourglassUsed = false
        PrivateField.RestoreData(Table.Clone(Rewind.LastGlowingHourglassData))
    end
    if slot == 1 then
        PrivateField.RestoreData(Table.Clone(Rewind.LastRewindData))
    end
end
Rewind:AddCallback(ModCallbacks.MC_POST_GLOWING_HOURGLASS_LOAD, Rewind.PostGlowingHourglassLoad)

return Rewind