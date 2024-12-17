local Lib = TYU
local StrangeSyringe = Lib:NewModItem("Strange Syringe", "STRANGESYRINGE")

function StrangeSyringe:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local count = rng:Next() % 7
    Lib.Entities.CreateTimer(function()
        player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 15)
    end, 30, count, true)
    player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_DRUGS, 3)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_ANGEL, 1)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_EVIL_ANGEL, 1)
    end
    return { Discharge = true, Remove = true, ShowAnim = true }
end
StrangeSyringe:AddCallback(ModCallbacks.MC_USE_ITEM, StrangeSyringe.UseItem, Lib.ModItemIDs.STRANGESYRINGE)

return StrangeSyringe