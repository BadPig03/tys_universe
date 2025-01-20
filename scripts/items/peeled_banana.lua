local PeeledBanana = TYU:NewModItem("Peeled Banana", "PEELED_BANANA")

local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

function PeeledBanana:PostNewRoom()
    if not Utils.IsRoomFirstVisit() or not Players.AnyoneHasCollectible(ModItemIDs.PEELED_BANANA) then
        return
    end
    for _, player in ipairs(Players.GetPlayers(true)) do
        if player:HasCollectible(ModItemIDs.PEELED_BANANA) and player:GetCollectibleRNG(ModItemIDs.PEELED_BANANA):RandomInt(100) < 25 * player:GetCollectibleNum(ModItemIDs.PEELED_BANANA) then
            player:AddHearts(1)
            local effect = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position - Vector(0, 38))
            effect.DepthOffset = 100
        end
    end
end
PeeledBanana:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PeeledBanana.PostNewRoom)

function PeeledBanana:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(ModItemIDs.PEELED_BANANA) or not player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end
    local count = player:GetCollectibleNum(ModItemIDs.PEELED_BANANA)
    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange + 100 * count
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Stat:AddSpeedUp(player, -0.03 * count)
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + count
    end
end
PeeledBanana:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PeeledBanana.EvaluateCache)

return PeeledBanana