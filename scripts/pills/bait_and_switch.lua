local BaitAndSwitch = TYU:NewModPill("Bait And Switch", "BAIT_AND_SWITCH")
local Players = TYU.Players
local ModPillEffectIDs = TYU.ModPillEffectIDs

function BaitAndSwitch:UsePill(pillEffect, player, useFlags, pillColor)
    if pillColor & PillColor.PILL_GIANT_FLAG == PillColor.PILL_GIANT_FLAG then
        Players.AddShield(player, 60)
    end
    player:TeleportToRandomPosition()
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_HELL_PORTAL2, 0.6)
    Players.AddShield(player, 60)
end
BaitAndSwitch:AddCallback(ModCallbacks.MC_USE_PILL, BaitAndSwitch.UsePill, ModPillEffectIDs.BAIT_AND_SWITCH)

return BaitAndSwitch