local Lib = TYU
local BloodyDice = Lib:NewModItem("Bloody Dice", "BLOODYDICE")

local function GetDamagePerCharge(player)
    local count = Lib:GetPlayerLibData(player, "BloodSample", "Counts") or 0
    local charge = 20 + math.log(count ^ 2 + 1) + count ^ 1.2
    if player:HasCollectible(CollectibleType.COLLECTIBLE_4_5_VOLT) then
        charge = charge * 0.8
    end
    if player:GetPlayerType() ~= Lib.ModPlayerIDs["Warfarin"] then
        charge = charge * 1.6
    else
        charge = charge * 0.8
    end
    return math.ceil(charge)
end

function BloodyDice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or useFlags & UseFlag.USE_VOID == UseFlag.USE_VOID then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local collectible = Lib.Collectibles.GetNearestDevilDeal(player.Position, 1 << 12)
    if collectible then
        local newType = Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
        Lib.Entities.Morph(collectible, nil, nil, newType)
        collectible.ShopItemId = -2
        collectible.Price = 0
        collectible:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
        local count = Lib:GetPlayerLibData(player, "BloodSample", "Counts") or 0
        Lib:SetPlayerLibData(player, count + 1, "BloodSample", "Counts")
        return { Discharge = true, Remove = false, ShowAnim = true }
    else
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
end
BloodyDice:AddCallback(ModCallbacks.MC_USE_ITEM, BloodyDice.UseItem, Lib.ModItemIDs.BLOODYDICE)

function BloodyDice:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(Lib.ModItemIDs.BLOODYDICE) or slot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local activeSlot = player:GetActiveItemSlot(Lib.ModItemIDs.BLOODYDICE)
    local charge = Lib:GetPlayerLibData(player, "BloodSample", "Charge") or 0
    player:GetActiveItemDesc(activeSlot).PartialCharge = charge
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BloodyDice.PostPlayerHUDRenderActiveItem)

function BloodyDice:PostUpdate()
    local room = Lib.GAME:GetRoom()
    local damage = room:GetEnemyDamageInflicted()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:HasCollectible(Lib.ModItemIDs.BLOODSAMPLE) or player:HasCollectible(Lib.ModItemIDs.BLOODYDICE) then
            local charge = Lib:GetPlayerLibData(player, "BloodSample", "Charge") or 0
            charge = charge + damage / GetDamagePerCharge(player)
            if charge >= 1 then
                charge = charge - 1
                if player:HasCollectible(Lib.ModItemIDs.BLOODSAMPLE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(Lib.ModItemIDs.BLOODSAMPLE), true, true, true)
                end
                if player:HasCollectible(Lib.ModItemIDs.BLOODYDICE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(Lib.ModItemIDs.BLOODYDICE), true, true, true)
                end
            end
            Lib:SetPlayerLibData(player, charge, "BloodSample", "Charge")
        end
    end
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_UPDATE, BloodyDice.PostUpdate)

return BloodyDice