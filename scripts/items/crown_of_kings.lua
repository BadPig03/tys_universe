local CrownOfKings = TYU:NewModItem("Crown of Kings", "CROWN_OF_KINGS")
local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModEntityFlags = TYU.ModEntityFlags
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "CrownOfKings", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "CrownOfKings", ...)
end

do 
    function PrivateField.SpawnEffect(player)
        local effect = Entities.Spawn(ModEntityIDs.CROWN_OF_KINGS_EFFECT.Type, ModEntityIDs.CROWN_OF_KINGS_EFFECT.Variant, ModEntityIDs.CROWN_OF_KINGS_EFFECT.SubType, player.Position, player.Velocity, player):ToEffect()
        local effectSprite = effect:GetSprite()
        local hasCrownOfLight = player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT)
        local hasDarkPrincesCrown = player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN)
        local flyOffset = Vector(0, 0)
        if player.CanFly then
            flyOffset = Vector(0, -4)
        end
        effectSprite.Scale = player.SpriteScale
        effect.DepthOffset = 0.1
        effect:AddEntityFlags(ModEntityFlags.FLAG_NO_PAUSE)
        if hasCrownOfLight and hasDarkPrincesCrown then
            effect.ParentOffset = Vector(0, -21) + flyOffset
        elseif (hasCrownOfLight and not hasDarkPrincesCrown) or (not hasCrownOfLight and hasDarkPrincesCrown) then
            effect.ParentOffset = Vector(0, -10.5) + flyOffset
        else
            effect.ParentOffset = Vector(0, 0) + flyOffset
        end
        effect.Position = effect.Position + flyOffset
        if GetPlayerLibData(player, "BossFound") then
            effectSprite:Play("FloatGlow", true)
        else
            effectSprite:Play("FloatNoGlow", true)
        end
        effect.Parent = player
        effect:FollowParent(player)
    end

    function PrivateField.GetEffect(player)
        for _, effect in pairs(Isaac.FindByType(ModEntityIDs.CROWN_OF_KINGS_EFFECT.Type, ModEntityIDs.CROWN_OF_KINGS_EFFECT.Variant, ModEntityIDs.CROWN_OF_KINGS_EFFECT.SubType)) do
            if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
                return effect:ToEffect()
            end
        end
        return nil
    end
end

function CrownOfKings:PostPlayerUpdate(player)
    if not player:HasCollectible(ModItemIDs.CROWN_OF_KINGS) then
        return
    end
    if not PrivateField.GetEffect(player) then
        PrivateField.SpawnEffect(player)
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CrownOfKings.PostPlayerUpdate, 0)

function CrownOfKings:PostNewRoom()
    local room = TYU.GAME:GetRoom()
    for _, player in pairs(Players.GetPlayers(true)) do
        local bossFound = false
        if player:HasCollectible(ModItemIDs.CROWN_OF_KINGS) then
            for _, ent in pairs(Isaac.GetRoomEntities()) do
                if ent:ToNPC() and ent:IsBoss() and ent.Type ~= EntityType.ENTITY_DARK_ESAU then
                    bossFound = true
                end
            end
            if Utils.IsRoomBossChallenge() and not room:IsAmbushDone() then
                SetPlayerLibData(player, true, "IsBossChallenge")
                bossFound = true
            end
            if Utils.IsRoomType(RoomType.ROOM_BOSSRUSH) and not room:IsAmbushDone() then
                SetPlayerLibData(player, true, "IsBossRush")
                bossFound = true
            end
        end
        SetPlayerLibData(player, bossFound, "BossFound")
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CrownOfKings.PostNewRoom)

function CrownOfKings:PreSpawnCleanAward(rng, spawnPosition)
    local room = TYU.GAME:GetRoom()
    for _, player in pairs(Players.GetPlayers(true)) do
        if player:HasCollectible(ModItemIDs.CROWN_OF_KINGS) and GetPlayerLibData(player, "BossFound") then
            if Utils.IsRoomType(RoomType.ROOM_CHALLENGE) and GetPlayerLibData(player, "IsBossChallenge") then
                Isaac.CreateTimer(function()
                    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Collectibles.GetCollectibleFromRandomPool(1, 3, rng), Utils.FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40))) 
                end, 1, 0, false)
                SetPlayerLibData(player, false, "IsBossChallenge")
            elseif Utils.IsRoomType(RoomType.ROOM_BOSSRUSH) and GetPlayerLibData(player, "IsBossRush") then
                Isaac.CreateTimer(function()
                    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Collectibles.GetCollectibleFromRandomPool(3, 3, rng), Utils.FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40))) 
                end, 1, 0, false)
                SetPlayerLibData(player, false, "IsBossRush")
            else
                Isaac.CreateTimer(function()
                    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Collectibles.GetCollectibleFromRandomPool(0, 3, rng), Utils.FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40))) 
                end, 1, 0, false)
            end
            SetPlayerLibData(player, false, "BossFound")
            player:AnimateHappy()
        end
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CrownOfKings.PreSpawnCleanAward)

function CrownOfKings:PostTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.CROWN_OF_KINGS) or not GetPlayerLibData(player, "BossFound") then
        return
    end
    SetPlayerLibData(player, { BossFound = false, IsBossRush = false, IsBossChallenge = false })
    player:AnimateSad()
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, CrownOfKings.PostTakeDamage, EntityType.ENTITY_PLAYER)

return CrownOfKings