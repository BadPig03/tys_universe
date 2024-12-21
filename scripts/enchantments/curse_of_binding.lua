local CurseOfBinding = TYU:NewModEnchantment("Curse Of Binding", "CURSE_OF_BINDING")
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs

function CurseOfBinding:PrePickupCollision(pickup, collider, low)
    if Utils.HasCurseMist() or pickup.SubType <= 0 or TYU.ITEMCONFIG:GetCollectible(pickup.SubType).Type ~= ItemType.ITEM_ACTIVE then
        return
    end
    local player = collider:ToPlayer()
    if not player or not player:GetEffects():HasNullEffect(ModEnchantmentIDs.CURSE_OF_BINDING) then
        return
    end
    if (not player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_NULL) or (player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == CollectibleType.COLLECTIBLE_NULL) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
CurseOfBinding:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CurseOfBinding.PrePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)

return CurseOfBinding