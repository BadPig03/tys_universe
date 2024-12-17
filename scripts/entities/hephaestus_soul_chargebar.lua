local Lib = TYU
local HephaestusSoulChargeBar = Lib:NewModEntity("Hephaestus Soul ChargeBar", "HEPHAESTUSSOULCHARGEBAR")

function HephaestusSoulChargeBar:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(Lib.ModItemIDs.HEPHAESTUSSOUL) then
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
        Lib:SetTempEntityLibData(player, true, "HephaestusSoul", "FullyCharged")
        sprite:Play("StartCharged", true)
	end
    if sprite:IsFinished("StartCharged") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Charged", true)
	end
    if sprite:IsFinished("Disappear") then
        Lib:SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 }, "HephaestusSoul")
        effect:Remove()
	end
end
HephaestusSoulChargeBar:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, HephaestusSoulChargeBar.PostEffectUpdate, Lib.ModEntityIDs.HEPHAESTUSSOULCHARGEBAR.Variant)

return HephaestusSoulChargeBar