local Lib = TYU
local CrownOfKingsEffect = Lib:NewModEntity("Crown Of Kings Effect", "CROWN_OF_KINGS_EFFECT")

function CrownOfKingsEffect:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(Lib.ModItemIDs.CROWN_OF_KINGS) then
        effect:Remove()
        return
    end
    local sprite = effect:GetSprite()
    local player = effect.Parent:ToPlayer()
    local hasCrownOfLight = player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT)
    local hasDarkPrincesCrown = player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN)
    local flyOffset = Vector(0, 0)
    if player.CanFly then
        flyOffset = Vector(0, -4)
    end
    sprite.Scale = player.SpriteScale
    effect.DepthOffset = 0.1
    if hasCrownOfLight and hasDarkPrincesCrown then
        effect.ParentOffset = Vector(0, -21) + flyOffset
    elseif (hasCrownOfLight and not hasDarkPrincesCrown) or (not hasCrownOfLight and hasDarkPrincesCrown) then
        effect.ParentOffset = Vector(0, -10.5) + flyOffset
    else
        effect.ParentOffset = Vector(0, 0) + flyOffset
    end
    if Lib:GetPlayerLibData(player, "CrownOfKings", "BossFound") then
        sprite:Play("FloatGlow")
    else
        sprite:Play("FloatNoGlow")
    end
    effect.Visible = player:IsExtraAnimationFinished()
end
CrownOfKingsEffect:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, CrownOfKingsEffect.PostEffectUpdate, Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.Variant)

return CrownOfKingsEffect