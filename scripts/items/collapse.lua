local Lib = TYU
local Collapse = Lib:NewModItem("Collapse", "COLLAPSE")

local function SpawnEffect(player)
    local effect = Lib.Entities.Spawn(Lib.ModEntityIDs.COLLAPSEEFFECT.Type, Lib.ModEntityIDs.COLLAPSEEFFECT.Variant, Lib.ModEntityIDs.COLLAPSEEFFECT.SubType, player.Position, player.Velocity, player):ToEffect()
    effect.Parent = player
    effect:FollowParent(player)
    effect:AddMagnetized(EntityRef(player), 30)
    effect:AddEntityFlags(Lib.ModEntityFlags.FLAG_NO_PAUSE)
end

local function GetEffect(player)
    for _, effect in pairs(Isaac.FindByType(Lib.ModEntityIDs.COLLAPSEEFFECT.Type, Lib.ModEntityIDs.COLLAPSEEFFECT.Variant, Lib.ModEntityIDs.COLLAPSEEFFECT.SubType)) do
        if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
            return effect:ToEffect()
        end
    end
    return nil
end

function Collapse:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(Lib.ModItemIDs.COLLAPSE) then
        return
    end
    player.TearFlags = player.TearFlags | TearFlags.TEAR_ORBIT | TearFlags.TEAR_ACCELERATE
end
Collapse:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Collapse.EvaluateCache, CacheFlag.CACHE_TEARFLAG)

function Collapse:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.COLLAPSE) then
        return
    end
    if not GetEffect(player) then
        SpawnEffect(player)
    end
end
Collapse:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Collapse.PostPlayerUpdate, 0)

function Collapse:PrePlayerTakeDamage(player, amount, flags, source, countdown)
    if not player:HasCollectible(Lib.ModItemIDs.COLLAPSE) or (source.Type == EntityType.ENTITY_FIREPLACE and source.Variant == 4) or flags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER then
        return
    end
    if source.Entity and source.Entity:ToNPC() or flags & DamageFlag.DAMAGE_ACID == DamageFlag.DAMAGE_ACID or flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION then
        return false
    end
end
Collapse:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.IMPORTANT, Collapse.PrePlayerTakeDamage)

function Collapse:PrePlayerCollision(player, collider, low)
    if not player:HasCollectible(Lib.ModItemIDs.COLLAPSE) then
        return
    end
    if not collider:ToNPC() or not collider:IsActiveEnemy() then
        return
    end
    collider:TakeDamage(math.sqrt(player.Damage), DamageFlag.DAMAGE_CRUSH, EntityRef(player), 0)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) and collider:HasMortalDamage() then
        collider:AddEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
    end
    return true
end
Collapse:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, Collapse.PrePlayerCollision, 0)

return Collapse