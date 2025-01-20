local LaserOrb = TYU:NewModEntity("Laser Orb", "LASER_ORB")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs

local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "LaserBlaster", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "LaserBlaster", ...)
end

do
    function PrivateField.DamageNearbyEnemies(effect, player)
        local entityList = {}
        local scaleX = effect:GetSprite().Scale.X
        local effectData = GetTempEntityLibData(effect)
        local effectType = effectData.Type
        for _, entity in pairs(Isaac.FindInRadius(effect.Position, 192 * scaleX, EntityPartition.ENEMY)) do
            if Entities.IsValidEnemy(entity) then
                table.insert(entityList, entity)
            end
        end
        for _, entity in ipairs(entityList) do
            local damageScale = effectData.DamageScale
            local entityPosition = entity.Position
            if Utils.HasFlags(effectType, 1 << 3) then
                damageScale = damageScale * 2
            end
            if Utils.HasFlags(effectType, 1 << 10) then
                damageScale = damageScale * math.sqrt(scaleX)
            end
            local laser = nil
            if Utils.HasFlags(effectType, 1 << 5) then
                laser = Entities.Spawn(EntityType.ENTITY_LASER, LaserVariant.BRIM_TECH, LaserSubType.LASER_SUBTYPE_LINEAR, effect.Position, effect.Velocity, player):ToLaser()
                laser.Color = player:GetLaserColor()
            else
                laser = player:FireTechLaser(effect.Position + Vector(0, 16), LaserOffset.LASER_TECH5_OFFSET, entityPosition - effect.Position - Vector(0, 16), false, true, player, damageScale)
                if Utils.HasFlags(effectType, 1 << 0, true) then
                    laser:SetMaxDistance((effect.Position - entityPosition):Length() * 1.2)
                end
            end
            local angleDegrees = (entityPosition - effect.Position):GetAngleDegrees()
            laser.AngleDegrees = angleDegrees
            laser.Timeout = 9
            laser.CollisionDamage = player.Damage * 1.5 * damageScale
            laser.Parent = effect
            laser.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
            if Utils.HasFlags(effectType, 1 << 4) then
                local knife = player:FireKnife(effect, 0, false)
                knife.Rotation = angleDegrees
                knife:Shoot(1, 1000)
                knife.CollisionDamage = player.Damage / 3
                SetTempEntityLibData(knife, true)
            end
            damageScale = math.min(10, damageScale * 1.01)
            SetTempEntityLibData(effect, damageScale, "DamageScale")
        end
    end
end

function LaserOrb:PostEffectUpdate(effect)
    local effectData = GetTempEntityLibData(effect)
    local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()
    if not effectData or not player then
        effect:Remove()
        return
    end
    local sprite = effect:GetSprite()
    local room = TYU.GAME:GetRoom()
    local type = effectData.Type
    if sprite:IsFinished("BeginLoop") then
        sprite:Play("Loop", true)
    end
    if sprite:IsPlaying("Loop") then
        if effectData.Cooldown == 0 then
            PrivateField.DamageNearbyEnemies(effect, player)
            effectData.Cooldown = effectData.MaxCooldown
        else
            effectData.Cooldown = effectData.Cooldown - 1
        end
        effectData.Time = effectData.Time + 1
    end
    if ((Utils.HasFlags(type, 1 << 12, true) and not room:IsPositionInRoom(effect.Position, 0)) or effectData.Time >= 600 or sprite.Scale:Length() < math.sqrt(2) * 0.1) and not effectData.Remove then
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_BLOOD_LASER_LARGER, 0.6, 0, false, 0.7)
        sprite:Play("EndLoop", true)
        effectData.Remove = true
    end
    if effectData.Remove then
        if sprite:IsFinished("EndLoop") then
            effect:Remove()
        end
        effect.Velocity = Vector(0, 0)
        return
    end
    if effectData.MovingCooldown > 0 then
        effectData.MovingCooldown = effectData.MovingCooldown - 1
        if Utils.HasFlags(type, 1 << 9) then
            effectData.RotationAngle = effectData.RotationSpeed % (2 * math.pi)
            effect.Velocity = Vector(math.cos(effectData.RotationAngle), math.sin(effectData.RotationAngle)):Resized(96) + player.Position + player.Velocity - effect.Position
        end
    else
        if Utils.HasFlags(type, 1 << 1) then
            local target = Entities.GetNearestEnemy(effect.Position)
            if target then
                effect:AddVelocity((target.Position - effect.Position):Resized(0.02))
            end
        elseif Utils.HasFlags(type, 1 << 2) then
            effect:AddVelocity((player.Position - effect.Position):Resized(0.02))
        elseif Utils.HasFlags(type, 1 << 11) then
            local shootingInput = player:GetShootingInput()
            if shootingInput:Length() > 0 then
                effect.Velocity = shootingInput:Resized(6)
            else
                effect.Velocity = effect.Velocity:Resized(0.99)
                if effect.Velocity:Length() < 1 then
                    effect.Velocity = Vector(0, 0)
                end
            end
        end
        if Utils.HasFlags(type, 1 << 12) then
            local roomSize = room:GetGridSize()
            local roomWidth = room:GetGridWidth()
            local gridIndex = room:GetGridIndex(effect.Position)
            if gridIndex == -1 and not effectData.Continuum then
                local clampedIndex = room:GetClampedGridIndex(effect.Position)
                if clampedIndex % roomWidth == 0 then
                    effect.Position = room:GetGridPosition(clampedIndex + roomWidth - 1) + Vector(40, effect.Position.Y - room:GetGridPosition(clampedIndex).Y)
                elseif clampedIndex % roomWidth == roomWidth - 1 then
                    effect.Position = room:GetGridPosition(clampedIndex - roomWidth + 1) + Vector(-40, effect.Position.Y - room:GetGridPosition(clampedIndex).Y)
                elseif clampedIndex <= roomWidth - 1 then
                    effect.Position = room:GetGridPosition(clampedIndex + roomSize - roomWidth) + Vector(effect.Position.X - room:GetGridPosition(clampedIndex).X, 40)
                elseif clampedIndex >= roomSize - roomWidth then
                    effect.Position = room:GetGridPosition(clampedIndex - roomSize + roomWidth) + Vector(effect.Position.X - room:GetGridPosition(clampedIndex).X, -40)
                end
                effectData.Continuum = true
            elseif gridIndex ~= -1 and effectData.Continuum then
                effectData.Continuum = false
            end
            if effect.Position.X < -40 or effect.Position.X > room:GetGridPosition(roomSize - 1).X + 40 or effect.Position.Y < -40 or effect.Position.Y > room:GetGridPosition(roomSize - 1).Y + 40 then
                TYU.SFXMANAGER:Play(SoundEffect.SOUND_BLOOD_LASER_LARGER, 0.6, 0, false, 0.7)
                sprite:Play("EndLoop", true)
                effectData.Remove = true
            end
        end
        if Utils.HasFlags(type, 1 << 11, true) then
            if Utils.HasFlags(type, 1 << 8) then
                if (not room:IsPositionInRoom(effect.Position + Vector(0, 8), 0) and room:IsPositionInRoom(effect.Position + Vector(0, -8), 0)) or (not room:IsPositionInRoom(effect.Position + Vector(0, -8), 0) and room:IsPositionInRoom(effect.Position + Vector(0, 8), 0)) then
                    effect.Velocity = Vector(effect.Velocity.X, -effect.Velocity.Y)
                    effectData.MaxVelocity = Vector(effectData.MaxVelocity.X, -effectData.MaxVelocity.Y)
                    effectData.Acceleration = effectData.MaxVelocity:Resized(0.02)
                end
                if (not room:IsPositionInRoom(effect.Position + Vector(8, 0), 0) and room:IsPositionInRoom(effect.Position + Vector(-8, 0), 0)) or (not room:IsPositionInRoom(effect.Position + Vector(-8, 0), 0) and room:IsPositionInRoom(effect.Position + Vector(8, 0), 0)) then
                    effect.Velocity = Vector(-effect.Velocity.X, effect.Velocity.Y)
                    effectData.MaxVelocity = Vector(-effectData.MaxVelocity.X, effectData.MaxVelocity.Y)
                    effectData.Acceleration = effectData.MaxVelocity:Resized(0.02)
                end
            end
            if Utils.HasFlags(type, 1 << 9) then
                effectData.RotationAngle = (effectData.RotationAngle + effectData.RotationSpeed) % (2 * math.pi)
                effect.Velocity = Vector(math.cos(effectData.RotationAngle), math.sin(effectData.RotationAngle)):Resized(96) + player.Position + player.Velocity - effect.Position
            end
            if effect.Velocity:Length() < effectData.MaxVelocity:Length() then
                effect:AddVelocity(effectData.Acceleration)
            elseif not effect:HasEntityFlags(EntityFlag.FLAG_MAGNETIZED) then
                effectData.Acceleration = Vector(0, 0)
            end
        end
    end
    if Utils.HasFlags(type, 1 << 6) then
        sprite.Scale = Vector(1, 1):Resized((0.8 + effectData.Time * 0.002) * math.sqrt(2))
    end
    if Utils.HasFlags(type, 1 << 10) then
        local scaleAdjustment = (Utils.HasFlags(type, 1 << 6) and 0.004) or 0.006
        sprite.Scale = Vector(1, 1):Resized(math.max(0, (1.6 - effectData.Time * scaleAdjustment)) * math.sqrt(2))
    end
    if effect.FrameCount % 5 ~= 0 then
        return
    end
    for _, entity in pairs(Isaac.FindInRadius(effect.Position, effect.Size * sprite.Scale.X, EntityPartition.ENEMY)) do
        if Entities.IsValidEnemy(entity) then
            entity:TakeDamage(player.Damage, DamageFlag.DAMAGE_LASER, EntityRef(player), 0)
        end
    end
end
LaserOrb:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, LaserOrb.PostEffectUpdate, ModEntityIDs.LASER_ORB.Variant)

return LaserOrb