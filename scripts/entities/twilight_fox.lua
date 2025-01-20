local TwilightFox = TYU:NewModEntity("Twilight Fox", "TWILIGHT_FOX")

local Entities = TYU.Entities

local ModEntityIDs = TYU.ModEntityIDs
local ModEntityFlags = TYU.ModEntityFlags

local PrivateField = {}

do
    function PrivateField.SpawnHalo(familiar, subType)
        local halo = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, subType, familiar.Position, familiar.Velocity, familiar):ToEffect()
        local sprite = halo:GetSprite()
        halo.Parent = familiar
        halo.Timeout = -1
        halo:FollowParent(familiar)
        halo:AddEntityFlags(ModEntityFlags.FLAG_NO_PAUSE)
        if subType == ModEntityIDs.TWILIGHT_FOX_HALO.SubType then
            sprite.Color = Color(1, 0.5, 1, 1)
            sprite.PlaybackSpeed = 0.8
        else
            local multiplier = math.min((0.6 + 0.01 * familiar.Hearts), 2)
            sprite.Scale = Vector(1, 1) * multiplier
            halo.ParentOffset = Vector(0, -24)
        end
        return halo
    end

    function PrivateField.GetHalo(familiar, subType)
        for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HALO, subType)) do
            local effect = ent:ToEffect()
            if GetPtrHash(effect.Parent) == GetPtrHash(familiar) then
                return effect
            end
        end
        return nil
    end
    
    function PrivateField.ClearHalo(familiar, subType)
        local halo = PrivateField.GetHalo(familiar, subType)
        if not halo then
            return
        end
        halo:Remove()
    end
end

function TwilightFox:FamiliarInit(familiar)
    local sprite = familiar:GetSprite()
    sprite:Play("Idle", true)
    familiar:AddToFollowers()
end
TwilightFox:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, TwilightFox.FamiliarInit, ModEntityIDs.TWILIGHT_FOX.Variant)

function TwilightFox:FamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()
    local cd = familiar.Keys
    if cd > 0 then
        familiar.Keys = cd - 1
        if sprite:IsPlaying("Idle") then
            sprite:Play("Curse", true)
        end
    else
        if sprite:IsPlaying("Curse") then
            sprite:Play("Idle", true)
        end
    end
    if not PrivateField.GetHalo(familiar, 3) then
        PrivateField.SpawnHalo(familiar, 3)
    end
    if not PrivateField.GetHalo(familiar, ModEntityIDs.TWILIGHT_FOX_HALO.SubType) then
        PrivateField.SpawnHalo(familiar, ModEntityIDs.TWILIGHT_FOX_HALO.SubType)
    end
    familiar:FollowParent()
end
TwilightFox:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, TwilightFox.FamiliarUpdate, ModEntityIDs.TWILIGHT_FOX.Variant)

function TwilightFox:PostNewLevel()
    for _, ent in pairs(Isaac.FindByType(ModEntityIDs.TWILIGHT_FOX.Type, ModEntityIDs.TWILIGHT_FOX.Variant)) do
        local familiar = ent:ToFamiliar()
        if familiar then
            familiar.Hearts = 0
        end
    end
end
TwilightFox:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, TwilightFox.PostNewLevel)

return TwilightFox