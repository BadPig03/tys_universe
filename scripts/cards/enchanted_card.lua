local EnchantedCard = TYU:NewModCard("Enchanted Card", "ENCHANTED_CARD")
local Enchantments = TYU.Enchantments
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModCardIDs = TYU.ModCardIDs
local PrivateField = {}

do
    PrivateField.GlintSprite = Sprite("gfx/effects/enchanted_card_glint.anm2")
    PrivateField.GlintSprite:Play("Idle", true)
    PrivateField.GlintSprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)    
end

function EnchantedCard:PostPickupRender(pickup, offset)
    local sprite = pickup:GetSprite()
    if pickup.SubType == ModCardIDs.ENCHANTED_CARD and Utils.HasFlags(sprite:GetRenderFlags(), AnimRenderFlags.GOLDEN, true) then
        sprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
    end
end
EnchantedCard:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, EnchantedCard.PostPickupRender, PickupVariant.PICKUP_TAROTCARD)

function EnchantedCard:PrePickupCollision(pickup, collider, low)
    if pickup.SubType ~= ModCardIDs.ENCHANTED_CARD or not collider or not collider:ToPlayer() then
        return 
    end
    local player = collider:ToPlayer()
    local enchantmentID = Enchantments.GetARandomEnchantment(pickup.InitSeed, true)
    Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
    Entities.SpawnFakePickupSprite(pickup, true)
    return { Collide = true, SkipCollisionEffects = true }
end
EnchantedCard:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, EnchantedCard.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)

function EnchantedCard:PostUseCard(card, player, useFlags)
    local enchantmentID = Enchantments.GetARandomEnchantment(player:GetCardRNG(ModCardIDs.ENCHANTED_CARD):Next(), true)
    Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
end
EnchantedCard:AddCallback(ModCallbacks.MC_USE_CARD, EnchantedCard.PostUseCard, ModCardIDs.ENCHANTED_CARD)

return EnchantedCard