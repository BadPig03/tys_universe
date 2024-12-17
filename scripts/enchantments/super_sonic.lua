local Lib = TYU
local SuperSonic = Lib:NewModEnchantment("Super Sonic", "SUPERSONIC")

function SuperSonic:PostUpdate()
    if Lib.GAME:GetRoom():HasCurseMist() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.SUPERSONIC)
    if count <= 0 then
        return
    end
    local player = Isaac.GetPlayer(0)
    for _, ent in pairs(Isaac.FindInRadius(player.Position, 1 << 16, EntityPartition.ENEMY)) do
        if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
            if ent:IsBoss() then
                if ent:GetBossStatusEffectCooldown() > 0 then
                    ent:SetBossStatusEffectCooldown(0)
                end
                ent:AddSlowing(EntityRef(player), 1, math.min(0.4, count * 0.075), Lib.Colors.SLOWING)
            else
                ent:AddSlowing(EntityRef(player), 1, math.min(0.8, count * 0.15), Lib.Colors.SLOWING)
            end
        end
    end
end
SuperSonic:AddCallback(ModCallbacks.MC_POST_UPDATE, SuperSonic.PostUpdate)

return SuperSonic