local Lib = TYU
local OceanusSoulChargeBar = Lib:NewModEntity("Oceanus Soul ChargeBar", "OCEANUS_SOUL_CHARGEBAR")

function OceanusSoulChargeBar:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) then
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
        Lib:SetTempEntityLibData(player, true, "OceanusSoul", "FullyCharged")
        sprite:Play("StartCharged", true)
	end
    if sprite:IsFinished("StartCharged") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Charged", true)
	end
    if sprite:IsFinished("Disappear") then
        Lib:SetTempEntityLibData(player, { FullyCharged = false, ChargeTime = 0 }, "OceanusSoul")
        effect:Remove()
	end
end
OceanusSoulChargeBar:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, OceanusSoulChargeBar.PostEffectUpdate, Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Variant)

return OceanusSoulChargeBar