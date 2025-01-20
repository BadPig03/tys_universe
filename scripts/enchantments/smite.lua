local Smite = TYU:NewModEnchantment("Smite", "SMITE")

local Players = TYU.Players
local Utils = TYU.Utils

local ModEnchantmentIDs = TYU.ModEnchantmentIDs

local PrivateField = {}

do
    PrivateField.SmiteList = {
        [EntityType.ENTITY_GAPER] = true,
        [EntityType.ENTITY_GUSHER] = true,
        [EntityType.ENTITY_HORF] = true,
        [EntityType.ENTITY_LARRYJR] = { [1] = true, [3] = true },
        [EntityType.ENTITY_GLOBIN] = true,
        [EntityType.ENTITY_MAW] = true,
        [EntityType.ENTITY_HOST] = true,
        [EntityType.ENTITY_CHUB] = { [2] = true },
        [EntityType.ENTITY_HOPPER] = { [0] = true, [2] = true, [3] = true },
        [EntityType.ENTITY_MRMAW] = true,
        [EntityType.ENTITY_VIS] = true,
        [EntityType.ENTITY_KNIGHT] = true,
        [EntityType.ENTITY_MONSTRO2] = { [0] = true },
        [EntityType.ENTITY_SLOTH] = true,
        [EntityType.ENTITY_GLUTTONY] = true,
        [EntityType.ENTITY_GREED] = true,
        [EntityType.ENTITY_PIN] = { [2] = true },
        [EntityType.ENTITY_DEATH] = { [0] = true, [20] = true, [30] = true },
        [EntityType.ENTITY_DUKE] = { [1] = true },
        [EntityType.ENTITY_PEEP] = { [1] = true },
        [EntityType.ENTITY_GEMINI] = { [2] = true, [12] = true },
        [EntityType.ENTITY_KEEPER] = true,
        [EntityType.ENTITY_GURGLE] = true,
        [EntityType.ENTITY_HANGER] = true,
        [EntityType.ENTITY_WIDOW] = { [1] = true },
        [EntityType.ENTITY_ISAAC] = { [1] = true },
        [EntityType.ENTITY_MOBILE_HOST] = true,
        [EntityType.ENTITY_DEATHS_HEAD] = true,
        [EntityType.ENTITY_SWINGER] = true,
        [EntityType.ENTITY_SKINNY] = true,
        [EntityType.ENTITY_BONY] = true,
        [EntityType.ENTITY_SPLASHER] = true,
        [EntityType.ENTITY_FLESH_MOBILE_HOST] = true,
        [EntityType.ENTITY_PSY_HORF] = true,
        [EntityType.ENTITY_NULLS] = true,
        [EntityType.ENTITY_FLOATING_KNIGHT] = true,
        [EntityType.ENTITY_MEGA_MAW] = true,
        [EntityType.ENTITY_GATE] = true,
        [EntityType.ENTITY_ADVERSARY] = true,
        [EntityType.ENTITY_THE_LAMB] = true,
        [EntityType.ENTITY_BLACK_BONY] = true,
        [EntityType.ENTITY_BLACK_GLOBIN] = true,
        [EntityType.ENTITY_BLACK_GLOBIN_HEAD] = true,
        [EntityType.ENTITY_BLACK_GLOBIN_BODY] = true,
        [EntityType.ENTITY_BONE_KNIGHT] = true,
        [EntityType.ENTITY_CYCLOPIA] = true,
        [EntityType.ENTITY_FLESH_DEATHS_HEAD] = true,
        [EntityType.ENTITY_HUSH_GAPER] = true,
        [EntityType.ENTITY_GREED_GAPER] = true,
        [EntityType.ENTITY_STAIN] = true,
        [EntityType.ENTITY_FORSAKEN] = true,
        [EntityType.ENTITY_RAG_MAN] = true,
        [EntityType.ENTITY_HUSH] = true,
        [EntityType.ENTITY_HUSH_SKINLESS] = true,
        [EntityType.ENTITY_RAG_MEGA] = true,
        [EntityType.ENTITY_SISTERS_VIS] = true,
        [EntityType.ENTITY_WRAITH] = true,
        [EntityType.ENTITY_DEEP_GAPER] = true,
        [EntityType.ENTITY_SUB_HORF] = true,
        [EntityType.ENTITY_BLURB] = true,
        [EntityType.ENTITY_FISSURE] = true,
        [EntityType.ENTITY_DANNY] = true,
        [EntityType.ENTITY_FACELESS] = true,
        [EntityType.ENTITY_NECRO] = true,
        [EntityType.ENTITY_BIG_BONY] = true,
        [EntityType.ENTITY_EXORCIST] = true,
        [EntityType.ENTITY_VIS_VERSA] = true,
        [EntityType.ENTITY_REVENANT] = true,
        [EntityType.ENTITY_GAPER_L2] = true,
        [EntityType.ENTITY_TWITCHY] = true,
        [EntityType.ENTITY_COHORT] = true,
        [EntityType.ENTITY_FLOATING_HOST] = true,
        [EntityType.ENTITY_EVIS] = true,
        [EntityType.ENTITY_POOT_MINE] = true,
        [EntityType.ENTITY_VIS_FATTY] = true,
        [EntityType.ENTITY_DUSTY_DEATHS_HEAD] = true,
        [EntityType.ENTITY_CLICKETY_CLACK] = true,
        [EntityType.ENTITY_MAZE_ROAMER] = true,
        [EntityType.ENTITY_LIL_BLUB] = true,
        [EntityType.ENTITY_ROTGUT] = { [0] = true, [2] = true },
        [EntityType.ENTITY_MOTHER] = true,
        [EntityType.ENTITY_MIN_MIN] = true
    }
end


function Smite:TakeDamage(entity, amount, flags, source, countdown)
    if Utils.HasCurseMist() or not entity:ToNPC() then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.SMITE)
    if count == 0 or not PrivateField.SmiteList[entity.Type] or (type(PrivateField.SmiteList[entity.Type]) == "table" and not PrivateField.SmiteList[entity.Type][entity.Variant]) then
        return
    end
    entity:AddBleeding(source, 15 * count)
    entity:BloodExplode()
    return { Damage = amount * (1 + 0.2 * count) }
end
Smite:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Smite.TakeDamage)

return Smite