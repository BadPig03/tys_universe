local Lib = TYU
local CurseOfBinding = Lib:NewModEnchantment("Curse Of Binding", "CURSEOFBINDING")

function CurseOfBinding:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if pickup.SubType <= 0 or Lib.ITEMCONFIG:GetCollectible(pickup.SubType).Type ~= ItemType.ITEM_ACTIVE then
        return
    end
    if not player or player:HasCurseMistEffect() or not player:GetEffects():HasNullEffect(Lib.ModEnchantmentIDs.CURSEOFBINDING) then
        return
    end
    if (not player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_NULL) or (player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == CollectibleType.COLLECTIBLE_NULL) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
CurseOfBinding:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CurseOfBinding.PrePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)

return CurseOfBinding