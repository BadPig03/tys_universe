local Lib = TYU
local ChefBeggar = Lib:NewModEntity("Chef Beggar", "CHEFBEGGAR")

local function AddFoodToQueue(slot, food)
	local bank = Lib.Foods.ExtractValues(slot:GetDonationValue())
	for i = 1, 4 do
		if bank[i] == 0 then
			bank[i] = food
			break
		end
	end
	slot:SetDonationValue(Lib.Foods.CombineValues(bank))
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
	local bank = Lib:GetGlobalLibData("Foods", "Bank")
	if not bank or Lib.Foods.GetValidEmptySlot(slot:GetDonationValue()) == 0 then
		return
	end
	local food = -1
	local foodIndex = 4
	for i = 4, 1, -1 do
		if bank[i] ~= -1 then
			food = bank[i]
			foodIndex = i
			Lib:SetGlobalLibData(-1, "Foods", "Bank", i)
			break
		end
		if i == 1 and bank[i] == -1 then
			return
		end
	end
	sprite:ReplaceSpritesheet(2, "gfx/ui/foods/"..(food + 1)..".png", true)
	sprite:Play("PayNothing", true)
	AddFoodToQueue(slot, food + 1)
	slot:SetState(2)
end
ChefBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, ChefBeggar.PreSlotCollision, Lib.ModEntityIDs.CHEFBEGGAR.Variant)

function ChefBeggar:PostSlotUpdate(slot)
	local sprite = slot:GetSprite()
	if sprite:IsEventTriggered("Prize") then
		local room = Lib.GAME:GetRoom()
		local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ModItemIDs.SUSPICIOUSSTEW, room:FindFreePickupSpawnPosition(slot.Position + Vector(0, 40))):ToPickup()
		item:SetVarData(slot:GetDonationValue())
		item:RemoveCollectibleCycle()
		item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
		item.Price = 0
		Lib:SetGlobalLibData(true, "WarfarinItems", tostring(item.InitSeed))
		Lib:SetGlobalLibData(slot:GetDonationValue(), "Foods", "Effects", tostring(item.InitSeed))
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_THUMBSUP)
	end
	if sprite:IsEventTriggered("GainItem") then
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
	end
    if sprite:IsFinished("PayNothing") then
		if Lib.Foods.GetValidEmptySlot(slot:GetDonationValue()) == 0 then
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
ChefBeggar:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, ChefBeggar.PostSlotUpdate, Lib.ModEntityIDs.CHEFBEGGAR.Variant)

function ChefBeggar:PreSlotCreateExplosionDrops(slot)
	if Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEFHAT) or Lib:GetGlobalLibData("Foods", "ChefHatSpawned") then
		local rng = slot:GetDropRNG()
		for i = 0, rng:RandomInt(2) do
			Lib.Entities.Spawn(Lib.ModEntityIDs.FOODSFOODITEM.Type, Lib.ModEntityIDs.FOODSFOODITEM.Variant, 0, slot.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
		end
	else
		local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ModItemIDs.CHEFHAT, slot.Position):ToPickup()
		item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
		item.Price = 0
		Lib:SetGlobalLibData(true, "Foods", "ChefHatSpawned")
	end
	slot:BloodExplode()
	slot:Remove()
    return false
end
ChefBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, ChefBeggar.PreSlotCreateExplosionDrops, Lib.ModEntityIDs.CHEFBEGGAR.Variant)

return ChefBeggar