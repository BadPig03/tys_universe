local Lib = TYU
local HealingBeggar = Lib:NewModEntity("Healing Beggar", "HEALINGBEGGAR")

local function SpawnBloodEffects(entity)
	Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position)
	Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, entity.Position)
	Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position)
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
	if sprite:IsPlaying("Idle") and player:GetBrokenHearts() >= 1 and player:GetNumCoins() >= 2 then
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
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_BAND_AID_PICK_UP)
		SpawnBloodEffects(player)
	end
end
HealingBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, HealingBeggar.PreSlotCollision, Lib.ModEntityIDs.HEALINGBEGGAR.Variant)

function HealingBeggar:PostSlotUpdate(slot)
	local player = slot.SpawnerEntity and slot.SpawnerEntity:ToPlayer()
	if not player then
		return
	end
	local sprite = slot:GetSprite()
	local room = Lib.GAME:GetRoom()
	local rng = slot:GetDropRNG()
	if sprite:IsEventTriggered("CoinInsert") then
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
		player:AddCoins(-1)
	end
	if sprite:IsEventTriggered("GainPill") then
		Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, slot.Position, Vector(1, 0):Resized(4 + rng:RandomFloat() * 5):Rotated(rng:RandomInt(360)))
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_THUMBS_DOWN)
	end
	if sprite:IsEventTriggered("Prize") then
		local newItem = Lib.ITEMPOOL:GetCollectible(Lib.ModItemPoolIDs.ILLNESS, true, rng:Next())
		Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, room:FindFreePickupSpawnPosition(slot.Position + Vector(0, 60), 0, true))
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_SLOTSPAWN)
		Lib.SFXMANAGER:Play(SoundEffect.SOUND_THUMBSUP)
		SpawnBloodEffects(player)
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
HealingBeggar:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, HealingBeggar.PostSlotUpdate, Lib.ModEntityIDs.HEALINGBEGGAR.Variant)

function HealingBeggar:PreSlotCreateExplosionDrops(slot)
	local rng = slot:GetDropRNG()
	for i = 0, rng:RandomInt(3) do
		Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, slot.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
	end
	SpawnBloodEffects(slot)
	slot:BloodExplode()
	slot:Remove()
    return false
end
HealingBeggar:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, HealingBeggar.PreSlotCreateExplosionDrops, Lib.ModEntityIDs.HEALINGBEGGAR.Variant)

return HealingBeggar