local PlanetariumTelescope = TYU:NewModItem("Planetarium Telescope", "PLANETARIUM_TELESCOPE")

local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.GetAvarageLuck()
        local luck = 0
        for _, player in ipairs(Players.GetPlayers(true)) do
            luck = luck + player.Luck
        end
        return luck / #Players.GetPlayers(true)
    end
    
    function PrivateField.GetItemCount(player)
        local count = 0
        for _, item in ipairs(TYU.ITEMCONFIG:GetTaggedItems(ItemConfig.TAG_STARS)) do
            count = count + player:GetCollectibleNum(item.ID)
        end
        return count
    end
end

function PlanetariumTelescope:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(ModItemIDs.PLANETARIUM_TELESCOPE) then
        return
    end
    local count = PrivateField.GetItemCount(player)
    if count == 0 then
        return
    end
    player.Luck = player.Luck + 2 * count
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PlanetariumTelescope.EvaluateCache, CacheFlag.CACHE_LUCK)

function PlanetariumTelescope:PrePlanetariumApplyStagePenalty()
    local stage = TYU.LEVEL:GetAbsoluteStage()
    if not Players.AnyoneHasCollectible(ModItemIDs.PLANETARIUM_TELESCOPE) or stage == LevelStage.STAGE4_3 or stage == LevelStage.STAGE8 then
        return
    end
    return false
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_STAGE_PENALTY, PlanetariumTelescope.PrePlanetariumApplyStagePenalty)

function PlanetariumTelescope:PrePlanetariumApplyTelescopeLens(chance)
    if not Players.AnyoneHasCollectible(ModItemIDs.PLANETARIUM_TELESCOPE) then
        return
    end
    return chance + math.min(0.5, math.max(0, PrivateField.GetAvarageLuck() / 12))
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, PlanetariumTelescope.PrePlanetariumApplyTelescopeLens)

function PlanetariumTelescope:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if type == ModItemIDs.PLANETARIUM_TELESCOPE and firstTime then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_STARS, Utils.FindFreePickupSpawnPosition(player.Position))
    end
    if type and TYU.ITEMCONFIG:GetCollectible(type):HasTags(ItemConfig.TAG_STARS) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
    end
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PlanetariumTelescope.PostAddCollectible)

function PlanetariumTelescope:PostPickupUpdate(pickup)
    if not Players.AnyoneHasCollectible(ModItemIDs.PLANETARIUM_TELESCOPE) or not Utils.IsRoomType(RoomType.ROOM_PLANETARIUM) or pickup.OptionsPickupIndex == 0 then
        return
    end
    pickup.OptionsPickupIndex = 0
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PlanetariumTelescope.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

return PlanetariumTelescope