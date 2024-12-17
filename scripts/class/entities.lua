local Entities = TYU:RegisterNewClass()

function Entities.Spawn(type, variant, subType, position, velocity, spawner, seed)
    velocity = velocity or Vector.Zero
    spawner = spawner or nil
    seed = seed or math.max(1, Random())
    return TYU.GAME:Spawn(type, variant, position, velocity, spawner, subType, seed)
end

function Entities.Morph(entity, newType, newVariant, newSubType, keepPrice, keepSeed, ignoreModifiers, showPoof)
    local pickup = entity:ToPickup()
    newType = newType or pickup.Type
    newVariant = newVariant or pickup.Variant
    newSubType = newSubType or pickup.SubType
    if keepPrice == nil then
        keepPrice = true
    end
    if keepSeed == nil then
        keepSeed = true
    end
    ignoreModifiers = ignoreModifiers or false
    if showPoof == nil then
        showPoof = true
    end
    pickup:Morph(newType, newVariant, newSubType, keepPrice, keepSeed, ignoreModifiers)
    if showPoof then
        return Entities.SpawnPoof(pickup.Position)
    end
end

function Entities.SpawnPoof(position, velocity)
    return Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, position, velocity):ToEffect()
end




function Entities.IsProceduralItem(entity)
    local pickup = entity:ToPickup()
    return pickup and pickup.SubType >= TYU.Constants.GLITCHED_ITEM_ID
end

function Entities.GetEntityID(entity)
    local player = entity:ToPlayer()
    if player then
        return TYU.Players.GetPlayerID(player)
    end
    local tear = entity:ToTear()
    if tear then
        return tonumber(GetPtrHash(entity)..tear:GetDropRNG():GetSeed())
    end
    return GetPtrHash(entity)
end

function Entities.GetEntityBySeed(seed)
    for _, ent in pairs(Isaac.GetRoomEntities()) do
        if ent.InitSeed == seed then
            return ent
        end
    end
    return nil
end

function Entities.GetCollectibles(includeShopItem, includeEmptyPedestal, excludeProceduralItem)
    includeShopItem = includeShopItem or false
    includeEmptyPedestal = includeEmptyPedestal or false
    excludeProceduralItem = excludeProceduralItem or false
    local entities = {}
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = ent:ToPickup()
        if (includeEmptyPedestal or pickup.SubType > CollectibleType.COLLECTIBLE_NULL) and (includeShopItem or not pickup:IsShopItem()) and (excludeProceduralItem or not Entities.IsProceduralItem(ent)) then
            table.insert(entities, pickup)
        end
    end
    return entities
end

function Entities.SpawnFakePickupSprite(pickup, golden)
    golden = golden or false
    pickup:PlayPickupSound()
    local fakePickup = TYU.Entities.Spawn(TYU.ModEntityIDs.FAKEPICKUP.Type, TYU.ModEntityIDs.FAKEPICKUP.Variant, TYU.ModEntityIDs.FAKEPICKUP.SubType, pickup.Position, pickup.Velocity, pickup.SpawnerEntity, pickup.InitSeed)
    local fakeSprite = fakePickup:GetSprite()
    fakeSprite:Load(pickup:GetSprite():GetFilename(), true)
    fakeSprite:Play("Collect", true)
    if golden then
        fakeSprite:SetRenderFlags(AnimRenderFlags.GOLDEN | AnimRenderFlags.IGNORE_GAME_TIME)
    end
    pickup:Remove()
end

function Entities.GetPlayerFromTear(tear)
    if tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() then
        return tear.SpawnerEntity:ToPlayer()
    elseif tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() and (tear.SpawnerEntity.Variant == FamiliarVariant.CAINS_OTHER_EYE or tear.SpawnerEntity.Variant == FamiliarVariant.INCUBUS or tear.SpawnerEntity.Variant == FamiliarVariant.FATES_REWARD or tear.SpawnerEntity.Variant == FamiliarVariant.TWISTED_BABY or tear.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY or tear.SpawnerEntity.Variant == FamiliarVariant.UMBILICAL_BABY) and tear.SpawnerEntity:ToFamiliar().Player and tear.SpawnerEntity:ToFamiliar().Player:ToPlayer() then
        return tear.SpawnerEntity:ToFamiliar().Player:ToPlayer()
    end
    return nil
end

function Entities.IsValidEnemy(enemy)
    return enemy and enemy:ToNPC() and enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM)
end

function Entities.IsValidEnemyEvenInvicible(enemy)
    return enemy and enemy:ToNPC() and enemy:IsActiveEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM)
end

function Entities.IsStationaryEnemy(enemy)
    if enemy.Mass == 100 or enemy:GetMinecart() then
        return true
    end
    local npc = enemy:ToNPC()
    local type = npc.Type
    local variant = npc.Variant
    if type == EntityType.ENTITY_PIN and npc.State == NpcState.STATE_ATTACK then
        return true
    end
    if type == EntityType.ENTITY_COLOSTOMIA and not (npc.State == NpcState.STATE_APPEAR or npc.State == NpcState.STATE_IDLE or npc.State == NpcState.STATE_ATTACK or npc.State == NpcState.STATE_ATTACK2 or npc.State == NpcState.STATE_SPECIAL) then
        return true
    end
    if type == EntityType.ENTITY_VISAGE or variant == 10 then
        return true
    end
    if type == EntityType.ENTITY_MOM or type == EntityType.ENTITY_MR_FRED or type == EntityType.ENTITY_DADDYLONGLEGS or type == EntityType.ENTITY_ROTGUT or type == EntityType.ENTITY_THE_LAMB or type == EntityType.ENTITY_HUSH or type == EntityType.ENTITY_HUSH_SKINLESS then
        return true
    end
    return false
end

function Entities.IsForcedMovingEnemy(enemy)
    local type = enemy.Type
    if type == EntityType.ENTITY_GUTS or type == EntityType.ENTITY_LUMP or type == EntityType.ENTITY_FRED or type == EntityType.ENTITY_MOMS_HAND or type == EntityType.ENTITY_WALL_CREEP or type == EntityType.ENTITY_RAGE_CREEP or type == EntityType.ENTITY_BLIND_CREEP or type == EntityType.ENTITY_MOMS_DEAD_HAND or type == EntityType.ENTITY_CORN_MINE or type == EntityType.ENTITY_THE_THING or type == EntityType.ENTITY_MR_MINE or type == EntityType.ENTITY_MOLE or type == EntityType.ENTITY_HENRY or type == EntityType.ENTITY_NEEDLE or type == EntityType.ENTITY_REAP_CREEP or type == EntityType.ENTITY_VISAGE or type == EntityType.ENTITY_FAMINE or type == EntityType.ENTITY_PESTILENCE or type == EntityType.ENTITY_WAR or type == EntityType.ENTITY_DEATH or type == EntityType.ENTITY_HUSH_FLY then
        return true
    end
    return false
end

function Entities.IsFireRelatedEnemy(enemy)
    local type = enemy.Type
    local variant = enemy.Variant
    local subType = enemy.SubType
    if (type == EntityType.ENTITY_GAPER and variant == 2) and (type == EntityType.ENTITY_CLOTTY and variant == 3) or (type == EntityType.ENTITY_KNIGHT and variant == 4) or type == EntityType.ENTITY_FLAMINGHOPPER or (type == EntityType.ENTITY_GURGLE and variant == 1) or (type == EntityType.ENTITY_FATTY and variant == 2) or (type == EntityType.ENTITY_SKINNY and variant == 2) or (type == EntityType.ENTITY_ROCK_SPIDER and variant == 2) or (type == EntityType.ENTITY_GYRO and variant == 1) or type == EntityType.ENTITY_FIRE_WORM then
        return true
    end
    if type == EntityType.ENTITY_LITTLE_HORN and variant == 0 and subType == 1 then
        return true
    end
    return false
end

function Entities.GetNearestEnemy(position, includePlayer)
    includePlayer = includePlayer or false
	local distance = 8192
    local nearestEnemy = nil
    local partition = EntityPartition.ENEMY
    if includePlayer then
        partition = partition | EntityPartition.PLAYER
    end
    for _, ent in pairs(Isaac.FindInRadius(position, 8192, partition)) do
        if ((ent:ToNPC() and Entities.IsValidEnemy(ent)) or ent:ToPlayer()) and (ent.Position - position):Length() < distance then
            distance = (ent.Position - position):Length()
            nearestEnemy = ent
        end
    end
    return nearestEnemy
end

function Entities.GetLowestHealthEnemy(position)
    local minHealth = 8092000
    local minHealthEnemy = nil
    for _, ent in pairs(Isaac.FindInRadius(position, 8192, EntityPartition.ENEMY)) do
        if Entities.IsValidEnemy(ent) and ent.HitPoints < minHealth then
            minHealth = ent.HitPoints
            minHealthEnemy = ent
        end
    end
    return minHealthEnemy
end

function Entities.GetHighestHealthEnemy(position)
    local maxHealth = 0
    local maxHealthEnemy = nil
    for _, ent in pairs(Isaac.FindInRadius(position, 8192, EntityPartition.ENEMY)) do
        if Entities.IsValidEnemy(ent) and ent.HitPoints > maxHealth then
            maxHealth = ent.HitPoints
            maxHealthEnemy = ent
        end
    end
    return maxHealthEnemy
end

function Entities.CreateTimer(...)
    local timer = Isaac.CreateTimer(...)
    timer:AddEntityFlags(TYU.ModEntityFlags.FLAG_NO_PAUSE)
end

return Entities