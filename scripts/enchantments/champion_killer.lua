local ChampionKiller = TYU:NewModEnchantment("Champion Killer", "CHAMPION_KILLER")

local Players = TYU.Players
local Utils = TYU.Utils

local ModEnchantmentIDs = TYU.ModEnchantmentIDs

function ChampionKiller:TakeDamage(entity, amount, flags, source, countdown)
    if Utils.HasCurseMist() then
        return
    end
    local npc = entity:ToNPC()
    if not npc then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.CHAMPION_KILLER)
    if count == 0 or not npc:IsChampion() then
        return
    end
    npc:AddBleeding(source, 15 * count)
    npc:BloodExplode()
    return { Damage = amount * (1 + 0.2 * count) }
end
ChampionKiller:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ChampionKiller.TakeDamage)

return ChampionKiller