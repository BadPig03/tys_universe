local AtonementVoucher = TYU:NewModItem("Atonement Voucher", "ATONEMENT_VOUCHER")

local Players = TYU.Players

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.RemoveCollectibles(player, id, count)
        count = count or 1
        if count < 0 then
            count = player:GetCollectibleNum(id)
        end
        for _ = 1, count do
            player:RemoveCollectible(id)
        end
    end
end

function AtonementVoucher:PostDevilCalculate(chance)
    if not Players.AnyoneHasCollectible(ModItemIDs.ATONEMENT_VOUCHER) then
        return
    end
    if TYU.LEVEL:GetAngelRoomChance() <= 0 then
        TYU.LEVEL:AddAngelRoomChance(1)
    end
    return 1
end
AtonementVoucher:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, AtonementVoucher.PostDevilCalculate)

function AtonementVoucher:PostNewLevel()
    for _, player in ipairs(Players.GetPlayers(true)) do
        PrivateField.RemoveCollectibles(player, ModItemIDs.ATONEMENT_VOUCHER, 1)
    end
end
AtonementVoucher:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, AtonementVoucher.PostNewLevel)

function AtonementVoucher:PreAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if TYU.GAME:GetDevilRoomDeals() > 0 then
        player:AddCollectible(CollectibleType.COLLECTIBLE_REDEMPTION)
        return false
    end
end
AtonementVoucher:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, AtonementVoucher.PreAddCollectible, ModItemIDs.ATONEMENT_VOUCHER)

return AtonementVoucher