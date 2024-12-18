local Lib = TYU
local Mirroring = Lib:NewModItem("Mirroring", "MIRRORING")

local function ChangePlayerToTaintedVersion(player)
    local room = Lib.GAME:GetRoom()
    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_ISAAC then
        local historyItems = player:GetHistory():GetCollectiblesHistory()
        player:ChangePlayerType(PlayerType.PLAYER_ISAAC_B)
        local count, limit = 0, player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 15 or 9
        for index = #historyItems, 1, -1 do
            local item = historyItems[index]
            local itemID = item:GetItemID()
            local collectibleConfig = Lib.ITEMCONFIG:GetCollectible(itemID)
            if not item:IsTrinket() and not collectibleConfig:HasTags(ItemConfig.TAG_QUEST) and collectibleConfig.Type ~= ItemType.ITEM_ACTIVE and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT then
                if count < limit then
                    player:DropCollectible(itemID)
                    count = count + 1
                end
                player:RemoveCollectible(itemID)
            end
        end
        for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            local pickup = ent:ToPickup()
            if pickup.FrameCount <= 1 then
                pickup:AddCollectibleCycle(Lib.Collectibles.GetCollectibleFromCurrentRoom(nil, player:GetCollectibleRNG(pickup.SubType)))
            end  
        end
    elseif playerType == PlayerType.PLAYER_JUDAS or playerType == PlayerType.PLAYER_BLACKJUDAS then
        local health = player:GetMaxHearts() + player:GetSoulHearts()
        Lib:SetPlayerLibData(player, playerType == PlayerType.PLAYER_BLACKJUDAS, "Mirroring", "BlackJudas")
        player:ChangePlayerType(PlayerType.PLAYER_JUDAS_B)
        player:AddSoulHearts(-99)
        player:AddBlackHearts(health)
    elseif playerType == PlayerType.PLAYER_BLUEBABY then
        local bombCount = player:GetNumBombs()
        player:ChangePlayerType(PlayerType.PLAYER_BLUEBABY_B)
        for i = 1, bombCount do
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType.POOP_SMALL, room:FindFreePickupSpawnPosition(player.Position, 0, true))
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

function Mirroring:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local room = Lib.GAME:GetRoom()
    local playerType = player:GetPlayerType()
    local playerConfig = EntityConfig.GetPlayer(playerType)
    if playerType == PlayerType.PLAYER_ESAU or playerType == PlayerType.PLAYER_LAZARUS2 or playerType == PlayerType.PLAYER_LAZARUS2_B or playerType== Lib.ModPlayerIDs.WARFARIN or not playerConfig:GetTaintedCounterpart() then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_BREAK)
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, room:FindFreePickupSpawnPosition(player.Position))
        return { Discharge = false, Remove = true, ShowAnim = true }
    end
    if playerConfig:IsTainted() then
        player:RemoveCollectible(Lib.ModItemIDs.MIRRORING, false, activeSlot)
        player:AddCollectible(Lib.ModItemIDs.MIRRORING_SHARD, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        return { Discharge = false, Remove = false, ShowAnim = true }
    else
        ChangePlayerToTaintedVersion(player)
        player:RemoveCollectible(Lib.ModItemIDs.MIRRORING, false, activeSlot)
        player:AddCollectible(Lib.ModItemIDs.MIRRORING_SHARD, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_ENTER)
        player:AnimateSad()
        Lib.SFXMANAGER:Stop(SoundEffect.SOUND_THUMBS_DOWN)
        Lib.GAME:ShowHallucination(5, room:GetBackdropType())
        Lib.SFXMANAGER:Stop(SoundEffect.SOUND_DEATH_CARD)
        return { Discharge = true, Remove = false, ShowAnim = false }    
    end
end
Mirroring:AddCallback(ModCallbacks.MC_USE_ITEM, Mirroring.UseItem, Lib.ModItemIDs.MIRRORING)

function Mirroring:PostUpdate()
    if Lib.LEVEL:GetStage() ~= LevelStage.STAGE1_2 or Lib.LEVEL:GetCurrentRoomDesc().Data.Variant < 10000 or not Lib.LEVEL:GetStateFlag(LevelStateFlag.STATE_MIRROR_BROKEN) or Lib:GetGlobalLibData("Mirroring") then
        return
    end
    local room = Lib.GAME:GetRoom()
    local targetPos
    for _, v in pairs({60, 74}) do
        local door = room:GetGridEntity(v)
        if door and door:ToDoor() and door:ToDoor().TargetRoomIndex == GridRooms.ROOM_MIRROR_IDX and door.Desc.Variant == 8 then
            targetPos = room:GetGridPosition(v)
            break
        end
    end
    if targetPos then
        local rng = Isaac.GetPlayer(0):GetCollectibleRNG(Lib.ModItemIDs.MIRRORING)
        if rng:RandomInt(100) < 25 then
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ModItemIDs.MIRRORINGBROKEN, room:FindFreePickupSpawnPosition(targetPos))
        end
    end
    Lib:SetGlobalLibData(true, "Mirroring")
end
Mirroring:AddCallback(ModCallbacks.MC_POST_UPDATE, Mirroring.PostUpdate)

return Mirroring