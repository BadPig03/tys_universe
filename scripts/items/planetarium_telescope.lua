local Lib = TYU
local PlanetariumTelescope = Lib:NewModItem("Planetarium Telescope", "PLANETARIUMTELESCOPE")

local function GetAvarageLuck()
    local luck = 0
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        luck = luck + player.Luck
    end
    return luck / #Lib.Players.GetPlayers(true)
end

local function GetItemCount(player)
    local count = 0
    for _, item in ipairs(Lib.ITEMCONFIG:GetTaggedItems(ItemConfig.TAG_STARS)) do
        count = count + player:GetCollectibleNum(item.ID)
    end
    return count
end

function PlanetariumTelescope:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(Lib.ModItemIDs.PLANETARIUMTELESCOPE) then
        return
    end
    player.Luck = player.Luck + 2 * GetItemCount(player)
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PlanetariumTelescope.EvaluateCache, CacheFlag.CACHE_LUCK)

function PlanetariumTelescope:PrePlanetariumApplyStagePenalty()
    local stage = Lib.LEVEL:GetAbsoluteStage()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.PLANETARIUMTELESCOPE) or stage == LevelStage.STAGE4_3 or stage == LevelStage.STAGE8 then
        return
    end
    return false
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_STAGE_PENALTY, PlanetariumTelescope.PrePlanetariumApplyStagePenalty)

function PlanetariumTelescope:PrePlanetariumApplyTelescopeLens(chance)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.PLANETARIUMTELESCOPE) then
        return
    end
    return chance + math.min(0.5, math.max(0, GetAvarageLuck() / 12))
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, PlanetariumTelescope.PrePlanetariumApplyTelescopeLens)

function PlanetariumTelescope:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    local room = Lib.GAME:GetRoom()
    if type == Lib.ModItemIDs.PLANETARIUMTELESCOPE and firstTime then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_STARS, room:FindFreePickupSpawnPosition(player.Position, 0, true))
    end
    if type and Lib.ITEMCONFIG:GetCollectible(type):HasTags(ItemConfig.TAG_STARS) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
    end
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PlanetariumTelescope.PostAddCollectible)

function PlanetariumTelescope:PostPickupUpdate(pickup)
    local room = Lib.GAME:GetRoom()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.PLANETARIUMTELESCOPE) or room:GetType() ~= RoomType.ROOM_PLANETARIUM or pickup.OptionsPickupIndex == 0 then
        return
    end
    pickup.OptionsPickupIndex = 0
end
PlanetariumTelescope:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PlanetariumTelescope.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

return PlanetariumTelescope