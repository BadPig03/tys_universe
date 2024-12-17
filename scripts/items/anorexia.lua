local Anorexia = TYU:NewModItem("Anorexia", "ANOREXIA")
local Collectibles = TYU.Collectibles
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local PrivateField = {}

do
	function PrivateField.SimulateHematemesisEffect(player)
		local room = TYU.GAME:GetRoom()
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_YUM_HEART)
		local healthType = player:GetHealthType()
		if healthType == HealthType.RED or healthType == HealthType.BONE then
			player:AddHearts(-99)
			player:AddHearts(2)
			for i = 0, rng:RandomInt(4) do
				Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, room:FindFreePickupSpawnPosition(player.Position, 0, true))
			end
		elseif healthType == HealthType.COIN then
			player:AddHearts(-99)
			player:AddHearts(2)
			for i = 0, rng:RandomInt(4) do
				Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(player.Position, 0, true))
			end
		else
			for i = 0, rng:RandomInt(4) do
				Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, room:FindFreePickupSpawnPosition(player.Position, 0, true))
			end
		end
	end
end

function Anorexia:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
	if collectibleType == TYU.ModItemIDs.ANOREXIA then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
			Players.RemoveCostume(player, TYU.ModItemIDs.ANOREXIA)
		elseif firstTime then
			PrivateField.SimulateHematemesisEffect(player)
		end
	elseif collectibleType == CollectibleType.COLLECTIBLE_BINGE_EATER and player:HasCollectible(TYU.ModItemIDs.ANOREXIA) then
		Players.RemoveCostume(player, TYU.ModItemIDs.ANOREXIA)
	end
end
Anorexia:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Anorexia.PostAddCollectible)

function Anorexia:PostPickupUpdate(pickup)
	if not Players.AnyoneHasCollectible(TYU.ModItemIDs.ANOREXIA) or Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) or Utils.IsInDeathCertificate() or pickup.Wait >= 5 or pickup.SubType == 0 or not TYU.ITEMCONFIG:GetCollectible(pickup.SubType) or not TYU.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
		return
	end
	local rng = Isaac.GetPlayer(0):GetCollectibleRNG(TYU.ModItemIDs.ANOREXIA)
	local newType = Collectibles.GetCollectibleFromCurrentRoom(ItemConfig.TAG_FOOD, rng)
	if pickup.SubType ~= newType then
		Entities.Morph(pickup, nil, nil, newType)
	elseif pickup.SubType == newType and pickup.SubType == CollectibleType.COLLECTIBLE_BREAKFAST then
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