local BloodyDice = TYU:NewModItem("Bloody Dice", "BLOODY_DICE")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local ModPlayerIDs = TYU.ModPlayerIDs
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
        if player:GetPlayerType() ~= ModPlayerIDs.Warfarin then
            charge = charge * 1.6
        else
            charge = charge * 0.8
        end
        return math.ceil(charge)
    end
end

function BloodyDice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_VOID) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local collectible = Collectibles.GetNearestDevilDeal(player.Position, 1 << 12)
    if collectible then
        local newType = Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
        Entities.Morph(collectible, nil, nil, newType)
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
BloodyDice:AddCallback(ModCallbacks.MC_USE_ITEM, BloodyDice.UseItem, ModItemIDs.BLOODY_DICE)

function BloodyDice:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(ModItemIDs.BLOODY_DICE) or slot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local activeSlot = player:GetActiveItemSlot(ModItemIDs.BLOODY_DICE)
    local charge = GetPlayerLibData(player, "Charge") or 0
    player:GetActiveItemDesc(activeSlot).PartialCharge = charge
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BloodyDice.PostPlayerHUDRenderActiveItem)

function BloodyDice:PostUpdate()
    if not Players.AnyoneHasCollectible(ModItemIDs.BLOOD_SAMPLE) and not Players.AnyoneHasCollectible(ModItemIDs.BLOODY_DICE) then
        return
    end
    local room = TYU.GAME:GetRoom()
    local damage = room:GetEnemyDamageInflicted()
    for _, player in pairs(Players.GetPlayers(true)) do
        if player:HasCollectible(ModItemIDs.BLOOD_SAMPLE) or player:HasCollectible(ModItemIDs.BLOODY_DICE) then
            local charge = GetPlayerLibData(player, "Charge") or 0
            charge = charge + damage / PrivateField.GetDamageAmount(player)
            if charge >= 1 then
                charge = charge - 1
                if player:HasCollectible(ModItemIDs.BLOOD_SAMPLE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(ModItemIDs.BLOOD_SAMPLE), true, true, true)
                end
                if player:HasCollectible(ModItemIDs.BLOODY_DICE) then
                    player:AddActiveCharge(1, player:GetActiveItemSlot(ModItemIDs.BLOODY_DICE), true, true, true)
                end
            end
            SetPlayerLibData(player, charge, "Charge")
        end
    end
end
BloodyDice:AddCallback(ModCallbacks.MC_POST_UPDATE, BloodyDice.PostUpdate)

return BloodyDice