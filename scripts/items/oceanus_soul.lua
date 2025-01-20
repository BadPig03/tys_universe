local OceanusSoul = TYU:NewModItem("Oceanus' Soul", "OCEANUS_SOUL")

local Constants = TYU.Constants
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModEntityFlags = TYU.ModEntityFlags
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "OceanusSoul", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "OceanusSoul", ...)
end

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "OceanusSoul", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("OceanusSoul", ...)
end

do
    PrivateField.StopFlushSound = false

    PrivateField.RainbowColors = {
        {1 / 12, 5 / 6, 1 / 12},
        {5 / 69, 50 / 69, 14 / 69},
        {5 / 78, 25 / 39, 23 / 78},
        {5 / 87, 50 / 87, 32 / 87},
        {5 / 96, 25 / 48, 41 / 96},
        {1 / 21, 10 / 21, 10 / 21},
        {5 / 96, 41 / 96, 25 / 48},
        {5 / 87, 32 / 87, 50 / 87},
        {5 / 78, 23 / 78, 25 / 39},
        {5 / 69, 14 / 69, 50 / 69},
        {1 / 12, 1 / 12, 5 / 6},
        {14 / 69, 5 / 69, 50 / 69},
        {23 / 78, 5 / 78, 25 / 39},
        {32 / 87, 5 / 87, 50 / 87},
        {41 / 96, 5 / 96, 25 / 48},
        {10 / 21, 1 / 21, 10 / 21},
        {25 / 48, 5 / 96, 41 / 96},
        {50 / 87, 5 / 87, 32 / 87},
        {25 / 39, 5 / 78, 23 / 78},
        {50 / 69, 5 / 69, 14 / 69},
        {5 / 6, 1 / 12, 1 / 12},
        {50 / 69, 14 / 69, 5 / 69},
        {25 / 39, 23 / 78, 5 / 78},
        {50 / 87, 32 / 87, 5 / 87},
        {25 / 48, 41 / 96, 5 / 96},
        {10 / 21, 10 / 21, 1 / 21},
        {41 / 96, 25 / 48, 5 / 96},
        {32 / 87, 50 / 87, 5 / 87},
        {23 / 78, 25 / 39, 5 / 78},
        {14 / 69, 50 / 69, 5 / 69}
    }

    function PrivateField.SpawnChargeBar(player)
        local chargeBar = Entities.Spawn(ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Type, ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Variant, ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.SubType, player.Position + Players.GetChargeBarPosition(player, 3), player.Velocity, player):ToEffect()
        chargeBar.Parent = player
        chargeBar:FollowParent(player)
        chargeBar.DepthOffset = 103
        chargeBar:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | ModEntityFlags.FLAG_NO_PAUSE)
        local sprite = chargeBar:GetSprite()
        sprite:Play("Charging", true)
        for i = 1, 6 do
            sprite:Update()
        end
        sprite.PlaybackSpeed = Constants.CHARGEBAR_PLAYBACKRATE
    end
    
    function PrivateField.GetChargerBar(player)
        for _, effect in pairs(Isaac.FindByType(ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Type, ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.Variant, ModEntityIDs.OCEANUS_SOUL_CHARGEBAR.SubType)) do
            if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
                return effect:ToEffect()
            end
        end
        return nil
    end
    
    function PrivateField.DisappearChargeBar(chargeBar, player)
        local sprite = chargeBar:GetSprite()
        if not sprite:IsPlaying("Disappear") then
            sprite.PlaybackSpeed = 1
            sprite:Play("Disappear", true)
        end
        if not player or not sprite:IsPlaying("Disappear") then
            return
        end
        Utils.CreateTimer(function()
            chargeBar.Visible = false
            PrivateField.SpawnChargeBar(player)
        end, 4, 0, false)
    end
    
    function PrivateField.IsStageHasWater()
        local stage = TYU.LEVEL:GetStage()
        local stageType = TYU.LEVEL:GetStageType()
        if (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2) and stageType >= StageType.STAGETYPE_REPENTANCE then
            return true
        end
        return false
    end

    function PrivateField.IsInvalid()
        if Utils.IsRoomType(RoomType.ROOM_DUNGEON) or Utils.IsRoomIndex(GridRooms.ROOM_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_GIDEON_DUNGEON_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON1_IDX) or Utils.IsRoomIndex(GridRooms.ROOM_ROTGUT_DUNGEON2_IDX) then
            return true
        end
        return false
    end

    function PrivateField.DestroyAllRocks()
        local room = TYU.GAME:GetRoom()
        for i = 0, room:GetGridSize() - 1 do
            local gridEntity = room:GetGridEntity(i)
            if gridEntity and not gridEntity:ToDoor() then
                gridEntity:Destroy(false)
            end
        end
    end

    function PrivateField.IsValidEnemyEvenInvicible(enemy)
        return enemy and enemy:ToNPC() and enemy:IsActiveEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM)
    end

    function PrivateField.SpawnWaterCurrent(player)
        SetTempEntityLibData(player, { FullyCharged = false, ChargeTime = 0 })
        local timeout = GetGlobalLibData("Timeout") or 0
        local addTime = math.floor(50 * math.sqrt(100 / (player.MaxFireDelay + 1)))
        SetGlobalLibData(timeout + addTime, "Timeout")
        SetGlobalLibData(Vector.FromAngle(player:GetLastDirection():GetAngleDegrees()), "Direction")
        TYU.GAME:ShakeScreen(15)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.75)
        local room = TYU.GAME:GetRoom()
        room:SetWaterColorMultiplier(KColor(1, 1, 1, 1))
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
            PrivateField.DestroyAllRocks()
        end
        for _, ent in pairs(Isaac.FindInRadius(player.Position, 8192, EntityPartition.ENEMY)) do
            local npc = ent:ToNPC()
            if npc and PrivateField.IsValidEnemyEvenInvicible(npc) then
                npc:AddConfusion(EntityRef(player), 60, false)
            end
        end
    end

    function PrivateField.AddStatueEffects(npc, player)
        local tearFlags = player.TearFlags
        local ref = EntityRef(player)
        local id = -1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
            id = player:GetCollectibleRNG(ModItemIDs.OCEANUS_SOUL):RandomInt(1, 12)
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
            npc:AddSlowing(ref, 30, 0.75, Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863))
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BACKSTABBER) or id == 8 then
            npc:AddBleeding(ref, 30)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) or id == 9 then
            npc:AddSlowing(ref, 30, 0.6, Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863))
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
end

function OceanusSoul:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(ModItemIDs.OCEANUS_SOUL) then
		return
    end
    player.CanFly = true
end
OceanusSoul:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, OceanusSoul.EvaluateCache, CacheFlag.CACHE_FLYING)

function OceanusSoul:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.OCEANUS_SOUL) then
		return
    end
    local chargeBar = PrivateField.GetChargerBar(player)
    local chargeTime = GetTempEntityLibData(player, "ChargeTime") or 0
    if PrivateField.IsInvalid() then
        if chargeBar then
            PrivateField.DisappearChargeBar(chargeBar)
        end
        return
    end
    if player:GetMarkedTarget() or player:GetPeeBurstCooldown() > 0 or (PrivateField.IsStageHasWater() and not Utils.IsRoomClear()) then
        if chargeBar and ((chargeBar:GetSprite():IsPlaying("StartCharged") and chargeBar:GetSprite():GetFrame() >= 1) or (chargeBar:GetSprite():IsPlaying("Charged"))) then
            PrivateField.SpawnWaterCurrent(player)
            PrivateField.DisappearChargeBar(chargeBar, player)
        end
        if not chargeBar and chargeTime > 7 then
            PrivateField.SpawnChargeBar(player)
        end
        SetTempEntityLibData(player, chargeTime + 1, "ChargeTime")
    else
        if Players.IsPressingFiringButton(player) then
            if not chargeBar and chargeTime > 7 then
                PrivateField.SpawnChargeBar(player)
            end
            SetTempEntityLibData(player, chargeTime + 1, "ChargeTime")
        elseif chargeBar then
            if GetTempEntityLibData(player, "FullyCharged") then
                PrivateField.SpawnWaterCurrent(player)
            end
            PrivateField.DisappearChargeBar(chargeBar)
        else
            SetTempEntityLibData(player, 0, "ChargeTime")
        end    
    end
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, OceanusSoul.PostPlayerUpdate, 0)

function OceanusSoul:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.OCEANUS_SOUL) then
        return
    end
    SetGlobalLibData(0, "Timeout")
    if PrivateField.IsInvalid() then
        return
    end
    local room = TYU.GAME:GetRoom()
    room:SetWaterAmount(1 / 100)
    room:SetWaterCurrent(Vector(1 / 10000, 0))
    local currentRoomIndex = TYU.LEVEL:GetCurrentRoomIndex()
    local roomDesc = TYU.LEVEL:GetRoomByIdx(currentRoomIndex)
    if not Utils.IsRoomFirstVisit() or not roomDesc.HasWater then
        return
    end
    roomDesc.HasWater = false
    TYU.GAME:ChangeRoom(currentRoomIndex)
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OceanusSoul.PostNewRoom)

function OceanusSoul:PostUpdate()
    if not Players.AnyoneHasCollectible(ModItemIDs.OCEANUS_SOUL) then
        return
    end
    local timeout = GetGlobalLibData("Timeout") or 0
    local direction = GetGlobalLibData("Direction") or Vector(0, 1)
    local room = TYU.GAME:GetRoom()
    local waterAmount = room:GetWaterAmount()
    local player = PlayerManager.FirstCollectibleOwner(ModItemIDs.OCEANUS_SOUL)
    if timeout > 0 then
        if waterAmount < 1 then
            room:SetWaterAmount(math.min(1, waterAmount + 1 / 10))
        end
        SetGlobalLibData(timeout - 1, "Timeout")
    else
        if waterAmount > 0 then
            room:SetWaterAmount(math.max(1 / 100, waterAmount - 1 / 10))
        end
    end
    if waterAmount > 1 / 100 then
        local frame = room:GetFrameCount()
        for _, ent in pairs(Isaac.FindInRadius(player.Position, 8192, EntityPartition.ENEMY)) do
            local npc = ent:ToNPC()
            if not npc or not PrivateField.IsValidEnemyEvenInvicible(npc) then
                goto continue
            end
            if Entities.IsFireRelatedEnemy(npc) then
                npc:Die()
            end
            if room:IsPositionInRoom(npc.Position, 0) then
                npc:AddVelocity(room:GetWaterCurrent() * 2.56)
            end
            if frame % 60 == 30 then
                PrivateField.AddStatueEffects(npc, player)
            end
            if frame % 30 == 15 then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) then
                    player:SpawnAquariusCreep().Position = npc.Position
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
                    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, npc.Position, Vector(0, 0), player)
                end
            end
            if frame % 4 == 2 then
                if npc:CollidesWithGrid() or Entities.IsStationaryEnemy(npc) then
                    npc:TakeDamage((player.Damage + 12 + 2 * (TYU.LEVEL:GetStage() - 1)) / 3, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
                end
                if Entities.IsForcedMovingEnemy(npc) then
                    npc:AddWeakness(EntityRef(player), 6)
                    if not room:IsPositionInRoom(npc.Position, 0) then
                        npc:TakeDamage((player.Damage + 12 + 2 * (TYU.LEVEL:GetStage() - 1)) / 3, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
                    end
                end
            end
            ::continue::
        end
    end
    if Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
        local color = PrivateField.RainbowColors[room:GetFrameCount() // 2 % 30 + 1]
        local kColor = KColor(color[1], color[2], color[3], 2 / 3)
        room:SetWaterColor(kColor)
    else
        local colorize = player:GetLaserColor():GetColorize()
        local sum = math.abs(colorize.R) + math.abs(colorize.G) + math.abs(colorize.B)
        room:SetWaterColor(KColor(math.max(0, colorize.R / sum), math.max(0, colorize.G / sum), math.max(0, colorize.B / sum), 1 / 2))
    end
    room:SetWaterCurrent(direction:Normalized():Resized(waterAmount ^ 2))
    TYU.SFXMANAGER:AdjustVolume(SoundEffect.SOUND_WATER_FLOW_LARGE, 0)
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_UPDATE, OceanusSoul.PostUpdate)

function OceanusSoul:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    local room = TYU.GAME:GetRoom()
    room:SetWaterAmount(1 / 100)
    room:SetWaterCurrent(Vector(1 / 10000, 0))
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, player.Position).DepthOffset = 9999
    TYU.GAME:ShakeScreen(15)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.8)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_BERSERK_END, 0.8, 2, false, 1.2, 0)
end
OceanusSoul:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, OceanusSoul.PostAddCollectible, ModItemIDs.OCEANUS_SOUL)

function OceanusSoul:PreSFXPlay(id, volume, frameDelay, loop, pitch, pan)
	if PrivateField.StopFlushSound and id == SoundEffect.SOUND_FLUSH then
        PrivateField.StopFlushSound = false
        return false
    end
    if Players.AnyoneHasCollectible(ModItemIDs.OCEANUS_SOUL) and id == SoundEffect.SOUND_WATER_FLOW_LARGE then
        return false
    end
end
OceanusSoul:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, OceanusSoul.PreSFXPlay)

return OceanusSoul