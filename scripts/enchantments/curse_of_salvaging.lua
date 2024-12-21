local CurseOfSalvaging = TYU:NewModEnchantment("Curse Of Salvaging", "CURSE_OF_SALVAGING")
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs

function CurseOfSalvaging:PrePickupCollision(pickup, collider, low)
    if Utils.HasCurseMist() or pickup.SubType <= 0 or TYU.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or not player:GetEffects():HasNullEffect(ModEnchantmentIDs.CURSE_OF_SALVAGING) or not player:IsExtraAnimationFinished() then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.ENCHANTED_BOOK)
    if rng:RandomInt(100) < 5 then
        Entities.SpawnPoof(pickup.Position)
        player:SalvageCollectible(pickup)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return { Collide = true, SkipCollisionEffects = true }
    end
end
CurseOfSalvaging:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CurseOfSalvaging.PrePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)

return CurseOfSalvaging