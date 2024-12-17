local Lib = TYU
local BaitAndSwitch = Lib:NewModPill("Bait And Switch", "BAITANDSWITCH")

function BaitAndSwitch:UsePill(pillEffect, player, useFlags, pillColor)
    if pillColor & PillColor.PILL_GIANT_FLAG == PillColor.PILL_GIANT_FLAG then
        Lib.Players.AddShield(player, 60)
    end
    player:TeleportToRandomPosition()
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_HELL_PORTAL2, 0.6)
    Lib.Players.AddShield(player, 60)
end
BaitAndSwitch:AddCallback(ModCallbacks.MC_USE_PILL, BaitAndSwitch.UsePill, Lib.ModPillEffectIDs.BAITANDSWITCH)

return BaitAndSwitch