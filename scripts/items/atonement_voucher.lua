local AtonementVoucher = TYU:NewModItem("Atonement Voucher", "ATONEMENTVOUCHER")
local Players = TYU.Players

function AtonementVoucher:PostDevilCalculate(chance)
    if Players.AnyoneHasCollectible(TYU.ModItemIDs.ATONEMENTVOUCHER) then
        if TYU.LEVEL:GetAngelRoomChance() <= 0 then
            TYU.LEVEL:AddAngelRoomChance(1)
        end
        return 1
    end
end
AtonementVoucher:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, AtonementVoucher.PostDevilCalculate)

function AtonementVoucher:PostNewLevel()
    for _, player in pairs(Players.GetPlayers(true)) do
        Players.RemoveCollectibles(player, TYU.ModItemIDs.ATONEMENTVOUCHER, -1)
    end
end
AtonementVoucher:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, AtonementVoucher.PostNewLevel)

function AtonementVoucher:PreAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if TYU.GAME:GetDevilRoomDeals() > 0 then
        player:AddCollectible(CollectibleType.COLLECTIBLE_REDEMPTION)
        return false
    end
end
AtonementVoucher:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, AtonementVoucher.PreAddCollectible, TYU.ModItemIDs.ATONEMENTVOUCHER)

return AtonementVoucher