local ReconVision = TYU:NewModItem("Recon Vision", "RECON_VISION")

local Constants = TYU.Constants
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Reverie = TYU.Reverie
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

if EID then
    function EID:hasCurseBlind()
        if Players.AnyoneHasCollectible(ModItemIDs.RECON_VISION) then
            return false
        end
        return Utils.HasFlags(TYU.LEVEL:GetCurses(), LevelCurse.CURSE_OF_BLIND)
    end
end

function ReconVision:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if not Reverie.WillPlayerBuff(player) then
        return
    end
    player:AddCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
end
ReconVision:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ReconVision.PostAddCollectible, ModItemIDs.RECON_VISION)

function ReconVision:PostPickupRender(pickup, offset)
    local subType = pickup.SubType
    if not Players.AnyoneHasCollectible(ModItemIDs.RECON_VISION) or subType == 0 or subType >= Constants.GLITCHED_ITEM_ID then
        return
    end
    if not Collectibles.IsBlind(pickup) then
        return
    end
    if pickup:IsBlind() then
        pickup:SetForceBlind(false)
    else
        local sprite = pickup:GetSprite()
        local gfxFileName = TYU.ITEMCONFIG:GetCollectible(subType).GfxFileName
        sprite:ReplaceSpritesheet(1, gfxFileName, true)
    end
    Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0.5, 0.5, 0.5, 1)
end
ReconVision:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_RENDER, CallbackPriority.EARLY, ReconVision.PostPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

return ReconVision