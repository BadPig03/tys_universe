local Lib = TYU
local HephaestusSoul = Lib:NewModItem("Hephaestus' Soul", "HEPHAESTUSSOUL")

local function SpawnChargeBar(player)
    local chargeBar = Lib.Entities.Spawn(Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.Type, Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.Variant, Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.SubType, player.Position + Lib.Players.GetChargeBarPosition(player, 2), player.Velocity, player):ToEffect()
    chargeBar.Parent = player
    chargeBar:FollowParent(player)
    chargeBar.DepthOffset = 104
    chargeBar:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | Lib.ModEntityFlags.FLAG_NO_PAUSE)
    local sprite = chargeBar:GetSprite()
    sprite:Play("Charging", true)
    for i = 1, 6 do
        sprite:Update()
    end
    sprite.PlaybackSpeed = Lib.Constants.CHARGEBAR_PLAYBACKRATE
end

local function GetChargerBar(player)
    for _, effect in pairs(Isaac.FindByType(Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.Type, Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.Variant, Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.SubType)) do
        if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
            return effect:ToEffect()
        end
    end
    return nil
end

local function DisappearChargeBar(chargeBar, player)
    local sprite = chargeBar:GetSprite()
    if not sprite:IsPlaying("Disappear") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Disappear", true)
    end
    if player and sprite:IsPlaying("Disappear") then
        Lib.Entities.CreateTimer(function()
            chargeBar.Visible = false
            SpawnChargeBar(player)
        end, 4, 0, false)
    end
end

local function BreakNearbyRocks(effect)
    local room = Lib.GAME:GetRoom()
    for i = 0, 3 do
        local gridEntity = room:GetGridEntityFromPos(effect.Position + Vector(0, 20):Rotated(90 * i))
        if gridEntity and not gridEntity:ToDoor() then
            gridEntity:Destroy(false)
        end
    end
end

local function GetCountAndAngle(player)
    local fireDelay = player.MaxFireDelay
    if fireDelay >= 30 then
        return 4
    elseif fireDelay < 30 and fireDelay >= 1 then
        return math.floor(-4/29 * fireDelay + 501/58)
    else
        return 8
    end
end

local function SpawnFireProjectiles(player)
    local lastDirection = Lib:GetTempEntityLibData(player, "HephaestusSoul").LastDirection:GetAngleDegrees()
    local maxCount = GetCountAndAngle(player)
    for i = 0, maxCount - 1 do
        local projectile = Lib.Entities.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, player.Position, Vector(17, 0):Rotated(i * (360 / maxCount)), player):ToProjectile()
        projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.DECELERATE)
        projectile:AddProjectileFlags(Lib.ModProjectileFlags.TEAR_BELONGTOPLAYER)
        projectile.SpriteOffset = Vector(0, 16)
        projectile.Parent = player
        if player.TearFlags & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING then
            projectile:AddProjectileFlags(ProjectileFlags.SMART)
        end
        if player.TearFlags & TearFlags.TEAR_BOMBERANG == TearFlags.TEAR_BOMBERANG then
            projectile:AddProjectileFlags(ProjectileFlags.TRIANGLE)
        end
        if player.TearFlags & TearFlags.TEAR_SPLIT == TearFlags.TEAR_SPLIT or player.TearFlags & TearFlags.TEAR_QUADSPLIT == TearFlags.TEAR_QUADSPLIT then
            projectile:AddProjectileFlags(ProjectileFlags.BURST)
        end
        if player.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
            projectile:AddProjectileFlags(ProjectileFlags.EXPLODE)
        end
        if player.TearFlags & TearFlags.TEAR_BOUNCE == TearFlags.TEAR_BOUNCE then
            projectile:AddProjectileFlags(ProjectileFlags.BOUNCE)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
            projectile:AddProjectileFlags(ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT)
            projectile.ChangeTimeout = 16
            projectile.ChangeVelocity = 0
        end
        if player.TearFlags & TearFlags.TEAR_ORBIT == TearFlags.TEAR_ORBIT then
            projectile:AddProjectileFlags(ProjectileFlags.ANTI_GRAVITY)
            projectile.SpriteOffset = Vector(0, 40)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) then
            projectile:AddProjectileFlags(ProjectileFlags.RED_CREEP)
        end
        if player.TearFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP == TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP then
            projectile:AddProjectileFlags(ProjectileFlags.ACID_GREEN)
        end
        if player.TearFlags & TearFlags.TEAR_CONTINUUM == TearFlags.TEAR_CONTINUUM then
            projectile:AddProjectileFlags(ProjectileFlags.CONTINUUM)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
            projectile:AddProjectileFlags(ProjectileFlags.LASER_SHOT)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
            projectile:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) or player:HasCollectible(Lib.ModItemIDs.OCEANUSSOUL) then
            projectile:AddProjectileFlags(ProjectileFlags.BLUE_FIRE_SPAWN)
            projectile:GetSprite().Color = Color(1, 1, 1, 1, -0.49, -0.1, 0, 0.51, 0.9, 1, 1)
        end
        if lastDirection <= 0 then
            projectile:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
        else
            projectile:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
        end
        projectile.CollisionDamage = player.Damage * 4 + 7
        if i % 2 == 0 then
            projectile:AddProjectileFlags(Lib.ModProjectileFlags.TEAR_HEPHAESTUSSOUL)
        else
            projectile:AddProjectileFlags(Lib.ModProjectileFlags.TEAR_HEPHAESTUSSOUL_X)
        end
        projectile:Update()
    end
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_FLAMETHROWER_START, 0.6)
    Lib:SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 }, "HephaestusSoul")
end

function HephaestusSoul:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
		return
    end
    player.CanFly = true
end
HephaestusSoul:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, HephaestusSoul.EvaluateCache, CacheFlag.CACHE_FLYING)

function HephaestusSoul:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
		return
    end
    local chargeBar = GetChargerBar(player)
    local chargeTime = Lib:GetTempEntityLibData(player, "HephaestusSoul", "ChargeTime") or 0
    if player:GetMarkedTarget() or player:GetPeeBurstCooldown() > 0 then
        if chargeBar and ((chargeBar:GetSprite():IsPlaying("StartCharged") and chargeBar:GetSprite():GetFrame() >= 1) or (chargeBar:GetSprite():IsPlaying("Charged"))) then
            SpawnFireProjectiles(player)
            DisappearChargeBar(chargeBar, player)
        end
        if not chargeBar and chargeTime > 7 then
            SpawnChargeBar(player)
        end
        Lib:SetTempEntityLibData(player, chargeTime + 1, "HephaestusSoul", "ChargeTime")
        Lib:SetTempEntityLibData(player, player:GetShootingInput(), "HephaestusSoul", "LastDirection")
    else
        if Lib.Players.IsPressingFiringButton(player) then
            if not chargeBar and chargeTime > 7 then
                SpawnChargeBar(player)
            end
            Lib:SetTempEntityLibData(player, chargeTime + 1, "HephaestusSoul", "ChargeTime")
            Lib:SetTempEntityLibData(player, player:GetShootingInput(), "HephaestusSoul", "LastDirection")
        elseif chargeBar then
            if Lib:GetTempEntityLibData(player, "HephaestusSoul", "FullyCharged") then
                SpawnFireProjectiles(player)
            end
            DisappearChargeBar(chargeBar)
        else
            Lib:SetTempEntityLibData(player, 0, "HephaestusSoul", "ChargeTime")
        end    
    end
end
HephaestusSoul:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HephaestusSoul.PostPlayerUpdate, 0)

function HephaestusSoul:PostEffectInit(effect)
    local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
        return
    end
    effect.CollisionDamage = player.Damage * 4 + 12
end
HephaestusSoul:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, HephaestusSoul.PostEffectInit, EffectVariant.FIRE_JET)

function HephaestusSoul:PostEffectUpdate(effect)
    local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
        return
    end
    for _, ent in pairs(Isaac.FindInRadius(effect.Position, 11, EntityPartition.BULLET)) do
        if not ent.SpawnerEntity or not ent.SpawnerEntity:ToPlayer() then
            ent:Die()
        end
    end
    BreakNearbyRocks(effect)
end
HephaestusSoul:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, HephaestusSoul.PostEffectUpdate, EffectVariant.FIRE_JET)

function HephaestusSoul:PostProjectileUpdate(projectile)
    local player = projectile.SpawnerEntity and projectile.SpawnerEntity:ToPlayer()
    if not player or not projectile:HasProjectileFlags(Lib.ModProjectileFlags.TEAR_BELONGTOPLAYER) then
        return
    end
    if projectile:HasProjectileFlags(ProjectileFlags.ANTI_GRAVITY) and projectile.FrameCount >= 70 then
        projectile:Die()
    end
end
HephaestusSoul:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, HephaestusSoul.PostProjectileUpdate, ProjectileVariant.PROJECTILE_FIRE)

function HephaestusSoul:PostProjectileDeath(projectile)
    local player = projectile.SpawnerEntity and projectile.SpawnerEntity:ToPlayer()
    if not player or not projectile:HasProjectileFlags(Lib.ModProjectileFlags.TEAR_BELONGTOPLAYER) then
        return
    end
    local subType = 0
    if player.TearFlags & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING or projectile:HasProjectileFlags(ProjectileFlags.SMART) then
        subType = 1
    elseif projectile:HasProjectileFlags(ProjectileFlags.BLUE_FIRE_SPAWN) then
        subType = 2
    end
    if projectile:HasProjectileFlags(Lib.ModProjectileFlags.TEAR_HEPHAESTUSSOUL) then
        for i = 0, 3 do
            local fireWave = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, subType, projectile.Position, Vector(0, 0), player):ToEffect()
            fireWave.Rotation = 90 * i
            if subType == 2 then
                fireWave.CollisionDamage = fireWave.CollisionDamage * 2
            end
            fireWave.CollisionDamage = projectile.CollisionDamage + 5
        end
    elseif projectile:HasProjectileFlags(Lib.ModProjectileFlags.TEAR_HEPHAESTUSSOUL_X) then
        for i = 0, 3 do
            local fireWave = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, subType, projectile.Position, Vector(0, 0), player):ToEffect()
            fireWave.Rotation = 90 * i + 45
            if subType == 2 then
                fireWave.CollisionDamage = fireWave.CollisionDamage * 2
            end
            fireWave.CollisionDamage = projectile.CollisionDamage + 5
        end
    end
    BreakNearbyRocks(projectile)
end
HephaestusSoul:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, HephaestusSoul.PostProjectileDeath, ProjectileVariant.PROJECTILE_FIRE)

function HephaestusSoul:EntityTakeDMG(entity, damage, damageFlags, source, countdownm)
    if not entity:ToFamiliar() or not source.Entity then
        return
    end
    local familiar = entity:ToFamiliar()
    local player = familiar.Player
    if not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
        return
    end
    if source.Type == EntityType.ENTITY_PROJECTILE and source.Variant == ProjectileVariant.PROJECTILE_FIRE and source.Entity:ToProjectile():HasProjectileFlags(Lib.ModProjectileFlags.TEAR_BELONGTOPLAYER) then
        return false
    end
    if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.FIRE_JET and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToPlayer() then
        return false
    end
end
HephaestusSoul:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, HephaestusSoul.EntityTakeDMG)

function HephaestusSoul:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not player:HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) or (source.Type == EntityType.ENTITY_FIREPLACE and source.Variant == 4) or flags & DamageFlag.DAMAGE_FIRE ~= DamageFlag.DAMAGE_FIRE then
		return
	end
    return false
end
HephaestusSoul:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.EARLY, HephaestusSoul.PrePlayerTakeDamage)

return HephaestusSoul