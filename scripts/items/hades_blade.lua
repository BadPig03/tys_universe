local HadesBlade = TYU:NewModItem("Hades Blade", "HADES_BLADE")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "HadesBlade", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "HadesBlade", ...)
end

do
    function PrivateField.IsInventoryFull(player)
        if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
            local count = 0
            local limit = 8
            for itemID, itemCount in pairs(player:GetCollectiblesList()) do
                if ItemConfig.Config.IsValidCollectible(itemID) and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT then
                    count = count + itemCount
                end
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                limit = 12
            end
            return count >= limit
        else
            return false
        end
    end

    function PrivateField.GrantsDevilFamiliar(player)
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
        player:TakeDamage(0, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 30)
        local rng = player:GetCollectibleRNG(ModItemIDs.HADES_BLADE)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_POWERUP1 + rng:RandomInt(2), 0.6)
        local item = Collectibles.GetFamiliarsFromItemPool(ItemPoolType.POOL_DEVIL, rng, CollectibleType.COLLECTIBLE_DEMON_BABY)
        local itemCollectible = TYU.ITEMCONFIG:GetCollectible(item)
        if PrivateField.IsInventoryFull(player) then
            local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
            item.Price = 0
            item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
            item:RemoveCollectibleCycle()
            player:AnimateCollectible(ModItemIDs.HADES_BLADE)
        else
            player:AnimateCollectible(item)
            player:QueueItem(itemCollectible)    
        end
        TYU.HUD:ShowItemText(player, itemCollectible)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            local count = GetPlayerLibData(player, "Count") or 0
            SetPlayerLibData(player, count + 1, "Count")
        end
    end
end

function HadesBlade:EvaluateCache(player, cacheFlag)
    local count = GetPlayerLibData(player, "Count") or 0
    Stat:AddFlatDamage(player, 0.2 * count)
end
HadesBlade:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HadesBlade.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function HadesBlade:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local healthType = player:GetHealthType()
    if healthType == HealthType.COIN then
        return { Discharge = false, Remove = false, ShowAnim = true }
    elseif healthType == HealthType.LOST then
        PrivateField.GrantsDevilFamiliar(player)
        return { Discharge = true, Remove = true, ShowAnim = false }
    else
        if player:GetBoneHearts() >= 1 then
            player:AddBoneHearts(-1)
            PrivateField.GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        elseif player:GetMaxHearts() >= 2 then
            player:AddMaxHearts(-2)
            PrivateField.GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        elseif player:GetSoulHearts() >= 6 then
            player:AddSoulHearts(-6)
            PrivateField.GrantsDevilFamiliar(player)
            return { Discharge = true, Remove = false, ShowAnim = false }
        end
    end
    return { Discharge = false, Remove = false, ShowAnim = true }
end
HadesBlade:AddCallback(ModCallbacks.MC_USE_ITEM, HadesBlade.UseItem, ModItemIDs.HADES_BLADE)

return HadesBlade