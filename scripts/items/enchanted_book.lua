local Lib = TYU
local EnchantedBook = Lib:NewModItem("Enchanted Book", "ENCHANTED_BOOK")

local glintSprite = Sprite("gfx/effects/enchanted_book_glint.anm2")
glintSprite:Play("Idle", true)
glintSprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)

local function GrantANewEnchantment(player, rng)
    local enchantmentID = Lib.Enchantments.GetAnApplicableEnchantment(player, rng:Next())
    if enchantmentID > 0 then
        Lib.Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Lib.ModCardIDs.ENCHANTED_CARD, Lib.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true), nil, nil, rng:Next())
        end
    end
end

function EnchantedBook:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(Lib.ModItemIDs.ENCHANTED_BOOK) then
        return
    end
    local hudOffset = Options.HUDOffset
    local extraOffset = Vector(0, 0)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        extraOffset = Vector(0, -4)
    end
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Lib.ModItemIDs.ENCHANTED_BOOK then
        glintSprite.Scale = Vector(1, 1)
        glintSprite:Render(Vector(20 + 20 * hudOffset, 16 + 12 * hudOffset) + extraOffset)
    end
    if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == Lib.ModItemIDs.ENCHANTED_BOOK then
        glintSprite.Scale = Vector(0.5, 0.5)
        glintSprite:Render(Vector(3 + 20 * hudOffset, 8 + 12 * hudOffset) + extraOffset)
    end
end
EnchantedBook:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, EnchantedBook.PostPlayerHUDRenderActiveItem)

function EnchantedBook:PostPickupRender(pickup, offset)
    local layer = pickup:GetSprite():GetLayer("head")
    if pickup.SubType == Lib.ModItemIDs.ENCHANTED_BOOK and not Lib.Collectibles.IsBlind(pickup) then
        if layer:GetRenderFlags() & AnimRenderFlags.GOLDEN ~= AnimRenderFlags.GOLDEN then
            layer:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
        end
    else
        if layer:GetRenderFlags() & AnimRenderFlags.GOLDEN == AnimRenderFlags.GOLDEN then
            layer:SetRenderFlags(~AnimRenderFlags.GOLDEN | ~AnimRenderFlags.IGNORE_GAME_TIME)
        end
    end
    if pickup.SubType == Lib.ModItemIDs.ENCHANTED_BOOK and Lib.Collectibles.IsBlind(pickup) then
        Lib.Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0.988, 0.792, 0.011, 1)
        pickup:SetForceBlind(false)
        pickup:GetSprite():ReplaceSpritesheet(layer:GetLayerID(), "gfx/items/collectibles/collectibles_enchanted_book.png", true)
    end
end
EnchantedBook:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, EnchantedBook.PostPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

function EnchantedBook:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
        Lib.Entities.CreateTimer(function() GrantANewEnchantment(player, rng) end, 45, 0, true)
    end
    local enchantmentID = Lib.Enchantments.GetAnApplicableEnchantment(player, rng:Next())
    if enchantmentID > 0 then
        Lib.Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Lib.ModCardIDs.ENCHANTED_CARD, Lib.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true), nil, nil, rng:Next())
        end
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    return { Discharge = false, Remove = false, ShowAnim = true }
end
EnchantedBook:AddCallback(ModCallbacks.MC_USE_ITEM, EnchantedBook.UseItem, Lib.ModItemIDs.ENCHANTED_BOOK)

return EnchantedBook