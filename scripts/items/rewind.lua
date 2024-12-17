local Lib = TYU
local Rewind = Lib:NewModItem("Rewind", "REWIND")

local roomTypeName = {
    [RoomType.ROOM_SHOP] = 'shop',
    [RoomType.ROOM_ERROR] = 'error',
    [RoomType.ROOM_TREASURE] = 'treasure',
    [RoomType.ROOM_BOSS] = 'boss',
    [RoomType.ROOM_MINIBOSS] = 'miniboss',
    [RoomType.ROOM_SECRET] = 'secret',
    [RoomType.ROOM_SUPERSECRET] = 'supersecret',
    [RoomType.ROOM_ARCADE] = 'arcade',
    [RoomType.ROOM_CURSE] = 'curse',
    [RoomType.ROOM_CHALLENGE] = 'challenge',
    [RoomType.ROOM_LIBRARY] = 'library',
    [RoomType.ROOM_SACRIFICE] = 'sacrifice',
    [RoomType.ROOM_DEVIL] = 'devil',
    [RoomType.ROOM_ANGEL] = 'angel',
    [RoomType.ROOM_ISAACS] = 'isaacs',
    [RoomType.ROOM_BARREN] = 'barren',
    [RoomType.ROOM_CHEST] = 'chest',
    [RoomType.ROOM_DICE] = 'dice',
    [RoomType.ROOM_BLACK_MARKET] = 'blackmarket',
    [RoomType.ROOM_PLANETARIUM] = 'planetarium',
    [RoomType.ROOM_ULTRASECRET] = 'ultrasecret'
}

local bossRoomVariant = {
	[1] = {
		[0] = {1010, 1011, 1012, 1013, 1019, 1020, 1021, 1022, 1023, 1029, 1035, 1036, 1088, 1089, 1095, 1096, 1117, 1118, 1119, 1120, 2010, 2011, 2012, 2013, 2050, 2051, 2052, 2053, 2070, 2071, 2072, 2073, 4010, 4011, 4012, 4013, 5020, 5021, 5022, 5023, 5140, 5141, 5142, 5143, 5146, 5147, 5148, 5149, 5160, 5161, 5162, 5163},
		[1] = {1019, 1029, 1035, 1036, 1088, 1089, 1095, 1096, 2010, 2011, 2012, 2013, 3320, 3321, 3322, 3323, 3340, 3341, 3342, 3343, 3370, 3371, 3372, 3373, 4010, 4011, 4012, 4013, 5010, 5011, 5012, 5013, 5160, 5161, 5162, 5163},
		[2] = {1010, 1011, 1012, 1013, 1019, 1020, 1021, 1022, 1023, 1029, 1035, 1036, 1088, 1089, 1095, 1096, 2010, 2011, 2012, 2013, 4010, 4011, 4012, 4013, 5010, 5011, 5012, 5013, 5140, 5141, 5142, 5143, 5160, 5161, 5162, 5163},
		[4] = {5170, 5171, 5172, 5173, 5180, 5181, 5182, 5183, 5230, 5231, 5232, 5233, 5280, 5281, 5282, 5283},
		[5] = {5170, 5171, 5172, 5173, 5180, 5181, 5182, 5183, 5190, 5191, 5192, 5193, 5320, 5321, 5322, 5322, 5330, 5330, 5330, 5330}
	},
	[2] = {
		[0] = {1030, 1031, 1032, 1033, 1040, 1041, 1042, 1043, 1079, 1085, 1086, 1087, 1100, 1101, 1102, 1103, 1106, 1107, 1108, 1109, 2020, 2021, 2022, 2023, 2060, 2061, 2062, 2063, 3280, 3281, 3282, 3283, 3384, 3385, 3386, 3387, 3394, 3395, 3396, 3397, 3398, 3399, 3404, 3405, 4020, 4021, 4022, 4023, 5030, 5031, 5032, 5033, 5050, 5051, 5052, 5053, 5080, 5081, 5082, 5083, 5270, 5271, 5272, 5273},
		[1] = {1079, 1085, 1086, 1087, 2020, 2021, 2022, 2023, 3260, 3261, 3262, 3263, 3270, 3271, 3272, 3273, 3280, 3281, 3282, 3283, 3290, 3291, 3292, 3293, 3360, 3361, 3362, 3363, 3384, 3385, 3386, 3387, 3394, 3395, 3396, 3397, 3398, 3399, 3404, 3405, 4020, 4021, 4022, 4023, 5080, 5081, 5082, 5083, 5100, 5101, 5102, 5103, 5270, 5271, 5272, 5273}, 
		[2] = {1030, 1031, 1032, 1033, 1040, 1041, 1042, 1043, 1079, 1085, 1086, 1087, 1100, 1101, 1102, 1103, 1106, 1107, 1108, 1109, 2020, 2021, 2022, 2023, 3280, 3281, 3282, 3283, 3384, 3385, 3386, 3387, 3394, 3395, 3396, 3397, 3398, 3399, 3404, 3405, 4020, 4021, 4022, 4023, 5080, 5081, 5082, 5083, 5270, 5271, 5272, 5273},
		[4] = {5200, 5201, 5202, 5203, 5210, 5211, 5212, 5213, 5220, 5221, 5222, 5223, 5250, 5251, 5253, 5254},
		[5] = {5210, 5211, 5212, 5213, 5240, 5241, 5242, 5243, 5260, 5261, 5262, 5263, 5310, 5311, 5312, 5313, 6020, 6021, 6022, 6022}
	},
	[3] = {
		[0] = {1050, 1051, 1052, 1053, 1110, 1111, 1112, 1113, 1097, 1098, 1099, 1105, 2030, 2031, 2032, 2033, 3406, 3407, 3408, 3409, 4030, 4034, 4035, 4036, 5040, 5041, 5042, 5043, 5060, 5061, 5062, 5063, 5090, 5091, 5092, 5093, 5250, 5251, 5252, 5253},
		[1] = {1097, 1098, 1099, 1105, 2030, 2031, 2032, 2033, 3406, 3407, 3408, 3409, 3350, 3351, 3352, 3353, 4030, 4034, 4035, 4036, 5040, 5041, 5042, 5043, 5090, 5091, 5092, 5093, 5240, 5241, 5242, 5243},
		[2] = {1050, 1051, 1052, 1053, 1110, 1111, 1112, 1113, 1097, 1098, 1099, 1105, 2030, 2031, 2032, 2033, 3406, 3407, 3408, 3409, 4030, 4034, 4035, 4036, 5040, 5041, 5042, 5043, 5060, 5061, 5062, 5063, 5090, 5091, 5092, 5093, 5250, 5251, 5252, 5253},
		[4] = {5370, 5371, 5372, 5372, 5290, 5291, 5292, 5293},
		[5] = {5300, 5300, 5301, 5301, 6010, 6011, 6012, 6012}
	},
	[4] = {
		[0] = {1070, 1071, 1072, 1073, 2040, 2041, 2042, 2043, 3300, 3301, 3302, 3303, 3310, 3311, 3312, 3313, 3330, 3331, 3332, 3333, 3400, 3401, 3402, 3403, 3406, 3407, 3408, 3409, 3410, 3411, 3412, 3413, 4031, 4032, 4033, 4033, 4040, 4041, 4042, 4043, 5070, 5071, 5072, 5072, 5110, 5111, 5113, 5113, 5152, 5153, 5154, 5155},
		[1] = {2040, 2041, 2042, 2043, 3300, 3301, 3302, 3303, 3310, 3311, 3312, 3313, 3330, 3331, 3332, 3333, 3400, 3401, 3402, 3403, 3406, 3407, 3408, 3409, 3410, 3411, 3412, 3413, 4031, 4032, 4033, 4033, 4040, 4041, 4042, 4043, 5070, 5071, 5072, 5072, 5110, 5111, 5113, 5113, 5152, 5153, 5154, 5155},
		[2] = {2040, 2041, 2042, 2043, 3300, 3301, 3302, 3303, 3310, 3311, 3312, 3313, 3330, 3331, 3332, 3333, 3400, 3401, 3402, 3403, 3406, 3407, 3408, 3409, 3410, 3411, 3412, 3413, 4031, 4032, 4033, 4033, 4040, 4041, 4042, 4043, 5070, 5071, 5072, 5072, 5110, 5111, 5113, 5113, 5152, 5153, 5154, 5155},
		[4] = {5360, 5361, 5362, 5362, 5350, 5351, 5352, 5352}
	},
	[10] = {
		[0] = {3380, 3381, 3382, 3383},
		[1] = {3600}
	},
	[11] = {
		[0] = {5130},
		[1] = {3390, 3391, 3392, 3393}
	},
	[12] = {
		[0] = {1010, 1011, 1012, 1013, 1019, 1020, 1021, 1022, 1023, 1029, 1030, 1031, 1032, 1033, 1035, 1036, 1040, 1041, 1042, 1043, 1050, 1051, 1052, 1053, 1070, 1071, 1072, 1073, 1079, 1085, 1086, 1087, 1088, 1089, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1117, 1118, 1119, 1120, 2010, 2011, 2012, 2013, 2020, 2021, 2022, 2023, 2030, 2031, 2032, 2033, 2040, 2041, 2042, 2043, 2050, 2051, 2052, 2053, 2060, 2061, 2062, 2063, 2070, 2071, 2072, 2073, 3260, 3261, 3262, 3263, 3270, 3271, 3272, 3273, 3280, 3281, 3282, 3283, 3290, 3291, 3292, 3293, 3300, 3301, 3302, 3303, 3310, 3311, 3312, 3313, 3320, 3321, 3322, 3323, 3330, 3331, 3332, 3333, 3340, 3341, 3342, 3343, 3350, 3351, 3352, 3353, 3360, 3361, 3362, 3363, 3370, 3371, 3372, 3373, 3380, 3381, 3382, 3383, 3384, 3385, 3386, 3387, 3390, 3391, 3392, 3393, 3394, 3395, 3396, 3397, 3398, 3399, 3400, 3401, 3402, 3403, 3404, 3405, 3406, 3407, 3408, 3409, 3410, 3411, 3412, 3413, 3600, 4010, 4011, 4012, 4013, 4020, 4021, 4022, 4023, 4030, 4031, 4032, 4033, 4034, 4035, 4036, 4040, 4041, 4042, 4043, 5010, 5011, 5012, 5013, 5020, 5021, 5022, 5023, 5030, 5031, 5032, 5033, 5040, 5041, 5042, 5043, 5050, 5051, 5052, 5053, 5060, 5061, 5062, 5063, 5070, 5071, 5072, 5080, 5081, 5082, 5083, 5090, 5091, 5092, 5093, 5100, 5101, 5102, 5103, 5110, 5111, 5113, 5130, 5140, 5141, 5142, 5143, 5146, 5147, 5148, 5149, 5152, 5153, 5154, 5155, 5160, 5161, 5162, 5163, 5240, 5241, 5242, 5243, 5250, 5251, 5252, 5253, 5270, 5271, 5272, 5273}
	}
}

local function TeleportToRoom(id, player, rng)
    if id == RoomType.ROOM_SHOP then
        local roomID = 0
        if Lib.Players.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B) then
            roomID = RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 7, 13).Variant
        else
            roomID = RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 6).Variant
        end
        Isaac.ExecuteCommand("goto s.shop."..roomID)
    elseif id == RoomType.ROOM_ERROR then
        Isaac.ExecuteCommand("goto s.error."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 32).Variant)
    elseif id == RoomType.ROOM_TREASURE then
        Isaac.ExecuteCommand("goto s.treasure."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 55).Variant)
    elseif id == RoomType.ROOM_BOSS then
        local index = -1
		local roomList = {}
		local stage = Lib.LEVEL:GetStage()
        local stageType = Lib.LEVEL:GetStageType()
		if stage <= LevelStage.STAGE4_2 then
			roomList = bossRoomVariant[math.ceil(stage / 2)][stageType]
			index = roomList[rng:RandomInt(#roomList) + 1]
		elseif stage == LevelStage.STAGE4_3 then
			Isaac.ExecuteCommand("goto x.boss")
		elseif stage >= LevelStage.STAGE5 and stage <= LevelStage.STAGE7 then
			roomList = bossRoomVariant[stage][stageType]
			index = roomList[rng:RandomInt(#roomList) + 1]
		elseif stage == LevelStage.STAGE8 then
			Isaac.ExecuteCommand("goto x.itemdungeon.666")
		end
		if index ~= -1 then
			Isaac.ExecuteCommand("goto s.boss."..index)
        else
            return -1
		end
    elseif id == RoomType.ROOM_MINIBOSS then
        Isaac.ExecuteCommand("goto s.miniboss."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 2000, 2262).Variant)
    elseif id == RoomType.ROOM_SECRET then
        Isaac.ExecuteCommand("goto s.secret."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 38).Variant)
    elseif id == RoomType.ROOM_SUPERSECRET then
        Isaac.ExecuteCommand("goto s.supersecret."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 32).Variant)
    elseif id == RoomType.ROOM_ARCADE then
        Isaac.ExecuteCommand("goto s.arcade."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 40).Variant)
    elseif id == RoomType.ROOM_CURSE then
        Isaac.ExecuteCommand("goto s.curse."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 30).Variant)
    elseif id == RoomType.ROOM_CHALLENGE then
		if Lib:GetGlobalLibData("Rewind", "ChallengeTriggered") then
			return -1
		else
			Lib:SetGlobalLibData(true, "Rewind", "ChallengeTriggered")
            if rng:RandomInt(100) < 50 then
                Isaac.ExecuteCommand("goto s.challenge."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 14).Variant)
            else
                Isaac.ExecuteCommand("goto s.challenge."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 16, 23).Variant)
            end    
		end
    elseif id == RoomType.ROOM_DEVIL then
        Isaac.ExecuteCommand("goto s.devil."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 23).Variant)
    elseif id == RoomType.ROOM_ANGEL then
        Isaac.ExecuteCommand("goto s.angel."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 21).Variant)
    elseif id == RoomType.ROOM_ISAACS then
        Isaac.ExecuteCommand("goto s.isaacs."..RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id, RoomShape.NUM_ROOMSHAPES, 0, 29).Variant)
    else
		local roomConfigRoom = RoomConfigHolder.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, id)
		Isaac.ExecuteCommand("goto s."..roomTypeName[id].."."..roomConfigRoom.Variant)
    end
    Lib.GAME:StartRoomTransition(GridRooms.ROOM_DEBUG_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, 0)
    return 0
end

function Rewind:PostNewRoom()
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    if Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_DEBUG_IDX and room:IsFirstVisit() and roomTypeName[roomType] then
        local count = Lib:GetGlobalLibData("Rewind", "Rooms", tostring(roomType)) or 0
        Lib:SetGlobalLibData(count + 1, "Rewind", "Rooms", tostring(roomType))
    end
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.REWIND) or Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_DEBUG_IDX then
		return
	end
    for i = 0, 7 do
        local door = room:GetDoor(i)
        if door and door.TargetRoomIndex == GridRooms.ROOM_DEBUG_IDX then
            door.TargetRoomIndex = Lib.LEVEL:GetStartingRoomIndex()
        end
    end
    if roomType == RoomType.ROOM_BLACK_MARKET then
        if Lib.LEVEL:MakeRedRoomDoor(GridRooms.ROOM_DEBUG_IDX, DoorSlot.LEFT0) then
            local door = Lib.GAME:GetRoom():GetDoor(DoorSlot.LEFT0)
            door.TargetRoomIndex = Lib.LEVEL:GetStartingRoomIndex()
        else
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_FOOL, Vector(200, 280))
        end
    end
    if roomType == RoomType.ROOM_CHALLENGE and Lib.LEVEL:GetCurrentRoomDesc().Data.Variant >= 16 then
        for i = 0, 7 do
            local door = room:GetDoor(i)
            if door then
                local sprite = door:GetSprite()
                sprite:Load("gfx/grid/door_09_bossambushroomdoor.anm2", true)
                sprite:Play("Opened")
            end
		end
	end
end
Rewind:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Rewind.PostNewRoom)

function Rewind:PostNewLevel()
	Lib:SetGlobalLibData(false, "Rewind", "ChallengeTriggered")
end
Rewind:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Rewind.PostNewLevel)

function Rewind:PostEffectInit(effect)
	local room = Lib.GAME:GetRoom()
	if Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_DEBUG_IDX or room:GetType() ~= RoomType.ROOM_SHOP then
        return
	end
    effect:Remove()
end
Rewind:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, Rewind.PostEffectInit, EffectVariant.TALL_LADDER)

function Rewind:PostGridEntityDoorUpdate(door)
	local room = Lib.GAME:GetRoom()
	if Lib.LEVEL:GetCurrentRoomIndex() ~= GridRooms.ROOM_DEBUG_IDX or not room:IsClear() or door:IsOpen() then
        return
	end
    local roomType = room:GetType()
    if roomType ~= RoomType.ROOM_SECRET and roomType ~= RoomType.ROOM_SUPERSECRET and roomType ~= RoomType.ROOM_ULTRASECRET then
        return
    end
    door:TryBlowOpen(true, nil)
end
Rewind:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, Rewind.PostGridEntityDoorUpdate, GridEntityType.GRID_DOOR)

function Rewind:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
	if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or Lib.LEVEL:GetCurrentRoomIndex() <= GridRooms.ROOM_DEVIL_IDX or Lib.LEVEL:GetAbsoluteStage() == LevelStage.STAGE8 or Lib.LEVEL:GetDimension() > Dimension.NORMAL or Lib.GAME:IsGreedMode() then
		return { Discharge = false, Remove = false, ShowAnim = true }
	end
    if activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and rng:RandomInt(100) < 10 then
        TeleportToRoom(RoomType.ROOM_ANGEL, player, rng)
		return { Discharge = true, Remove = false, ShowAnim = true }
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and rng:RandomInt(100) < 10 then
		TeleportToRoom(RoomType.ROOM_DEVIL, player, rng)
		return { Discharge = true, Remove = false, ShowAnim = true }
	end
    local rooms = Lib:GetGlobalLibData("Rewind", "Rooms")
    if rooms == nil then
        Lib.GAME:StartRoomTransition(GridRooms.ROOM_ERROR_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, 0)
        return { Discharge = true, Remove = false, ShowAnim = true }
    end
    local restartTime = 0
    ::restart::
    if restartTime >= 6 then
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
    local roomOutcomes = WeightedOutcomePicker()
    for roomType, count in pairs(rooms) do
        roomOutcomes:AddOutcomeWeight(tonumber(roomType), count)
    end
    local result = roomOutcomes:PickOutcome(rng)
    local currentCount = Lib:GetGlobalLibData("Rewind", "Rooms", tostring(result))
    if currentCount >= 2 then
        Lib:SetGlobalLibData(currentCount - 1, "Rewind", "Rooms", tostring(result))
    end
    if TeleportToRoom(result, player, rng) == -1 then
        restartTime = restartTime + 1
        goto restart
    end
	return { Discharge = true, Remove = false, ShowAnim = true }
end
Rewind:AddCallback(ModCallbacks.MC_USE_ITEM, Rewind.UseItem, Lib.ModItemIDs.REWIND)

return Rewind