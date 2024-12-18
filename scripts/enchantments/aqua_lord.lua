local Lib = TYU
local AquaLord = Lib:NewModEnchantment("Aqua Lord", "AQUA_LORD")

function AquaLord:EvaluateCache(player, cacheFlag)
    if player:HasCurseMistEffect() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(Lib.ModEnchantmentIDs.AQUA_LORD)
	if count > 0 and Lib.Players.OnValidCreep(player) then
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_ACID
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            Lib.Stat:AddTearsMultiplier(player, 2.5)
        end
    end
end
AquaLord:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AquaLord.EvaluateCache)

function AquaLord:PostPlayerUpdate(player)
    if player:HasCurseMistEffect() then
        return
    end
    if player:GetEffects():HasNullEffect(Lib.ModEnchantmentIDs.AQUA_LORD) then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG, true)
    end
end
AquaLord:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, AquaLord.PostPlayerUpdate, 0)

function AquaLord:PostEffectInit(effect)
    if Lib.GAME:GetRoom():HasCurseMist() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.AQUA_LORD)
    if count > 0 and EntityEffect.IsPlayerCreep(effect.Variant) then
        effect.Scale = effect.Scale + 0.65
    end
end
AquaLord:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, AquaLord.PostEffectInit)

return AquaLord