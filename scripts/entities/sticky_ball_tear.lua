local StickyBallTear = TYU:NewModEntity("Sticky Ball Tear", "STICKY_BALL_TEAR")
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModTearFlags = TYU.ModTearFlags
local ModEntityIDs = TYU.ModEntityIDs
local PrivateField  = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "StickyBall", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "StickyBall", ...)
end

do
	function PrivateField.GetTearScale(tear)
		local sprite = tear:GetSprite()
		local scale = tear.Scale
		local sizeMulti = tear.SizeMulti
		local flags = tear.TearFlags
		if scale > 2.55 then
			return Vector(scale * sizeMulti.X / 2.55, scale * sizeMulti.Y / 2.55)
		elseif Utils.HasFlags(flags, TearFlags.TEAR_GROW) or Utils.HasFlags(flags, TearFlags.TEAR_LUDOVICO) then
			if scale <= 0.3 then
				return Vector(scale * sizeMulti.X / 0.25, scale * sizeMulti.Y / 0.25)
			elseif scale <= 0.55 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
				return Vector(scale * sizeMulti.X / adjustedBase, scale * sizeMulti.Y / adjustedBase)
			elseif scale <= 1.175 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.125) * 0.125 + 0.175
				return Vector(scale * sizeMulti.X / adjustedBase, scale * sizeMulti.Y / adjustedBase)
			elseif scale <= 2.175 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
				return Vector(scale * sizeMulti.X / adjustedBase, scale * sizeMulti.Y / adjustedBase)
			else
				return Vector(scale * sizeMulti.X / 2.55, scale * sizeMulti.Y / 2.55)
			end
		else
			return sizeMulti
		end
	end

	function PrivateField.GetNormalTearPoofVariant(scale, height)
		if scale > 0.8 then
			if height < -5 then
				return EffectVariant.TEAR_POOF_A
			else
				return EffectVariant.TEAR_POOF_B
			end
		elseif scale > 0.4 then
			return EffectVariant.TEAR_POOF_SMALL
		else
			return EffectVariant.TEAR_POOF_VERYSMALL
		end
	end

	function PrivateField.GetAnimationName(tear)
		local scale = tear.Scale
		local prefix = "Regular"	
		local anim
		if scale <= 0.3 then
			anim = prefix.."Tear1"
		elseif scale <= 0.55 then
			anim = prefix.."Tear2"
		elseif scale <= 0.675 then
			anim = prefix.."Tear3"
		elseif scale <= 0.8 then
			anim = prefix.."Tear4"
		elseif scale <= 0.925 then
			anim = prefix.."Tear5"
		elseif scale <= 1.05 then
			anim = prefix.."Tear6"
		elseif scale <= 1.175 then
			anim = prefix.."Tear7"
		elseif scale <= 1.425 then
			anim = prefix.."Tear8"
		elseif scale <= 1.675 then
			anim = prefix.."Tear9"
		elseif scale <= 1.925 then
			anim = prefix.."Tear10"
		elseif scale <= 2.175 then
			anim = prefix.."Tear11"
		elseif scale <= 2.55 then
			anim = prefix.."Tear12"
		else
			anim = prefix.."Tear13"
		end
		return anim
	end
end

function StickyBallTear:ApplyStickyLevel(npc, player, rng)
    local data = GetTempEntityLibData(npc)
    if not data then
        data = { Level = 0, HitCooldown = 0, Timeout = 0 }
        SetTempEntityLibData(npc, data)
    end
	if data.HitCooldown > 0 then
		return
	end
	SetTempEntityLibData(npc, 15, "HitCooldown")	
    local level = data.Level
    if level > 5 then
		return
    end
	if rng:RandomInt(100) < 50 then
		if level == 0 then
			local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 1 then
			local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 2 then
			local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 3 then
			local squirt = Entities.Spawn(ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Type, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Variant, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 4 then
			local squirt = Entities.Spawn(ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.Type, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.Variant, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		else
			local squirt = Entities.Spawn(ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.Type, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.Variant, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
	SetTempEntityLibData(npc, level + 1, "Level")
	local cooldown = npc:GetBossStatusEffectCooldown()
	if npc:IsBoss() and cooldown > 0 then
		npc:SetBossStatusEffectCooldown(0)
	end
	npc:AddSlowing(EntityRef(player), math.max(0, 150 - npc:GetSlowingCountdown()), 0.75, Color(1, 1, 1, 1))
	npc:SetBossStatusEffectCooldown(cooldown)
	SetTempEntityLibData(npc, 150, "Timeout")
end

function StickyBallTear:PostTearRender(tear, offset)
    if not tear:HasTearFlags(ModTearFlags.TEAR_STICKYBALL) then
        return
    end
    local data = GetTempEntityLibData(tear)
    if not data then
        data = { Sprite = Sprite("gfx/projectiles/sticky_ball_tear.anm2", true), LastRenderFrame = 0 }
        SetTempEntityLibData(tear, data)
    end    
	local sprite = data.Sprite
	local tearSprite = tear:GetSprite()
	local anim = PrivateField.GetAnimationName(tear)
	sprite.PlaybackSpeed = tearSprite.PlaybackSpeed
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	elseif not TYU.GAME:IsPaused() and Isaac.GetFrameCount() % 2 == 0 and data.LastRenderFrame ~= Isaac.GetFrameCount() then
		sprite:Update()
	end
	sprite.Scale = PrivateField.GetTearScale(tear)
	local adjustedVelocity = tear.Velocity
    local flags = tear.TearFlags
	if tear.FallingSpeed < 0 or (tear.FallingSpeed > 0.2 and Utils.HasFlags(flags, TearFlags.TEAR_LUDOVICO, true) and ((Utils.HasFlags(flags, TearFlags.TEAR_ABSORB, true) and Utils.HasFlags(flags, TearFlags.TEAR_POP, true)) or tear.Velocity:Length() <= 0.1)) then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end	
	sprite.Rotation = adjustedVelocity:GetAngleDegrees() + 90
	sprite.FlipX = false
	sprite.FlipY = false
	sprite.Color = tearSprite.Color
    sprite:Render(Isaac.WorldToRenderPosition(tear.Position + tear.PositionOffset) + offset)
	data.LastRenderFrame = Isaac.GetFrameCount()
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, StickyBallTear.PostTearRender, ModEntityIDs.STICKY_BALL_TEAR.Variant)

function StickyBallTear:PostTearDeath(tear)
    if not tear:HasTearFlags(ModTearFlags.TEAR_STICKYBALL) then
        return
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEAT_JUMPS, 0.6, 0, false, 1.2)
	if tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE) then
        return
    end
	local scale = tear.Scale
	local color = tear:GetSprite().Color
    local poof = Entities.Spawn(EntityType.ENTITY_EFFECT, PrivateField.GetNormalTearPoofVariant(tear.Scale, tear.Height), 0, tear.Position, Vector(0, 0), tear)
    poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/sticky_ball_tearpoof.png", true)
    poof:GetSprite().Color = color
    if scale > 0.8 then
        poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
    end
    poof.PositionOffset = tear.PositionOffset
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, StickyBallTear.PostTearDeath)

function StickyBallTear:PostTearCollision(tear, collider, low)
    if not tear:HasTearFlags(ModTearFlags.TEAR_STICKYBALL) or not Entities.IsValidEnemy(collider) then
        return
    end
	local npc = collider:ToNPC()
	local player = Utils.GetPlayerFromTear(tear)
	StickyBallTear:ApplyStickyLevel(npc, player, tear:GetDropRNG())
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, StickyBallTear.PostTearCollision)

return StickyBallTear