local RottenSteak = TYU:NewModItem("Rotten Steak", "ROTTEN_STEAK")

local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat

local ModItemIDs = TYU.ModItemIDs

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("RottenSteak", ...)
end

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "RottenSteak", ...)
end

function RottenSteak:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(ModItemIDs.ROTTEN_STEAK)
    if count <= 0 then
        return
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        Stat:AddFlatTears(player, 0.7 * count)
        Stat:AddTearsUp(player, -0.5 * count)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + 0.2 * count
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + 100 * count
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            Stat:AddSpeedUp(player, -0.03 * count)
        end
    end
end
RottenSteak:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, RottenSteak.EvaluateCache)

function RottenSteak:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    player:AddRottenHearts(2)
    local count = GetGlobalLibData() or 0
    SetGlobalLibData(count + 1)
end
RottenSteak:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, RottenSteak.PostAddCollectible, ModItemIDs.ROTTEN_STEAK)

function RottenSteak:PostPickupUpdate(pickup)
	if pickup.SubType == CollectibleType.COLLECTIBLE_NULL or pickup.SubType == ModItemIDs.ROTTEN_STEAK and pickup.Wait >= 1 then
		return
	end
	if not TYU.ITEMCONFIG:GetCollectible(pickup.SubType) or not TYU.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
		return
	end
	if not Players.AnyoneHasCollectible(ModItemIDs.ROTTEN_STEAK) then
		return
	end
    local count = GetGlobalLibData() or 0
    if count <= 0 then
        return
    end
    local newType = ModItemIDs.ROTTEN_STEAK
    Entities.Morph(pickup, nil, nil, newType)
    Entities.SpawnPoof(pickup.Position)
    SetGlobalLibData(count - 1)
end
RottenSteak:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, RottenSteak.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

return RottenSteak