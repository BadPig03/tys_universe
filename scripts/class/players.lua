local Players = TYU:RegisterNewClass()

function Players.AnyoneHasCollectible(id)
    return PlayerManager.AnyoneHasCollectible(id)
end

function Players.AddShield(player, time)
    local effects = player:GetEffects()
    local effect = effects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
    if not effect then
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
        effect = effects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
        effect.Cooldown = 0
    end
    effect.Cooldown = (effect.Cooldown or 0) + time
end

function Players.RemoveCostume(player, id)
    player:RemoveCostume(TYU.ITEMCONFIG:GetCollectible(id))
end

function Players.GetPlayers(ignoreCoopBabies)
    if ignoreCoopBabies == nil then
        ignoreCoopBabies = true
    end
    local playerList = {}
    for i = 0, TYU.GAME:GetNumPlayers() - 1 do
        local player = TYU.GAME:GetPlayer(i)
        if not ignoreCoopBabies or player.Variant == 0 then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function Players.AddLostCurse(player, remove)
    remove = remove or false
    local effects = player:GetEffects()
    if remove then
        effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE)
    else
        effects:AddNullEffect(NullItemID.ID_LOST_CURSE)
    end
end

function Players.AnyoneIsPlayerType(type)
    return PlayerManager.AnyoneIsPlayerType(type)
end

function Players.CanPickEternalHearts(player)
    local limit = player:GetHeartLimit()
    if player:GetMaxHearts() == limit and player:GetEternalHearts() == 1 then
        return false
    end
    return true
end

function Players.GetTotalTrinketMultiplier(id)
    return PlayerManager.GetTotalTrinketMultiplier(id)
end

function Players.IsPlayerHasCard(player, card)
    for i = PillCardSlot.PRIMARY, PillCardSlot.QUATERNARY do
        if player:GetCard(i) == card then
            return true
        end
    end
    return false
end

function Players.GetPlayerID(player, differ)
    differ = differ or false
    player = player:ToPlayer()
    if not player then
        return -1
    end
    local player2 = player
    if player:IsSubPlayer() then
        local parent = player:GetSubPlayer()
        if parent then
            player2 = parent
        end
    end
    if differ and player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        return player2:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SPOON_BENDER):GetSeed()
    end
    return player2:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
end

function Players.IsInLostCurse(player)
    return player:HasInstantDeathCurse()
end

function Players.IsJacobOrEsau(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU
end

function Players.IsForgottenOrSoul(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THESOUL
end

function Players.IsTaintedForgottenAndSoul(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_THEFORGOTTEN_B or playerType == PlayerType.PLAYER_THESOUL_B
end

function Players.IsTaintedLazarusOrFlippedLazarus(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B
end

function Players.IsRedOnlyCharacter(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_BETHANY or playerType == TYU.ModPlayerIDs.WARFARIN
end

function Players.RemoveCollectibles(player, id, count)
    count = count or 1
    if count < 0 then
        count = player:GetCollectibleNum(id)
    end
    for i = 1, count do
        player:RemoveCollectible(id)
    end
end

function Players.GetNullEffectCounts(id)
    local count = 0
    for _, player in pairs(TYU.Players.GetPlayers(true)) do
        local effects = player:GetEffects()
        if effects:HasNullEffect(id) then
            count = count + effects:GetNullEffectNum(id)
        end
    end
    return count
end

function Players.OnValidCreep(player)
    local room = TYU.GAME:GetRoom()
	local creepList = {
		[EffectVariant.CREEP_RED] = true,
		[EffectVariant.CREEP_GREEN] = true,
		[EffectVariant.CREEP_YELLOW] = true,
		[EffectVariant.CREEP_WHITE] = true,
		[EffectVariant.CREEP_BLACK] = true,
		[EffectVariant.PLAYER_CREEP_LEMON_MISHAP] = true,
		[EffectVariant.PLAYER_CREEP_HOLYWATER] = true,
		[EffectVariant.PLAYER_CREEP_WHITE] = true,
		[EffectVariant.PLAYER_CREEP_BLACK] = true,
		[EffectVariant.PLAYER_CREEP_RED] = true,
		[EffectVariant.PLAYER_CREEP_GREEN] = true,
		[EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = true,
		[EffectVariant.CREEP_BROWN] = true,
		[EffectVariant.PLAYER_CREEP_LEMON_PARTY] = true,
		[EffectVariant.PLAYER_CREEP_PUDDLE_MILK] = true,
		[EffectVariant.CREEP_SLIPPERY_BROWN] = true,
		[EffectVariant.CREEP_SLIPPERY_BROWN_GROWING] = true,
		[EffectVariant.CREEP_STATIC] = true,
		[EffectVariant.CREEP_LIQUID_POOP] = true
	}
    if room:HasWater() or room:GetWaterAmount() > 0 then
        return true
    end
    for _, ent in pairs(Isaac.GetRoomEntities()) do
        if ent.Type == EntityType.ENTITY_EFFECT and creepList[ent.Variant] and player.Position:Distance(ent.Position) <= ent.Size * ent:ToEffect().Scale * 1.25 then
            return true
        end
    end
    return false
end

function Players.GetChargeBarPosition(player, type)
    local hasBobsStomach = player:HasCollectible(TYU.ModItemIDs.BOBSSTOMACH)
    local hasHephaestusSoul = player:HasCollectible(TYU.ModItemIDs.HEPHAESTUSSOUL)
    local hasOceanusSoul = player:HasCollectible(TYU.ModItemIDs.OCEANUSSOUL)
    if type == 1 then
        return Vector(-21, -60)
    elseif type == 2 then
        if hasBobsStomach then
            return Vector(-30, -43)
        else
            return Vector(-21, -60)
        end
    elseif type == 3 then
        if hasBobsStomach and hasHephaestusSoul then
            return Vector(-42, -60)
        elseif (hasBobsStomach and not hasHephaestusSoul) or (not hasBobsStomach and hasHephaestusSoul) then
            return Vector(-30, -43)
        else
            return Vector(-21, -60)
        end
    end
end

function Players.IsPressingFiringButton(player)
    local controllerIndex = player.ControllerIndex
	return Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controllerIndex)
end

function Players.IsInventoryFull(player)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
        local count = 0
        local limit = 8
        for itemID, itemCount in pairs(player:GetCollectiblesList()) do
            if ItemConfig.Config.IsValidCollectible(itemID) and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT then
                count = count + itemCount
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            limit = 12
        end
        return count >= limit
    else
        return false
    end
end

function Players.GetRotationAngle(player)
    local direction = player:GetShootingInput()
    if direction.X == 0 and direction.Y == 0 then
        return math.pi * 0.5
    elseif direction.X == 0 and direction.Y == -1 then
        return math.pi * 1.5
    elseif direction.X == 1 and direction.Y == -1 then
        return math.pi * 1.75
    elseif direction.X == 1 and direction.Y == 0 then
        return 0
    elseif direction.X == 1 and direction.Y == 1 then
        return math.pi * 0.25
    elseif direction.X == 0 and direction.Y == 1 then
        return math.pi * 0.5
    elseif direction.X == -1 and direction.Y == 1 then
        return math.pi * 0.75
    elseif direction.X == -1 and direction.Y == 0 then
        return math.pi
    elseif direction.X == -1 and direction.Y == -1 then
        return math.pi * 1.25
    end
end

return Players