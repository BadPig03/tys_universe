local MarriageCertificate = TYU:NewModItem("Marriage Certificate", "MARRIAGE_CERTIFICATE")
local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils
local ModNullItemIDs = TYU.ModNullItemIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    PrivateField.AllowCopying = false

    PrivateField.BannedCollectibles = {
        [CollectibleType.COLLECTIBLE_1UP] = true,
        [CollectibleType.COLLECTIBLE_DEAD_CAT] = true,
        [CollectibleType.COLLECTIBLE_GUPPYS_COLLAR] = true,
        [CollectibleType.COLLECTIBLE_JUDAS_SHADOW] = true,
        [CollectibleType.COLLECTIBLE_LAZARUS_RAGS] = true,
        [CollectibleType.COLLECTIBLE_STRAW_MAN] = true,
        [CollectibleType.COLLECTIBLE_INNER_CHILD] = true,
        [ModItemIDs.MAGNIFIER] = true,
        [ModItemIDs.MARRIAGE_CERTIFICATE] = true
    }
end

do
    function PrivateField.IsSubPlayer(player)
        return player.Parent and player.Parent:ToPlayer() and player:GetEffects():HasNullEffect(ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
    end

    function PrivateField.IsSubPlayerDead(player)
        return player:GetPlayerType() == PlayerType.PLAYER_THELOST and player:GetEffects():HasNullEffect(ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
    end
end

function MarriageCertificate:PreAddCollectible(type, charge, firstTime, slot, varData, player)
    if type == ModItemIDs.MARRIAGE_CERTIFICATE then
        if player:GetPlayerType() == PlayerType.PLAYER_ESAU and player:GetOtherTwin() then
            local twinPlayer = player:GetOtherTwin()
            twinPlayer:AddCollectible(ModItemIDs.MARRIAGE_CERTIFICATE)
            return false
        end
        if player.Parent and player.Parent:ToPlayer() then
            player.Parent:ToPlayer():AddCollectible(type)
            return false
        end
    end
    if not PrivateField.AllowCopying and PrivateField.IsSubPlayer(player) and type ~= CollectibleType.COLLECTIBLE_DOGMA then
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
    local newPlayer = Isaac.GetPlayer(TYU.GAME:GetNumPlayers() - 1)
    newPlayer.Parent = player
    newPlayer:RemoveCollectible(CollectibleType.COLLECTIBLE_RAZOR_BLADE)
    newPlayer:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    newPlayer:GetEffects():AddNullEffect(ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER)
    TYU.HUD:AssignPlayerHUDs()
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, MarriageCertificate.PostAddCollectible, ModItemIDs.MARRIAGE_CERTIFICATE)

function MarriageCertificate:PostTriggerCollectibleRemoved(player, type)
    for _, player2 in pairs(Players.GetPlayers(true)) do
        if PrivateField.IsSubPlayer(player2) and GetPtrHash(player) == GetPtrHash(player2.Parent:ToPlayer()) then
            PlayerManager.RemoveCoPlayer(player2)
            return
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, MarriageCertificate.PostTriggerCollectibleRemoved, ModItemIDs.MARRIAGE_CERTIFICATE)

function MarriageCertificate:PreTriggerPlayerDeath(player)
    local effects = player:GetEffects()
    if not effects:HasNullEffect(ModNullItemIDs.MARRIAGE_CERTIFICATE_SUBPLAYER) then
        return
    end
    player:ChangePlayerType(PlayerType.PLAYER_THELOST)
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
    player:Revive()
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)   
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, MarriageCertificate.PreTriggerPlayerDeath)

function MarriageCertificate:EvaluateCache(player, cacheFlag)
    if not PrivateField.IsSubPlayerDead(player) then
        return
    end
    Stat:MultiplyDamage(player, 0.2)
end
MarriageCertificate:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, MarriageCertificate.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function MarriageCertificate:PrePlayerTakeDamage(player, amount, flags, source, countdown)
	if not PrivateField.IsSubPlayerDead(player) then
		return
	end
    return false
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, MarriageCertificate.PrePlayerTakeDamage)

function MarriageCertificate:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not PrivateField.IsSubPlayerDead(player) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, MarriageCertificate.PrePickupCollision)

function MarriageCertificate:PreSlotCollision(slot, collider, low)
    local player = collider:ToPlayer()
    if not player or not PrivateField.IsSubPlayerDead(player) then
        return
    end
    return { Collide = true, SkipCollisionEffects = true }
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, MarriageCertificate.PreSlotCollision)

function MarriageCertificate:PreUseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if not Players.AnyoneHasCollectible(ModItemIDs.MARRIAGE_CERTIFICATE) then
        return
    end
    for _, player2 in pairs(Players.GetPlayers(true)) do
        if PrivateField.IsSubPlayer(player2) and GetPtrHash(player) == GetPtrHash(player2.Parent:ToPlayer()) then
            PlayerManager.RemoveCoPlayer(player2)
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, MarriageCertificate.PreUseItem, CollectibleType.COLLECTIBLE_GENESIS)

function MarriageCertificate:PostNewRoom()
    if not Utils.IsInKnifePuzzle() then
        return
    end
    for _, player in pairs(Players.GetPlayers(true)) do
        if PrivateField.IsSubPlayer(player) and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST then
            player:ChangePlayerType(PlayerType.PLAYER_THELOST)
        end
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MarriageCertificate.PostNewRoom)

function MarriageCertificate:PostPlayerNewLevel(player)
    local effects = player:GetEffects()
    if not PrivateField.IsSubPlayer(player) then
        return
    end
    if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
        player:ChangePlayerType(PlayerType.PLAYER_EVE)
        effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, -1)
        player:AddMaxHearts(4)
        player:AddHearts(2)
        player:AddSoulHearts(-1)
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)            
    else
        PrivateField.AllowCopying = true
        local history = player.Parent:ToPlayer():GetHistory():GetCollectiblesHistory()
        for i = 0, 2 do
            if not history[#history - i] or history[#history - i]:IsTrinket() then
                goto continue
            end
            local itemID = history[#history - i]:GetItemID()
            if not PrivateField.BannedCollectibles[itemID] and not TYU.ITEMCONFIG:GetCollectible(itemID):HasTags(ItemConfig.TAG_QUEST) and TYU.ITEMCONFIG:GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE then
                player:AddCollectible(itemID)
            end
            ::continue::
        end
        PrivateField.AllowCopying = false
    end
end
MarriageCertificate:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, MarriageCertificate.PostPlayerNewLevel)

return MarriageCertificate