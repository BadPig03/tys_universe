local Lib = TYU
local TwilightFoxHalo = Lib:NewModEntity("Twilight Fox Halo", "TWILIGHTFOXHALO")

function TwilightFoxHalo:PostEffectUpdate(effect)
    if effect.SubType ~= 3 and effect.SubType ~= Lib.ModEntityIDs.TWILIGHTFOXHALO.SubType then
        return
    end
    local familiar = effect.SpawnerEntity and effect.SpawnerEntity:ToFamiliar()
    if not familiar or familiar.SubType ~= Lib.ModEntityIDs.TWILIGHTFOX.SubType or not effect.IsFollowing then
        effect:Remove()
        return
    end
    if effect.SubType == 3 then
        local scale = effect:GetSprite().Scale
        local multiplier = math.min((0.6 + 0.01 * familiar.Hearts), 2)
        effect:GetSprite().Scale = Vector(1, 1) * multiplier
        for _, ent in pairs(Isaac.FindInRadius(effect.Position + Vector(0, 18), 64 * multiplier, EntityPartition.ENEMY)) do
            if Lib.Entities.IsValidEnemy(ent) then
                if ent:GetWeaknessCountdown() < 2 then
                    ent:AddWeakness(EntityRef(familiar.Player), 2)
                end
            end
        end
    end
    if effect.SubType == Lib.ModEntityIDs.TWILIGHTFOXHALO.SubType then
        for _, ent in pairs(Isaac.FindInRadius(effect.Position + Vector(0, -5), 52, EntityPartition.BULLET | EntityPartition.ENEMY)) do
            if ent:ToProjectile() then
                familiar.Hearts = familiar.Hearts + 1
                familiar.Keys = 60
                ent:Die()
            end
            if ent:ToNPC() then
                ent:AddVelocity((ent.Position - effect.Position):Normalized():Resized(5))
            end
        end
    end
end
TwilightFoxHalo:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, TwilightFoxHalo.PostEffectUpdate, Lib.ModEntityIDs.TWILIGHTFOXHALO.Variant)

return TwilightFoxHalo