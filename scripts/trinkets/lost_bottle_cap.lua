local Lib = TYU
local LostBottleCap = Lib:NewModTrinket("Lost Bottle Cap", "LOST_BOTTLE_CAP")

function LostBottleCap:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if activeSlot < ActiveSlot.SLOT_PRIMARY then
        return
    end
    local multiplier = player:GetTrinketMultiplier(Lib.ModTrinketIDs.LOST_BOTTLE_CAP)
    local maxCharge = player:GetActiveMaxCharge(activeSlot)
    if multiplier == 0 or rng:RandomInt(90) >= 30 * multiplier or useFlags & UseFlag.USE_OWNED ~= UseFlag.USE_OWNED or maxCharge <= 1 then
        return
    end
    Lib.Utils.CreateTimer(function()
        local active = player:GetActiveItemDesc(activeSlot)
        if active.Item ~= itemID or active.Charge == maxCharge then
            return
        end    
        player:AddActiveCharge(math.ceil(maxCharge / 2), activeSlot, true, false, false)
    end, 1, 0, true)
end
LostBottleCap:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.IMPORTANT, LostBottleCap.UseItem)

return LostBottleCap