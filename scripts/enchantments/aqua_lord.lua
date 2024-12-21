local AquaLord = TYU:NewModEnchantment("Aqua Lord", "AQUA_LORD")
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local PrivateField = {}

do
    function PrivateField.OnValidCreep(player)
        local creepList = {
            [EffectVariant.CREEP_RED] = true,
            [EffectVariant.CREEP_GREEN] = true,
            [EffectVariant.CREEP_YELLOW] = true,
            [EffectVariant.CREEP_WHITE] = true,
            [EffectVariant.CREEP_BLACK] = true,
            [EffectVariant.PLAYER_CREEP_LEMON_MISHAP] = true,
            [EffectVariant.PLAYER_CREEP_HOLYWATER] = true,
            [EffectVariant.PLAYER_CREEP_WHITE] = true,
            [EffectVariant.PLAYER_CREEP_BLACK] = true,
            [EffectVariant.PLAYER_CREEP_RED] = true,
            [EffectVariant.PLAYER_CREEP_GREEN] = true,
            [EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = true,
            [EffectVariant.CREEP_BROWN] = true,
            [EffectVariant.PLAYER_CREEP_LEMON_PARTY] = true,
            [EffectVariant.PLAYER_CREEP_PUDDLE_MILK] = true,
            [EffectVariant.CREEP_SLIPPERY_BROWN] = true,
            [EffectVariant.CREEP_SLIPPERY_BROWN_GROWING] = true,
            [EffectVariant.CREEP_STATIC] = true,
            [EffectVariant.CREEP_LIQUID_POOP] = true
        }
        local room = TYU.GAME:GetRoom()
        if room:HasWater() or room:GetWaterAmount() > 0 then
            return true
        end
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            if ent.Type == EntityType.ENTITY_EFFECT and creepList[ent.Variant] and player.Position:Distance(ent.Position) <= ent.Size * ent:ToEffect().Scale * 1.25 then
                return true
            end
        end
        return false
    end
end

function AquaLord:EvaluateCache(player, cacheFlag)
    if Utils.HasCurseMist() then
        return
    end
    local count = player:GetEffects():GetNullEffectNum(ModEnchantmentIDs.AQUA_LORD)
	if count == 0 or not PrivateField.OnValidCreep(player) then
        return
    end
    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_ACID
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        Stat:AddTearsMultiplier(player, 2.5)
    end
end
AquaLord:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AquaLord.EvaluateCache)

function AquaLord:PostPlayerUpdate(player)
    if player:HasCurseMistEffect() then
        return
    end
    if player:GetEffects():HasNullEffect(ModEnchantmentIDs.AQUA_LORD) then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG, true)
    end
end
AquaLord:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, AquaLord.PostPlayerUpdate, 0)

function AquaLord:PostEffectInit(effect)
    if TYU.GAME:GetRoom():HasCurseMist() then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.AQUA_LORD)
    if count == 0 or not EntityEffect.IsPlayerCreep(effect.Variant) then
        return
    end
    effect.Scale = effect.Scale + 0.65
end
AquaLord:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, AquaLord.PostEffectInit)

return AquaLord