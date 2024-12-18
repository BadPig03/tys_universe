local Lib = TYU
local CurseOfVanishing = Lib:NewModEnchantment("Curse Of Vanishing", "CURSE_OF_VANISHING")

function CurseOfVanishing:PostPlayerRevive(player)
    if player:HasCurseMistEffect() or not player:GetEffects():HasNullEffect(Lib.ModEnchantmentIDs.CURSE_OF_VANISHING) then
        return
    end
    local primaryActive = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local secondaryActive = player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)
    if secondaryActive > 0 then
        player:RemoveCollectible(secondaryActive, false, ActiveSlot.SLOT_SECONDARY)
    end
    if primaryActive > 0 then
        player:RemoveCollectible(primaryActive, false, ActiveSlot.SLOT_PRIMARY)
    end
end
CurseOfVanishing:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, CurseOfVanishing.PostPlayerRevive)

return CurseOfVanishing