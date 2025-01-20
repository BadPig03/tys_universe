local Anorexia = TYU:NewModItem("Anorexia", "ANOREXIA")

local Collectibles = TYU.Collectibles
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.SimulateHematemesisEffect(player)
        if player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY_B then
			player:AddHearts(-99)
			player:AddHearts(2)
		end
        local variant, subtype
		if player:GetHealthType() == HealthType.COIN then
            variant, subtype = PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY
        else
            variant, subtype = PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL
        end
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_YUM_HEART)
        for _ = 0, rng:RandomInt(4) do
            Entities.Spawn(EntityType.ENTITY_PICKUP, variant, subtype, Utils.FindFreePickupSpawnPosition(player.Position))
        end
    end

end

function Anorexia:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == ModItemIDs.ANOREXIA then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
            Players.RemoveCostume(player, ModItemIDs.ANOREXIA)
        elseif firstTime then
            PrivateField.SimulateHematemesisEffect(player)
        end
        return
	elseif collectibleType == CollectibleType.COLLECTIBLE_BINGE_EATER and player:HasCollectible(ModItemIDs.ANOREXIA) then
        Players.RemoveCostume(player, ModItemIDs.ANOREXIA)
    end
end
Anorexia:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Anorexia.PostAddCollectible)

function Anorexia:PostPickupUpdate(pickup)
	if pickup.SubType == CollectibleType.COLLECTIBLE_NULL or pickup.Wait >= 5 then
		return
	end
	if not TYU.ITEMCONFIG:GetCollectible(pickup.SubType) or not TYU.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
		return
	end
	if not Players.AnyoneHasCollectible(ModItemIDs.ANOREXIA) or Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) or Utils.IsInDeathCertificate() then
		return
	end
    local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.ANOREXIA)
    local newType = Collectibles.GetCollectibleFromCurrentRoom(ItemConfig.TAG_FOOD, rng)
    if pickup.SubType ~= newType then
        Entities.Morph(pickup, nil, nil, newType)
    elseif pickup.SubType == CollectibleType.COLLECTIBLE_BREAKFAST then
        if rng:RandomInt(100) < 75 then
            pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
            Entities.Morph(pickup, nil, nil, CollectibleType.COLLECTIBLE_BREAKFAST, nil, nil, nil, false)
            Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0, 0, 0, 1)
        else
            pickup:TryRemoveCollectible()
            Entities.SpawnPoof(pickup.Position)
        end
    end
end
Anorexia:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Anorexia.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

return Anorexia