local Players = TYU:RegisterNewClass()

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

function Players.IsJacobOrEsau(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_JACOB or playerType == PlayerType.PLAYER_ESAU
end

function Players.IsTaintedForgottenAndSoul(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_THEFORGOTTEN_B or playerType == PlayerType.PLAYER_THESOUL_B
end

function Players.IsTaintedLazarusOrFlippedLazarus(player)
    local playerType = player:GetPlayerType()
    return playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B
end

function Players.IsInLostCurse(player)
    return player:HasInstantDeathCurse()
end

function Players.GetChargeBarPosition(player, type)
    local hasBobsStomach = player:HasCollectible(TYU.ModItemIDs.BOBS_STOMACH)
    local hasHephaestusSoul = player:HasCollectible(TYU.ModItemIDs.HEPHAESTUS_SOUL)
    local hasOceanusSoul = player:HasCollectible(TYU.ModItemIDs.OCEANUS_SOUL)
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

function Players.GetNullEffectCounts(id)
    local count = 0
    for _, player in pairs(Players.GetPlayers(true)) do
        local effects = player:GetEffects()
        if effects:HasNullEffect(id) then
            count = count + effects:GetNullEffectNum(id)
        end
    end
    return count
end

function Players.IsPressingFiringButton(player)
    local controllerIndex = player.ControllerIndex
	return Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controllerIndex)
end

function Players.AnyoneIsPlayerType(type)
    return PlayerManager.AnyoneIsPlayerType(type)
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


function Players.RemoveCollectibles(player, id, count)
    count = count or 1
    if count < 0 then
        count = player:GetCollectibleNum(id)
    end
    for i = 1, count do
        player:RemoveCollectible(id)
    end
end

return Players