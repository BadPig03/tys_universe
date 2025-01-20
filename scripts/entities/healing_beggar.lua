local HealingBeggar = TYU:NewModEntity("Healing Beggar", "HEALING_BEGGAR")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModItemPoolIDs = TYU.ModItemPoolIDs

local PrivateField = {}

do
	function PrivateField.SpawnBloodEffects(entity)
		Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position)
		Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, entity.Position)
		Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position)
	end
end

function HealingBeggar:PreSlotCollision(slot, collider, low)
	local player = collider:ToPlayer()
	if not player then
		return
	end
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() then
		player = player:GetOtherTwin()
	end
	local sprite = slot:GetSprite()
	local rng = slot:GetDropRNG()
	if not sprite:IsPlaying("Idle") or player:GetBrokenHearts() == 0 or player:GetNumCoins() <= 1 then
		return
	end
	local donationValue = slot:GetDonationValue()
	if rng:RandomInt(100) < math.min(100, donationValue * 9) then
		slot:SetDonationValue(donationValue - 1)
		sprite:Play("PayPrize", true)
		slot:SetState(2)
	else
		slot:SetDonationValue(donationValue + 1)
		sprite:Play("PayNothing", true)
		slot:SetState(5)
	end
	slot.SpawnerEntity = player
	TYU.SFXMANAGER:Play(SoundEffect.SOUND_BAND_AID_PICK_UP)
	PrivateField.SpawnBloodEffects(player)
end
HealingBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, HealingBeggar.PreSlotCollision, ModEntityIDs.HEALING_BEGGAR.Variant)

function HealingBeggar:PostSlotUpdate(slot)
	local player = slot.SpawnerEntity and slot.SpawnerEntity:ToPlayer()
	if not player then
		return
	end
	local sprite = slot:GetSprite()
	local rng = slot:GetDropRNG()
	if sprite:IsEventTriggered("CoinInsert") then
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
		player:AddCoins(-1)
	end
	if sprite:IsEventTriggered("GainPill") then
		Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, slot.Position, Vector(1, 0):Resized(4 + rng:RandomFloat() * 5):Rotated(rng:RandomInt(360)))
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_THUMBS_DOWN)
	end
	if sprite:IsEventTriggered("Prize") then
		local newItem = TYU.ITEMPOOL:GetCollectible(ModItemPoolIDs.ILLNESS, true, rng:Next())
		Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, Utils.FindFreePickupSpawnPosition(slot.Position + Vector(0, 60)))
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		TYU.SFXMANAGER:Play(SoundEffect.SOUND_THUMBSUP)
		PrivateField.SpawnBloodEffects(player)
		player:AddBrokenHearts(-1)
		if rng:RandomInt(100) < math.min(100, slot:GetDonationValue() * 4) then
			sprite:Play("Teleport", true)
			slot:SetState(4)
		end
	end
	if sprite:IsFinished("PayPrize") then
		sprite:Play("Prize", true)
		slot:SetState(2)
	end
	if sprite:IsFinished("Prize") or sprite:IsFinished("PayNothing") then
		sprite:Play("Idle", true)
		slot:SetState(1)
	end
	if sprite:IsFinished("Teleport") then
		slot:Remove()
	end
end
HealingBeggar:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, HealingBeggar.PostSlotUpdate, ModEntityIDs.HEALING_BEGGAR.Variant)

function HealingBeggar:PreSlotCreateExplosionDrops(slot)
	local rng = slot:GetDropRNG()
	for i = 0, rng:RandomInt(3) do
		Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, slot.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
	end
	PrivateField.SpawnBloodEffects(slot)
	slot:BloodExplode()
	slot:Remove()
    return false
end
HealingBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, HealingBeggar.PreSlotCreateExplosionDrops, ModEntityIDs.HEALING_BEGGAR.Variant)

return HealingBeggar