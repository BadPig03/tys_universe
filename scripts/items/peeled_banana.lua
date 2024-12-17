local Lib = TYU
local PeeledBanana = Lib:NewModItem("Peeled Banana", "PEELEDBANANA")

function PeeledBanana:PostNewRoom()
    local room = Lib.GAME:GetRoom()
    if not room:IsFirstVisit() or not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.PEELEDBANANA) then
        return
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:HasCollectible(Lib.ModItemIDs.PEELEDBANANA) and player:GetCollectibleRNG(Lib.ModItemIDs.PEELEDBANANA):RandomInt(100) < 25 * player:GetCollectibleNum(Lib.ModItemIDs.PEELEDBANANA) then
            player:AddHearts(1)
            local effect = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position - Vector(0, 38))
            effect.DepthOffset = 100
        end
    end
end
PeeledBanana:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PeeledBanana.PostNewRoom)

function PeeledBanana:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(Lib.ModItemIDs.PEELEDBANANA) or not player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        return
    end
    local count = player:GetCollectibleNum(Lib.ModItemIDs.PEELEDBANANA)
    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange + 100 * count
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Lib.Stat:AddSpeedUp(player, -0.03 * count)
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + count
    end
end
PeeledBanana:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PeeledBanana.EvaluateCache)

return PeeledBanana