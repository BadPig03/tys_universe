local Lib = TYU
local BloodSample = Lib:NewModItem("Blood Sample", "BLOODSAMPLE")

function BloodSample:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or useFlags & UseFlag.USE_VOID == UseFlag.USE_VOID then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local count = Lib:GetPlayerLibData(player, "BloodSample", "Counts") or 0
    Lib:SetPlayerLibData(player, count + 1, "BloodSample", "Counts")
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_SUPERHOLY, 0.6)
    player:AddMaxHearts(2)
    if player:GetPlayerType() == Lib.ModPlayerIDs.WARFARIN and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        player:AddHearts(2)
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
BloodSample:AddCallback(ModCallbacks.MC_USE_ITEM, BloodSample.UseItem, Lib.ModItemIDs.BLOODSAMPLE)

function BloodSample:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(Lib.ModItemIDs.BLOODSAMPLE) or slot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local activeSlot = player:GetActiveItemSlot(Lib.ModItemIDs.BLOODSAMPLE)
    local charge = Lib:GetPlayerLibData(player, "BloodSample", "Charge") or 0
    player:GetActiveItemDesc(activeSlot).PartialCharge = charge
end
BloodSample:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BloodSample.PostPlayerHUDRenderActiveItem)

return BloodSample