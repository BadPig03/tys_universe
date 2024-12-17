local Lib = TYU
local Guilt = Lib:NewModItem("Guilt", "GUILT")

local qualityTranslation = {
    [0] = "零",
    [1] = "一",
    [2] = "二",
    [3] = "三",
    [4] = "四"
}

local function RemoveItemsAndDisplay()
    local rng = Lib.LEVEL:GetDevilAngelRoomRNG()
    local item = Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, false, rng:Next(), CollectibleType.COLLECTIBLE_SAD_ONION)
    if item ~= CollectibleType.COLLECTIBLE_SAD_ONION then
        local quality = Lib.ITEMCONFIG:GetCollectible(item).Quality
        Lib.ITEMPOOL:RemoveCollectible(item)
        if Options.Language == "zh" then
            Lib.HUD:ShowFortuneText("一个品质"..qualityTranslation[quality].."级的道具被移除!")
        else
            Lib.HUD:ShowFortuneText("An item of quality "..quality ,"has been removed")
        end
    end
end

local function ReplaceDevilRoom()
    Lib.LEVEL:InitializeDevilAngelRoom(false, true)
    local rng = Isaac.GetPlayer(0):GetCollectibleRNG(Lib.ModItemIDs.GUILT)
    if #Lib.ModRoomIDs.GUILTDEVILROOMS == 0 then
        Lib.SaveAndLoad.ReloadRoomData()
    end
    local roomList = WeightedOutcomePicker()
    for _, id in ipairs(Lib.ModRoomIDs.GUILTDEVILROOMS) do
        roomList:AddOutcomeWeight(id, 1)
    end
    local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DEVIL, roomList:PickOutcome(rng))
    Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data = newRoom
end

function Guilt:PostNewLevel()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.GUILT) then
        return
    end
    ReplaceDevilRoom()
end
Guilt:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Guilt.PostNewLevel)

function Guilt:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if firstTime then
        Lib.GAME:AddDevilRoomDeal()
        Lib.GAME:AddDevilRoomDeal()
        if Lib.LEVEL:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data == nil then
            ReplaceDevilRoom()
        end
    end
end
Guilt:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Guilt.PostAddCollectible, Lib.ModItemIDs.GUILT)

function Guilt:PostPlayerNewRoomTempEffects(player)
    if not Lib.LEVEL:CanSpawnDevilRoom() or not player:HasCollectible(Lib.ModItemIDs.GUILT) or Lib.GAME:GetRoom():IsMirrorWorld() or Lib.LEVEL:GetCurrentRoomIndex() ~= Lib.LEVEL:GetStartingRoomIndex() or not Lib.GAME:GetRoom():IsFirstVisit() or Lib.LEVEL:IsAscent() or Isaac.GetChallenge() == Challenge.CHALLENGE_BACKASSWARDS then
        return
    end
    local oldCount = Lib:GetGlobalLibData("Guilt", "Count") or 0
    local currentCount = Lib.GAME:GetDevilRoomDeals()
    local differ = currentCount - oldCount
    if differ < 2 then
        for i = 1, 2 * (2 - differ) do
            Lib.Entities.CreateTimer(function() RemoveItemsAndDisplay() end, 15 + 60 * (i - 1), 0, true)
        end
    end
    Lib:SetGlobalLibData(currentCount, "Guilt", "Count")
end
Guilt:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Guilt.PostPlayerNewRoomTempEffects)

function Guilt:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    Lib:SetGlobalLibData(0, "Guilt", "Count")
end
Guilt:AddCallback(ModCallbacks.MC_USE_ITEM, Guilt.UseItem, CollectibleType.COLLECTIBLE_R_KEY)

function Guilt:PostDevilCalculate(chance)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.GUILT) then
        return
    end
    return chance + math.max(0, (Lib.GAME:GetDevilRoomDeals() - 2)) * 0.05
end
Guilt:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, Guilt.PostDevilCalculate)

function Guilt:PostNPCDeath(npc)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.GUILT) or npc.Variant ~= 1 then
        return
    end
    local room = Lib.GAME:GetRoom()
    local rng = npc:GetDropRNG()
    for i = 1, 2 do
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, true, rng:Next()), room:FindFreePickupSpawnPosition(npc.Position, 0, true, false))
    end
end
Guilt:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Guilt.PostNPCDeath, EntityType.ENTITY_FALLEN)

return Guilt