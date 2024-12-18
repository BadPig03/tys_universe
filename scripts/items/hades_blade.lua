local Lib = TYU
local HadesBlade = Lib:NewModItem("Hades Blade", "HADES_BLADE")

local function GrantsDevilFamiliar(player)
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.HADES_BLADE)
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
    player:TakeDamage(0, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 30)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_POWERUP1 + rng:RandomInt(2), 0.6)
    local item = Lib.Collectibles.GetFamiliarsFromItemPool(ItemPoolType.POOL_DEVIL, rng, CollectibleType.COLLECTIBLE_DEMON_BABY)
    local itemConfigCollectible = Lib.ITEMCONFIG:GetCollectible(item)
    if Lib.Players.IsInventoryFull(player) then
        local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, Lib.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true)):ToPickup()
        item.Price = 0
        item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
        item:RemoveCollectibleCycle()
        player:AnimateCollectible(Lib.ModItemIDs.HADES_BLADE)
    else
        player:AnimateCollectible(item)
        player:QueueItem(itemConfigCollectible)    
    end
    Lib.HUD:ShowItemText(player, itemConfigCollectible)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        local count = Lib:GetPlayerLibData(player, "HadesBlade", "Count") or 0
        Lib:SetPlayerLibData(player, count + 1, "HadesBlade", "Count")
	end
end

function HadesBlade:EvaluateCache(player, cacheFlag)
    local count = Lib:GetPlayerLibData(player, "HadesBlade", "Count") or 0
    Lib.Stat:AddFlatDamage(player, 0.2 * count)
end
HadesBlade:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HadesBlade.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function HadesBlade:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if player:GetHealthType() == HealthType.COIN then
        return { Discharge = false, Remove = false, ShowAnim = true }
    elseif player:GetHealthType() == HealthType.LOST then
        GrantsDevilFamiliar(player)
        return { Discharge = true, Remove = true, ShowAnim = false }
    else
        if player:GetBoneHearts() >= 1 then
            player:AddBoneHearts(-1)
            GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        elseif player:GetMaxHearts() >= 2 then
            player:AddMaxHearts(-2)
            GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        elseif player:GetSoulHearts() >= 6 then
            player:AddSoulHearts(-6)
            GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        end
    end
    return { Discharge = false, Remove = false, ShowAnim = true }
end
HadesBlade:AddCallback(ModCallbacks.MC_USE_ITEM, HadesBlade.UseItem, Lib.ModItemIDs.HADES_BLADE)

return HadesBlade