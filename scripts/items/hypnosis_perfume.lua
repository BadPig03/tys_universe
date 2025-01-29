local HypnosisPerfume = TYU:NewModItem("Hypnosis Perfume", "HYPNOSIS_PERFUME")

local Entities = TYU.Entities
local Players = TYU.Players

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

function HypnosisPerfume:PostPlayerUpdate(player)
    local hasCollectible = player:HasCollectible(ModItemIDs.HYPNOSIS_PERFUME)
    local hasCharmed = player:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
    if hasCollectible and not hasCharmed then
        player:AddCharmed(EntityRef(player), -1)
    elseif not hasCollectible and hasCharmed then
        player:ClearEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
    end
end
HypnosisPerfume:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HypnosisPerfume.PostPlayerUpdate)

function HypnosisPerfume:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(ModItemIDs.HYPNOSIS_PERFUME) then
        return
    end
    local rng = RNG(npc.InitSeed)
    if (npc.SpawnerEntity and rng:RandomInt(100) >= 10) or (not npc.SpawnerEntity and rng:RandomInt(100) >= 5) then
        return
    end
    local cloud = Entities.Spawn(ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.Type, ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.Variant, ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.SubType, npc.Position):ToEffect()
    cloud.Timeout = 300
end
HypnosisPerfume:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, HypnosisPerfume.PostNPCDeath)

return HypnosisPerfume