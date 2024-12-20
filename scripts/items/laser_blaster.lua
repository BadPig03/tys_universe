local LaserBlaster = TYU:NewModItem("Laser Blaster", "LASER_BLASTER")
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}


local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "LaserBlaster", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "LaserBlaster", ...)
end

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "LaserBlaster", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "LaserBlaster", ...)
end

do
    function PrivateField.SetEntityColor(effect, laser)
        local sprite = effect:GetSprite()
        local laserColor = laser.Color:GetColorize()
        if math.abs(laserColor.R) + math.abs(laserColor.G) + math.abs(laserColor.B) > 0 then
            sprite.Color = Color(laserColor.R / 3, laserColor.G / 3, laserColor.B / 3, 1)
        end
    end

    function PrivateField.GetRotationAngle(player)
        local direction = player:GetShootingInput()
        if direction.X == 0 and direction.Y == 0 then
            return math.pi * 0.5
        elseif direction.X == 0 and direction.Y == -1 then
            return math.pi * 1.5
        elseif direction.X == 1 and direction.Y == -1 then
            return math.pi * 1.75
        elseif direction.X == 1 and direction.Y == 0 then
            return 0
        elseif direction.X == 1 and direction.Y == 1 then
            return math.pi * 0.25
        elseif direction.X == 0 and direction.Y == 1 then
            return math.pi * 0.5
        elseif direction.X == -1 and direction.Y == 1 then
            return math.pi * 0.75
        elseif direction.X == -1 and direction.Y == 0 then
            return math.pi
        elseif direction.X == -1 and direction.Y == -1 then
            return math.pi * 1.25
        end
    end

    function PrivateField.FireLaserOrb(player, direction, delay)
        delay = delay or 0
        local laserOrb = Entities.Spawn(ModEntityIDs.LASER_ORB.Type, ModEntityIDs.LASER_ORB.Variant, ModEntityIDs.LASER_ORB.SubType, player.Position, Vector(0, 0), player):ToEffect()
        local laserX = player:FireTechXLaser(laserOrb.Position, Vector(0, 0), 0, player, 1)
        local sprite = laserOrb:GetSprite()
        laserX.Parent = laserOrb
        laserX.ParentOffset = Vector(0, 24)
        laserX.SubType = LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT
        laserX:SetTimeout(0)
        laserX:Update()
        sprite.Color = Color(1, 0, 0, 1)
        sprite.Scale = Vector(0.8, 0.8)
        local orbData = {}
        orbData.Laser = laserX
        orbData.Remove = false
        orbData.MaxVelocity = direction:Normalized():Resized(math.sqrt(player.ShotSpeed * 3))
        orbData.Acceleration = orbData.MaxVelocity:Resized(0.02)
        orbData.DamageScale = 1.05
        orbData.RotationSpeed = 0
        orbData.RotationAngle = 0
        orbData.Time = 0
        orbData.Cooldown = 0
        orbData.MaxCooldown = 240
        orbData.MovingCooldown = delay
        orbData.Type = 1 << -1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
            orbData.Type = orbData.Type | 1 << 0
            orbData.MaxCooldown = orbData.MaxCooldown * 0.6
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
            orbData.Type = orbData.Type | 1 << 0
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_HOMING) then
            orbData.Type = orbData.Type | 1 << 1
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_BOMBERANG) then
            orbData.Type = orbData.Type | 1 << 2
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
            orbData.Type = orbData.Type | 1 << 3
            orbData.MaxCooldown = orbData.MaxCooldown * 2.4
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
            orbData.Type = orbData.Type | 1 << 4
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            orbData.Type = orbData.Type | 1 << 5
            orbData.MaxCooldown = orbData.MaxCooldown * 3.2
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_GROW) then
            orbData.Type = orbData.Type | 1 << 6
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_EXPLOSIVE) then
            orbData.MaxCooldown = orbData.MaxCooldown * 3.2
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_PERSISTENT) then
            orbData.Type = orbData.Type | 1 << 7
            orbData.MaxCooldown = orbData.MaxCooldown * 2.4
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) then
            orbData.MaxCooldown = orbData.MaxCooldown * 1.8
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_BOUNCE) then
            orbData.Type = orbData.Type | 1 << 8
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
            orbData.MovingCooldown = orbData.MovingCooldown + 60
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_ORBIT) then
            orbData.Type = orbData.Type | 1 << 9
            orbData.RotationSpeed = math.pi / 90
            orbData.RotationAngle = PrivateField.GetRotationAngle(player)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5) then
            orbData.MaxCooldown = orbData.MaxCooldown * 0.9
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_SHRINK) then
            orbData.Type = orbData.Type | 1 << 10
            sprite.Scale = Vector(1.6, 1.6)
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_MAGNETIZE) then
            laserOrb:AddEntityFlags(EntityFlag.FLAG_MAGNETIZED)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) or player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) then
            orbData.Type = orbData.Type | 1 << 11
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
            orbData.MaxCooldown = orbData.MaxCooldown * 0.1
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_CONTINUUM) then
            orbData.Type = orbData.Type | 1 << 12
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
            orbData.Type = orbData.Type | 1 << 13
            laserX.Radius = laserX.Radius + 32
        end
        if Utils.HasFlags(player.TearFlags, TearFlags.TEAR_JACOBS) then
            orbData.Type = orbData.Type | 1 << 13
            laserX.Radius = laserX.Radius + 16
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            orbData.DamageScale = orbData.DamageScale * 2
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
            orbData.DamageScale = orbData.DamageScale * 1.5
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            orbData.DamageScale = orbData.DamageScale * 1.25
        end
        orbData.DamageScale = math.max(0.005, orbData.DamageScale)
        orbData.MaxCooldown = math.ceil(math.sqrt(orbData.MaxCooldown))
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_BLOOD_LASER_LARGER, 0.6, 0, false, 1.1)
        SetTempEntityLibData(laserOrb, orbData)
        PrivateField.SetEntityColor(laserOrb, laserX)
    end
end

function LaserBlaster:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_ALLOWWISPSPAWN) then
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    if Utils.HasFlags(useFlags, UseFlag.USE_VOID) then
        PrivateField.FireLaserOrb(player, player:GetRecentMovementVector())
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_OWNED, true) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if player:IsHoldingItem() then
        SetPlayerLibData(player, false, "Lifted")
        player:AnimateCollectible(ModItemIDs.LASER_BLASTER, "HideItem")
    else
        SetPlayerLibData(player, true, "Lifted")
        player:AnimateCollectible(ModItemIDs.LASER_BLASTER, "LiftItem")
    end
    return { Discharge = false, Remove = false, ShowAnim = false }
end
LaserBlaster:AddCallback(ModCallbacks.MC_USE_ITEM, LaserBlaster.UseItem, ModItemIDs.LASER_BLASTER)

function LaserBlaster:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.LASER_BLASTER) then
        return
    end
    if GetPlayerLibData(player, "Lifted") and (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= ModItemIDs.LASER_BLASTER or not player:IsHoldingItem()) then
        SetPlayerLibData(player, false, "Lifted")
        player:AnimateCollectible(ModItemIDs.LASER_BLASTER, "HideItem")
    end
    local direction = player:GetShootingInput()
    if GetPlayerLibData(player, "Lifted") and not (direction.X == 0 and direction.Y == 0) then
        PrivateField.FireLaserOrb(player, direction)
        player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
        player:AnimateCollectible(ModItemIDs.LASER_BLASTER, "HideItem")
        SetPlayerLibData(player, false, "Lifted")
    end
end
LaserBlaster:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, LaserBlaster.PostPlayerUpdate, 0)

function LaserBlaster:PostKnifeUpdate(knife)
    local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
    local remove = GetTempEntityLibData(knife)
    if not player or not remove or knife:GetKnifeDistance() <= knife.MaxDistance * 0.9 then
        return
    end
    knife:Remove()
end
LaserBlaster:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, LaserBlaster.PostKnifeUpdate, KnifeVariant.MOMS_KNIFE)

return LaserBlaster