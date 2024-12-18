local Lib = TYU
local ChampionKiller = Lib:NewModEnchantment("Champion Killer", "CHAMPION_KILLER")

function ChampionKiller:TakeDamage(entity, amount, flags, source, countdown)
    if Lib.GAME:GetRoom():HasCurseMist() then
        return
    end
    local npc = entity:ToNPC()
    if not npc then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.CHAMPION_KILLER)
    if count == 0 or not npc:IsChampion() then
        return
    end
    npc:AddBleeding(source, 15 * count)
    npc:BloodExplode()
    return { Damage = amount * (1 + 0.2 * count) }
end
ChampionKiller:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ChampionKiller.TakeDamage)

return ChampionKiller