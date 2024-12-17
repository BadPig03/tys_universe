local Lib = TYU
local BobsStomachChargeBar = Lib:NewModEntity("Bobs Stomach ChargeBar", "BOBSSTOMACHCHARGEBAR")

function BobsStomachChargeBar:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(Lib.ModItemIDs.BOBSSTOMACH) then
        effect:Remove()
        return
    end
    local sprite = effect:GetSprite()
    local player = effect.Parent:ToPlayer()
    if sprite:IsPlaying("Charging") then
        if not player:IsExtraAnimationFinished() and sprite.PlaybackSpeed ~= 0 then
            sprite.PlaybackSpeed = 0
        elseif player:IsExtraAnimationFinished() and sprite.PlaybackSpeed ~= Lib.Constants.CHARGEBAR_PLAYBACKRATE then
            sprite.PlaybackSpeed = Lib.Constants.CHARGEBAR_PLAYBACKRATE
        end
    end
    if sprite:IsFinished("Charging") then
        sprite.PlaybackSpeed = 1
        Lib:SetTempEntityLibData(player, true, "BobsStomach", "FullyCharged")
        sprite:Play("StartCharged", true)
	end
    if sprite:IsFinished("StartCharged") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Charged", true)
	end
    if sprite:IsFinished("Disappear") then
        Lib:SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 }, "BobsStomach")
        effect:Remove()
	end
end
BobsStomachChargeBar:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, BobsStomachChargeBar.PostEffectUpdate, Lib.ModEntityIDs.BOBSSTOMACHCHARGEBAR.Variant)

return BobsStomachChargeBar