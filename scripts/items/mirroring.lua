local Mirroring = TYU:NewModItem("Mirroring", "MIRRORING")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local ModPlayerIDs = TYU.ModPlayerIDs
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "Mirroring", ...)
end

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Mirroring", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Mirroring", ...)
end

do
    function PrivateField.ChangePlayerToTaintedVersion(player)
        local playerType = player:GetPlayerType()
        if playerType == PlayerType.PLAYER_ISAAC then
            local historyItems = player:GetHistory():GetCollectiblesHistory()
            player:ChangePlayerType(PlayerType.PLAYER_ISAAC_B)
            local count, limit = 0, player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 15 or 9
            for index = #historyItems, 1, -1 do
                local item = historyItems[index]
                local itemID = item:GetItemID()
                local collectibleConfig = TYU.ITEMCONFIG:GetCollectible(itemID)
                if not item:IsTrinket() and not collectibleConfig:HasTags(ItemConfig.TAG_QUEST) and collectibleConfig.Type ~= ItemType.ITEM_ACTIVE and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT then
                    if count < limit then
                        player:DropCollectible(itemID)
                        count = count + 1
                    end
                    player:RemoveCollectible(itemID)
                end
            end
            for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                local pickup = ent:ToPickup()
                if pickup.FrameCount <= 1 then
                    pickup:AddCollectibleCycle(Collectibles.GetCollectibleFromCurrentRoom(nil, player:GetCollectibleRNG(pickup.SubType)))
                end  
            end
        elseif playerType == PlayerType.PLAYER_JUDAS or playerType == PlayerType.PLAYER_BLACKJUDAS then
            local health = player:GetMaxHearts() + player:GetSoulHearts()
            SetPlayerLibData(player, playerType == PlayerType.PLAYER_BLACKJUDAS, "BlackJudas")
            player:ChangePlayerType(PlayerType.PLAYER_JUDAS_B)
            player:AddSoulHearts(-99)
            player:AddBlackHearts(health)
        elseif playerType == PlayerType.PLAYER_BLUEBABY then
            local bombCount = player:GetNumBombs()
            player:ChangePlayerType(PlayerType.PLAYER_BLUEBABY_B)
            for i = 1, bombCount do
                Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType.POOP_SMALL, Utils.FindFreePickupSpawnPosition(player.Position))
            end
        elseif playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THESOUL then
            player:ChangePlayerType(PlayerType.PLAYER_THEFORGOTTEN_B)
        elseif playerType == PlayerType.PLAYER_BETHANY then
            local charge = player:GetMaxHearts()
            local health = math.max(2, player:GetSoulCharge())
            player:ChangePlayerType(PlayerType.PLAYER_BETHANY_B)
            player:AddMaxHearts(-99)
            player:AddHearts(-99)
            player:AddSoulHearts(-99)
            player:AddSoulHearts(health)
            player:AddBloodCharge(charge)
        else
            player:ChangePlayerType(EntityConfig.GetPlayer(playerType):GetTaintedCounterpart():GetPlayerType())
        end
    end
end

function Mirroring:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local playerType = player:GetPlayerType()
    local playerConfig = EntityConfig.GetPlayer(playerType)
    if playerType == PlayerType.PLAYER_ESAU or playerType == PlayerType.PLAYER_LAZARUS2 or playerType == PlayerType.PLAYER_LAZARUS2_B or playerType == ModPlayerIDs.WARFARIN or not playerConfig:GetTaintedCounterpart() then
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_BREAK)
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, Utils.FindFreePickupSpawnPosition(player.Position))
        return { Discharge = false, Remove = true, ShowAnim = true }
    end
    if playerConfig:IsTainted() then
        player:RemoveCollectible(ModItemIDs.MIRRORING, false, activeSlot)
        player:AddCollectible(ModItemIDs.MIRRORING_SHARD, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        return { Discharge = false, Remove = false, ShowAnim = true }
    else
        local room = TYU.GAME:GetRoom()
        PrivateField.ChangePlayerToTaintedVersion(player)
        player:RemoveCollectible(ModItemIDs.MIRRORING, false, activeSlot)
        player:AddCollectible(ModItemIDs.MIRRORING_SHARD, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_ENTER)
        player:AnimateSad()
        TYU.SFXMANAGER:Stop(SoundEffect.SOUND_THUMBS_DOWN)
        TYU.GAME:ShowHallucination(5, room:GetBackdropType())
        TYU.SFXMANAGER:Stop(SoundEffect.SOUND_DEATH_CARD)
        return { Discharge = true, Remove = false, ShowAnim = false }    
    end
end
Mirroring:AddCallback(ModCallbacks.MC_USE_ITEM, Mirroring.UseItem, ModItemIDs.MIRRORING)

function Mirroring:PostUpdate()
    if TYU.LEVEL:GetStage() ~= LevelStage.STAGE1_2 or TYU.LEVEL:GetCurrentRoomDesc().Data.Variant < 10000 or not TYU.LEVEL:GetStateFlag(LevelStateFlag.STATE_MIRROR_BROKEN) or GetGlobalLibData() then
        return
    end
    local room = TYU.GAME:GetRoom()
    local targetPos = nil
    for _, v in pairs({60, 74}) do
        local door = room:GetGridEntity(v)
        if door and door:ToDoor() and door:ToDoor().TargetRoomIndex == GridRooms.ROOM_MIRROR_IDX and door.Desc.Variant == 8 then
            targetPos = room:GetGridPosition(v)
            break
        end
    end
    if targetPos then
        local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.MIRRORING)
        if rng:RandomInt(100) < 25 then
            Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ModItemIDs.MIRRORINGBROKEN, room:FindFreePickupSpawnPosition(targetPos))
        end
    end
    SetGlobalLibData(true)
end
Mirroring:AddCallback(ModCallbacks.MC_POST_UPDATE, Mirroring.PostUpdate)

return Mirroring