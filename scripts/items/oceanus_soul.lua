local Lib = TYU
local OceanusSoul = Lib:NewModItem("Oceanus' Soul", "OCEANUS_SOUL")

local stopFlushSound = false

local function SpawnChargeBar(player)
    local chargeBar = Lib.Entities.Spawn(Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Type, Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Variant, Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.SubType, player.Position + Lib.Players.GetChargeBarPosition(player, 3), player.Velocity, player):ToEffect()
    chargeBar.Parent = player
    chargeBar:FollowParent(player)
    chargeBar.DepthOffset = 103
    chargeBar:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | Lib.ModEntityFlags.FLAG_NO_PAUSE)
    local sprite = chargeBar:GetSprite()
    sprite:Play("Charging", true)
    for i = 1, 6 do
        sprite:Update()
    end
    sprite.PlaybackSpeed = Lib.Constants.CHARGEBAR_PLAYBACKRATE
end

local function GetChargerBar(player)
    for _, effect in pairs(Isaac.FindByType(Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Type, Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Variant, Lib.ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.SubType)) do
        if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
            return effect:ToEffect()
        end
    end
    return nil
end

local function DisappearChargeBar(chargeBar, player)
    local sprite = chargeBar:GetSprite()
    if not sprite:IsPlaying("Disappear") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Disappear", true)
    end
    if player and sprite:IsPlaying("Disappear") then
        Lib.Utils.CreateTimer(function() chargeBar.Visible = false SpawnChargeBar(player) end, 4, 0, false)
    end
end

local function IsWateryStage()
    local stage = Lib.LEVEL:GetStage()
    local stageType = Lib.LEVEL:GetStageType()
    if (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2) and stageType >= StageType.STAGETYPE_REPENTANCE then
        return true
    end
    return false
end

local function IsInvalidRoom()
    local room = Lib.GAME:GetRoom()
    local roomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    if room:GetType() == RoomType.ROOM_DUNGEON or roomIndex == GridRooms.ROOM_DUNGEON_IDX or roomIndex == GridRooms.ROOM_GIDEON_DUNGEON_IDX or roomIndex == GridRooms.ROOM_ROTGUT_DUNGEON1_IDX or roomIndex == GridRooms.ROOM_ROTGUT_DUNGEON2_IDX then
        return true
    end
    return false
end

local function SpawnWaterCurrent(player)
    local room = Lib.GAME:GetRoom()
    Lib:SetTempEntityLibData(player, { FullyCharged = false, ChargeTime = 0 }, "OceanusSoul")
    local timeout = Lib:GetGlobalLibData("OceanusSoul", "Timeout") or 0
    local addTime = math.floor(50 * math.sqrt(100 / (player.MaxFireDelay + 1)))
    Lib:SetGlobalLibData(timeout + addTime, "OceanusSoul", "Timeout")
    Lib:SetGlobalLibData(Vector.FromAngle(player:GetLastDirection():GetAngleDegrees()), "OceanusSoul", "Direction")
    Lib.GAME:ShakeScreen(15)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.75)
    room:SetWaterColorMultiplier(KColor(1, 1, 1, 1))
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
        for i = 0, room:GetGridSize() - 1 do
            local gridEntity = room:GetGridEntity(i)
            if gridEntity and not gridEntity:ToDoor() then
                gridEntity:Destroy(false)
            end
        end
    end
    for _, ent in pairs(Isaac.FindInRadius(player.Position, 8192, EntityPartition.ENEMY)) do
        local npc = ent:ToNPC()
        if npc and Lib.Entities.IsValidEnemyEvenInvicible(npc) then
            npc:AddConfusion(EntityRef(player), 60, false)
        end
    end
end

local function AddStatueEffects(npc, player)
    local tearFlags = player.TearFlags
    local ref = EntityRef(player)
    local id = -1
    if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
        id = player:GetCollectibleRNG(Lib.ModItemIDs.OCEANUS_SOUL):RandomInt(1, 12)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) or id == 1 then
        npc:AddBurn(ref, 30, player.Damage)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) or id == 2 then
        npc:AddCharmed(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_IRON_BAR) or player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) or id == 3 then
        npc:AddConfusion(ref, 30, false)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_PERFUME) or player:HasCollectible(CollectibleType.COLLECTIBLE_ABADDON) or player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_MATTER) or id == 4 then
        npc:AddFear(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_CONTACTS) or id == 5 then
        npc:AddFreeze(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) or player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) or id == 6 then
        npc:AddPoison(ref, 30, player.Damage)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIDER_BITE) or player:HasCollectible(CollectibleType.COLLECTIBLE_BALL_OF_TAR) or id == 7 then
        npc:AddSlowing(ref, 30, 0.75, Lib.Colors.SLOWING)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BACKSTABBER) or id == 8 then
        npc:AddBleeding(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) or id == 9 then
        npc:AddSlowing(ref, 30, 0.6, Lib.Colors.SLOWING)
        npc:AddIce(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_GODS_FLESH) or id == 10 then
        npc:AddShrink(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) or id == 11 then
        npc:AddBaited(ref, 30)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LODESTONE) or id == 12 then
        npc:AddMagnetized(ref, 30)
    end
end

function OceanusSoul:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) then
		return
    end
    player.CanFly = true
end
OceanusSoul:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, OceanusSoul.EvaluateCache, CacheFlag.CACHE_FLYING)

function OceanusSoul:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) then
		return
    end
    local chargeBar = GetChargerBar(player)
    local chargeTime = Lib:GetTempEntityLibData(player, "OceanusSoul", "ChargeTime") or 0
    if chargeBar and IsInvalidRoom() then
        DisappearChargeBar(chargeBar)
        return
    end
    if IsInvalidRoom() then
        return
    end
    if player:GetMarkedTarget() or player:GetPeeBurstCooldown() > 0 or (IsWateryStage() and not Lib.GAME:GetRoom():IsClear()) then
        if chargeBar and ((chargeBar:GetSprite():IsPlaying("StartCharged") and chargeBar:GetSprite():GetFrame() >= 1) or (chargeBar:GetSprite():IsPlaying("Charged"))) then
            SpawnWaterCurrent(player)
            DisappearChargeBar(chargeBar, player)
        end
        if not chargeBar and chargeTime > 7 then
            SpawnChargeBar(player)
        end
        Lib:SetTempEntityLibData(player, chargeTime + 1, "OceanusSoul", "ChargeTime")
    else
        if Lib.Players.IsPressingFiringButton(player) then
            if not chargeBar and chargeTime > 7 then
                SpawnChargeBar(player)
            end
            Lib:SetTempEntityLibData(player, chargeTime + 1, "OceanusSoul", "ChargeTime")
        elseif chargeBar then
            if Lib:GetTempEntityLibData(player, "OceanusSoul", "FullyCharged") then
                SpawnWaterCurrent(player)
            end
            DisappearChargeBar(chargeBar)
        else
            Lib:SetTempEntityLibData(player, 0, "OceanusSoul", "ChargeTime")
        end    
    end
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, OceanusSoul.PostPlayerUpdate, 0)

function OceanusSoul:PostNewRoom()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) then
        return
    end
    Lib:SetGlobalLibData(0, "OceanusSoul", "Timeout")
    if IsInvalidRoom() then
        return
    end
    local room = Lib.GAME:GetRoom()
    room:SetWaterAmount(1 / 100)
    room:SetWaterCurrent(Vector(1 / 10000, 0))
    local currentRoomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    local roomDesc = Lib.LEVEL:GetRoomByIdx(currentRoomIndex)
    if room:IsFirstVisit() and roomDesc.HasWater then
        roomDesc.HasWater = false
        Lib.GAME:ChangeRoom(currentRoomIndex)
    end
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OceanusSoul.PostNewRoom)

function OceanusSoul:PostUpdate()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) then
        return
    end
    local room = Lib.GAME:GetRoom()
    local timeout = Lib:GetGlobalLibData("OceanusSoul", "Timeout") or 0
    local direction = Lib:GetGlobalLibData("OceanusSoul", "Direction") or Vector(0, 1)
    local waterAmount = room:GetWaterAmount()
    local player = PlayerManager.FirstCollectibleOwner(Lib.ModItemIDs.OCEANUS_SOUL)
    if timeout > 0 then
        if waterAmount < 1 then
            room:SetWaterAmount(math.min(1, waterAmount + 1 / 10))
        end
        Lib:SetGlobalLibData(timeout - 1, "OceanusSoul", "Timeout")
    else
        if waterAmount > 0 then
            room:SetWaterAmount(math.max(1 / 100, waterAmount - 1 / 10))
        end
    end
    if waterAmount > 1 / 100 then
        local frame = room:GetFrameCount()
        for _, ent in pairs(Isaac.FindInRadius(player.Position, 8192, EntityPartition.ENEMY)) do
            local npc = ent:ToNPC()
            if npc and Lib.Entities.IsValidEnemyEvenInvicible(npc) then
                if Lib.Entities.IsFireRelatedEnemy(npc) then
                    npc:Die()
                end
                if room:IsPositionInRoom(npc.Position, 0) then
                    npc:AddVelocity(room:GetWaterCurrent() * 2.56)
                end
                if frame % 60 == 30 then
                    AddStatueEffects(npc, player)
                end
                if frame % 30 == 15 then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) then
                        player:SpawnAquariusCreep().Position = npc.Position
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
                        Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, npc.Position, Vector(0, 0), player)
                    end
                end
                if frame % 4 == 2 then
                    if npc:CollidesWithGrid() or Lib.Entities.IsStationaryEnemy(npc) then
                        npc:TakeDamage((player.Damage + 12 + 2 * (Lib.LEVEL:GetStage() - 1)) / 3, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
                    end
                    if Lib.Entities.IsForcedMovingEnemy(npc) then
                        npc:AddWeakness(EntityRef(player), 6)
                        if not room:IsPositionInRoom(npc.Position, 0) then
                            npc:TakeDamage((player.Damage + 12 + 2 * (Lib.LEVEL:GetStage() - 1)) / 3, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
                        end
                    end
                end
            end
        end
    end
    if Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
        local color = Lib.RainbowColors[room:GetFrameCount() // 2 % 30 + 1]
        local kColor = KColor(color[1], color[2], color[3], 2 / 3)
        room:SetWaterColor(kColor)
    else
        local colorize = player:GetLaserColor():GetColorize()
        local sum = math.abs(colorize.R) + math.abs(colorize.G) + math.abs(colorize.B)
        room:SetWaterColor(KColor(math.max(0, colorize.R / sum), math.max(0, colorize.G / sum), math.max(0, colorize.B / sum), 1 / 2))
    end
    room:SetWaterCurrent(direction:Normalized():Resized(waterAmount ^ 2))
    Lib.SFXMANAGER:AdjustVolume(SoundEffect.SOUND_WATER_FLOW_LARGE, 0)
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_UPDATE, OceanusSoul.PostUpdate)

function OceanusSoul:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    local room = Lib.GAME:GetRoom()
    room:SetWaterAmount(1 / 100)
    room:SetWaterCurrent(Vector(1 / 10000, 0))
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, player.Position).DepthOffset = 9999
    Lib.GAME:ShakeScreen(15)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.8)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_BERSERK_END, 0.8, 2, false, 1.2, 0)
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, OceanusSoul.PostAddCollectible, Lib.ModItemIDs.OCEANUS_SOUL)

function OceanusSoul:PreSFXPlay(id, volume, frameDelay, loop, pitch, pan)
	if stopFlushSound and id == SoundEffect.SOUND_FLUSH then
        stopFlushSound = false
        return false
    end
    if Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.OCEANUS_SOUL) and id == SoundEffect.SOUND_WATER_FLOW_LARGE then
        return false
    end
end
OceanusSoul:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, OceanusSoul.PreSFXPlay)

return OceanusSoul