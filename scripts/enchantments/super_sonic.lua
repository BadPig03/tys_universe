local SuperSonic = TYU:NewModEnchantment("Super Sonic", "SUPER_SONIC")

local Players = TYU.Players
local Utils = TYU.Utils

local ModEnchantmentIDs = TYU.ModEnchantmentIDs

function SuperSonic:PostUpdate()
    if Utils.HasCurseMist() then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.SUPER_SONIC)
    if count == 0 then
        return
    end
    local player = Isaac.GetPlayer(0)
    for _, ent in pairs(Isaac.FindInRadius(player.Position, 1 << 16, EntityPartition.ENEMY)) do
        if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
            if ent:IsBoss() then
                local cooldown = ent:GetBossStatusEffectCooldown()
                if cooldown > 0 then
                    ent:SetBossStatusEffectCooldown(0)
                end
                ent:AddSlowing(EntityRef(player), 1, math.min(0.4, count * 0.075), Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863))
                if cooldown > 0 then
                    ent:SetBossStatusEffectCooldown(cooldown)
                end
            else
                ent:AddSlowing(EntityRef(player), 1, math.min(0.8, count * 0.15), Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863))
            end
        end
    end
end
SuperSonic:AddCallback(ModCallbacks.MC_POST_UPDATE, SuperSonic.PostUpdate)

return SuperSonic