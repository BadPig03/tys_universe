local ChocolatePancake = TYU:NewModItem("Chocolate Pancake", "CHOCOLATE_PANCAKE")

local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

function ChocolatePancake:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(ModItemIDs.CHOCOLATE_PANCAKE) then
        return
    end
    local rng = npc:GetDropRNG()
    if (not npc.SpawnerEntity and rng:RandomInt(200) < 5) or (npc.SpawnerEntity and rng:RandomInt(400) < 5) then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, Utils.FindFreePickupSpawnPosition(npc.Position))
    end
end
ChocolatePancake:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ChocolatePancake.PostNPCDeath)

function ChocolatePancake:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(ModItemIDs.CHOCOLATE_PANCAKE)
    if count < 0 or not player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.2 * count
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Stat:AddSpeedUp(player, -0.03 * count)
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + count
    end
end
ChocolatePancake:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ChocolatePancake.EvaluateCache)

return ChocolatePancake