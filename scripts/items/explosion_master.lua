local Lib = TYU
local ExplosionMaster = Lib:NewModItem("Explosion Master", "EXPLOSIONMASTER")

function ExplosionMaster:PostProjectileUpdate(projectile)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.EXPLOSIONMASTER) or projectile:HasProjectileFlags(Lib.ModProjectileFlags.TEAR_BELONGTOPLAYER) then
        return
    end
    local rng = RNG(projectile.InitSeed)
    if rng:RandomInt(100) < 20 and projectile.FrameCount <= 1 then
        local bomb = Lib.Entities.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_SAD_BLOOD, 0, projectile.Position, projectile.Velocity * 2, nil):ToBomb()
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 2)
        bomb:SetScale(0.75)
        bomb.RadiusMultiplier = 0.75
        bomb.ExplosionDamage = 50
        bomb:AddTearFlags(Lib.ModTearFlags.TEAR_EXPLOSION_MASTER)
        local poof = Lib.Entities.SpawnPoof(bomb.Position)
        poof.SpriteScale = projectile.SpriteScale
        projectile:Remove()
    end
end
ExplosionMaster:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, ExplosionMaster.PostProjectileUpdate)

function ExplosionMaster:PreRoomExit()
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_BOMB, BombVariant.BOMB_SAD_BLOOD)) do
        if ent:ToBomb() and ent:ToBomb():HasTearFlags(Lib.ModTearFlags.TEAR_EXPLOSION_MASTER) then
            ent:Remove()
        end
    end
end
ExplosionMaster:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, ExplosionMaster.PreRoomExit)

function ExplosionMaster:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not source or not source.Entity or not source.Entity:ToBomb() or not source.Entity:ToBomb():HasTearFlags(Lib.ModTearFlags.TEAR_EXPLOSION_MASTER) or player:HasCollectible(CollectibleType.COLLECTIBLE_HOST_HAT) or player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then
        return
    end
    return false
end
ExplosionMaster:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, ExplosionMaster.PrePlayerTakeDamage)


return ExplosionMaster