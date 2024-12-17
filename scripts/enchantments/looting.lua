local Lib = TYU
local Looting = Lib:NewModEnchantment("Looting", "LOOTING")

local function GetRandomPickupFromBoss(rng)
    local outcomes = WeightedOutcomePicker()
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_CHEST, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_BOMBCHEST, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_LOCKEDCHEST, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_REDCHEST, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_SPIKEDCHEST, 6)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_MIMICCHEST, 6)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_HAUNTEDCHEST, 6)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_WOODENCHEST, 4)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_OLDCHEST, 2)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_ETERNALCHEST, 1)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_MEGACHEST, 1)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_GRAB_BAG, 67)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_TRINKET, 67)
    return outcomes:PickOutcome(rng)
end

local function GetRandomPickupFromChampion(rng)
    local outcomes = WeightedOutcomePicker()
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_LIL_BATTERY, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_TAROTCARD, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_PILL, 10)
    return outcomes:PickOutcome(rng)
end

local function GetRandomPickupFromMonster(rng)
    local outcomes = WeightedOutcomePicker()
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_HEART, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_COIN, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_BOMB, 10)
    outcomes:AddOutcomeWeight(PickupVariant.PICKUP_KEY, 10)
    return outcomes:PickOutcome(rng)
end

function Looting:PostNPCDeath(npc)
    if Lib.GAME:GetRoom():HasCurseMist() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.LOOTING)
    if count == 0 or not npc:IsEnemy() or npc:IsInvincible() or npc.Type == EntityType.ENTITY_SHOPKEEPER or npc.Type == EntityType.ENTITY_FIREPLACE then
        return
    end
    local rng = RNG(npc.InitSeed)
    local position = npc.Position
    if npc.SpawnerEntity then
        count = count / 3
    end
    if npc:IsBoss() then
        if rng:RandomInt(90) < 30 * count then
            local variant = GetRandomPickupFromBoss(rng)
            if variant == PickupVariant.PICKUP_GRAB_BAG and rng:RandomInt(100) < 50 then
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, variant, 1, position)
            else
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, variant, 0, position)
            end
        end
    else
        if npc:IsChampion() then
            if rng:RandomInt(100) < 25 * count then
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, GetRandomPickupFromChampion(rng), 0, position)
            end
        else
            if rng:RandomInt(1000) < 125 * count then
                Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, GetRandomPickupFromMonster(rng), 0, position)
            end
        end
    end
end
Looting:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Looting.PostNPCDeath)

return Looting