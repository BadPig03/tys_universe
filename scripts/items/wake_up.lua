local WakeUp = TYU:NewModItem("Wake-up", "WAKE_UP")
local Callbacks = TYU.Callbacks
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local SaveAndLoad = TYU.SaveAndLoad
local ModRoomIDs = TYU.ModRoomIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("WakeUp", ...)
end

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "WakeUp", ...)
end

do
    PrivateField.WakeUpBannedItems = {
        [CollectibleType.COLLECTIBLE_SKELETON_KEY] = true,
        [CollectibleType.COLLECTIBLE_DOLLAR] = true,
        [CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = true,
        [CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = true,
        [CollectibleType.COLLECTIBLE_CRYSTAL_BALL] = true,
        [CollectibleType.COLLECTIBLE_PYRO] = true,
        [CollectibleType.COLLECTIBLE_MOMS_KEY] = true,
        [CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = true,
        [CollectibleType.COLLECTIBLE_GOAT_HEAD] = true,
        [CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW] = true,
        [CollectibleType.COLLECTIBLE_THERES_OPTIONS] = true,
        [CollectibleType.COLLECTIBLE_BLACK_CANDLE] = true,
        [CollectibleType.COLLECTIBLE_D100] = true,
        [CollectibleType.COLLECTIBLE_MIND] = true,
        [CollectibleType.COLLECTIBLE_DIPLOPIA] = true,
        [CollectibleType.COLLECTIBLE_CAR_BATTERY] = true,
        [CollectibleType.COLLECTIBLE_CHARGED_BABY] = true,
        [CollectibleType.COLLECTIBLE_RUNE_BAG] = true,
        [CollectibleType.COLLECTIBLE_CHAOS] = true,
        [CollectibleType.COLLECTIBLE_MORE_OPTIONS] = true,
        [CollectibleType.COLLECTIBLE_TELEPORT_2] = true,
        [CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS] = true,
        [CollectibleType.COLLECTIBLE_SACK_HEAD] = true,
        [CollectibleType.COLLECTIBLE_EDENS_SOUL] = true,
        [CollectibleType.COLLECTIBLE_EUCHARIST] = true,
        [CollectibleType.COLLECTIBLE_SACK_OF_SACKS] = true,
        [CollectibleType.COLLECTIBLE_MYSTERY_GIFT] = true,
        [CollectibleType.COLLECTIBLE_JUMPER_CABLES] = true,
        [CollectibleType.COLLECTIBLE_MR_ME] = true,
        [CollectibleType.COLLECTIBLE_SCHOOLBAG] = true,
        [CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = true,
        [CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = true,
        [CollectibleType.COLLECTIBLE_RED_KEY] = true,
        [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = true,
        [CollectibleType.COLLECTIBLE_STAIRWAY] = true,
        [CollectibleType.COLLECTIBLE_MERCURIUS] = true,
        [CollectibleType.COLLECTIBLE_ETERNAL_D6] = true,
        [CollectibleType.COLLECTIBLE_BIRTHRIGHT] = true,
        [CollectibleType.COLLECTIBLE_GENESIS] = true,
        [CollectibleType.COLLECTIBLE_CARD_READING] = true,
        [CollectibleType.COLLECTIBLE_ECHO_CHAMBER] = true,
        [CollectibleType.COLLECTIBLE_ISAACS_TOMB] = true,
        [CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING] = true,
        [CollectibleType.COLLECTIBLE_KEEPERS_SACK] = true,
        [CollectibleType.COLLECTIBLE_EVERYTHING_JAR] = true,
        [CollectibleType.COLLECTIBLE_ANIMA_SOLA] = true,
        [CollectibleType.COLLECTIBLE_D6] = true,
        [CollectibleType.COLLECTIBLE_VOID] = true,
        [CollectibleType.COLLECTIBLE_D_INFINITY] = true,
        [CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1] = true,
        [CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_2] = true,
        [CollectibleType.COLLECTIBLE_MOMS_SHOVEL] = true,
        [CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE] = true,
        [CollectibleType.COLLECTIBLE_R_KEY] = true,
        [CollectibleType.COLLECTIBLE_URN_OF_SOULS] = true,
        [CollectibleType.COLLECTIBLE_GLITCHED_CROWN] = true,
        [CollectibleType.COLLECTIBLE_SACRED_ORB] = true,
        [CollectibleType.COLLECTIBLE_ABYSS] = true,
        [CollectibleType.COLLECTIBLE_FLIP] = true,
        [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = true,
        [ModItemIDs.BEGGAR_MASK] = true,
        [ModItemIDs.CROWN_OF_KINGS] = true,
        [ModItemIDs.ORDER] = true,
        [ModItemIDs.HADES_BLADE] = true,
        [ModItemIDs.MIRRORING] = true,
        [ModItemIDs.MIRRORING_SHARD] = true,
        [ModItemIDs.PLANETARIUM_TELESCOPE] = true,
        [ModItemIDs.THE_GOSPEL_OF_JOHN] = true,
        [ModItemIDs.WAKE_UP] = true
    }
end

do
    function PrivateField.IsInvalidRoom()
        if not Utils.IsRoomIndex(GridRooms.ROOM_EXTRA_BOSS_IDX) or not TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data then
            return true
        end
        if ModRoomIDs.WAKE_UP_MAIN_ROOM == -1 then
            SaveAndLoad.ReloadRoomData()
        end
        if TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data.Variant ~= ModRoomIDs.WAKE_UP_MAIN_ROOM then
            return true
        end
        return false
    end

    function PrivateField.GetOffensiveCollectible(rng)
        local itemID = CollectibleType.COLLECTIBLE_BREAKFAST
        local itemList = {}
        for i = 1, TYU.ITEMCONFIG:GetCollectibles().Size - 1 do
            if ItemConfig.Config.IsValidCollectible(i) and TYU.ITEMCONFIG:GetCollectible(i).Quality >= 3 and TYU.ITEMCONFIG:GetCollectible(i):HasTags(ItemConfig.TAG_OFFENSIVE) and TYU.ITEMCONFIG:GetCollectible(i).Type ~= ItemType.ITEM_ACTIVE and not PrivateField.WakeUpBannedItems[i] and TYU.ITEMPOOL:CanSpawnCollectible(i, false) then
                table.insert(itemList, i)
            end
        end
        itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
        if itemID == CollectibleType.COLLECTIBLE_BREAKFAST then
            return CollectibleType.COLLECTIBLE_PENTAGRAM
        end
        TYU.ITEMPOOL:RemoveCollectible(itemID)
        return itemID
    end
    
    function PrivateField.GetOffensiveCollectibleEx(rng, angel)
        local itemPoolType = (angel and ItemPoolType.POOL_ANGEL) or ItemPoolType.POOL_DEVIL
        local itemID = CollectibleType.COLLECTIBLE_BREAKFAST
        local itemList = {}
        for _, itemTable in ipairs(TYU.ITEMPOOL:GetCollectiblesFromPool(itemPoolType)) do
            local itemID = itemTable.itemID
            if TYU.ITEMPOOL:HasCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID) and TYU.ITEMCONFIG:GetCollectible(itemID).Quality >= 3 and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_OFFENSIVE) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and not PrivateField.WakeUpBannedItems[itemID] and TYU.ITEMPOOL:CanSpawnCollectible(itemID, false) then
                table.insert(itemList, itemID)
            end
        end
        itemID = TYU.ITEMPOOL:GetCollectibleFromList(itemList, rng:Next())
        if itemID == CollectibleType.COLLECTIBLE_BREAKFAST then
            return (angel and CollectibleType.COLLECTIBLE_IMMACULATE_HEART) or CollectibleType.COLLECTIBLE_PENTAGRAM
        end
        return itemID
    end

    function PrivateField.GetNewCollectible(rng)
        local newItem = nil
        if GetGlobalLibData("Devil") then
            newItem = PrivateField.GetOffensiveCollectibleEx(rng, false)
        elseif GetGlobalLibData("Angel") then
            newItem = PrivateField.GetOffensiveCollectibleEx(rng, true)
        else
            newItem = PrivateField.GetOffensiveCollectible(rng)
        end
        return newItem
    end
end

function WakeUp:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.HasFlags(useFlags, UseFlag.USE_VOID) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if GetGlobalLibData("Used") or GetGlobalLibData("Killed") or GetGlobalLibData("Escaped") or TYU.GAME:IsGreedMode() or TYU.LEVEL:GetAbsoluteStage() >= LevelStage.STAGE5 or Utils.IsAscent() or TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data then
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
    if ModRoomIDs.WAKE_UP_MAIN_ROOM == -1 then
        SaveAndLoad.ReloadRoomData()
    end
    player:UseCard(Card.CARD_REVERSE_EMPEROR, 0)
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, ModRoomIDs.WAKE_UP_MAIN_ROOM)
    TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data = newRoom
    TYU.GAME:StartRoomTransition(GridRooms.ROOM_EXTRA_BOSS_IDX, Direction.UP, RoomTransitionAnim.DEATH_CERTIFICATE, Isaac.GetPlayer(0), 0)
    SetGlobalLibData(true, "Used")
    SetGlobalLibData(true, "CurrentLevelUsed")
    SetGlobalLibData(player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES), "Angel")
    SetGlobalLibData(player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE), "Devil")
	return { Discharge = true, Remove = true, ShowAnim = true }
end
WakeUp:AddCallback(ModCallbacks.MC_USE_ITEM, WakeUp.UseItem, ModItemIDs.WAKE_UP)

function WakeUp:PostNewLevel()
    if GetGlobalLibData("CurrentLevelUsed") then
        SetGlobalLibData(false, "CurrentLevelUsed")
    end
end
WakeUp:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, WakeUp.PostNewLevel)

function WakeUp:ReplaceWakeUpMainRoomContents(isLoaded)
    if not GetGlobalLibData("Used") then
        return
    end
    if PrivateField.IsInvalidRoom() and not GetGlobalLibData("Escaped") then
        local text = (Options.Language == "zh" and "你无法逃离…") or "YOU CAN'T ESCAPE..."
        TYU.HUD:ShowFortuneText(text)
        TYU.GAME:Darken(1, 120)
        TYU.GAME:ShakeScreen(150)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_DEATH_SKULL_SUMMON_END, 0.6, 2, false, 0.85)
        SetGlobalLibData(true, "Escaped")
        SetGlobalLibData(false, "Used")
    end
    if isLoaded and not PrivateField.IsInvalidRoom() and not GetGlobalLibData("Escaped") then
        TYU.GAME:StartRoomTransition(TYU.LEVEL:GetStartingRoomIndex(), Direction.UP, RoomTransitionAnim.DEATH_CERTIFICATE, Isaac.GetPlayer(0), 0)
    end
    if not PrivateField.IsInvalidRoom() then
        local room = TYU.GAME:GetRoom()
        room:SetBackdropType(BackdropType.DOGMA, 1)
        room:RemoveDoor(DoorSlot.DOWN0)
        room:RemoveGridEntityImmediate(37, 0, false)
        Utils.RemoveAllDecorations()
        if not Utils.IsRoomFirstVisit() then
            return
        end
        Entities.Spawn(EntityType.ENTITY_GENERIC_PROP, 4, 0, Vector(320, 420))
        local rng = RNG(room:GetAwardSeed())
        for i = 0, 2 do
            local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, PrivateField.GetNewCollectible(rng), room:GetGridPosition(154 + 3 * i)):ToPickup()
            item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE | EntityFlag.FLAG_GLITCH)
            item.Price = 0
            Utils.AddSeedToWarfarinItems(item.InitSeed)
            item:RemoveCollectibleCycle()
            if not Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER) then
                for j = 1, 2 do
                    item:AddCollectibleCycle(PrivateField.GetNewCollectible(rng))
                end
            end
        end
    end
end
WakeUp:AddCallback(Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, WakeUp.ReplaceWakeUpMainRoomContents)

function WakeUp:PostUpdate()
    local room = TYU.GAME:GetRoom()
    if GetGlobalLibData("Escaped") and room:GetFrameCount() % 300 == 30 then
        local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.WAKE_UP)
        local angelBaby = Entities.Spawn(EntityType.ENTITY_DOGMA, 10, 0, room:GetGridPosition(room:GetRandomTileIndex(rng:Next())))
        angelBaby:SetInvincible(true)
        angelBaby:AddEntityFlags(EntityFlag.FLAG_AMBUSH | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        Entities.SpawnPoof(angelBaby.Position):GetSprite().Color:SetColorize(2, 2, 2, 1)    
    end
    if PrivateField.IsInvalidRoom() or not GetGlobalLibData("Used") then
        return
    end
    if room:GetBackdropType() ~= BackdropType.DOGMA then
        room:SetBackdropType(BackdropType.DOGMA, 1)
    end
    TYU.GAME:Darken(1, 30)
    if GetGlobalLibData("Taken") then
        return
    end
    local anyCollectibleFound = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local pickup = ent:ToPickup()
        if pickup.SubType > 0 and not pickup:IsShopItem() then
            anyCollectibleFound = true
        end
    end
    if not anyCollectibleFound then
        local text = (Options.Language == "zh" and "深入梦魇…") or "DEEP IN A NIGHTMARE..."
        TYU.HUD:ShowFortuneText(text)
        TYU.GAME:Darken(1, 120)
        TYU.GAME:ShakeScreen(120)
        room:RemoveGridEntityImmediate(37, 0, false)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MOTHERSHADOW_DASH, 0.6, 2, false, 0.5)
        for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            Entities.SpawnPoof(ent.Position)
            ent:Remove()
        end
        for _, player in pairs(Players.GetPlayers(true)) do
            player:AddControlsCooldown(240)
        end
        Utils.CreateTimer(function()
            TYU.GAME:SetBloom(60, -12)
        end, 60, 0, false)
        Utils.CreateTimer(function()
            for _, player in pairs(Players.GetPlayers(true)) do
                player:Teleport(Vector(320, 620), false, true)
            end
            for _, tv in pairs(Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP, 4)) do
                tv:Remove()
            end
            Entities.Spawn(EntityType.ENTITY_DOGMA, 0, 0, Vector(320, 420))
            SetGlobalLibData(true, "Spawned")    
        end, 110, 0, false)
        SetGlobalLibData(true, "Taken")
    end
end
WakeUp:AddCallback(ModCallbacks.MC_POST_UPDATE, WakeUp.PostUpdate)

function WakeUp:PostEntityKill(entity)
    if PrivateField.IsInvalidRoom() or not GetGlobalLibData("Spawned") or entity.Variant ~= 2 then
        return
    end
    local dogma = Entities.Spawn(EntityType.ENTITY_DOGMA, 2, 0, entity.Position)
    dogma.DepthOffset = 9999
    dogma:AddHealth(-dogma.MaxHitPoints)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_DEATH, 0.6, 2, false, 0.65)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_LIGHT_RAY_FIRE, 0.6, 2, false, 0.65)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_LIGHT_RAY_CHARGE, 0.6, 2, false, 0.65)
    TYU.GAME:ShakeScreen(89)
    dogma:Die()
    entity:Remove()
    SetGlobalLibData(false, "Used")
    SetGlobalLibData(true, "Killed")
    Utils.CreateTimer(function()
        TYU.GAME:SetBloom(60, -12)
        for _, player in pairs(Players.GetPlayers(true)) do
            player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
        end
    end, 60, 0, false)
    Utils.CreateTimer(function()
        TYU.GAME:ChangeRoom(GridRooms.ROOM_ERROR_IDX)
        TYU.GAME:ChangeRoom(TYU.LEVEL:GetStartingRoomIndex())
    end, 80, 0, false)
end
WakeUp:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, WakeUp.PostEntityKill, EntityType.ENTITY_DOGMA)

function WakeUp:PreUseCard(card, player, useFlags)
    if card == Card.CARD_REVERSE_EMPEROR and GetGlobalLibData("CurrentLevelUsed") then
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_REVERSE_EMPEROR, Utils.FindFreePickupSpawnPosition(player.Position, 0, true))
        return true
    end
end
WakeUp:AddCallback(ModCallbacks.MC_PRE_USE_CARD, WakeUp.PreUseCard)

function WakeUp:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if PrivateField.IsInvalidRoom() then
        return
    end
    return true
end
WakeUp:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, WakeUp.PreUseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

return WakeUp