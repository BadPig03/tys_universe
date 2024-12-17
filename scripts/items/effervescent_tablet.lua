local Lib = TYU
local EffervescentTablet = Lib:NewModItem("Effervescent Tablet", "EFFERVESCENTTABLET")

function EffervescentTablet:EvaluateCache(player, cacheFlag)
    if not player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.EFFERVESCENTTABLETEFFECT) then
        return
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        Lib.Stat:SetSpeedMultiplier(player, 0.1)
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        Lib.Stat:AddTearsMultiplier(player, 2.5)
    end
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local damageMultiplier = 0.1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            damageMultiplier = 0.5
        end
        Lib.Stat:SetDamageMultiplier(player, damageMultiplier)
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed / 2
    end
    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        if player:HasWeaponType(WeaponType.WEAPON_TEARS) then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PUNCH | TearFlags.TEAR_POP | TearFlags.TEAR_BOUNCE_WALLSONLY
        else
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PUNCH
        end
    end
end
EffervescentTablet:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EffervescentTablet.EvaluateCache)

function EffervescentTablet:PostFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player or not player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.EFFERVESCENTTABLETEFFECT) then
        return
    end
    tear:ChangeVariant(TearVariant.BALLOON_BRIMSTONE)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        local color = Color(1, 1, 1, 0.7, 0, 0, 0)
        color:SetColorize(5, 5, 5, 1.5)
        tear:SetColor(color, 8192, 99, false, false)    
    end
end
EffervescentTablet:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, EffervescentTablet.PostFireTear)

function EffervescentTablet:PostFamiliarFireProjectile(tear)
    if not tear or not tear:ToTear() then
        return
    end
    local familiar = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar()
    if familiar.SubType ~= Lib.ModItemIDs.EFFERVESCENTTABLET then
        return
    end
    local color = Color(1, 1, 1, 0.7, 0, 0, 0)
    color:SetColorize(5, 5, 5, 1.5)
    tear:SetColor(color, 8192, 99, false, false)   
end
EffervescentTablet:AddCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, EffervescentTablet.PostFamiliarFireProjectile, FamiliarVariant.WISP)

function EffervescentTablet:FamiliarUpdate(familiar)
    if familiar.SubType ~= Lib.ModItemIDs.EFFERVESCENTTABLET then
        return
    end
    if familiar.FrameCount >= 240 then
        familiar:TakeDamage(10, 0, EntityRef(familiar), 0)
    end
end
EffervescentTablet:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EffervescentTablet.FamiliarUpdate, FamiliarVariant.WISP)

function EffervescentTablet:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    player:AddNullItemEffect(Lib.ModNullItemIDs.EFFERVESCENTTABLETEFFECT, true, 120, true)
    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    return { Discharge = true, Remove = false, ShowAnim = true }
end
EffervescentTablet:AddCallback(ModCallbacks.MC_USE_ITEM, EffervescentTablet.UseItem, Lib.ModItemIDs.EFFERVESCENTTABLET)

return EffervescentTablet