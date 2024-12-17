local Lib = TYU
local ReconVision = Lib:NewModItem("Recon Vision", "RECONVISION")

if EID then
    function EID:hasCurseBlind()
        if Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.RECONVISION) then
            return false
        end
        return Lib.LEVEL:GetCurses() & LevelCurse.CURSE_OF_BLIND > 0
    end
end

function ReconVision:PostPickupRender(pickup, offset)
    local subType = pickup.SubType
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.RECONVISION) or subType == 0 or subType >= Lib.Constants.GLITCHED_ITEM_ID then
        return
    end
    if not Lib.Collectibles.IsBlind(pickup) then
        return
    end
    if pickup:IsBlind() then
        pickup:SetForceBlind(false)
    else
        local sprite = pickup:GetSprite()
        local gfxFileName = Lib.ITEMCONFIG:GetCollectible(subType).GfxFileName
        sprite:ReplaceSpritesheet(1, gfxFileName, true)
    end
    Lib.Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0.5, 0.5, 0.5, 1)
end
ReconVision:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_RENDER, CallbackPriority.EARLY, ReconVision.PostPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

return ReconVision