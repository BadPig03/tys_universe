local Lib = TYU
local CursedDice = Lib:NewModItem("Cursed Dice", "CURSEDDICE")

function CursedDice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = ent:ToPickup()
        if pickup.SubType > 0 then
            if Lib.Collectibles.IsBlind(pickup) then
                pickup:SetNewOptionsPickupIndex(0)
                pickup.Price = 0
                Lib.Entities.Morph(pickup, nil, Lib.ModEntityIDs.CURSEDPENNY.Variant, Lib.ModEntityIDs.CURSEDPENNY.SubType)
            else
                local newType = Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, RNG(pickup.InitSeed))
                local chance = 0
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                    chance = chance + 10
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
                    chance = chance + 10
                end
                Lib.Entities.Morph(pickup, nil, nil, newType)
                pickup.Touched = false
                if rng:RandomInt(100) < (100 - chance) then
                    pickup:SetForceBlind(true)
                end
            end
        end
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
CursedDice:AddCallback(ModCallbacks.MC_USE_ITEM, CursedDice.UseItem, Lib.ModItemIDs.CURSEDDICE)

return CursedDice