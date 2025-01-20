local Guilt = TYU:NewModItem("Guilt", "GUILT")

local Entities = TYU.Entities
local Players = TYU.Players
local SaveAndLoad = TYU.SaveAndLoad
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModRoomIDs = TYU.ModRoomIDs

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Guilt", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Guilt", ...)
end

do
    PrivateField.QualityTranslation = {
        [0] = "零",
        [1] = "一",
        [2] = "二",
        [3] = "三",
        [4] = "四"
    }

    function PrivateField.RemoveItemsAndDisplay()
        local rng = TYU.LEVEL:GetDevilAngelRoomRNG()
        local item = TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, false, rng:Next(), CollectibleType.COLLECTIBLE_SAD_ONION)
        if item == CollectibleType.COLLECTIBLE_SAD_ONION then
            return
        end
        local quality = TYU.ITEMCONFIG:GetCollectible(item).Quality
        if Options.Language == "zh" then
            TYU.HUD:ShowFortuneText("一个品质"..PrivateField.QualityTranslation[quality].."级的道具被移除!")
        else
            TYU.HUD:ShowFortuneText("An item of quality "..quality ,"has been removed")
        end
        TYU.ITEMPOOL:RemoveCollectible(item)
    end

    function PrivateField.ReplaceDevilRoom()
        TYU.LEVEL:InitializeDevilAngelRoom(false, true)
        local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.GUILT)
        if #ModRoomIDs.GUILT_DEVIL_ROOMS == 0 then
            SaveAndLoad.ReloadRoomData()
        end
        local roomList = WeightedOutcomePicker()
        for _, id in ipairs(ModRoomIDs.GUILT_DEVIL_ROOMS) do
            roomList:AddOutcomeWeight(id, 1)
        end
        local newRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DEVIL, roomList:PickOutcome(rng))
        TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data = newRoom
    end
end

function Guilt:PostNewLevel()
    if not Players.AnyoneHasCollectible(ModItemIDs.GUILT) or TYU.GAME:IsGreedMode() then
        return
    end
    PrivateField.ReplaceDevilRoom()
end
Guilt:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Guilt.PostNewLevel)

function Guilt:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if TYU.GAME:IsGreedMode() then
        return
    end
    if not firstTime then
        return
    end
    for i = 1, 2 do
        TYU.GAME:AddDevilRoomDeal()
    end
    if TYU.LEVEL:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data == nil then
        PrivateField.ReplaceDevilRoom()
    end
end
Guilt:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Guilt.PostAddCollectible, ModItemIDs.GUILT)

function Guilt:PostPlayerNewRoomTempEffects(player)
    if not TYU.LEVEL:CanSpawnDevilRoom() or not player:HasCollectible(ModItemIDs.GUILT) or Utils.IsMirrorWorld() or not Utils.IsStartingRoom() or not Utils.IsRoomFirstVisit() or Utils.IsAscent() or Isaac.GetChallenge() == Challenge.CHALLENGE_BACKASSWARDS or TYU.GAME:IsGreedMode() then
        return
    end
    local oldCount = GetGlobalLibData("Count") or 0
    local currentCount = TYU.GAME:GetDevilRoomDeals()
    local differ = currentCount - oldCount
    if differ < 2 then
        for i = 1, 2 * (2 - differ) do
            Utils.CreateTimer(function()
                PrivateField.RemoveItemsAndDisplay()
            end, 15 + 60 * (i - 1), 0, true)
        end
    end
    SetGlobalLibData(currentCount, "Count")
end
Guilt:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, Guilt.PostPlayerNewRoomTempEffects)

function Guilt:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    SetGlobalLibData(0, "Count")
end
Guilt:AddCallback(ModCallbacks.MC_USE_ITEM, Guilt.UseItem, CollectibleType.COLLECTIBLE_R_KEY)

function Guilt:PostDevilCalculate(chance)
    if not Players.AnyoneHasCollectible(ModItemIDs.GUILT) then
        return
    end
    return chance + math.max(0, (TYU.GAME:GetDevilRoomDeals() - 2)) * 0.05
end
Guilt:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, Guilt.PostDevilCalculate)

function Guilt:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(ModItemIDs.GUILT) or npc.Variant ~= 1 then
        return
    end
    local rng = npc:GetDropRNG()
    for i = 1, 2 do
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, TYU.ITEMPOOL:GetCollectible(ItemPoolType.POOL_DEVIL, true, rng:Next()), Utils.FindFreePickupSpawnPosition(npc.Position))
    end
end
Guilt:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Guilt.PostNPCDeath, EntityType.ENTITY_FALLEN)

return Guilt