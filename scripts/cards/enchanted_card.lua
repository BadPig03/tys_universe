local Lib = TYU
local EnchantedCard = Lib:NewModCard("Enchanted Card", "ENCHANTEDCARD")

local glintSprite = Sprite("gfx/effects/enchanted_card_glint.anm2")
glintSprite:Play("Idle", true)
glintSprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)

function EnchantedCard:PostPickupRender(pickup, offset)
    local sprite = pickup:GetSprite()
    if pickup.SubType == Lib.ModCardIDs.ENCHANTEDCARD and sprite:GetRenderFlags() & AnimRenderFlags.GOLDEN ~= AnimRenderFlags.GOLDEN then
        sprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
    end
end
EnchantedCard:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, EnchantedCard.PostPickupRender, PickupVariant.PICKUP_TAROTCARD)

function EnchantedCard:PrePickupCollision(pickup, collider, low)
    if pickup.SubType ~= Lib.ModCardIDs.ENCHANTEDCARD or not collider or not collider:ToPlayer() then
        return 
    end
    local player = collider:ToPlayer()
    local enchantmentID = Lib.Enchantments.GetARandomEnchantment(pickup.InitSeed, true)
    Lib.Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
    Lib.Entities.SpawnFakePickupSprite(pickup, true)
    return { Collide = true, SkipCollisionEffects = true }
end
EnchantedCard:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, EnchantedCard.PrePickupCollision, PickupVariant.PICKUP_TAROTCARD)

function EnchantedCard:PostUseCard(card, player, useFlags)
    local enchantmentID = Lib.Enchantments.GetARandomEnchantment(player:GetCardRNG(Lib.ModCardIDs.ENCHANTEDCARD):Next(), true)
    Lib.Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
end
EnchantedCard:AddCallback(ModCallbacks.MC_USE_CARD, EnchantedCard.PostUseCard, Lib.ModCardIDs.ENCHANTEDCARD)

return EnchantedCard