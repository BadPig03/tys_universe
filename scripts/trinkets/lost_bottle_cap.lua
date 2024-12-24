local LostBottleCap = TYU:NewModTrinket("Lost Bottle Cap", "LOST_BOTTLE_CAP")
local Utils = TYU.Utils
local ModTrinketIDs = TYU.ModTrinketIDs

function LostBottleCap:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if activeSlot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.LOST_BOTTLE_CAP)
    local maxCharge = player:GetActiveMaxCharge(activeSlot)
    if multiplier == 0 or rng:RandomInt(90) >= 30 * multiplier or Utils.HasFlags(useFlags, UseFlag.USE_OWNED, true) or maxCharge <= 1 then
        return
    end
    Utils.CreateTimer(function()
        local active = player:GetActiveItemDesc(activeSlot)
        if active.Item ~= itemID or active.Charge == maxCharge then
            return
        end    
        player:AddActiveCharge(math.ceil(maxCharge / 2), activeSlot, true, false, false)
    end, 1, 0, true)
end
LostBottleCap:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.IMPORTANT, LostBottleCap.UseItem)

return LostBottleCap