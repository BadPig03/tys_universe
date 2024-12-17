local Lib = TYU
local CursedPenny = Lib:NewModEntity("Cursed Penny", "CURSEDPENNY")

local function TriggerDifferentEffects(player, id, rng)
    local room = Lib.GAME:GetRoom()
    local position = room:FindFreePickupSpawnPosition(player.Position, 0, true)
    if id == 1 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, position)
    elseif id == 2 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, position)
    elseif id == 3 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, position)
    elseif id == 4 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Lib.ModEntityIDs.CURSEDPENNY.SubType, position)
    elseif id == 5 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, position)
    elseif id == 6 then
        if player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY) == 0 then
            if player:AddActiveCharge(1, ActiveSlot.SLOT_SECONDARY) == 0 then
                player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET)
            end
        end
    elseif id == 7 then
        player:AddBlueFlies(1, player.Position, player)
    elseif id == 8 then
        Lib.GAME:Fart(player.Position, 85, player)
        Lib.GAME:ButterBeanFart(player.Position, 85, player, false, false)
    elseif id == 9 then
        Lib.GAME:MoveToRandomRoom(false, rng:Next(), player)
    end
end

function CursedPenny:PostPickupUpdate(pickup)
    if pickup.SubType ~= Lib.ModEntityIDs.CURSEDPENNY.SubType then
        return
    end
    local sprite = pickup:GetSprite()
    if sprite:IsEventTriggered("DropSound") then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_PENNYDROP, 0.7, 2, false, 1.2)
    end
end
CursedPenny:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CursedPenny.PostPickupUpdate, Lib.ModEntityIDs.CURSEDPENNY.Variant)

function CursedPenny:PostPickupCollision(pickup, collider, low)
    if pickup.SubType ~= Lib.ModEntityIDs.CURSEDPENNY.SubType or (not collider:ToPlayer() and not collider:ToFamiliar() and not collider:ToNPC()) then
        return
    end
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_PENNYPICKUP, 0.7, 2, false, 1.2)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        local rng = player:GetCollectibleRNG(Lib.ModItemIDs.CURSEDTREASURE)
        local effectsOutcome = WeightedOutcomePicker()
        for id = 1, 9 do
            local weight = 1
            if id == 9 and player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
                weight = 0
            end
            effectsOutcome:AddOutcomeWeight(id, weight)
        end
        TriggerDifferentEffects(player, effectsOutcome:PickOutcome(rng), rng)
    end
end
CursedPenny:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, CursedPenny.PostPickupCollision, Lib.ModEntityIDs.CURSEDPENNY.Variant)

function CursedPenny:PrePickupMorph(pickup, type, variant, subType, keepPrice, keepSeed, ignoreModifiers)
    if pickup.Variant == Lib.ModEntityIDs.CURSEDPENNY.Variant and pickup.SubType == Lib.ModEntityIDs.CURSEDPENNY.SubType then
        return false
    end
end
CursedPenny:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CursedPenny.PrePickupMorph)

return CursedPenny