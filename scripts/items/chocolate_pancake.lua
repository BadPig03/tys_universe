local Lib = TYU
local ChocolatePancake = Lib:NewModItem("Chocolate Pancake", "CHOCOLATEPANCAKE")

function ChocolatePancake:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(Lib.ModItemIDs.CHOCOLATEPANCAKE)
    if count < 0 or not player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.2 * count
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Lib.Stat:AddSpeedUp(player, -0.03 * count)
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + count
    end
end
ChocolatePancake:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ChocolatePancake.EvaluateCache)

function ChocolatePancake:PostNPCDeath(npc)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHOCOLATEPANCAKE) then
        return
    end
    local rng = npc:GetDropRNG()
    if (not npc.SpawnerEntity and rng:RandomInt(200) < 5) or (npc.SpawnerEntity and rng:RandomInt(400) < 5) then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, npc.Position) 
    end
end
ChocolatePancake:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ChocolatePancake.PostNPCDeath)

return ChocolatePancake