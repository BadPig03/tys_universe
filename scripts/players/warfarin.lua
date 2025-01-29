local Warfarin = TYU:NewModPlayer("Warfarin", false, "WARFARIN")

local Callbacks = TYU.Callbacks
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local SaveAndLoad = TYU.SaveAndLoad
local Rewind = TYU.Rewind
local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs
local ModPlayerIDs = TYU.ModPlayerIDs
local ModGiantBookIDs = TYU.ModGiantBookIDs
local ModNullItemIDs = TYU.ModNullItemIDs
local ModItemIDs = TYU.ModItemIDs
local ModSoundIDs = TYU.ModSoundIDs
local ModRoomIDs = TYU.ModRoomIDs

local PrivateField = {}

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "BloodSample", ...)
end

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "BloodSample", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("WarfarinBlackmarket", ...)
end

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "WarfarinBlackmarket", ...)
end

if CuerLib then
    CuerLib.Players.SetOnlyRedHeartPlayer(ModPlayerIDs.WARFARIN, true)
end

do
    PrivateField.ItemPoolFlag = true
    PrivateField.StopHurtSound = false

    function PrivateField.GetHeartCharge(player, pickup)
        if pickup.SubType == HeartSubType.HEART_SOUL or pickup.SubType == HeartSubType.HEART_BLACK then
            return 2
        elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
            return 1
        end
        return -1
    end

    function PrivateField.IsDarkRoomStartingRoom()
        return TYU.LEVEL:GetAbsoluteStage() == LevelStage.STAGE6 and TYU.LEVEL:GetStageType() == StageType.STAGETYPE_ORIGINAL and Utils.IsStartingRoom()
    end

    function PrivateField.IsSatanicBibleUsedBossRoom()
        return Utils.IsRoomType(RoomType.ROOM_BOSS) and TYU.LEVEL:GetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED)
    end    
end

function Warfarin:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        Stat:AddFlatDamage(player, 0.2 * TYU.GAME:GetDevilRoomDeals())
    elseif cacheFlag == CacheFlag.CACHE_FLYING and effects:HasNullEffect(ModNullItemIDs.WARFARIN_WINGS) and not Utils.HasCurseMist() then
        player.CanFly = true
    elseif effects:HasNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_BURSTSPLIT
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            Stat:AddTearsMultiplier(player, 0.8)
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            Stat:AddSpeedUp(player, 0.15)
        end
    end
end
Warfarin:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Warfarin.EvaluateCache)

function Warfarin:PostFireTear(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player or player:GetPlayerType() ~= ModPlayerIDs.WARFARIN then
        return
    end
    if player:GetEffects():HasNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA) and tear.Variant == TearVariant.BLUE then
        tear:ChangeVariant(TearVariant.BLOOD)
    end
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        return
    end
    local angle = tear.Velocity:GetAngleDegrees()
    if angle == 0 then
        tear.Position = tear.Position + Vector(0, 4)
    elseif angle == 90 then
        tear.Position = tear.Position + Vector(-10, 0)
    elseif angle == 180 then
        tear.Position = tear.Position + Vector(0, -4)
    elseif angle == -90 then
        tear.Position = tear.Position + Vector(10, 0)
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Warfarin.PostFireTear)

function Warfarin:PostPlayerUpdate(player)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    local hearts = player:GetMaxHearts() + player:GetBoneHearts() * 2
    if hearts > 6 and effects:HasNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        effects:RemoveNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA)
        if not GetPlayerLibData(player, "OutTriggered") then
            TYU.ITEMOVERLAY.Show(ModGiantBookIDs.WARFARIN_OUT, 3, player)
            SetPlayerLibData(player, true, "OutTriggered")
        end
    elseif hearts <= 6 and not effects:HasNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        effects:AddNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA)
        if not GetPlayerLibData(player, "InTriggered") then
            TYU.ITEMOVERLAY.Show(ModGiantBookIDs.WARFARIN_IN, 3, player)
            SetPlayerLibData(player, true, "InTriggered")
        end
    end
    local collectible = Collectibles.GetNearestDevilDeal(player.Position, 128)
    local charge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + player:GetBatteryCharge(ActiveSlot.SLOT_POCKET)
    if collectible and Utils.IsRoomClear() then
        if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == ModItemIDs.BLOOD_SAMPLE then
            if player:IsExtraAnimationFinished() then
                player:AnimateCollectible(ModItemIDs.BLOODY_DICE, "UseItem", "PlayerPickup")
            end
            player:SetPocketActiveItem(ModItemIDs.BLOODY_DICE, ActiveSlot.SLOT_POCKET, true)
            player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
        end
    else
        if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == ModItemIDs.BLOODY_DICE then
            if player:IsExtraAnimationFinished() then
                player:AnimateCollectible(ModItemIDs.BLOOD_SAMPLE, "UseItem", "PlayerPickup")
            end
            player:SetPocketActiveItem(ModItemIDs.BLOOD_SAMPLE, ActiveSlot.SLOT_POCKET, true)
            player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
        end
    end
    
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Warfarin.PostPlayerUpdate, 0)

function Warfarin:PostHUDUpdate()
    for _, player in ipairs(Players.GetPlayers(true)) do
        if player:GetPlayerType() == ModPlayerIDs.WARFARIN then
            if PlayerManager.GetEsauJrState(player:GetPlayerIndex()) and player:GetBlackHearts() > 0 then
                player:AddMaxHearts(2)
                player:AddHearts(2)
            end
            if player:GetSoulHearts() > 0 then
                player:AddSoulHearts(-player:GetSoulHearts())
            end
        end
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_HUD_UPDATE, Warfarin.PostHUDUpdate)

function Warfarin:PostPlayerNewRoomTempEffects(player)
    SetPlayerLibData(player, false, "OutTriggered")
    SetPlayerLibData(player, false, "InTriggered")
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Warfarin.PostPlayerNewRoomTempEffects, ModPlayerIDs.WARFARIN)

function Warfarin:PostPickupUpdate(pickup)
    local itemConfig = TYU.ITEMCONFIG:GetCollectible(pickup.SubType)
    if not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) or Utils.IsInDeathCertificate() or Utils.IsRoomIndex(GridRooms.ROOM_GENESIS_IDX) or Utils.IsRoomType(RoomType.ROOM_SHOP) or Utils.IsRoomType(RoomType.ROOM_DUNGEON) or pickup.SubType <= 0 or pickup:GetAlternatePedestal() > 0 or pickup.ShopItemId == -2 or pickup.Touched or itemConfig:HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    if TYU:GetGlobalLibData("WarfarinItems", tostring(pickup.InitSeed)) then
        return
    end
    local isCycled = #pickup:GetCollectibleCycle() > 0
    if pickup.FrameCount >= ((isCycled and 0) or 5) then
        Utils.AddSeedToWarfarinItems(pickup.InitSeed)
        if not pickup:IsShopItem() then
            pickup:MakeShopItem(-2)
            Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(1, 0, 0, 1)    
        end
    else
        if pickup:IsShopItem() then
            Utils.AddSeedToWarfarinItems(pickup.InitSeed)
        end
        for _, effect in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0)) do
            if effect.Position:Distance(pickup.Position) == 0 then
                effect:Remove()
            end
        end
        pickup.Wait = 20
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Warfarin.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

function Warfarin:PostPickupInit(pickup)
    if not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) then
        return
    end
    if pickup.SubType ~= HeartSubType.HEART_BLENDED then
        return
    end
    local rng = pickup:GetDropRNG()
    if rng:RandomInt(100) < 50 then
        Entities.Morph(pickup, nil, nil, HeartSubType.HEART_SOUL, true, true, true, false)
    else
        Entities.Morph(pickup, nil, nil, HeartSubType.HEART_FULL, true, true, true, false)
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Warfarin.PostPickupInit, PickupVariant.PICKUP_HEART)

function Warfarin:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    if type == CollectibleType.COLLECTIBLE_ABADDON and firstTime and player:GetMaxHearts() + player:GetBoneHearts() == 0 then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end
    if type == CollectibleType.COLLECTIBLE_CHARM_VAMPIRE then
        effects:RemoveNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_WINGS).ID, -1)
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_WINGS).ID)
        player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
    end
    if type == CollectibleType.COLLECTIBLE_BLOOD_BAG and firstTime then
        player:AddHearts(99)
    end
    if type == CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT or type == CollectibleType.COLLECTIBLE_DEAD_DOVE then
        effects:RemoveNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_WINGS).ID, -1)
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_WINGS).ID)
    end
    if type == CollectibleType.COLLECTIBLE_MAGIC_8_BALL then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_MAGIC_8_BALL).ID)
    end
    if type == CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_CEREMONIAL_ROBES).ID)
    end
    if type == CollectibleType.COLLECTIBLE_MOMS_WIG then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_MOMS_WIG).ID)
    end
    if type == CollectibleType.COLLECTIBLE_BLACK_CANDLE then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_BLACK_CANDLE).ID)
    end
    if type == CollectibleType.COLLECTIBLE_TAURUS then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_TAURUS).ID)
    end
    if type == CollectibleType.COLLECTIBLE_LEO then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_LEO).ID)
    end
    if type == CollectibleType.COLLECTIBLE_INTRUDER then
        Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_INTRUDER)
    end
    if type == CollectibleType.COLLECTIBLE_TERRA then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_FROZEN_HAIR_3).ID)
    end
    if type == CollectibleType.COLLECTIBLE_JUPITER then
        Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_JUPITER)
    end
    if type == CollectibleType.COLLECTIBLE_URANUS then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_FROZEN_HAIR_4).ID)
    end
    if type == CollectibleType.COLLECTIBLE_CARD_READING then
        effects:AddNullEffect(TYU.ITEMCONFIG:GetCollectible(ModNullItemIDs.WARFARIN_CARD_READING).ID)
    end
    if type == CollectibleType.COLLECTIBLE_C_SECTION then
        Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_C_SECTION)
    end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
end
Warfarin:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Warfarin.PostAddCollectible)

function Warfarin:PlayerGetHeartLimit(player, limit, isKeeper)
    local heartLimit = (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 18) or 12
    if (player:GetMaxHearts() + 2 * player:GetBoneHearts() < heartLimit) or (player:GetBrokenHearts() > (24 - heartLimit) / 2) then
        return
    end
    return heartLimit
end
Warfarin:AddCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, Warfarin.PlayerGetHeartLimit, ModPlayerIDs.WARFARIN)

function Warfarin:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or not player:CanPickSoulHearts() then
        return
    end
    local charge = PrivateField.GetHeartCharge(player, pickup)
    if charge <= 0 then
        return
    end
    Entities.SpawnFakePickupSprite(pickup)
    player:AddSoulHearts(charge)
    return { Collide = true, SkipCollisionEffects = true }
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Warfarin.PrePickupCollision, PickupVariant.PICKUP_HEART)

function Warfarin:PrePlayerAddHearts(player, amount, addHealthType, _)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or amount <= 0 then
        return
    end
    if Utils.HasFlags(addHealthType, AddHealthType.SOUL) or Utils.HasFlags(addHealthType, AddHealthType.BLACK) then
        for i = 1, amount do
            if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_ALABASTER_BOX and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) < 12 then
                player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY, true, false, true)
            elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == CollectibleType.COLLECTIBLE_ALABASTER_BOX and player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) < 12 then
                player:AddActiveCharge(1, ActiveSlot.SLOT_SECONDARY, true, false, true)
            else
                player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET, true, true, true)
            end
        end
        return 0
    elseif player:GetEffects():HasNullEffect(ModNullItemIDs.WARFARIN_HAEMOLACRIA) and Utils.HasFlags(addHealthType, AddHealthType.RED) and not (Rewind.GlowingHourglassUsed and TYU.GAME:GetRoom():GetFrameCount() <= 0) then
        return amount * 2
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, Warfarin.PrePlayerAddHearts)

function Warfarin:PostPlayerRevive(player)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN then
        return
    end
    if player:GetSoulHearts() ~= 1 or player:GetMaxHearts() + player:GetBoneHearts() ~= 0 then
        return
    end
    player:AddSoulHearts(-1)
    player:AddMaxHearts(2)
    player:AddHearts(2)
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, Warfarin.PostPlayerRevive)

function Warfarin:PostPickupShopPurchase(pickup, player, moneySpent)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE or player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or moneySpent >= 0 or moneySpent == PickupPrice.PRICE_FREE then
        return
    end
    if Utils.IsRoomType(RoomType.ROOM_DEVIL) or PrivateField.IsSatanicBibleUsedBossRoom() or PrivateField.IsDarkRoomStartingRoom() then
        return
    end
    TYU.GAME:AddDevilRoomDeal()
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Warfarin.PostPickupShopPurchase)

function Warfarin:PrePlayerTakeDamage(player, amount, flags, source, countdown)
    local playerType = player:GetPlayerType()
	if playerType == ModPlayerIDs.WARFARIN and not PrivateField.StopHurtSound then
        PrivateField.StopHurtSound = true
    elseif playerType ~= ModPlayerIDs.WARFARIN and PrivateField.StopHurtSound then
        PrivateField.StopHurtSound = false
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, Warfarin.PrePlayerTakeDamage)

function Warfarin:PreSFXPlay(id, volume, frameDelay, loop, pitch, pan)
	if PrivateField.StopHurtSound then
        PrivateField.StopHurtSound = false
        return {ModSoundIDs.WARFARIN_PLAYER_HURT, volume, frameDelay, loop, pitch, pan}
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, Warfarin.PreSFXPlay, SoundEffect.SOUND_ISAAC_HURT_GRUNT)

function Warfarin:PreLevelSelect(levelStage, stageType)
    if not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) then
        return
    end
    SetGlobalLibData({}, "RoomIndices")
    SetGlobalLibData(false, "Spawned")
    TYU:SetGlobalLibData({}, "WarfarinItems")
    for _, player in ipairs(Players.GetPlayers(true)) do
        local movingBoxContents = player:GetMovingBoxContents()
        for i = 0, movingBoxContents:__len() - 1 do
            local item = movingBoxContents:Get(i)
            if item:GetType() == EntityType.ENTITY_PICKUP and item:GetVariant() == PickupVariant.PICKUP_COLLECTIBLE then
                Utils.AddSeedToWarfarinItems(item.InitSeed)
            end
        end
    end
    if TYU.ITEMPOOL:HasCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD) then
        TYU.ITEMPOOL:RemoveCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD)
    end
    if TYU.ITEMPOOL:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) then
        TYU.ITEMPOOL:RemoveCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, Warfarin.PreLevelSelect)

function Warfarin:PreLevelPlaceRoom(levelGeneratorRoom, roomConfigRoom, seed)
    if Utils.IsInDeathCertificate() or not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) or roomConfigRoom.Type ~= RoomType.ROOM_SHOP or roomConfigRoom.Shape ~= RoomShape.ROOMSHAPE_1x1 then
        return
    end
    if #ModRoomIDs.WARFARIN_BLACK_MARKETS == 0 then
        SaveAndLoad.ReloadRoomData()
    end
    local rng = RNG(seed)
    local roomList = WeightedOutcomePicker()
    for _, id in ipairs(ModRoomIDs.WARFARIN_BLACK_MARKETS) do
        roomList:AddOutcomeWeight(id, 1)
    end
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET_EXIT, roomList:PickOutcome(rng))
    local roomIndices = GetGlobalLibData("RoomIndices")
    table.insert(roomIndices, 13 * levelGeneratorRoom:Row() + levelGeneratorRoom:Column())
    SetGlobalLibData(true, "Spawned")
    return newRoom
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, Warfarin.PreLevelPlaceRoom)

function Warfarin:PreNewRoom(room, roomDesc)
    if not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) or not GetGlobalLibData("Spawned") or Utils.IsInDeathCertificate() then
        return
    end
    local roomIndicesTable = GetGlobalLibData("RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    if not Utils.IsRoomIndex(blackmarketRoomIndex) then
        return
    end
    local itemPool = ItemPoolType.POOL_SHOP
    if Players.AnyoneHasCollectible(ModItemIDs.ORDER) then
        itemPool = Utils.GetOrderItemPool()
    end
    room:SetItemPool(itemPool)
end
Warfarin:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, 50, Warfarin.PreNewRoom)

function Warfarin:ReplaceBlackmarketDoorSprite()
    local room = TYU.GAME:GetRoom()
    if Utils.IsInDeathCertificate() or not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) or not GetGlobalLibData("Spawned") or Utils.IsRoomType(RoomType.ROOM_SECRET) then
        return
    end
    local roomIndicesTable = GetGlobalLibData("RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    for slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
        local door = room:GetDoor(slot)
        if door and ((door.TargetRoomIndex == blackmarketRoomIndex and door.CurrentRoomType ~= RoomType.ROOM_SECRET and door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET and door.CurrentRoomType ~= RoomType.ROOM_ULTRASECRET) or (Utils.IsRoomIndex(blackmarketRoomIndex) and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET)) then
            local doorSprite = door:GetSprite()
            doorSprite:Load("gfx/grid/warfarin_blackmarket_door.anm2", true)
            if door:IsLocked() then
                door:SetLocked(false)
            end
            if door:IsOpen() then
                doorSprite:Play("Opened")
            else
                doorSprite:Play("Closed")
            end
        end
    end
    if not Utils.IsRoomIndex(blackmarketRoomIndex) then
        return
    end
    room:SetBackdropType(BackdropType.GEHENNA, 1)
    if not Utils.IsRoomFirstVisit() then
        return
    end
    Entities.Spawn(ModEntityIDs.WARFARIN_BLACKMARKET_CRAWLSPACE.Type, ModEntityIDs.WARFARIN_BLACKMARKET_CRAWLSPACE.Variant, ModEntityIDs.WARFARIN_BLACKMARKET_CRAWLSPACE.SubType, Vector(440, 160))
end
Warfarin:AddCallback(Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, Warfarin.ReplaceBlackmarketDoorSprite)

function Warfarin:UseCard(card, player, useFlags)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or not GetGlobalLibData("Spawned") or Utils.IsInDeathCertificate() then
        return
    end
    local roomIndicesTable = GetGlobalLibData("RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    TYU.GAME:StartRoomTransition(blackmarketRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, -1)
end
Warfarin:AddCallback(ModCallbacks.MC_USE_CARD, Warfarin.UseCard, Card.CARD_HERMIT)

function Warfarin:PostPickupMorph(pickup, previousType, previousVariant, previousSubType, keptPrice, keptSeed, ignoredModifiers)
    if not Players.AnyoneIsPlayerType(ModPlayerIDs.WARFARIN) or pickup.Type ~= EntityType.ENTITY_PICKUP or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        return
    end
    Utils.AddSeedToWarfarinItems(pickup.InitSeed)
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, Warfarin.PostPickupMorph)

function Warfarin:PrePlayerRender(player, offset)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or TYU.GAME:GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
        return
    end
    return false
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, Warfarin.PrePlayerRender)

function Warfarin:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if player:GetPlayerType() ~= ModPlayerIDs.WARFARIN or not Utils.IsRoomIndex(GridRooms.ROOM_SECRET_SHOP_IDX) or not Utils.IsRoomFirstVisit() then
        return
    end
    return true
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, Warfarin.PreUseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

return Warfarin