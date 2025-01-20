local ChefBeggar = TYU:NewModEntity("Chef Beggar", "CHEF_BEGGAR")

local Entities = TYU.Entities
local Foods = TYU.Foods
local Players = TYU.Players
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Foods", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Foods", ...)
end

do
	function PrivateField.AddFoodToQueue(slot, food)
		local bank = Foods.ExtractValues(slot:GetDonationValue())
		for i = 1, 4 do
			if bank[i] == 0 then
				bank[i] = food
				break
			end
		end
		slot:SetDonationValue(Foods.CombineValues(bank))
	end
end

function ChefBeggar:PreSlotCollision(slot, collider, low)
	local player = collider:ToPlayer()
	if not player then
		return
	end
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
		player = player:GetOtherTwin()
	end
	local sprite = slot:GetSprite()
	if not sprite:IsPlaying("Idle") then
		return
	end
	local bank = GetGlobalLibData("Bank")
	if not bank or Foods.GetValidEmptySlot(slot:GetDonationValue()) == 0 then
		return
	end
	local food = -1
	local foodIndex = 4
	for i = 4, 1, -1 do
		if bank[i] ~= -1 then
			food = bank[i]
			foodIndex = i
			SetGlobalLibData(-1, "Bank", i)
			break
		end
		if i == 1 and bank[i] == -1 then
			return
		end
	end
	PrivateField.AddFoodToQueue(slot, food + 1)
	slot:SetState(2)
	sprite:ReplaceSpritesheet(2, "gfx/ui/foods/"..(food + 1)..".png", true)
	sprite:Play("PayNothing", true)
end
ChefBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, ChefBeggar.PreSlotCollision, ModEntityIDs.CHEF_BEGGAR.Variant)

function ChefBeggar:PostSlotUpdate(slot)
	local sprite = slot:GetSprite()
	if sprite:IsEventTriggered("Prize") then
		local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ModItemIDs.SUSPICIOUS_STEW, Utils.FindFreePickupSpawnPosition(slot.Position + Vector(0, 40))):ToPickup()
		item:SetVarData(slot:GetDonationValue())
		item:RemoveCollectibleCycle()
		item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
		item.Price = 0
		Utils.AddSeedToWarfarinItems(item.InitSeed)
		SetGlobalLibData(slot:GetDonationValue(), "Effects", tostring(item.InitSeed))
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_THUMBSUP)
	end
	if sprite:IsEventTriggered("GainItem") then
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
	end
    if sprite:IsFinished("PayNothing") then
		if Foods.GetValidEmptySlot(slot:GetDonationValue()) == 0 then
			sprite:Play("Prize", true)
			slot:SetState(2)
			return
		end
		sprite:Play("Idle", true)
		slot:SetState(1)
	end
	if sprite:IsFinished("Prize") then
		sprite:Play("Idle", true)
		slot:SetDonationValue(0)
		slot:SetState(1)
	end
end
ChefBeggar:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, ChefBeggar.PostSlotUpdate, ModEntityIDs.CHEF_BEGGAR.Variant)

function ChefBeggar:PreSlotCreateExplosionDrops(slot)
	if Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) or GetGlobalLibData("ChefHatSpawned") then
		local rng = slot:GetDropRNG()
		for i = 0, rng:RandomInt(2) do
			Entities.Spawn(ModEntityIDs.FOODS_FOOD_ITEM.Type, ModEntityIDs.FOODS_FOOD_ITEM.Variant, 0, slot.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
		end
	else
		local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ModItemIDs.CHEF_HAT, slot.Position):ToPickup()
		item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
		item.Price = 0
		SetGlobalLibData(true, "ChefHatSpawned")
	end
	slot:BloodExplode()
	slot:Remove()
    return false
end
ChefBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, ChefBeggar.PreSlotCreateExplosionDrops, ModEntityIDs.CHEF_BEGGAR.Variant)

return ChefBeggar