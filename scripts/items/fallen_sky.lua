local Lib = TYU
local FallenSky = Lib:NewModItem("Fallen Sky", "FALLEN_SKY")

local chainSprite = Sprite("gfx/effects/fallen_sky_chain.anm2", true)
chainSprite:Play("Idle", true)

local function ValidatePossibility(player, rng, multiplier)
    rng = rng or player:GetCollectibleRNG(Lib.ModItemIDs.FALLEN_SKY)
    multiplier = multiplier or 1
    return rng:RandomFloat() < multiplier / math.max(2, 10 - math.floor(player.Luck / 2))
end

local function ReplaceFetusSprite(tear, player)
    local tearSprite = tear:GetSprite()
    local playerType = player:GetPlayerType()
    local path = nil
    if tear.Variant == TearVariant.SWORD_BEAM then
        path = "gfx/effects/fallen_sky_sword_effect.png"
    elseif tear.Variant == TearVariant.FETUS then
        if playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
            path = "gfx/effects/fetus_tears_forgotten.png"
        elseif playerType == PlayerType.PLAYER_BLACKJUDAS then
            path = "gfx/effects/fetus_tears_shadow.png"
        else
            local color = player:GetBodyColor()
            if color == SkinColor.SKIN_PINK then
                path = "gfx/effects/fetus_tears.png"
            elseif color == SkinColor.SKIN_WHITE then
                path = "gfx/effects/fetus_tears_white.png"
            elseif color == SkinColor.SKIN_BLACK then
                path = "gfx/effects/fetus_tears_black.png"
            elseif color == SkinColor.SKIN_BLUE then
                path = "gfx/effects/fetus_tears_blue.png"
            elseif color == SkinColor.SKIN_RED then
                path = "gfx/effects/fetus_tears_red.png"
            elseif color == SkinColor.SKIN_GREEN then
                path = "gfx/effects/fetus_tears_green.png"
            elseif color == SkinColor.SKIN_GREY then
                path = "gfx/effects/fetus_tears_grey.png"
            end
        end
    end
    if path then
        tearSprite:ReplaceSpritesheet(0, path, true)
    end
end

local function SpawnASword(entity, player, multiplier)
    local sword = Lib.Entities.Spawn(Lib.ModEntityIDs.FALLEN_SKY_SWORD.Type, Lib.ModEntityIDs.FALLEN_SKY_SWORD.Variant, Lib.ModEntityIDs.FALLEN_SKY_SWORD.SubType, entity.Position - Vector(0, 500), Vector(0, 0), player):ToEffect()
    local swordSprite = sword:GetSprite()
    local randomNumber = sword:GetDropRNG():RandomFloat()
    if randomNumber < 1 / 3 then
        swordSprite:ReplaceSpritesheet(0, "gfx/effects/fallen_sky_sword_alt.png", true)
    elseif randomNumber >= 1 / 3 and randomNumber < 2 / 3 then
        swordSprite:ReplaceSpritesheet(0, "gfx/effects/fallen_sky_sword_alt_2.png", true)
    end
    sword.DepthOffset = entity.DepthOffset + 1
    swordSprite:Play("Fall", true)
    swordSprite.PlaybackSpeed = 1.5
    local swordData = { Player = player, Target = entity, Position = 500, Multiplier = multiplier or 1, Delay = 0 }
    Lib:SetTempEntityLibData(sword, swordData, "Data")
end

local function SpawnAGroupOfFallenSwords(entity, player)
    local room = Lib.GAME:GetRoom()
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.FALLEN_SKY)
    local times = rng:RandomInt(4, 12)
    for i = 0, times - 1 do
        local sword = Lib.Entities.Spawn(Lib.ModEntityIDs.FALLEN_SKY_SWORD.Type, Lib.ModEntityIDs.FALLEN_SKY_SWORD.Variant, Lib.ModEntityIDs.FALLEN_SKY_SWORD.SubType, room:GetClampedPosition(entity.Position + rng:RandomVector() * rng:RandomInt(60), 16) - Vector(0, 500), Vector(0, 0), player):ToEffect()
        local swordSprite = sword:GetSprite()
        local randomNumber = rng:RandomFloat()
        if randomNumber < 1 / 3 then
            swordSprite:ReplaceSpritesheet(0, "gfx/effects/fallen_sky_sword_alt.png", true)
        elseif randomNumber >= 1 / 3 and randomNumber < 2 / 3 then
            swordSprite:ReplaceSpritesheet(0, "gfx/effects/fallen_sky_sword_alt_2.png", true)
        end
        swordSprite:Play("Fall", true)
        swordSprite.PlaybackSpeed = 0
        sword.DepthOffset = entity.DepthOffset + 1
        local swordData = { Player = player, Target = entity, Position = 500, Multiplier = 0.5, Group = true, Delay = i * 2 }
        Lib:SetTempEntityLibData(sword, swordData, "Data")
    end
end

local function GetChainedEnemies(origin)
    local enemies = {}
    local room = Lib.GAME:GetRoom()
    for _, entity in pairs(Isaac.FindInRadius(room:GetCenterPos(), 8192, EntityPartition.ENEMY)) do
        local data = Lib:GetTempEntityLibData(entity, "FallenSky")
        if data and data.Parent and data.Parent:ToNPC() and GetPtrHash(data.Parent) == GetPtrHash(origin) then
            table.insert(enemies, entity)
        end
    end
    return enemies
end

function FallenSky:PostFireTear(tear)
    local player = Lib.Utils.GetPlayerFromTear(tear)
    if not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) then
        return
    end
    if ValidatePossibility(player) then
        local newTear = Lib.Entities.Spawn(EntityType.ENTITY_TEAR, (tear.Variant == TearVariant.FETUS and TearVariant.FETUS) or TearVariant.SWORD_BEAM, 0, tear.Position - Vector(0, 16), tear.Velocity, tear.SpawnerEntity):ToTear()
        if newTear.Variant == TearVariant.FETUS then
            ReplaceFetusSprite(newTear, player)
        end
        newTear:AddTearFlags(tear.TearFlags | TearFlags.TEAR_HOMING | Lib.ModTearFlags.TEAR_FALLENSKY)
        newTear.FallingSpeed = tear.FallingSpeed
        newTear.FallingAcceleration = tear.FallingAcceleration
        newTear.ContinueVelocity = tear.ContinueVelocity
        newTear.Height = tear.Height
        newTear.CollisionDamage = tear.CollisionDamage
        newTear.Scale = tear.BaseScale
        newTear.KnockbackMultiplier = tear.KnockbackMultiplier
        newTear.HomingFriction = tear.HomingFriction
        newTear.CanTriggerStreakEnd = tear.CanTriggerStreakEnd
        Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, newTear.Position + Vector(0, 20)):GetSprite().PlaybackSpeed = 1.5
        tear:Remove()
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, FallenSky.PostFireTear)

function FallenSky:PostTearCollision(tear, collider, low)
    local player = Lib.Utils.GetPlayerFromTear(tear)
    if not player then
        return
    end
    if player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) and tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
        tear:AddTearFlags(Lib.ModTearFlags.TEAR_FALLENSKY)
    end
    if not tear:HasTearFlags(Lib.ModTearFlags.TEAR_FALLENSKY) or not Lib.Entities.IsValidEnemy(collider) then
        return
    end
    if tear.Variant == TearVariant.FETUS and tear.FrameCount % 15 ~= 0 then
        return
    end
    if tear:HasTearFlags(TearFlags.TEAR_PIERCING) and tear.FrameCount % 3 ~= 0 then
        return
    end
    if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and tear.FrameCount % 30 ~= 0 then
        return
    end
    if (tear:HasTearFlags(TearFlags.TEAR_STICKY) or tear:HasTearFlags(TearFlags.TEAR_BOOGER) or tear:HasTearFlags(TearFlags.TEAR_SPORE)) and tear.FrameCount % 30 ~= 0 then
        return
    end
    if tear:HasTearFlags(TearFlags.TEAR_BURSTSPLIT) then
        SpawnAGroupOfFallenSwords(collider, player)
    else
        SpawnASword(collider, player, tear.CollisionDamage / player.Damage)
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, FallenSky.PostTearCollision)

function FallenSky:PostNPCRender(npc, offset)
    local data = Lib:GetTempEntityLibData(npc, "FallenSky")
    if not data or data.Timeout > 118 then
        return
    end
    local enemyPos = npc.Position
    local parent = data.Parent
    if parent == nil and #GetChainedEnemies(npc) > 0 then
        chainSprite:RenderLayer(0, Isaac.WorldToScreen(enemyPos))
    end
    if parent and parent:ToNPC() and parent:Exists() then
        local differVector = parent.Position - enemyPos
        local beam = Beam(chainSprite, "chain", false, false)
        beam:Add(Isaac.WorldToScreen(enemyPos), 0)
        beam:Add(Isaac.WorldToScreen(parent.Position), differVector:Length())
        beam:Render()
        chainSprite:RenderLayer(0, Isaac.WorldToScreen(enemyPos))
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, FallenSky.PostNPCRender)

function FallenSky:PostNPCUpdate(npc)
    local data = Lib:GetTempEntityLibData(npc, "FallenSky")
    if not data then
        return
    end
    local player = data.Player
    local parent = data.Parent
    local multiplier = data.Multiplier
    if data.Timeout == 0 then
        if parent then
            SpawnASword(npc, player, multiplier) 
        end
        Lib:SetTempEntityLibData(npc, nil, "FallenSky")
    end
    if npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE or (parent and parent:ToNPC() and (not parent:Exists() or parent.Position:Distance(npc.Position) >= 512 or Lib:GetTempEntityLibData(npc, "FallenSky") == nil)) then
        Lib:SetTempEntityLibData(npc, nil, "FallenSky")
    end
    if data.Timeout > 0 then
        if data.Timeout < 118 then
            npc:AddBurn(EntityRef(player), 2, player.Damage)
        end
        data.Timeout = data.Timeout - 1
    end
end
FallenSky:AddCallback(ModCallbacks.MC_NPC_UPDATE, FallenSky.PostNPCUpdate)

function FallenSky:PostBombUpdate(bomb)
	local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) or bomb:GetExplosionCountdown() > 0 or bomb:GetSprite():GetFrame() == 58 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(bomb.Position, bomb.RadiusMultiplier * player.TearRange / 4, EntityPartition.ENEMY)) do
        if Lib.Entities.IsValidEnemy(enemy) and ValidatePossibility(player, bomb:GetDropRNG(), (bomb.IsFetus and 2.5) or 100) then
            SpawnASword(enemy, player)
        end
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, FallenSky.PostBombUpdate)

function FallenSky:PostRocketEffectUpdate(rocket)
	local player = rocket.SpawnerEntity and rocket.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) or rocket.PositionOffset.Y ~= 0 then
        return
    end
    for _, enemy in pairs(Isaac.FindInRadius(rocket.Position, player.TearRange / 4, EntityPartition.ENEMY)) do
        if Lib.Entities.IsValidEnemy(enemy) and ValidatePossibility(player, rocket:GetDropRNG(), 2.5) then
            SpawnASword(enemy, player)
        end
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FallenSky.PostRocketEffectUpdate, EffectVariant.ROCKET)

function FallenSky:PostLaserCollision(laser, collider, low)
	local player = laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer()
	if not laser.Visible or not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) or not Lib.Entities.IsValidEnemy(collider) or not ValidatePossibility(player, laser:GetDropRNG()) then
        return
    end
    SpawnASword(collider, player, laser.CollisionDamage / player.Damage)
end
FallenSky:AddCallback(ModCallbacks.MC_POST_LASER_COLLISION, FallenSky.PostLaserCollision)

function FallenSky:PostKnifeCollision(knife, collider, low)
	local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
	if not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) or not Lib.Entities.IsValidEnemy(collider) then
        return
    end
    if knife.Variant == KnifeVariant.MOMS_KNIFE or knife.Variant == KnifeVariant.SUMPTORIUM then
        local triggerChance = (knife:IsFlying() and knife:GetKnifeDistance() / knife.MaxDistance < 0.8) and 1 or 0.6
        if ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            SpawnASword(collider, player)
        end
    else
        local triggerChance = knife:GetIsSwinging() and 1 or 0
        if ValidatePossibility(player, knife:GetDropRNG(), triggerChance) then
            SpawnASword(collider, player)
        end
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_KNIFE_COLLISION, FallenSky.PostKnifeCollision)

function FallenSky:PostKnifeInit(knife)
	local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.FALLEN_SKY) or not (knife.Variant ~= KnifeVariant.MOMS_KNIFE and knife.Variant ~= KnifeVariant.SUMPTORIUM and knife.Variant ~= KnifeVariant.BAG_OF_CRAFTING) then
        return
    end
    local knifeSprite = knife:GetSprite()
    local path = nil
    if knife.Variant == KnifeVariant.BONE_CLUB then
        path = "gfx/effects/fallen_sky_bone_club.png"
    elseif knife.Variant == KnifeVariant.BONE_SCYTHE then
        path = "gfx/effects/fallen_sky_bone_scythe.png"
    elseif knife.Variant == KnifeVariant.BERSERK_CLUB then
        path = "gfx/effects/fallen_sky_berserk_club.png"
    elseif knife.Variant == KnifeVariant.NOTCHED_AXE then
        path = "gfx/effects/fallen_sky_notched_axe.png"
    elseif knife.Variant == KnifeVariant.SPIRIT_SWORD then
        path = "gfx/effects/fallen_sky_spirit_sword.png"
    elseif knife.Variant == KnifeVariant.TECH_SWORD then
        path = "gfx/effects/fallen_sky_tech_sword.png"
    end
    if path then
        knifeSprite:ReplaceSpritesheet(0, path, true)
    end
end
FallenSky:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, FallenSky.PostKnifeInit)

return FallenSky