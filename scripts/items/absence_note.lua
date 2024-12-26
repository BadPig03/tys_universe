local AbsenceNote = TYU:NewModItem("Absence Note", "ABSENCE_NOTE")

local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do -- 私有方法
    -- 获得初始的波数
    function PrivateField.GetWaves()
        return {
            BossChallenge = 2,
            Bossrush = 15,
            Challenge = 3
        }
    end

    -- 获取床的具体生成位置
    function PrivateField.GetBedPosition()
        if Utils.IsRoomType(RoomType.ROOM_CHALLENGE) then -- 普通挑战房
            return Utils.FindFreePickupSpawnPosition(Vector(520, 200))
        elseif Utils.IsRoomBossChallenge() then -- 头目挑战房
            return Utils.FindFreePickupSpawnPosition(Vector(580, 220))
        elseif Utils.IsRoomType(RoomType.ROOM_BOSSRUSH) then -- 头目车轮战房
            return Utils.FindFreePickupSpawnPosition(Vector(900, 400)) 
        else
            return nil
        end
    end

    -- 计算波数，算法为波数除2后向上取整
    function PrivateField.CalculateNewWaves(num)
        return math.ceil(num / 2)
    end

    -- 设置波数
    function PrivateField.SetWaves()
        local waves = PrivateField.GetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(PrivateField.CalculateNewWaves(waves.BossChallenge))
        TYU.AMBUSH.SetMaxBossrushWaves(PrivateField.CalculateNewWaves(waves.Bossrush))
        TYU.AMBUSH.SetMaxChallengeWaves(PrivateField.CalculateNewWaves(waves.Challenge))
    end

    -- 重置波数
    function PrivateField.ResetWaves()
        local waves = PrivateField.GetWaves()
        TYU.AMBUSH.SetMaxBossChallengeWaves(waves.BossChallenge)
        TYU.AMBUSH.SetMaxBossrushWaves(waves.Bossrush)
        TYU.AMBUSH.SetMaxChallengeWaves(waves.Challenge)
    end
end

-- 回调：检测是否进入了新房间
-- 当进入指定的房间类型时，在对应位置上生成一张床
function AbsenceNote:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.ABSENCE_NOTE) or not Utils.IsRoomFirstVisit() then
        return -- 如果没有角色拥有请假条，或者房间并非第一次进入，则返回
    end

    local bedPosition = PrivateField.GetBedPosition() -- 获取床的具体位置
    if bedPosition then -- 对指定的3种房间类型外无效
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BED, 0, bedPosition)
    end
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, AbsenceNote.PostNewRoom)

-- 回调：检测玩家是否获得了赎罪券
-- 获得赎罪券后设置成对应的波数
function AbsenceNote:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    PrivateField.SetWaves()
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, AbsenceNote.PostAddCollectible, ModItemIDs.ABSENCE_NOTE)

-- 回调：检测玩家是否失去了赎罪券
-- 失去赎罪券后重置为初始的波数
function AbsenceNote:PostTriggerCollectibleRemoved(player, collectibleType)
    PrivateField.ResetWaves()
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, AbsenceNote.PostTriggerCollectibleRemoved, ModItemIDs.ABSENCE_NOTE)

-- 回调：检测游戏是否重新开始
-- 由于R门的bug，目前游戏重新开始后波数不会重置，需要手动重置一次
function AbsenceNote:PostGameStarted(continued)
    if not continued then
        PrivateField.ResetWaves()
    end
end
AbsenceNote:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, AbsenceNote.PostGameStarted)

return AbsenceNote