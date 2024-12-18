local Lib = TYU
local TheGospelOfJohn = Lib:NewModItem("The Gospel of John", "THE_GOSPEL_OF_JOHN")

function TheGospelOfJohn:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then   
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local foundAnyCollectible = false
    local morphedAnyCollectible = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if ent.SubType > 0 then
            foundAnyCollectible = true
            local pickup = ent:ToPickup()
            local newType = Lib.Collectibles.GetAngelRoomCollectible(player:GetCollectibleRNG(Lib.ModItemIDs.THE_GOSPEL_OF_JOHN))
            if newType == CollectibleType.COLLECTIBLE_BREAKFAST then
                return { Discharge = false, Remove = false, ShowAnim = true }
            end
            local brokenHearts = Lib.ITEMCONFIG:GetCollectible(newType).Quality - 2
            if player:GetHeartLimit() > brokenHearts * 2 then
                morphedAnyCollectible = true
                player:AddBrokenHearts(brokenHearts)
                Lib.Entities.Morph(pickup, nil, nil, newType, true, true, false, false)
                Lib.ITEMPOOL:RemoveCollectible(newType)
                Lib.Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(2, 2, 2, 1)    
            end
        end
    end
    if foundAnyCollectible and not morphedAnyCollectible then
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
    if useFlags & UseFlag.USE_VOID ~= UseFlag.USE_VOID then
        ItemOverlay.Show(Lib.ModGiantBookIDs.THE_GOSPEL_OF_JOHN, 3, player)
    end
    if not foundAnyCollectible then
        player:AddBrokenHearts(-1)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            player:AddBrokenHearts(-1)
        end
        return { Discharge = true, Remove = false, ShowAnim = true }
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 25 then
        player:AddItemWisp(Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_ANGEL, false), player.Position, true)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 25 then
        player:AddItemWisp(Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, false), player.Position, true)
    end
    return { Discharge = true, Remove = false, ShowAnim = true }
end
TheGospelOfJohn:AddCallback(ModCallbacks.MC_USE_ITEM, TheGospelOfJohn.UseItem, Lib.ModItemIDs.THE_GOSPEL_OF_JOHN)

return TheGospelOfJohn