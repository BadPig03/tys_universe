local Lib = TYU
local PhilosophersStaff = Lib:NewModItem("Philosopher's Staff", "PHILOSOPHERSSTAFF")

function PhilosophersStaff:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local room = Lib.GAME:GetRoom()
    local discharge = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        if not ent:ToPickup():IsShopItem() then
            Lib.SFXMANAGER:Play(SoundEffect.SOUND_GOLD_HEART, 0.6)
            Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, ent.Position)
            local crater = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, ent.Position)
            crater:GetSprite().Color:SetColorize(6, 4.5, 0.2, 2)
            Lib.GAME:SpawnParticles(ent.Position, EffectVariant.COIN_PARTICLE, 25, 7)
            for i = 1, 4 + rng:RandomInt(4) do
                local subType = CoinSubType.COIN_PENNY
                if rng:RandomInt(100) < 10 then
                    subType = rng:RandomInt(CoinSubType.COIN_NICKEL, CoinSubType.COIN_GOLDEN + 1)
                end
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, subType, room:FindFreePickupSpawnPosition(ent.Position, 0, true))
            end
            ent:Remove()
            discharge = true
        end
    end
    if discharge then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            player:AddWisp(CollectibleType.COLLECTIBLE_GOLDEN_RAZOR, player.Position, true)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            for i = 1, 3 do
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, rng:RandomInt(CoinSubType.COIN_PENNY, CoinSubType.COIN_GOLDEN), room:FindFreePickupSpawnPosition(player.Position, 0, true))
            end
        end
    end
    return { Discharge = discharge, Remove = false, ShowAnim = true }
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_USE_ITEM, PhilosophersStaff.UseItem, Lib.ModItemIDs.PHILOSOPHERSSTAFF)

function PhilosophersStaff:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.PHILOSOPHERSSTAFF) then
        return
    end
    if player:HasCollectible(Lib.ModItemIDs.CHEFHAT) then
        local bank = Lib:GetGlobalLibData("Foods", "Bank")
        if not bank then
            return
        end
        for i = 1, 4 do
            if bank[i] == Lib.ModFoodItemIDs.APPLE - 1 then
                bank[i] = Lib.ModFoodItemIDs.GOLDENAPPLE - 1
            elseif bank[i] == Lib.ModFoodItemIDs.CARROT - 1 then
                bank[i] = Lib.ModFoodItemIDs.GOLDENCARROT - 1
            end
        end
    end
    for i = 0, player:GetMaxTrinkets() do
        local trinket = player:GetTrinket(i)
        if trinket > 0 and trinket & TrinketType.TRINKET_GOLDEN_FLAG ~= TrinketType.TRINKET_GOLDEN_FLAG then
            player:TryRemoveTrinket(trinket)
            player:AddTrinket(trinket | TrinketType.TRINKET_GOLDEN_FLAG)
        end
    end
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PhilosophersStaff.PostPlayerUpdate, 0)

function PhilosophersStaff:PostNPCDeath(npc)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.PHILOSOPHERSSTAFF) then
        return
    end
    local rng = RNG(npc.InitSeed)
    if (not npc.SpawnerEntity and rng:RandomInt(100) < 4) or (npc.SpawnerEntity and rng:RandomInt(100) < 2) then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, npc.Position) 
    end
end
PhilosophersStaff:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, PhilosophersStaff.PostNPCDeath)

return PhilosophersStaff