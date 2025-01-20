local PhilosophersStaff = TYU:NewModItem("Philosopher's Staff", "PHILOSOPHERS_STAFF")

local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModFoodItemIDs = TYU.ModFoodItemIDs

function PhilosophersStaff:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local discharge = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        local pickup = ent:ToPickup()
        if not pickup:IsShopItem() then
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_GOLD_HEART, 0.6)
            Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, pickup.Position)
            local crater = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, pickup.Position)
            crater:GetSprite().Color:SetColorize(6, 4.5, 0.2, 2)
            TYU.GAME:SpawnParticles(pickup.Position, EffectVariant.COIN_PARTICLE, 25, 7)
            for i = 1, 4 + rng:RandomInt(4) do
                local subType = CoinSubType.COIN_PENNY
                if rng:RandomInt(100) < 10 then
                    subType = rng:RandomInt(CoinSubType.COIN_NICKEL, CoinSubType.COIN_GOLDEN + 1)
                end
                Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, subType, Utils.FindFreePickupSpawnPosition(pickup.Position))
            end
            pickup:Remove()
            discharge = true
        end
    end
    if discharge then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            player:AddWisp(CollectibleType.COLLECTIBLE_GOLDEN_RAZOR, player.Position, true)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            for i = 1, 3 do
                Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, rng:RandomInt(CoinSubType.COIN_PENNY, CoinSubType.COIN_GOLDEN), Utils.FindFreePickupSpawnPosition(player.Position))
            end
        end
    end
    return { Discharge = discharge, Remove = false, ShowAnim = true }
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_USE_ITEM, PhilosophersStaff.UseItem, ModItemIDs.PHILOSOPHERS_STAFF)

function PhilosophersStaff:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.PHILOSOPHERS_STAFF) then
        return
    end
    if player:HasCollectible(ModItemIDs.CHEF_HAT) then
        local bank = TYU:GetGlobalLibData("Foods", "Bank")
        if not bank then
            return
        end
        for i = 1, 4 do
            if bank[i] == ModFoodItemIDs.APPLE - 1 then
                bank[i] = ModFoodItemIDs.GOLDEN_APPLE - 1
            elseif bank[i] == ModFoodItemIDs.CARROT - 1 then
                bank[i] = ModFoodItemIDs.GOLDEN_CARROT - 1
            end
        end
    end
    for i = 0, player:GetMaxTrinkets() do
        local trinket = player:GetTrinket(i)
        if trinket > 0 and Utils.HasFlags(trinket, TrinketType.TRINKET_GOLDEN_FLAG, true) then
            player:TryRemoveTrinket(trinket)
            player:AddTrinket(trinket | TrinketType.TRINKET_GOLDEN_FLAG)
        end
    end
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PhilosophersStaff.PostPlayerUpdate, 0)

function PhilosophersStaff:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(ModItemIDs.PHILOSOPHERS_STAFF) then
        return
    end
    local rng = RNG(npc.InitSeed)
    if (npc.SpawnerEntity and rng:RandomInt(100) >= 4) or (not npc.SpawnerEntity and rng:RandomInt(100) >= 2) then
        return
    end
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, npc.Position) 
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, PhilosophersStaff.PostNPCDeath)

return PhilosophersStaff