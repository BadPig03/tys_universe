local CursedPenny = TYU:NewModEntity("Cursed Penny", "CURSED_PENNY")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.TriggerDifferentEffects(player, id, rng)
        local position = Utils.FindFreePickupSpawnPosition(player.Position)
        if id == 1 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, position)
        elseif id == 2 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, position)
        elseif id == 3 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, position)
        elseif id == 4 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, ModEntityIDs.CURSED_PENNY.SubType, position)
        elseif id == 5 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, position)
        elseif id == 6 then
            if player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY) == 0 then
                if player:AddActiveCharge(1, ActiveSlot.SLOT_SECONDARY) == 0 then
                    player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET)
                end
            end
        elseif id == 7 then
            player:AddBlueFlies(1, player.Position, player)
        elseif id == 8 then
            TYU.GAME:Fart(player.Position, 85, player)
            TYU.GAME:ButterBeanFart(player.Position, 85, player, false, false)
        elseif id == 9 then
            TYU.GAME:MoveToRandomRoom(false, rng:Next(), player)
        end
    end
end

function CursedPenny:PostPickupUpdate(pickup)
    if pickup.SubType ~= ModEntityIDs.CURSED_PENNY.SubType then
        return
    end
    local sprite = pickup:GetSprite()
    if not sprite:IsEventTriggered("DropSound") then
        return
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_PENNYDROP, 0.7, 2, false, 1.2)
end
CursedPenny:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CursedPenny.PostPickupUpdate, ModEntityIDs.CURSED_PENNY.Variant)

function CursedPenny:PostPickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if pickup.SubType ~= ModEntityIDs.CURSED_PENNY.SubType or not player then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.CURSED_TREASURE)
    local effectsOutcome = WeightedOutcomePicker()
    for id = 1, 9 do
        local weight = 1
        if id == 9 and player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
            weight = 0
        end
        effectsOutcome:AddOutcomeWeight(id, weight)
    end
    PrivateField.TriggerDifferentEffects(player, effectsOutcome:PickOutcome(rng), rng)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_PENNYPICKUP, 0.7, 2, false, 1.2)
end
CursedPenny:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, CursedPenny.PostPickupCollision, ModEntityIDs.CURSED_PENNY.Variant)

function CursedPenny:PrePickupMorph(pickup, type, variant, subType, keepPrice, keepSeed, ignoreModifiers)
    if pickup.Variant ~= ModEntityIDs.CURSED_PENNY.Variant or pickup.SubType ~= ModEntityIDs.CURSED_PENNY.SubType then
        return
    end
    return false
end
CursedPenny:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CursedPenny.PrePickupMorph)

return CursedPenny