local BloodyDice = TYU:NewModItem("Bloody Dice", "BLOODYDICE")
local Collectibles = TYU.Collectibles
local Players = TYU.Players
local Utils = TYU.Utils
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "BloodSample", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "BloodSample", ...)
end

do
    function PrivateField.GetDamageAmount(player)
        local count = GetPlayerLibData(player, "Counts") or 0
        local charge = 20 + math.log(count ^ 2 + 1) + count ^ 1.2
        if player:HasCollectible(CollectibleType.COLLECTIBLE_4_5_VOLT) then
            charge = charge * 0.8
        end
        if player:GetPlayerType() ~= TYU.ModPlayerIDs.Warfarin then
            charge = charge * 1.6
        else
            charge = charge * 0.8
        end
        return math.ceil(charge)
    end
end

function BloodyDice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasUseFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasUseFlags(useFlags, UseFlag.USE_VOID) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local collectible = Collectibles.GetNearestDevilDeal(player.Position, 1 << 12)
    if collectible then
        local newType = Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
        TYU.Entities.Morph(collectible, nil, nil, newType)
        collectible.ShopItemId = -2
        collectible.Price = 0
        collectible:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
        local count = GetPlayerLibData(player, "Counts") or 0
        SetPlayerLibData(player, count + 1, "Counts")
        return { Discharge = true, Remove = false, ShowAnim = true }
    else
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
end
BloodyDice:AddCallback(ModCallbacks.MC_USE_ITEM, BloodyDice.UseItem, TYU.ModItemIDs.BLOODYDICE)

function BloodyDice:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(TYU.ModItemIDs.BLOODYDICE) or slot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local activeSlot = player:GetActiveItemSlot(TYU.ModItemIDs.BLOODYDICE)
    local charge = GetPlayerLibData(player, "Charge") or 0
    player:GetActiveItemDesc(activeSlot).PartialCharge = charge
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BloodyDice.PostPlayerHUDRenderActiveItem)

function BloodyDice:PostUpdate()
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.BLOODSAMPLE) and not Players.AnyoneHasCollectible(TYU.ModItemIDs.BLOODYDICE) then
        return
    end
    local room = TYU.GAME:GetRoom()
    local damage = room:GetEnemyDamageInflicted()
    for _, player in pairs(Players.GetPlayers(true)) do
        if player:HasCollectible(TYU.ModItemIDs.BLOODSAMPLE) or player:HasCollectible(TYU.ModItemIDs.BLOODYDICE) then
            local charge = GetPlayerLibData(player, "Charge") or 0
            charge = charge + damage / PrivateField.GetDamageAmount(player)
            if charge >= 1 then
                charge = charge - 1
                if player:HasCollectible(TYU.ModItemIDs.BLOODSAMPLE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(TYU.ModItemIDs.BLOODSAMPLE), true, true, true)
                end
                if player:HasCollectible(TYU.ModItemIDs.BLOODYDICE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(TYU.ModItemIDs.BLOODYDICE), true, true, true)
                end
            end
            SetPlayerLibData(player, charge, "Charge")
        end
    end
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_UPDATE, BloodyDice.PostUpdate)

return BloodyDice