local BrokenGlassEye = TYU:NewModTrinket("Broken Glass Eye", "BROKEN_GLASS_EYE")

local Stat = TYU.Stat

local ModTrinketIDs = TYU.ModTrinketIDs

function BrokenGlassEye:EvaluateCache(player, cacheFlag)
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.BROKEN_GLASS_EYE)
    if multiplier == 0 then
        return
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        Stat:AddTearsMultiplier(player, math.min(1, 0.1 * multiplier + 0.8))
    else
        Stat:AddTearsMultiplier(player, math.min(1, 0.15 * multiplier + 0.45))
    end
end
BrokenGlassEye:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenGlassEye.EvaluateCache, CacheFlag.CACHE_FIREDELAY)

function BrokenGlassEye:PostPlayerGetMultiShotParams(player)
    local weapon = player:GetWeapon(1)
    if not weapon then
        return
    end
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.BROKEN_GLASS_EYE)
    if multiplier == 0 then
        return
    end
    local weaponType = weapon:GetWeaponType()
    local params = player:GetMultiShotParams(weaponType)
    local totalNum = math.min(16, params:GetNumTears() + 1)
    params:SetNumTears(totalNum)
    params:SetNumLanesPerEye(totalNum)
    params:SetNumEyesActive(params:GetNumEyesActive())
    params:SetMultiEyeAngle(params:GetMultiEyeAngle())
    if weaponType ~= WeaponType.WEAPON_ROCKETS and weaponType ~= WeaponType.WEAPON_MONSTROS_LUNGS and weaponType ~= WeaponType.WEAPON_LUDOVICO_TECHNIQUE and weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_UMBILICAL_WHIP then
        params:SetSpreadAngle(weaponType, params:GetSpreadAngle(weaponType))
    end
    return params
end
BrokenGlassEye:AddCallback(ModCallbacks.MC_POST_PLAYER_GET_MULTI_SHOT_PARAMS, BrokenGlassEye.PostPlayerGetMultiShotParams)

return BrokenGlassEye