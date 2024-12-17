local Lib = TYU
local Knockback = Lib:NewModEnchantment("Knockback", "KNOCKBACK")

function Knockback:PostPlayerUpdate(player)
    local room = Lib.GAME:GetRoom()
    if room:HasCurseMist() or room:GetFrameCount() % 30 > 0 then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.KNOCKBACK)
    if count == 0 then
        return
    end
    for _, ent in pairs(Isaac.FindInRadius(player.Position, 80 * count, EntityPartition.ENEMY)) do
        if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
            local cooldown = ent:GetBossStatusEffectCooldown()
            if ent:IsBoss() and cooldown > 0 then
                ent:SetBossStatusEffectCooldown(0)
            end
            ent:AddKnockback(EntityRef(player), (ent.Position - player.Position):Normalized():Resized(count * 7), 15, true)
            ent:SetBossStatusEffectCooldown(cooldown)
        end
    end
end
Knockback:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Knockback.PostPlayerUpdate, 0)

return Knockback