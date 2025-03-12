local TwistedLovers = TYU:NewModTrinket("Twisted Lovers", "TWISTED_LOVERS")

local ModTrinketIDs = TYU.ModTrinketIDs

local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local PrivateField = {}

do
    function PrivateField.AddBrokenHearts(player)
        local healthType = player:GetHealthType()
        if healthType == HealthType.BONE then
            player:AddBoneHearts(-2)
        elseif healthType == HealthType.SOUL then
            player:AddSoulHearts(-4)
        else
            player:AddMaxHearts(-2)
        end
        player:AddBrokenHearts(1)
        Entities.SpawnPoof(player.Position):GetSprite().Color:SetColorize(1, 0, 0, 1)
    end
end

function TwistedLovers:PreUseCard(cardID, player, useFlag)
    local multiplier = Players.GetTotalTrinketMultiplier(ModTrinketIDs.TWISTED_LOVERS)
    if multiplier == 0 or Utils.HasFlags(useFlag, UseFlag.USE_CARBATTERY) or cardID > Card.CARD_WORLD then
        return
    end
    PrivateField.AddBrokenHearts(player)
    player:UseCard(cardID + Card.CARD_REVERSE_FOOL - Card.CARD_FOOL, useFlag | UseFlag.USE_CARBATTERY)
    return true
end
TwistedLovers:AddCallback(ModCallbacks.MC_PRE_USE_CARD, TwistedLovers.PreUseCard)

return TwistedLovers