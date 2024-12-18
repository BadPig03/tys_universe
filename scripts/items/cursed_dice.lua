local CursedDice = TYU:NewModItem("Cursed Dice", "CURSED_DICE")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

function CursedDice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = ent:ToPickup()
        if pickup.SubType > CollectibleType.COLLECTIBLE_NULL then
            if Collectibles.IsBlind(pickup) then
                pickup:SetNewOptionsPickupIndex(0)
                pickup.Price = 0
                Entities.Morph(pickup, nil, ModEntityIDs.CURSED_PENNY.Variant, ModEntityIDs.CURSED_PENNY.SubType)
            else
                local item = Collectibles.GetCollectibleFromCurrentRoom(nil, rng)
                Entities.Morph(pickup, nil, nil, item)
                local chance = 0
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                    chance = chance + 10
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
                    chance = chance + 10
                end
                if rng:RandomInt(100) < (100 - chance) then
                    pickup:SetForceBlind(true)
                end
                pickup.Touched = false
            end
        end
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
CursedDice:AddCallback(ModCallbacks.MC_USE_ITEM, CursedDice.UseItem, ModItemIDs.CURSED_DICE)

return CursedDice