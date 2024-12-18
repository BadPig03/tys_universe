local CollapseEffect = TYU:NewModEntity("Collapse Effect", "COLLAPSE_EFFECT")
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

function CollapseEffect:PostEffectUpdate(effect)
    if not effect.Parent or not effect.Parent:ToPlayer() or not effect.Parent:ToPlayer():HasCollectible(ModItemIDs.COLLAPSE) then
        effect:Remove()
        return
    end
    local player = effect.Parent:ToPlayer()
    effect:AddMagnetized(EntityRef(player), 1)
end
CollapseEffect:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, CollapseEffect.PostEffectUpdate, ModEntityIDs.COLLAPSE_EFFECT.Variant)

return CollapseEffect