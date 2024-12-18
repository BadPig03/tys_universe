local Collapse = TYU:NewModItem("Collapse", "COLLAPSE")
local Entities = TYU.Entities
local Players = TYU.Players
local PrivateField = {}

do
    function PrivateField.SpawnEffect(player)
        local effect = Entities.Spawn(TYU.ModEntityIDs.COLLAPSEEFFECT.Type, TYU.ModEntityIDs.COLLAPSEEFFECT.Variant, TYU.ModEntityIDs.COLLAPSEEFFECT.SubType, player.Position, player.Velocity, player):ToEffect()
        effect.Parent = player
        effect:FollowParent(player)
        effect:AddMagnetized(EntityRef(player), 30)
        effect:AddEntityFlags(TYU.ModEntityFlags.FLAG_NO_PAUSE)
    end

    function PrivateField.GetEffect(player)
        for _, effect in pairs(Isaac.FindByType(TYU.ModEntityIDs.COLLAPSEEFFECT.Type, TYU.ModEntityIDs.COLLAPSEEFFECT.Variant, TYU.ModEntityIDs.COLLAPSEEFFECT.SubType)) do
            if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
                return effect:ToEffect()
            end
        end
        return nil
    end
end

function Collapse:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(TYU.ModItemIDs.COLLAPSE) then
        return
    end
    player.TearFlags = player.TearFlags | TearFlags.TEAR_ORBIT | TearFlags.TEAR_ACCELERATE
end
Collapse:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Collapse.EvaluateCache, CacheFlag.CACHE_TEARFLAG)

function Collapse:PostUpdate()
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.COLLAPSE) then
        return
    end
    for _, player in pairs(Players.GetPlayers(true)) do
        if player:HasCollectible(TYU.ModItemIDs.COLLAPSE) and not PrivateField.GetEffect(player) then
            PrivateField.SpawnEffect(player)
        end
    end
end
Collapse:AddCallback(ModCallbacks.MC_POST_UPDATE, Collapse.PostUpdate)

function Collapse:PrePlayerTakeDamage(player, amount, flags, source, countdown)
    if not player:HasCollectible(TYU.ModItemIDs.COLLAPSE) or (source.Type == EntityType.ENTITY_FIREPLACE and source.Variant == 4) or flags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER then
        return
    end
    if (not source.Entity or not source.Entity:ToNPC()) and flags & DamageFlag.DAMAGE_ACID ~= DamageFlag.DAMAGE_ACID and flags & DamageFlag.DAMAGE_EXPLOSION ~= DamageFlag.DAMAGE_EXPLOSION then
        return
    end
    return false
end
Collapse:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.IMPORTANT, Collapse.PrePlayerTakeDamage)

function Collapse:PrePlayerCollision(player, collider, low)
    if not player:HasCollectible(TYU.ModItemIDs.COLLAPSE) or not collider:ToNPC() or not collider:IsActiveEnemy() then
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