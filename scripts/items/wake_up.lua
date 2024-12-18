local Lib = TYU
local WakeUp = Lib:NewModItem("Wake-up", "WAKE_UP")

local function IsInvalidRoom()
    if Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_EXTRA_BOSS_IDX or not Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data then
        return true
    end
    if Lib.ModRoomIDs.WAKE_UP_MAIN_ROOM == -1 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    if Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data.Variant ~= Lib.ModRoomIDs.WAKE_UP_MAIN_ROOM then
        return true
    end
    return false
end

local function DisplayEscapeText()
    local language = Options.Language
    if language == "zh" then
        Lib.HUD:ShowFortuneText("你无法逃离…")
    else
        Lib.HUD:ShowFortuneText("YOU CAN'T ESCAPE...")
    end
    Lib:SetGlobalLibData(true, "WakeUp", "Escaped")
    Lib.GAME:Darken(1, 120)
    Lib.GAME:ShakeScreen(150)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_DEATH_SKULL_SUMMON_END, 0.6, 2, false, 0.85)
end

local function GetNewCollectible(rng)
    local newItem = nil
    if Lib:GetGlobalLibData("WakeUp", "Devil") then
        newItem = Lib.Collectibles.GetOffensiveCollectibleEx(rng, false)
    elseif Lib:GetGlobalLibData("WakeUp", "Angel") then
        newItem = Lib.Collectibles.GetOffensiveCollectibleEx(rng, true)
    else
        newItem = Lib.Collectibles.GetOffensiveCollectible(rng)
    end
    return newItem
end

function WakeUp:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or useFlags & UseFlag.USE_VOID == UseFlag.USE_VOID then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    if Lib:GetGlobalLibData("WakeUp", "Used") or Lib:GetGlobalLibData("WakeUp", "Killed") or Lib:GetGlobalLibData("WakeUp", "Escaped") or Lib.GAME:IsGreedMode() or Lib.LEVEL:GetAbsoluteStage() >= LevelStage.STAGE5 or Lib.LEVEL:IsAscent() or Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data then
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
    if Lib.ModRoomIDs.WAKE_UP_MAIN_ROOM == -1 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    player:UseCard(Card.CARD_REVERSE_EMPEROR, 0)
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, Lib.ModRoomIDs.WAKE_UP_MAIN_ROOM)
    Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_EXTRA_BOSS_IDX).Data = newRoom
    Lib.GAME:StartRoomTransition(GridRooms.ROOM_EXTRA_BOSS_IDX, Direction.UP, RoomTransitionAnim.DEATH_CERTIFICATE, Isaac.GetPlayer(0), 0)
    Lib:SetGlobalLibData(true, "WakeUp", "Used")
    Lib:SetGlobalLibData(true, "WakeUp", "CurrentLevelUsed")
    Lib:SetGlobalLibData(player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES), "WakeUp", "Angel")
    Lib:SetGlobalLibData(player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE), "WakeUp", "Devil")
	return { Discharge = true, Remove = true, ShowAnim = true }
end
WakeUp:AddCallback(ModCallbacks.MC_USE_ITEM, WakeUp.UseItem, Lib.ModItemIDs.WAKE_UP)

function WakeUp:PostNewLevel()
    if Lib:GetGlobalLibData("WakeUp", "CurrentLevelUsed") then
        Lib:SetGlobalLibData(false, "WakeUp", "CurrentLevelUsed")
    end
end
WakeUp:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, WakeUp.PostNewLevel)

function WakeUp:ReplaceWakeUpMainRoomContents(isLoaded)
    if not Lib:GetGlobalLibData("WakeUp", "Used") then
        return
    end
    if IsInvalidRoom() and not Lib:GetGlobalLibData("WakeUp", "Escaped") then
        DisplayEscapeText()
        Lib:SetGlobalLibData(false, "WakeUp", "Used")
    end
    if isLoaded and not IsInvalidRoom() and not Lib:GetGlobalLibData("WakeUp", "Escaped") then
        Lib.GAME:StartRoomTransition(Lib.LEVEL:GetStartingRoomIndex(), Direction.UP, RoomTransitionAnim.DEATH_CERTIFICATE, Isaac.GetPlayer(0), 0)
    end
    if not IsInvalidRoom() then
        local room = Lib.GAME:GetRoom()
        room:SetBackdropType(BackdropType.DOGMA, 1)
        room:RemoveDoor(DoorSlot.DOWN0)
        room:RemoveGridEntityImmediate(37, 0, false)
        Lib.Levels.RemoveAllDecorations()
        if room:IsFirstVisit() then
            Lib.Entities.Spawn(EntityType.ENTITY_GENERIC_PROP, 4, 0, Vector(320, 420))
            local rng = RNG(room:GetAwardSeed())
            for i = 0, 2 do
                local item = Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, GetNewCollectible(rng), room:GetGridPosition(154 + 3 * i)):ToPickup()
                item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE | EntityFlag.FLAG_GLITCH)
                item.Price = 0
                Lib:SetGlobalLibData(true, "WarfarinItems", tostring(item.InitSeed))
                item:RemoveCollectibleCycle()
                if not Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER) then
                    for j = 1, 2 do
                        item:AddCollectibleCycle(GetNewCollectible(rng))
                    end
                end
            end
        end
    end
end
WakeUp:AddCallback(Lib.Callbacks.TYU_POST_NEW_ROOM_OR_LOAD, WakeUp.ReplaceWakeUpMainRoomContents)

function WakeUp:PostUpdate()
    local room = Lib.GAME:GetRoom()
    if Lib:GetGlobalLibData("WakeUp", "Escaped") then
        if room:GetFrameCount() % 300 == 30 then
            local rng = Isaac.GetPlayer(0):GetCollectibleRNG(Lib.ModItemIDs.WAKE_UP)
            local angelBaby = Lib.Entities.Spawn(EntityType.ENTITY_DOGMA, 10, 0, room:GetGridPosition(room:GetRandomTileIndex(rng:Next())))
            angelBaby:SetInvincible(true)
            angelBaby:AddEntityFlags(EntityFlag.FLAG_AMBUSH | EntityFlag.FLAG_NO_STATUS_EFFECTS)
            Lib.Entities.SpawnPoof(angelBaby.Position):GetSprite().Color:SetColorize(2, 2, 2, 1)    
        end
    end
    if IsInvalidRoom() or not Lib:GetGlobalLibData("WakeUp", "Used") then
        return
    end
    if room:GetBackdropType() ~= BackdropType.DOGMA then
        room:SetBackdropType(BackdropType.DOGMA, 1)
    end
    Lib.GAME:Darken(1, 30)
    if Lib:GetGlobalLibData("WakeUp", "Taken") then
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
        local language = Options.Language
        if language == "zh" then
            Lib.HUD:ShowFortuneText("深入梦魇…")
        else
            Lib.HUD:ShowFortuneText("DEEP IN A NIGHTMARE...")
        end
        Lib.GAME:Darken(1, 120)
        Lib.GAME:ShakeScreen(120)
        room:RemoveGridEntityImmediate(37, 0, false)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MOTHERSHADOW_DASH, 0.6, 2, false, 0.5)
        for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            Lib.Entities.SpawnPoof(ent.Position)
            ent:Remove()
        end
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            player:AddControlsCooldown(240)
        end
        Lib.Entities.CreateTimer(function()
            Lib.GAME:SetBloom(60, -12)
        end, 60, 0, false)
        Lib.Entities.CreateTimer(function()
            for _, player in pairs(Lib.Players.GetPlayers(true)) do
                player:Teleport(Vector(320, 620), false, true)
            end
            for _, tv in pairs(Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP, 4)) do
                tv:Remove()
            end
            Lib.Entities.Spawn(EntityType.ENTITY_DOGMA, 0, 0, Vector(320, 420))
            Lib:SetGlobalLibData(true, "WakeUp", "Spawned")    
        end, 110, 0, false)
        Lib:SetGlobalLibData(true, "WakeUp", "Taken")
    end
end
WakeUp:AddCallback(ModCallbacks.MC_POST_UPDATE, WakeUp.PostUpdate)

function WakeUp:PostEntityKill(entity)
    if IsInvalidRoom() or not Lib:GetGlobalLibData("WakeUp", "Spawned") or entity.Variant ~= 2 then
        return
    end
    local dogma = Lib.Entities.Spawn(EntityType.ENTITY_DOGMA, 2, 0, entity.Position)
    dogma.DepthOffset = 9999
    dogma:AddHealth(-dogma.MaxHitPoints)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_DEATH, 0.6, 2, false, 0.65)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_LIGHT_RAY_FIRE, 0.6, 2, false, 0.65)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_DOGMA_LIGHT_RAY_CHARGE, 0.6, 2, false, 0.65)
    Lib.GAME:ShakeScreen(89)
    dogma:Die()
    entity:Remove()
    Lib:SetGlobalLibData(false, "WakeUp", "Used")
    Lib:SetGlobalLibData(true, "WakeUp", "Killed")
    Lib.Entities.CreateTimer(function()
        Lib.GAME:SetBloom(60, -12)
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            player:AddCollectible(CollectibleType.COLLECTIBLE_DOGMA)
        end
    end, 60, 0, false)
    Lib.Entities.CreateTimer(function()
        Lib.GAME:ChangeRoom(GridRooms.ROOM_ERROR_IDX)
        Lib.GAME:ChangeRoom(Lib.LEVEL:GetStartingRoomIndex())
    end, 80, 0, false)
end
WakeUp:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, WakeUp.PostEntityKill, EntityType.ENTITY_DOGMA)

function WakeUp:PreUseCard(card, player, useFlags)
    if card == Card.CARD_REVERSE_EMPEROR and Lib:GetGlobalLibData("WakeUp", "CurrentLevelUsed") then
        local room = Lib.GAME:GetRoom()
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_REVERSE_EMPEROR, room:FindFreePickupSpawnPosition(player.Position, 0, true))
        return true
    end
end
WakeUp:AddCallback(ModCallbacks.MC_PRE_USE_CARD, WakeUp.PreUseCard)

function WakeUp:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if IsInvalidRoom() then
        return
    end
    return true
end
WakeUp:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, WakeUp.PreUseItem, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

return WakeUp