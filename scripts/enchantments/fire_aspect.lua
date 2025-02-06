local FireAspect = TYU:NewModEnchantment("Fire Aspect", "FIRE_ASPECT")

local Players = TYU.Players
local Utils = TYU.Utils

local ModEnchantmentIDs = TYU.ModEnchantmentIDs

function FireAspect:PostPlayerUpdate(player)
    if Utils.HasCurseMist() then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.FIRE_ASPECT)
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
            if ent:IsBoss() and cooldown > 0 then
                ent:SetBossStatusEffectCooldown(cooldown)
            end
        end
    end
end
FireAspect:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FireAspect.PostPlayerUpdate, 0)

return FireAspect