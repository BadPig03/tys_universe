local EnchantedBook = TYU:NewModItem("Enchanted Book", "ENCHANTED_BOOK")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Enchantments = TYU.Enchantments
local Utils = TYU.Utils
local ModCardIDs = TYU.ModCardIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    PrivateField.GlintSprite = Sprite("gfx/effects/enchanted_book_glint.anm2")
    PrivateField.GlintSprite:Play("Idle", true)
    PrivateField.GlintSprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
    
    function PrivateField.GrantANewEnchantment(player, rng)
        local enchantmentID = Enchantments.GetAnApplicableEnchantment(player, rng:Next())
        if enchantmentID <= 0 then
            return
        end
        Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            return
        end
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, ModCardIDs.ENCHANTED_CARD, Utils.FindFreePickupSpawnPosition(player.Position), nil, nil, rng:Next())
    end
end

function EnchantedBook:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(ModItemIDs.ENCHANTED_BOOK) then
        return
    end
    local hudOffset = Options.HUDOffset
    local extraOffset = Vector(0, 0)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        extraOffset = Vector(0, -4)
    end
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == ModItemIDs.ENCHANTED_BOOK then
        PrivateField.GlintSprite.Scale = Vector(1, 1)
        PrivateField.GlintSprite:Render(Vector(20 + 20 * hudOffset, 16 + 12 * hudOffset) + extraOffset)
    end
    if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == ModItemIDs.ENCHANTED_BOOK then
        PrivateField.GlintSprite.Scale = Vector(0.5, 0.5)
        PrivateField.GlintSprite:Render(Vector(3 + 20 * hudOffset, 8 + 12 * hudOffset) + extraOffset)
    end
end
EnchantedBook:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, EnchantedBook.PostPlayerHUDRenderActiveItem)

function EnchantedBook:PostPickupRender(pickup, offset)
    local layer = pickup:GetSprite():GetLayer("head")
    if pickup.SubType == ModItemIDs.ENCHANTED_BOOK and not Collectibles.IsBlind(pickup) then
        if Utils.HasFlags(layer:GetRenderFlags(), AnimRenderFlags.GOLDEN, true) then
            layer:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
        end
    else
        if Utils.HasFlags(layer:GetRenderFlags(), AnimRenderFlags.GOLDEN) then
            layer:SetRenderFlags(~AnimRenderFlags.GOLDEN | ~AnimRenderFlags.IGNORE_GAME_TIME)
        end
    end
    if pickup.SubType == ModItemIDs.ENCHANTED_BOOK and Collectibles.IsBlind(pickup) then
        Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0.988, 0.792, 0.011, 1)
        pickup:SetForceBlind(false)
        pickup:GetSprite():ReplaceSpritesheet(layer:GetLayerID(), "gfx/items/collectibles/collectibles_enchanted_book.png", true)
    end
end
EnchantedBook:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, EnchantedBook.PostPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

function EnchantedBook:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
        Utils.CreateTimer(function()
            PrivateField.GrantANewEnchantment(player, rng)
        end, 45, 0, true)
    end
    local enchantmentID = Enchantments.GetAnApplicableEnchantment(player, rng:Next())
    if enchantmentID > 0 then
        Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, ModCardIDs.ENCHANTED_CARD, Utils.FindFreePickupSpawnPosition(player.Position), nil, nil, rng:Next())
        end
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    return { Discharge = false, Remove = false, ShowAnim = true }
end
EnchantedBook:AddCallback(ModCallbacks.MC_USE_ITEM, EnchantedBook.UseItem, ModItemIDs.ENCHANTED_BOOK)

return EnchantedBook