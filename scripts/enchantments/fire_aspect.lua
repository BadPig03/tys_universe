local Lib = TYU
local FireAspect = Lib:NewModEnchantment("Fire Aspect", "FIRE_ASPECT")

function FireAspect:PostPlayerUpdate(player)
    if player:HasCurseMistEffect() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.FIRE_ASPECT)
    if count == 0 then
        return
    end
    for _, ent in pairs(Isaac.FindInRadius(player.Position, 80 * count, EntityPartition.ENEMY)) do
        if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
            local cooldown = ent:GetBossStatusEffectCooldown()
            if ent:IsBoss() and cooldown > 0 then
                ent:SetBossStatusEffectCooldown(0)
            end
            ent:AddBurn(EntityRef(player), 1, player.Damage)
            ent:SetBossStatusEffectCooldown(cooldown)
        end
    end
end
FireAspect:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FireAspect.PostPlayerUpdate, 0)

return FireAspect