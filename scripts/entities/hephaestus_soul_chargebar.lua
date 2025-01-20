local HephaestusSoulChargeBar = TYU:NewModEntity("Hephaestus Soul ChargeBar", "HEPHAESTUS_SOUL_CHARGEBAR")

local Constants = TYU.Constants

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "HephaestusSoul", ...)
end

function HephaestusSoulChargeBar:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(ModItemIDs.HEPHAESTUS_SOUL) then
        effect:Remove()
        return
    end
    local sprite = effect:GetSprite()
    local player = effect.Parent:ToPlayer()
    if sprite:IsPlaying("Charging") then
        if not player:IsExtraAnimationFinished() and sprite.PlaybackSpeed ~= 0 then
            sprite.PlaybackSpeed = 0
        elseif player:IsExtraAnimationFinished() and sprite.PlaybackSpeed ~= Constants.CHARGEBAR_PLAYBACKRATE then
            sprite.PlaybackSpeed = Constants.CHARGEBAR_PLAYBACKRATE
        end
    end
    if sprite:IsFinished("Charging") then
        sprite.PlaybackSpeed = 1
        SetTempEntityLibData(player, true, "FullyCharged")
        sprite:Play("StartCharged", true)
	end
    if sprite:IsFinished("StartCharged") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Charged", true)
	end
    if sprite:IsFinished("Disappear") then
        SetTempEntityLibData(player, { FullyCharged = false, LastDirection = Vector(0, 0), ChargeTime = 0 })
        effect:Remove()
	end
end
HephaestusSoulChargeBar:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, HephaestusSoulChargeBar.PostEffectUpdate, ModEntityIDs.HEPHAESTUS_SOUL_CHARGEBAR.Variant)

return HephaestusSoulChargeBar