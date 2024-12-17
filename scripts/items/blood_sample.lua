local BloodSample = TYU:NewModItem("Blood Sample", "BLOODSAMPLE")
local Utils = TYU.Utils

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "BloodSample", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "BloodSample", ...)
end

function BloodSample:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasUseFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasUseFlags(useFlags, UseFlag.USE_VOID) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local count = GetPlayerLibData(player, "Counts") or 0
    SetPlayerLibData(player, count + 1, "Counts")
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_SUPERHOLY, 0.6)
    player:AddMaxHearts(2)
    if player:GetPlayerType() == TYU.ModPlayerIDs.WARFARIN and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        player:AddHearts(2)
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
BloodSample:AddCallback(ModCallbacks.MC_USE_ITEM, BloodSample.UseItem, TYU.ModItemIDs.BLOODSAMPLE)

function BloodSample:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(TYU.ModItemIDs.BLOODSAMPLE) or slot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local activeSlot = player:GetActiveItemSlot(TYU.ModItemIDs.BLOODSAMPLE)
    local charge = GetPlayerLibData(player, "Charge") or 0
    player:GetActiveItemDesc(activeSlot).PartialCharge = charge
end
BloodSample:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BloodSample.PostPlayerHUDRenderActiveItem)

return BloodSample