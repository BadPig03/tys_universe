local Lib = TYU
local CurseOfSalvaging = Lib:NewModEnchantment("Curse Of Salvaging", "CURSEOFSALVAGING")

function CurseOfSalvaging:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if pickup.SubType <= 0 or Lib.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    if not player or player:HasCurseMistEffect() or player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or not player:GetEffects():HasNullEffect(Lib.ModEnchantmentIDs.CURSEOFSALVAGING) or not player:IsExtraAnimationFinished() then
        return
    end
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.ENCHANTEDBOOK)
    if rng:RandomInt(100) < 5 then
        Lib.Entities.SpawnPoof(pickup.Position)
        player:SalvageCollectible(pickup)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_THUMBS_DOWN)
        return { Collide = true, SkipCollisionEffects = true }
    end
end
CurseOfSalvaging:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CurseOfSalvaging.PrePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)

return CurseOfSalvaging