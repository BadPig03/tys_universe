local Lib = TYU
local StickyBallTear = Lib:NewModEntity("Sticky Ball Tear", "STICKYBALLTEAR")

local function GetTearScale13(tear)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti
	local flags = tear.TearFlags
	if scale > 2.55 then
        return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
	elseif flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
		if scale <= 0.3 then
			return Vector((scale * sizeMulti.X) / 0.25, (scale * sizeMulti.Y) / 0.25)
		elseif scale <= 0.55 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 1.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.125) * 0.125 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 2.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		else
			return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
		end
    else
        return sizeMulti
	end
end

local function GetNormalTearPoofVariant(scale, height)
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

function StickyBallTear:PostTearRender(tear, offset)
    if not tear:HasTearFlags(Lib.ModTearFlags.TEAR_STICKYBALL) then
        return
    end
    local data = Lib:GetTempEntityLibData(tear, "CustomTear")
    if not data then
        data = { Sprite = Sprite("gfx/projectiles/sticky_ball_tear.anm2", true), LastRenderFrame = 0 }
        Lib:SetTempEntityLibData(tear, data, "CustomTear")
    end    
	local sprite = data.Sprite
	local tearSprite = tear:GetSprite()
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
	sprite.PlaybackSpeed = tearSprite.PlaybackSpeed
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	elseif not Lib.GAME:IsPaused() and Isaac.GetFrameCount() % 2 == 0 and data.LastRenderFrame ~= Isaac.GetFrameCount() then
		sprite:Update()
	end
	sprite.Scale = GetTearScale13(tear)
	local adjustedVelocity = tear.Velocity
    local flags = tear.TearFlags
	if tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed and flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end	
	sprite.Rotation = adjustedVelocity:GetAngleDegrees() + 90
	sprite.FlipX = false
	sprite.FlipY = false
	sprite.Color = tearSprite.Color
    sprite:Render(Isaac.WorldToRenderPosition(tear.Position + tear.PositionOffset) + offset)
	data.LastRenderFrame = Isaac.GetFrameCount()
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, StickyBallTear.PostTearRender, Lib.ModEntityIDs.STICKYBALLTEAR.Variant)

function StickyBallTear:PostTearDeath(tear)
    if not tear:HasTearFlags(Lib.ModTearFlags.TEAR_STICKYBALL) then
        return
    end
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEAT_JUMPS, 0.6, 0, false, 1.2)
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
        return
    end
	local scale = tear.Scale
	local color = tear:GetSprite().Color
    local poof = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, GetNormalTearPoofVariant(tear.Scale, tear.Height), 0, tear.Position, Vector(0, 0), tear)
    poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/sticky_ball_tearpoof.png", true)
    poof:GetSprite().Color = color
    if scale > 0.8 then
        poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
    end
    poof.PositionOffset = tear.PositionOffset
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, StickyBallTear.PostTearDeath)

function StickyBallTear:ApplyStickyLevel(npc, player, rng)
    local data = Lib:GetTempEntityLibData(npc, "StickyBall")
    if not data then
        data = { Level = 0, HitCooldown = 0, Timeout = 0 }
        Lib:SetTempEntityLibData(npc, data, "StickyBall")
    end
	if data.HitCooldown > 0 then
		return
	end
	Lib:SetTempEntityLibData(npc, 15, "StickyBall", "HitCooldown")	
    local level = data.Level
    if level > 5 then
		return
    end
	if rng:RandomInt(100) < 50 then
		if level == 0 then
			local dip = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLDIPLEVEL1.Type, Lib.ModEntityIDs.STICKYBALLDIPLEVEL1.Variant, Lib.ModEntityIDs.STICKYBALLDIPLEVEL1.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 1 then
			local dip = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLDIPLEVEL2.Type, Lib.ModEntityIDs.STICKYBALLDIPLEVEL2.Variant, Lib.ModEntityIDs.STICKYBALLDIPLEVEL2.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 2 then
			local dip = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLDIPLEVEL3.Type, Lib.ModEntityIDs.STICKYBALLDIPLEVEL3.Variant, Lib.ModEntityIDs.STICKYBALLDIPLEVEL3.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 3 then
			local squirt = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL1.Type, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL1.Variant, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL1.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		elseif level == 4 then
			local squirt = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL2.Type, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL2.Variant, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL2.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		else
			local squirt = Lib.Entities.Spawn(Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL3.Type, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL3.Variant, Lib.ModEntityIDs.STICKYBALLSQUIRTLEVEL3.SubType, npc.Position, Vector(0, 0), player):ToNPC()
			squirt:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
	Lib:SetTempEntityLibData(npc, level + 1, "StickyBall", "Level")
	local cooldown = npc:GetBossStatusEffectCooldown()
	if npc:IsBoss() and cooldown > 0 then
		npc:SetBossStatusEffectCooldown(0)
	end
	npc:AddSlowing(EntityRef(player), math.max(0, 150 - npc:GetSlowingCountdown()), 0.75, Color(1, 1, 1, 1))
	npc:SetBossStatusEffectCooldown(cooldown)
	Lib:SetTempEntityLibData(npc, 150, "StickyBall", "Timeout")
end

function StickyBallTear:PostTearCollision(tear, collider, low)
    if not tear:HasTearFlags(Lib.ModTearFlags.TEAR_STICKYBALL) or not Lib.Entities.IsValidEnemy(collider) then
        return
    end
	local npc = collider:ToNPC()
	local player = Lib.Entities.GetPlayerFromTear(tear)
	StickyBallTear:ApplyStickyLevel(npc, player, tear:GetDropRNG())
end
StickyBallTear:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, StickyBallTear.PostTearCollision)

return StickyBallTear