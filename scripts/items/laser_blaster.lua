local Lib = TYU
local LaserBlaster = Lib:NewModItem("Laser Blaster", "LASER_BLASTER")

local function SetEntityColor(effect, laser)
    local sprite = effect:GetSprite()
    local laserColor = laser.Color:GetColorize()
    if math.abs(laserColor.R) + math.abs(laserColor.G) + math.abs(laserColor.B) > 0 then
        sprite.Color = Color(laserColor.R / 3, laserColor.G / 3, laserColor.B / 3, 1)
    end
end

local function FireLaserOrb(player, direction, delay)
    delay = delay or 0
    local laserOrb = Lib.Entities.Spawn(Lib.ModEntityIDs.LASER_ORB.Type, Lib.ModEntityIDs.LASER_ORB.Variant, Lib.ModEntityIDs.LASER_ORB.SubType, player.Position, Vector(0, 0), player):ToEffect()
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
    if player.TearFlags & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING then
        orbData.Type = orbData.Type | 1 << 1
    end
    if player.TearFlags & TearFlags.TEAR_BOMBERANG == TearFlags.TEAR_BOMBERANG then
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
    if player.TearFlags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW then
        orbData.Type = orbData.Type | 1 << 6
    end
    if player.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
        orbData.MaxCooldown = orbData.MaxCooldown * 3.2
    end
    if player.TearFlags & TearFlags.TEAR_PERSISTENT == TearFlags.TEAR_PERSISTENT then
        orbData.Type = orbData.Type | 1 << 7
        orbData.MaxCooldown = orbData.MaxCooldown * 2.4
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) then
        orbData.MaxCooldown = orbData.MaxCooldown * 1.8
    end
    if player.TearFlags & TearFlags.TEAR_BOUNCE == TearFlags.TEAR_BOUNCE then
        orbData.Type = orbData.Type | 1 << 8
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
        orbData.MovingCooldown = orbData.MovingCooldown + 60
    end
    if player.TearFlags & TearFlags.TEAR_ORBIT == TearFlags.TEAR_ORBIT then
        orbData.Type = orbData.Type | 1 << 9
        orbData.RotationSpeed = math.pi / 90
        orbData.RotationAngle = Lib.Players.GetRotationAngle(player)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5) then
        orbData.MaxCooldown = orbData.MaxCooldown * 0.9
    end
    if player.TearFlags & TearFlags.TEAR_SHRINK == TearFlags.TEAR_SHRINK then
        orbData.Type = orbData.Type | 1 << 10
        sprite.Scale = Vector(1.6, 1.6)
    end
    if player.TearFlags & TearFlags.TEAR_MAGNETIZE == TearFlags.TEAR_MAGNETIZE then
        laserOrb:AddEntityFlags(EntityFlag.FLAG_MAGNETIZED)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) or player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) then
        orbData.Type = orbData.Type | 1 << 11
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
        orbData.MaxCooldown = orbData.MaxCooldown * 0.1
    end
    if player.TearFlags & TearFlags.TEAR_CONTINUUM == TearFlags.TEAR_CONTINUUM then
        orbData.Type = orbData.Type | 1 << 12
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
        orbData.Type = orbData.Type | 1 << 13
        laserX.Radius = laserX.Radius + 32
    end
    if player.TearFlags & TearFlags.TEAR_JACOBS == TearFlags.TEAR_JACOBS then
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
    Lib:SetTempEntityLibData(laserOrb, orbData, "LaserBlaster")
    SetEntityColor(laserOrb, laserX)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_BLOOD_LASER_LARGER, 0.6, 0, false, 1.1)
end

function LaserBlaster:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_ALLOWWISPSPAWN == UseFlag.USE_ALLOWWISPSPAWN then
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    if useFlags & UseFlag.USE_VOID == UseFlag.USE_VOID then
        FireLaserOrb(player, player:GetRecentMovementVector())
        return { Discharge = true, Remove = false, ShowAnim = false }
    end
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or useFlags & UseFlag.USE_OWNED ~= UseFlag.USE_OWNED then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if player:IsHoldingItem() then
        Lib:SetPlayerLibData(player, false, "LaserBlaster", "Lifted")
        player:AnimateCollectible(Lib.ModItemIDs.LASER_BLASTER, "HideItem")
    else
        Lib:SetPlayerLibData(player, true, "LaserBlaster", "Lifted")
        player:AnimateCollectible(Lib.ModItemIDs.LASER_BLASTER, "LiftItem")
    end
    return { Discharge = false, Remove = false, ShowAnim = false }
end
LaserBlaster:AddCallback(ModCallbacks.MC_USE_ITEM, LaserBlaster.UseItem, Lib.ModItemIDs.LASER_BLASTER)

function LaserBlaster:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.LASER_BLASTER) then
        return
    end
    if Lib:GetPlayerLibData(player, "LaserBlaster", "Lifted") and (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= Lib.ModItemIDs.LASER_BLASTER or not player:IsHoldingItem()) then
        Lib:SetPlayerLibData(player, false, "LaserBlaster", "Lifted")
        player:AnimateCollectible(Lib.ModItemIDs.LASER_BLASTER, "HideItem")
    end
    local direction = player:GetShootingInput()
    if Lib:GetPlayerLibData(player, "LaserBlaster", "Lifted") and not (direction.X == 0 and direction.Y == 0) then
        FireLaserOrb(player, direction)
        player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
        player:AnimateCollectible(Lib.ModItemIDs.LASER_BLASTER, "HideItem")
        Lib:SetPlayerLibData(player, false, "LaserBlaster", "Lifted")
    end
end
LaserBlaster:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, LaserBlaster.PostPlayerUpdate, 0)

function LaserBlaster:PostKnifeUpdate(knife)
    local remove = Lib:GetTempEntityLibData(knife, "LaserBlaster")
    local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
    if not player or not remove or knife:GetKnifeDistance() <= knife.MaxDistance * 0.9 then
        return
    end
    knife:Remove()
end
LaserBlaster:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, LaserBlaster.PostKnifeUpdate, KnifeVariant.MOMS_KNIFE)

return LaserBlaster