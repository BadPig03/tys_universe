local Collapse = TYU:NewModItem("Collapse", "COLLAPSE")

local Entities = TYU.Entities
local Players = TYU.Players
local Reverie = TYU.Reverie
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModEntityFlags = TYU.ModEntityFlags

local PrivateField = {}

do
    function PrivateField.SpawnEffect(player)
        local effect = Entities.Spawn(ModEntityIDs.COLLAPSE_EFFECT.Type, ModEntityIDs.COLLAPSE_EFFECT.Variant, ModEntityIDs.COLLAPSE_EFFECT.SubType, player.Position, player.Velocity, player):ToEffect()
        effect.Parent = player
        effect:FollowParent(player)
        effect:AddMagnetized(EntityRef(player), 30)
        effect:AddEntityFlags(ModEntityFlags.FLAG_NO_PAUSE)
    end

    function PrivateField.GetEffect(player)
        for _, effect in pairs(Isaac.FindByType(ModEntityIDs.COLLAPSE_EFFECT.Type, ModEntityIDs.COLLAPSE_EFFECT.Variant, ModEntityIDs.COLLAPSE_EFFECT.SubType)) do
            if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
                return effect:ToEffect()
            end
        end
        return nil
    end

    function PrivateField.IsSourceRelatedToProjectile(source, flags)
        if source.Entity == nil then
            return false
        elseif source.Entity:ToProjectile() then
            return true
        end
        return false
    end
end

function Collapse:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(ModItemIDs.COLLAPSE) then
        return
    end
    player.TearFlags = player.TearFlags | TearFlags.TEAR_ORBIT | TearFlags.TEAR_ACCELERATE
end
Collapse:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Collapse.EvaluateCache, CacheFlag.CACHE_TEARFLAG)

function Collapse:PostUpdate()
    if not Players.AnyoneHasCollectible(ModItemIDs.COLLAPSE) then
        return
    end
    for _, player in ipairs(Players.GetPlayers(true)) do
        if player:HasCollectible(ModItemIDs.COLLAPSE) and not PrivateField.GetEffect(player) then
            PrivateField.SpawnEffect(player)
        end
    end
end
Collapse:AddCallback(ModCallbacks.MC_POST_UPDATE, Collapse.PostUpdate)

function Collapse:PrePlayerTakeDamage(player, amount, flags, source, countdown)
    if not player:HasCollectible(ModItemIDs.COLLAPSE) or (source.Type == EntityType.ENTITY_FIREPLACE and source.Variant == 4) or Utils.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
        return
    end
    if Reverie.WillPlayerBuff(player) and PrivateField.IsSourceRelatedToProjectile(source, flags) then
        return false
    end
    if (not source.Entity or not source.Entity:ToNPC()) and Utils.HasFlags(flags, DamageFlag.DAMAGE_ACID, true) and Utils.HasFlags(flags, DamageFlag.DAMAGE_EXPLOSION, true) then
        return
    end
    return false
end
Collapse:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.IMPORTANT, Collapse.PrePlayerTakeDamage)

function Collapse:PrePlayerCollision(player, collider, low)
    if not player:HasCollectible(ModItemIDs.COLLAPSE) or not collider:ToNPC() or not collider:IsActiveEnemy() then
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