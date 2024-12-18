local Lib = TYU
local Warfarin = Lib:NewModPlayer("Warfarin", false, "WARFARIN")

if CuerLib then
    CuerLib.Players.SetOnlyRedHeartPlayer(Lib.ModPlayerIDs.WARFARIN, true)
end

local itemPoolFlag = true
local stopHurtSound = false

local function GetHeartCharge(player, pickup)
    if pickup.SubType == HeartSubType.HEART_SOUL or pickup.SubType == HeartSubType.HEART_BLACK then
        return 2
    elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
        return 1
    end
    return -1
end

function Warfarin:EvaluateCache(player, cacheFlag)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        Lib.Stat:AddFlatDamage(player, 0.2 * Lib.GAME:GetDevilRoomDeals())
    elseif cacheFlag == CacheFlag.CACHE_FLYING and effects:HasNullEffect(Lib.ModNullItemIDs.WARFARIN_WINGS) and not player:HasCurseMistEffect() then
        player.CanFly = true
    elseif effects:HasNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_BURSTSPLIT
        end
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            Lib.Stat:AddTearsMultiplier(player, 0.8)
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            Lib.Stat:AddSpeedUp(player, 0.15)
        end
    end
end
Warfarin:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Warfarin.EvaluateCache)

function Warfarin:PostFireTear(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if not player or player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN then
        return
    end
    if player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA) and tear.Variant == TearVariant.BLUE then
        tear:ChangeVariant(TearVariant.BLOOD)
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
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
end
Warfarin:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Warfarin.PostFireTear)

function Warfarin:PostPlayerUpdate(player)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    local hearts = player:GetMaxHearts() + player:GetBoneHearts() * 2
    if hearts > 6 and effects:HasNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        effects:RemoveNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA)
        if not Lib:GetPlayerLibData(player, "BloodSample", "OutTriggered") then
            Lib.ITEMOVERLAY.Show(Lib.ModGiantBookIDs.WARFARIN_OUT, 3, player)
            Lib:SetPlayerLibData(player, true, "BloodSample", "OutTriggered")
        end
    elseif hearts <= 6 and not effects:HasNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA) then
        effects:AddNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA)
        if not Lib:GetPlayerLibData(player, "BloodSample", "InTriggered") then
            Lib.ITEMOVERLAY.Show(Lib.ModGiantBookIDs.WARFARIN_IN, 3, player)
            Lib:SetPlayerLibData(player, true, "BloodSample", "InTriggered")
        end
    end
    local collectible = Lib.Collectibles.GetNearestDevilDeal(player.Position)
    local charge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + player:GetBatteryCharge(ActiveSlot.SLOT_POCKET)
    if collectible and Lib.GAME:GetRoom():IsClear() then
        if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == Lib.ModItemIDs.BLOOD_SAMPLE then
            if player:IsExtraAnimationFinished() then
                player:AnimateCollectible(Lib.ModItemIDs.BLOODY_DICE, "UseItem", "PlayerPickup")
            end
            player:SetPocketActiveItem(Lib.ModItemIDs.BLOODY_DICE, ActiveSlot.SLOT_POCKET, true)
            player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
        end
    else
        if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == Lib.ModItemIDs.BLOODY_DICE then
            if player:IsExtraAnimationFinished() then
                player:AnimateCollectible(Lib.ModItemIDs.BLOOD_SAMPLE, "UseItem", "PlayerPickup")
            end
            player:SetPocketActiveItem(Lib.ModItemIDs.BLOOD_SAMPLE, ActiveSlot.SLOT_POCKET, true)
            player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
        end
    end
    
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Warfarin.PostPlayerUpdate, 0)

function Warfarin:PostHUDUpdate()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:GetPlayerType() == Lib.ModPlayerIDs.WARFARIN then
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

function Warfarin:PostNewRoom()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:GetPlayerType() == Lib.ModPlayerIDs.WARFARIN then
            Lib:SetPlayerLibData(player, false, "BloodSample", "OutTriggered")
            Lib:SetPlayerLibData(player, false, "BloodSample", "InTriggered")
        end
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Warfarin.PostNewRoom)

function Warfarin:PostPickupUpdate(pickup)
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    local itemConfig = Lib.ITEMCONFIG:GetCollectible(pickup.SubType)
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or Lib.Levels.IsInDeathCertificate() or Lib.Levels.IsInGenesisRoom() or roomType == RoomType.ROOM_SHOP or roomType == RoomType.ROOM_DUNGEON or pickup.SubType <= 0 or pickup:GetAlternatePedestal() > 0 or pickup.ShopItemId == -2 or pickup.Touched or itemConfig:HasTags(ItemConfig.TAG_QUEST) then
        return
    end
    if Lib:GetGlobalLibData("WarfarinItems", tostring(pickup.InitSeed)) then
        return
    end
    local isCycled = #pickup:GetCollectibleCycle() > 0
    if pickup.FrameCount >= ((isCycled and 0) or 5) then
        Lib:SetGlobalLibData(true, "WarfarinItems", tostring(pickup.InitSeed))
        if not pickup:IsShopItem() then
            pickup:MakeShopItem(-2)
            Lib.Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(1, 0, 0, 1)    
        end
    else
        if pickup:IsShopItem() then
            Lib:SetGlobalLibData(true, "WarfarinItems", tostring(pickup.InitSeed))
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
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) then
        return
    end
    if pickup.SubType == HeartSubType.HEART_BLENDED then
        local rng = pickup:GetDropRNG()
        if rng:RandomInt(100) < 50 then
            Lib.Entities.Morph(pickup, nil, nil, HeartSubType.HEART_SOUL, true, true, true, false)
        else
            Lib.Entities.Morph(pickup, nil, nil, HeartSubType.HEART_FULL, true, true, true, false)
        end
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Warfarin.PostPickupInit, PickupVariant.PICKUP_HEART)

function Warfarin:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN then
        return
    end
    local effects = player:GetEffects()
    if type == CollectibleType.COLLECTIBLE_ABADDON and firstTime and player:GetMaxHearts() + player:GetBoneHearts() == 0 then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end
    if type == CollectibleType.COLLECTIBLE_CHARM_VAMPIRE then
        effects:RemoveNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_WINGS).ID, -1)
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_WINGS).ID)
        player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
    end
    if type == CollectibleType.COLLECTIBLE_BLOOD_BAG and firstTime then
        player:AddHearts(99)
    end
    if type == CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT or type == CollectibleType.COLLECTIBLE_DEAD_DOVE then
        effects:RemoveNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_WINGS).ID, -1)
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_WINGS).ID)
    end
    if type == CollectibleType.COLLECTIBLE_MAGIC_8_BALL then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_MAGIC_8_BALL).ID)
    end
    if type == CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_CEREMONIAL_ROBES).ID)
    end
    if type == CollectibleType.COLLECTIBLE_MOMS_WIG then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_MOMS_WIG).ID)
    end
    if type == CollectibleType.COLLECTIBLE_BLACK_CANDLE then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_BLACK_CANDLE).ID)
    end
    if type == CollectibleType.COLLECTIBLE_TAURUS then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_TAURUS).ID)
    end
    if type == CollectibleType.COLLECTIBLE_LEO then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_LEO).ID)
    end
    if type == CollectibleType.COLLECTIBLE_INTRUDER then
        Lib.Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_INTRUDER)
    end
    if type == CollectibleType.COLLECTIBLE_TERRA then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_FROZEN_HAIR_3).ID)
    end
    if type == CollectibleType.COLLECTIBLE_JUPITER then
        Lib.Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_JUPITER)
    end
    if type == CollectibleType.COLLECTIBLE_URANUS then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_FROZEN_HAIR_4).ID)
    end
    if type == CollectibleType.COLLECTIBLE_CARD_READING then
        effects:AddNullEffect(Lib.ITEMCONFIG:GetCollectible(Lib.ModNullItemIDs.WARFARIN_CARD_READING).ID)
    end
    if type == CollectibleType.COLLECTIBLE_C_SECTION then
        Lib.Players.RemoveCostume(player, CollectibleType.COLLECTIBLE_C_SECTION)
    end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
end
Warfarin:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Warfarin.PostAddCollectible)

function Warfarin:PlayerGetHeartLimit(player, limit, isKeeper)
    local heartLimit = (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 18) or 12
    if player:GetMaxHearts() + 2 * player:GetBoneHearts() >= heartLimit and player:GetBrokenHearts() <= (24 - heartLimit) / 2 then
        return heartLimit
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, Warfarin.PlayerGetHeartLimit, Lib.ModPlayerIDs.WARFARIN)

function Warfarin:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or not player:CanPickSoulHearts() then
        return
    end
    local charge = GetHeartCharge(player, pickup)
    if charge <= 0 then
        return
    end
    Lib.Entities.SpawnFakePickupSprite(pickup)
    player:AddSoulHearts(charge)
    return { Collide = true, SkipCollisionEffects = true }
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Warfarin.PrePickupCollision, PickupVariant.PICKUP_HEART)

function Warfarin:PrePlayerAddHearts(player, amount, addHealthType, _)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or amount <= 0 or Lib.GAME:GetRoom():GetFrameCount() <= 0 then
        return
    end
    if addHealthType & AddHealthType.SOUL == AddHealthType.SOUL or addHealthType & AddHealthType.BLACK == AddHealthType.BLACK then
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
    elseif player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.WARFARIN_HAEMOLACRIA) and addHealthType & AddHealthType.RED == AddHealthType.RED and not Lib.Rewind.GlowingHourglassUsed then
        return amount * 2
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, Warfarin.PrePlayerAddHearts)

function Warfarin:PostPlayerRevive(player)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN then
        return
    end
    if player:GetSoulHearts() == 1 and player:GetMaxHearts() + player:GetBoneHearts() == 0 then
        player:AddSoulHearts(-1)
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, Warfarin.PostPlayerRevive)

function Warfarin:PostPickupShopPurchase(pickup, player, moneySpent)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE or player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or moneySpent >= 0 or moneySpent == PickupPrice.PRICE_FREE then
        return
    end
    if Lib.GAME:GetRoom():GetType() == RoomType.ROOM_DEVIL or Lib.Levels.IsSatanicBibleUsedBossRoom() or Lib.Levels.IsDarkRoomStartingRoom() then
        return
    end
    Lib.GAME:AddDevilRoomDeal()
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, Warfarin.PostPickupShopPurchase)

function Warfarin:PrePlayerTakeDamage(player, amount, flags, source, countdown)
    local playerType = player:GetPlayerType()
	if playerType == Lib.ModPlayerIDs.WARFARIN and not stopHurtSound then
        stopHurtSound = true
    elseif playerType ~= Lib.ModPlayerIDs.WARFARIN and stopHurtSound then
        stopHurtSound = false
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, Warfarin.PrePlayerTakeDamage)

function Warfarin:PreSFXPlay(id, volume, frameDelay, loop, pitch, pan)
	if stopHurtSound then
        stopHurtSound = false
        return {Lib.ModSoundIDs.WARFARIN_PLAYER_HURT, volume, frameDelay, loop, pitch, pan}
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, Warfarin.PreSFXPlay, SoundEffect.SOUND_ISAAC_HURT_GRUNT)

function Warfarin:PreLevelSelect(levelStage, stageType)
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) then
        return
    end
    Lib:SetGlobalLibData({}, "WarfarinBlackmarket", "RoomIndices")
    Lib:SetGlobalLibData(false, "WarfarinBlackmarket", "Spawned")
    Lib:SetGlobalLibData({}, "WarfarinItems")
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        local movingBoxContents = player:GetMovingBoxContents()
        for i = 0, movingBoxContents:__len() - 1 do
            local item = movingBoxContents:Get(i)
            if item:GetType() == EntityType.ENTITY_PICKUP and item:GetVariant() == PickupVariant.PICKUP_COLLECTIBLE then
                Lib:SetGlobalLibData(true, "WarfarinItems", tostring(item:GetInitSeed()))
            end
        end
    end
    if Lib.ITEMPOOL:HasCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD) then
        Lib.ITEMPOOL:RemoveCollectible(CollectibleType.COLLECTIBLE_MEMBER_CARD)
    end
    if Lib.ITEMPOOL:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) then
        Lib.ITEMPOOL:RemoveCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
    end
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, Warfarin.PreLevelSelect)

function Warfarin:PreLevelPlaceRoom(levelGeneratorRoom, roomConfigRoom, seed)
    if Lib.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE or not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or roomConfigRoom.Type ~= RoomType.ROOM_SHOP or roomConfigRoom.Shape ~= RoomShape.ROOMSHAPE_1x1 then
        return
    end
    if #Lib.ModRoomIDs.WARFARIN_BLACK_MARKETS == 0 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    local rng = RNG(seed)
    local roomList = WeightedOutcomePicker()
    for _, id in ipairs(Lib.ModRoomIDs.WARFARIN_BLACK_MARKETS) do
        roomList:AddOutcomeWeight(id, 1)
    end
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET_EXIT, roomList:PickOutcome(rng))
    local roomIndices = Lib:GetGlobalLibData("WarfarinBlackmarket", "RoomIndices")
    table.insert(roomIndices, 13 * levelGeneratorRoom:Row() + levelGeneratorRoom:Column())
    Lib:SetGlobalLibData(true, "WarfarinBlackmarket", "Spawned")
    return newRoom
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, Warfarin.PreLevelPlaceRoom)

function Warfarin:PreNewRoom(room, roomDesc)
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or not Lib:GetGlobalLibData("WarfarinBlackmarket", "Spawned") or Lib.Levels.IsInDeathCertificate() then
        return
    end
    local roomIndicesTable = Lib:GetGlobalLibData("WarfarinBlackmarket", "RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    if Lib.LEVEL:GetCurrentRoomIndex() ~= blackmarketRoomIndex then
        return
    end
    local itemPool = ItemPoolType.POOL_SHOP
    if Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.ORDER) then
        itemPool = Lib:GetGlobalLibData("Order")[Lib.LEVEL:GetStage()]
    end
    room:SetItemPool(itemPool)
end
Warfarin:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, 50, Warfarin.PreNewRoom)

function Warfarin:PostNewRoom()
    local room = Lib.GAME:GetRoom()
    local currentRoomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or not Lib:GetGlobalLibData("WarfarinBlackmarket", "Spawned") or not room:IsFirstVisit() or currentRoomIndex ~= GridRooms.ROOM_SECRET_SHOP_IDX then
        return
    end
    local roomIndicesTable = Lib:GetGlobalLibData("WarfarinBlackmarket", "RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    Lib.GAME:ChangeRoom(blackmarketRoomIndex)
    Lib.GAME:ChangeRoom(currentRoomIndex)
end
Warfarin:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Warfarin.PostNewRoom)

function Warfarin:ReplaceBlackmarketDoorSprite()
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    if Lib.Levels.IsInDeathCertificate() or not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or not Lib:GetGlobalLibData("WarfarinBlackmarket", "Spawned") or roomType == RoomType.ROOM_SECRET then
        return
    end
    local roomIndicesTable = Lib:GetGlobalLibData("WarfarinBlackmarket", "RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    local currentRoomIndex = Lib.LEVEL:GetCurrentRoomIndex()
    for slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
        local door = room:GetDoor(slot)
        if door and ((door.TargetRoomIndex == blackmarketRoomIndex and door.CurrentRoomType ~= RoomType.ROOM_SECRET and door.CurrentRoomType ~= RoomType.ROOM_SUPERSECRET and door.CurrentRoomType ~= RoomType.ROOM_ULTRASECRET) or (currentRoomIndex == blackmarketRoomIndex and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET)) then
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
    if currentRoomIndex == blackmarketRoomIndex then
        room:SetBackdropType(BackdropType.GEHENNA, 1)
        if room:IsFirstVisit() then
            room:TrySpawnSecretShop(true)
        end
    end
end
Warfarin:AddCallback(Lib.Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, Warfarin.ReplaceBlackmarketDoorSprite)

function Warfarin:UseCard(card, player, useFlags)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or not Lib:GetGlobalLibData("WarfarinBlackmarket", "Spawned") or Lib.LEVEL:GetDimension() == Dimension.DEATH_CERTIFICATE then
        return
    end
    local roomIndicesTable = Lib:GetGlobalLibData("WarfarinBlackmarket", "RoomIndices")
    local blackmarketRoomIndex = roomIndicesTable[#roomIndicesTable]
    Lib.GAME:StartRoomTransition(blackmarketRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, -1)
end
Warfarin:AddCallback(ModCallbacks.MC_USE_CARD, Warfarin.UseCard, Card.CARD_HERMIT)

function Warfarin:PostPickupMorph(pickup, previousType, previousVariant, previousSubType, keptPrice, keptSeed, ignoredModifiers)
    if not Lib.Players.AnyoneIsPlayerType(Lib.ModPlayerIDs.WARFARIN) or pickup.Type ~= EntityType.ENTITY_PICKUP or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
        return
    end
    Lib:SetGlobalLibData(true, "WarfarinItems", tostring(pickup.InitSeed))
end
Warfarin:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, Warfarin.PostPickupMorph)

function Warfarin:PrePlayerRender(player, offset)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or Lib.GAME:GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
        return
    end
    return false
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, Warfarin.PrePlayerRender)

function Warfarin:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if player:GetPlayerType() ~= Lib.ModPlayerIDs.WARFARIN or Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_SECRET_SHOP_IDX or not Lib.GAME:GetRoom():IsFirstVisit() then
        return
    end
    return true
end
Warfarin:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, Warfarin.PreUseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

return Warfarin