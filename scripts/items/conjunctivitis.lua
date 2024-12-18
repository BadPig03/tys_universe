local Conjunctivitis = TYU:NewModItem("Conjunctivitis", "CONJUNCTIVITIS")
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    PrivateField.PlayFireSound = false
    PrivateField.PlayDeathSound = false

    function PrivateField.GetTrailLength(tear)
        local player = Utils.GetPlayerFromTear(tear)
        if not player then
            return 4
        end
        local shotSpeed = player.ShotSpeed
        local length = 6 * shotSpeed ^ 1.5
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE) or player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY) then
            length = length / 2
        end
        return math.max(2, math.ceil(length))
    end

    function PrivateField.MakeNewCopy(tear)
        local newTear = Entities.Spawn(EntityType.ENTITY_TEAR, (tear.Variant == TearVariant.BLUE and TearVariant.BLOOD) or tear.Variant, tear.SubType, tear.Position, tear.Velocity:Normalized():Resized(0.05), tear.SpawnerEntity):ToTear()
        newTear:AddTearFlags(tear.TearFlags | TYU.ModTearFlags.TEAR_TRAILED)
        newTear:ClearTearFlags(TearFlags.TEAR_HOMING | TYU.ModTearFlags.TEAR_TRAILING)
        newTear:SetMultidimensionalTouched(true)
        newTear.ContinueVelocity = tear.ContinueVelocity
        newTear.FallingAcceleration = tear.FallingAcceleration
        newTear.FallingSpeed = 0
        newTear.KnockbackMultiplier = tear.KnockbackMultiplier
        newTear.Height = tear.Height
        newTear.Scale = tear.BaseScale
        newTear:SetColor(tear:GetColor(), 8192, 99, false, false)
        newTear.CollisionDamage = tear.CollisionDamage / 2
    end

    function PrivateField.SetSpriteAlpha(sprite, tear)
        local oldColor = sprite.Color
        local oldColorize = oldColor:GetColorize()
        oldColor:SetColorize(oldColorize.R, oldColorize.G, oldColorize.B, oldColorize.A)
        oldColor:SetTint(tear.Color.R, tear.Color.G, tear.Color.B, 1 - math.sqrt(tear.FrameCount / PrivateField.GetTrailLength(tear)))
    end
end

function Conjunctivitis:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(ModItemIDs.CONJUNCTIVITIS) then
        return
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_POP) then
        player.TearFlags = player.TearFlags ~ TearFlags.TEAR_POP
    end
    player.TearFlags = player.TearFlags | TYU.ModTearFlags.TEAR_TRAILING | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
end
Conjunctivitis:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Conjunctivitis.EvaluateCache, CacheFlag.CACHE_TEARFLAG)

function Conjunctivitis:PostFireTear(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.CONJUNCTIVITIS) or tear.Variant ~= TearVariant.BLUE then
        return
    end
    tear:ChangeVariant(TearVariant.BLOOD)
end
Conjunctivitis:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Conjunctivitis.PostFireTear)

function Conjunctivitis:PostTearUpdate(tear)
    if tear:HasTearFlags(TYU.ModTearFlags.TEAR_TRAILING) and not tear:HasTearFlags(TearFlags.TEAR_ABSORB) and tear.CollisionDamage >= 1 then
        if tear.Variant == TearVariant.BLUE then
            tear:ChangeVariant(TearVariant.BLOOD)
        end
        PrivateField.MakeNewCopy(tear)
    end
    if not tear:HasTearFlags(TYU.ModTearFlags.TEAR_TRAILED) then
        return
    end
    if tear.FrameCount >= PrivateField.GetTrailLength(tear) then
        tear:Remove()
    end
    PrivateField.SetSpriteAlpha(tear:GetSprite(), tear)
    local alpha = 1 - math.sqrt(tear.FrameCount / PrivateField.GetTrailLength(tear))
    tear:GetTearEffectSprite().Color:SetTint(1, 1, 1, alpha)
    tear:GetTearHaloSprite().Color:SetTint(1, 1, 1, alpha)
    tear:GetDeadEyeSprite().Color:SetTint(1, 1, 1, alpha)
    tear:SetShadowSize(0)
end
Conjunctivitis:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, Conjunctivitis.PostTearUpdate)

function Conjunctivitis:PostFireTear(tear)
    local player = Utils.GetPlayerFromTear(tear)
    if not player or not player:HasCollectible(ModItemIDs.CONJUNCTIVITIS) then
        return
    end
    PrivateField.PlayFireSound = true
end
Conjunctivitis:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Conjunctivitis.PostFireTear)

function Conjunctivitis:PostTearDeath(tear)
    if Utils.HasFlags(tear.TearFlags, TYU.ModTearFlags.TEAR_TRAILED) then
        return
    end
    local player = Utils.GetPlayerFromTear(tear)
    if not player or not player:HasCollectible(ModItemIDs.CONJUNCTIVITIS) then
    end
    PrivateField.PlayDeathSound = true
end
Conjunctivitis:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, Conjunctivitis.PostTearDeath)

function Conjunctivitis:PreSFXPlay(id, volume, frameDelay, loop, pitch, pan)
    if not Players.AnyoneHasCollectible(ModItemIDs.CONJUNCTIVITIS) then
        return
    end
    if id == SoundEffect.SOUND_TEARS_FIRE or id == SoundEffect.SOUND_PLOP then
        if PrivateField.PlayFireSound then
            PrivateField.PlayFireSound = false
        else
            return false
        end
    end
    if id == SoundEffect.SOUND_SPLATTER then
        if PrivateField.PlayDeathSound then
            PrivateField.PlayDeathSound = false
        else
            return false
        end
    end
end
Conjunctivitis:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, Conjunctivitis.PreSFXPlay)

return Conjunctivitis