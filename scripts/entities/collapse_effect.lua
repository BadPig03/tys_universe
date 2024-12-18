local Lib = TYU
local CollapseEffect = Lib:NewModEntity("Collapse Effect", "COLLAPSE_EFFECT")

function CollapseEffect:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(Lib.ModItemIDs.COLLAPSE) then
        effect:Remove()
        return
    end
    local player = effect.Parent:ToPlayer()
    effect:AddMagnetized(EntityRef(player), 1)
end
CollapseEffect:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, CollapseEffect.PostEffectUpdate, Lib.ModEntityIDs.COLLAPSE_EFFECT.Variant)

return CollapseEffect