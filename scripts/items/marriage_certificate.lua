local Lib = TYU
local MarriageCertificate = Lib:NewModItem("Marriage Certificate", "MARRIAGE_CERTIFICATE")

local forbidCopying = false

local bannedCollectibles = {
    [CollectibleType.COLLECTIBLE_1UP] = true,
    [CollectibleType.COLLECTIBLE_DEAD_CAT] = true,
    [CollectibleType.COLLECTIBLE_GUPPYS_COLLAR] = true,
    [CollectibleType.COLLECTIBLE_JUDAS_SHADOW] = true,
    [CollectibleType.COLLECTIBLE_LAZARUS_RAGS] = true,
    [CollectibleType.COLLECTIBLE_STRAW_MAN] = true,
    [CollectibleType.COLLECTIBLE_INNER_CHILD] = true,
    [Lib.ModItemIDs.MAGNIFIER] = true,
    [Lib.ModItemIDs.MARRIAGE_CERTIFICATE] = true
}

local function IsDeadEve(player)
    return player:GetPlayerType() == PlayerType.PLAYER_THELOST and player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
end

function MarriageCertificate:SetForbidCopying(value)
    forbidCopying = value
end

function MarriageCertificate:IsSubPlayer(player)
    return player.Parent and player.Parent:ToPlayer() and player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
end

function MarriageCertificate:PreAddCollectible(type, charge, firstTime, slot, varData, player)
    if type == Lib.ModItemIDs.MARRIAGE_CERTIFICATE then
        if player:GetPlayerType() == PlayerType.PLAYER_ESAU and player:GetOtherTwin() then
            local twinPlayer = player:GetOtherTwin()
            twinPlayer:AddCollectible(Lib.ModItemIDs.MARRIAGE_CERTIFICATE)
            return false
        end
        if player.Parent and player.Parent:ToPlayer() then
            player.Parent:ToPlayer():AddCollectible(type)
            return false
        end
    end
    if not forbidCopying and MarriageCertificate:IsSubPlayer(player) and type ~= CollectibleType.COLLECTIBLE_DOGMA then
        player.Parent:ToPlayer():AddCollectible(type)
        return false
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, MarriageCertificate.PreAddCollectible)

function MarriageCertificate:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    Isaac.ExecuteCommand("addplayer 5 "..player.ControllerIndex)
    local newPlayer = Isaac.GetPlayer(Lib.GAME:GetNumPlayers() - 1)
    newPlayer.Parent = player
    newPlayer:RemoveCollectible(CollectibleType.COLLECTIBLE_RAZOR_BLADE)
    newPlayer:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    newPlayer:GetEffects():AddNullEffect(Lib.ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
    Lib.HUD:AssignPlayerHUDs()
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, MarriageCertificate.PostAddCollectible, Lib.ModItemIDs.MARRIAGE_CERTIFICATE)

function MarriageCertificate:PostTriggerCollectibleRemoved(player, type)
    for _, player2 in pairs(Lib.Players.GetPlayers(true)) do
        if MarriageCertificate:IsSubPlayer(player2) and GetPtrHash(player) == GetPtrHash(player2.Parent:ToPlayer()) then
            PlayerManager.RemoveCoPlayer(player2)
            return
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, MarriageCertificate.PostTriggerCollectibleRemoved, Lib.ModItemIDs.MARRIAGE_CERTIFICATE)

function MarriageCertificate:PreTriggerPlayerDeath(player)
    local effects = player:GetEffects()
    if not effects:HasNullEffect(Lib.ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER) then
        return
    end
    player:ChangePlayerType(PlayerType.PLAYER_THELOST)
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
    player:Revive()
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)   
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, MarriageCertificate.PreTriggerPlayerDeath)

function MarriageCertificate:EvaluateCache(player, cacheFlag)
    if not IsDeadEve(player) then
        return
    end
    Lib.Stat:MultiplyDamage(player, 0.2)
end
MarriageCertificate:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, MarriageCertificate.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function MarriageCertificate:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not IsDeadEve(player) then
		return
	end
    return false
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, MarriageCertificate.PrePlayerTakeDamage)

function MarriageCertificate:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not IsDeadEve(player) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, MarriageCertificate.PrePickupCollision)

function MarriageCertificate:PreSlotCollision(slot, collider, low)
    local player = collider:ToPlayer()
    if not player or not IsDeadEve(player) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, MarriageCertificate.PreSlotCollision)

function MarriageCertificate:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.MARRIAGE_CERTIFICATE) then
        return
    end
    for _, player2 in pairs(Lib.Players.GetPlayers(true)) do
        if MarriageCertificate:IsSubPlayer(player2) and GetPtrHash(player) == GetPtrHash(player2.Parent:ToPlayer()) then
            PlayerManager.RemoveCoPlayer(player2)
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, MarriageCertificate.PreUseItem, CollectibleType.COLLECTIBLE_GENESIS)

function MarriageCertificate:PostNewRoom()
    if not Lib.LEVEL:HasAbandonedMineshaft() or Lib.LEVEL:GetDimension() ~= Dimension.MINESHAFT then
        return
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if MarriageCertificate:IsSubPlayer(player) and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST then
            player:ChangePlayerType(PlayerType.PLAYER_THELOST)
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MarriageCertificate.PostNewRoom)

function MarriageCertificate:PostNewLevel()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        local effects = player:GetEffects()
        if MarriageCertificate:IsSubPlayer(player) then
            if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
                player:ChangePlayerType(PlayerType.PLAYER_EVE)
                effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, -1)
                player:AddMaxHearts(4)
                player:AddHearts(2)
                player:AddSoulHearts(-1)
                Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
                Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)            
            else
                local history = player.Parent:ToPlayer():GetHistory():GetCollectiblesHistory()
                MarriageCertificate:SetForbidCopying(true)
                for i = 0, 2 do
                    if not history[#history - i] or history[#history - i]:IsTrinket() then
                        goto continue
                    end
                    local itemID = history[#history - i]:GetItemID()
                    if not bannedCollectibles[itemID] and not Lib.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and Lib.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE then
                        player:AddCollectible(itemID)
                    end
                    ::continue::
                end
                MarriageCertificate:SetForbidCopying(false)
            end
        end
    end    
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, MarriageCertificate.PostNewLevel)

return MarriageCertificate