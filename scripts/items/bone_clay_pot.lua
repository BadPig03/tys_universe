local BoneClayPot = TYU:NewModItem("Bone Clay Pot", "BONE_CLAY_POT")

local Entities = TYU.Entities
local Reverie = TYU.Reverie
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "BoneClayPot", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "BoneClayPot", ...)
end

do
    local charges = {
        [HeartSubType.HEART_HALF] = 1,
        [HeartSubType.HEART_FULL] = 2,
        [HeartSubType.HEART_SCARED] = 2,
        [HeartSubType.HEART_DOUBLEPACK] = 4,
        [HeartSubType.HEART_BLENDED] = 1
    }

    setmetatable(charges, { __index = function() return 0 end })

    function PrivateField.GetHeartCharge(subType)
        return charges[subType]
    end
end

do
    local subTypes = {
        [1] = HeartSubType.HEART_ROTTEN,
        [2] = HeartSubType.HEART_HALF_SOUL,
        [3] = HeartSubType.HEART_BLENDED,
        [4] = HeartSubType.HEART_SOUL,
        [5] = HeartSubType.HEART_BLACK,
        [6] = HeartSubType.HEART_GOLDEN,
        [7] = HeartSubType.HEART_ETERNAL,
        [8] = HeartSubType.HEART_BONE
    }

    setmetatable(subTypes, { __index = function() return -1 end })

    function PrivateField.GetChargeHeart(charge)
        return subTypes[charge]
    end
end

do
    PrivateField.PickupSprite = Sprite("gfx/ui/bone_clay_pot_hearts.anm2", true)
    PrivateField.PickupSprite.Scale = Vector(0.5, 0.5)
end

do
    function PrivateField.TryToAddCharge(player, charge)
        if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= ModItemIDs.BONE_CLAY_POT then
            return false
        end
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 8 then
            return false
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 8 and player:GetBatteryCharge(ActiveSlot.SLOT_PRIMARY) == 8 then
            return false
        end
        player:AddActiveCharge(charge, ActiveSlot.SLOT_PRIMARY, true, false, true)
        return true
    end
end

function BoneClayPot:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_VOID) then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, Utils.FindFreePickupSpawnPosition(player.Position))
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local charge = player:GetActiveCharge(activeSlot)
    local subType = PrivateField.GetChargeHeart(charge)
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, subType, Utils.FindFreePickupSpawnPosition(player.Position))
    if Reverie.WillPlayerBuff(player) then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, subType, Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 5 * charge then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 5 * charge then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, Utils.FindFreePickupSpawnPosition(player.Position)):ToPickup()
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_HEARTOUT, 0.6)
    return { Discharge = true, Remove = false, ShowAnim = true }
end
BoneClayPot:AddCallback(ModCallbacks.MC_USE_ITEM, BoneClayPot.UseItem, ModItemIDs.BONE_CLAY_POT)

function BoneClayPot:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.BONE_CLAY_POT) or pickup:IsShopItem() or player:CanPickRedHearts() then
        return
    end
    local subType = pickup.SubType
    local charge = PrivateField.GetHeartCharge(subType)
    if charge == 0 then
        return
    end
    if not PrivateField.TryToAddCharge(player, charge) then
        return
    end
    if subType == HeartSubType.HEART_BLENDED then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, Utils.FindFreePickupSpawnPosition(player.Position))
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_HEARTIN, 0.6)
    Entities.SpawnFakePickupSprite(pickup)
    pickup:TriggerTheresOptionsPickup()
    pickup:Remove()
    return true
end
BoneClayPot:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BoneClayPot.PrePickupCollision, PickupVariant.PICKUP_HEART)

function BoneClayPot:PostPlayerHUDRenderActiveItem(player, slot, offset, alpha, scale)
    if not player:HasCollectible(ModItemIDs.BONE_CLAY_POT) or player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= ModItemIDs.BONE_CLAY_POT or not TYU.HUD:IsVisible() or player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) == 0 then
        return
    end
    local hudOffset = Options.HUDOffset
    local count = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    PrivateField.PickupSprite:SetFrame("Idle", count - 1)
    PrivateField.PickupSprite:Render(Vector(20 + 20 * hudOffset, 19 + 12 * hudOffset))
end
BoneClayPot:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, BoneClayPot.PostPlayerHUDRenderActiveItem)

function BoneClayPot:PlayerGetActiveMinUsableCharge(slot, player, currentMinUsableCharge)
    return 1
end
BoneClayPot:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, BoneClayPot.PlayerGetActiveMinUsableCharge, ModItemIDs.BONE_CLAY_POT)

return BoneClayPot