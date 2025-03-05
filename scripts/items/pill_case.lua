local PillCase = TYU:NewModItem("Pill Case", "PILL_CASE")

local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.GetPillColors(player)
        local pillLists = {}
        for i = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do
            local pillColor = player:GetPill(i)
            if pillColor ~= PillColor.PILL_NULL then
                table.insert(pillLists, pillColor)
            end
        end
        return pillLists
    end
end

function PillCase:PostUpdate()
    for _, player in ipairs(Players.GetPlayers(true)) do
        if player:HasCollectible(ModItemIDs.PILL_CASE) then
            local pillLists = PrivateField.GetPillColors(player)
            for _, pillColor in ipairs(pillLists) do
                if not TYU.ITEMPOOL:IsPillIdentified(pillColor) then
                    TYU.ITEMPOOL:IdentifyPill(pillColor)
                end
            end 
        end
    end
end
PillCase:AddCallback(ModCallbacks.MC_POST_UPDATE, PillCase.PostUpdate)

function PillCase:PrePlayerAddPill(player, pillColor, slot)
    if not player:HasCollectible(ModItemIDs.PILL_CASE) or Utils.HasFlags(pillColor, PillColor.PILL_GIANT_FLAG) then
        return
    end
    return pillColor | PillColor.PILL_GIANT_FLAG
end
PillCase:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_PILL, PillCase.PrePlayerAddPill)

return PillCase