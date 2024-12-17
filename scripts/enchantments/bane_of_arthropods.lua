local Lib = TYU
local BaneOfArthropods = Lib:NewModEnchantment("Bane Of Arthropods", "BANEOFARTHROPODS")

local arthropodList = {
    [EntityType.ENTITY_FLY] = true,
    [EntityType.ENTITY_POOTER] = true,
    [EntityType.ENTITY_ATTACKFLY] = true,
    [EntityType.ENTITY_LARRYJR] = true,
    [EntityType.ENTITY_BOOMFLY] = true,
    [EntityType.ENTITY_SUCKER] = true,
    [EntityType.ENTITY_PIN] = true,
    [EntityType.ENTITY_MOTER] = true,
    [EntityType.ENTITY_SPIDER] = true,
    [EntityType.ENTITY_SWARMER] = true,
    [EntityType.ENTITY_BIGSPIDER] = true,
    [EntityType.ENTITY_ETERNALFLY] = true,
    [EntityType.ENTITY_WIDOW] = true,
    [EntityType.ENTITY_DADDYLONGLEGS] = true,
    [EntityType.ENTITY_NEST] = true,
    [EntityType.ENTITY_BABY_LONG_LEGS] = true,
    [EntityType.ENTITY_CRAZY_LONG_LEGS] = true,
    [EntityType.ENTITY_FLY_L2] = true,
    [EntityType.ENTITY_SPIDER_L2] = true,
    [EntityType.ENTITY_RING_OF_FLIES] = true,
    [EntityType.ENTITY_WALL_CREEP] = true,
    [EntityType.ENTITY_RAGE_CREEP] = true,
    [EntityType.ENTITY_BLIND_CREEP] = true,
    [EntityType.ENTITY_RAGLING] = true,
    [EntityType.ENTITY_FULL_FLY] = true,
    [EntityType.ENTITY_TICKING_SPIDER] = true,
    [EntityType.ENTITY_DART_FLY] = true,
    [EntityType.ENTITY_SWARM] = true,
    [EntityType.ENTITY_HUSH_FLY] = true,
    [EntityType.ENTITY_BLISTER] = true,
    [EntityType.ENTITY_THE_THING] = true,
    [EntityType.ENTITY_WILLO] = true,
    [EntityType.ENTITY_STRIDER] = true,
    [EntityType.ENTITY_ROCK_SPIDER] = true,
    [EntityType.ENTITY_FLY_BOMB] = true,
    [EntityType.ENTITY_WILLO_L2] = true,
    [EntityType.ENTITY_TWITCHY] = true,
    [EntityType.ENTITY_ARMYFLY] = true,
    [EntityType.ENTITY_REAP_CREEP] = true,
    [EntityType.ENTITY_SWARM_SPIDER] = true,
    [EntityType.ENTITY_BABY_PLUM] = true,
    [EntityType.ENTITY_BEAST] = { [11] = true, [21] = true, [23] = true }
}

function BaneOfArthropods:TakeDamage(entity, amount, flags, source, countdown)
    if Lib.GAME:GetRoom():HasCurseMist() or not entity:ToNPC() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.BANEOFARTHROPODS)
    if count == 0 or not arthropodList[entity.Type] or (type(arthropodList[entity.Type]) == "table" and not arthropodList[entity.Type][entity.Variant]) then
        return
    end
    entity:AddBleeding(source, 15 * count)
    entity:BloodExplode()
    return { Damage = amount * (1 + 0.2 * count) }
end
BaneOfArthropods:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BaneOfArthropods.TakeDamage)

return BaneOfArthropods