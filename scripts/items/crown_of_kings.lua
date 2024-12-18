local Lib = TYU
local CrownOfKings = Lib:NewModItem("Crown of Kings", "CROWN_OF_KINGS")

local function GetEffect(player)
    for _, effect in pairs(Isaac.FindByType(Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.Type, Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.Variant, Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.SubType)) do
        if effect.Parent and effect.Parent:ToPlayer() and GetPtrHash(effect.Parent:ToPlayer()) == GetPtrHash(player) then
            return effect:ToEffect()
        end
    end
    return nil
end

local function SpawnEffect(player)
    local effect = Lib.Entities.Spawn(Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.Type, Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.Variant, Lib.ModEntityIDs.CROWN_OF_KINGS_EFFECT.SubType, player.Position, player.Velocity, player):ToEffect()
    local effectSprite = effect:GetSprite()
    local hasCrownOfLight = player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT)
    local hasDarkPrincesCrown = player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN)
    local flyOffset = Vector(0, 0)
    if player.CanFly then
        flyOffset = Vector(0, -4)
    end
    effectSprite.Scale = player.SpriteScale
    effect.DepthOffset = 0.1
    effect:AddEntityFlags(Lib.ModEntityFlags.FLAG_NO_PAUSE)
    if hasCrownOfLight and hasDarkPrincesCrown then
        effect.ParentOffset = Vector(0, -21) + flyOffset
    elseif (hasCrownOfLight and not hasDarkPrincesCrown) or (not hasCrownOfLight and hasDarkPrincesCrown) then
        effect.ParentOffset = Vector(0, -10.5) + flyOffset
    else
        effect.ParentOffset = Vector(0, 0) + flyOffset
    end
    effect.Position = effect.Position + flyOffset
    if Lib:GetPlayerLibData(player, "CrownOfKings", "BossFound") then
        effectSprite:Play("FloatGlow", true)
    else
        effectSprite:Play("FloatNoGlow", true)
    end
    effect.Parent = player
    effect:FollowParent(player)
end

function CrownOfKings:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.CROWN_OF_KINGS) then
        return
    end
    if not GetEffect(player) then
        SpawnEffect(player)
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CrownOfKings.PostPlayerUpdate, 0)

function CrownOfKings:PostNewRoom()
    local room = Lib.GAME:GetRoom()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        local bossFound = false
        if player:HasCollectible(Lib.ModItemIDs.CROWN_OF_KINGS) then
            for _, ent in pairs(Isaac.GetRoomEntities()) do
                if ent:ToNPC() and ent:IsBoss() and ent.Type ~= EntityType.ENTITY_DARK_ESAU then
                    bossFound = true
                end
            end
            if Lib.Levels.IsBossChallengeRoom() and not room:IsAmbushDone() then
                Lib:SetPlayerLibData(player, true, "CrownOfKings", "IsBossChallenge")
                bossFound = true
            end
            if Lib.Levels.IsBossRushRoom() and not room:IsAmbushDone() then
                Lib:SetPlayerLibData(player, true, "CrownOfKings", "IsBossRush")
                bossFound = true
            end
        end
        Lib:SetPlayerLibData(player, bossFound, "CrownOfKings", "BossFound")
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CrownOfKings.PostNewRoom)

function CrownOfKings:PreSpawnCleanAward(rng, spawnPosition)
    local room = Lib.GAME:GetRoom()
    local roomType = room:GetType()
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        if player:HasCollectible(Lib.ModItemIDs.CROWN_OF_KINGS) and Lib:GetPlayerLibData(player, "CrownOfKings", "BossFound") then
            if roomType == RoomType.ROOM_CHALLENGE and Lib:GetPlayerLibData(player, "CrownOfKings", "IsBossChallenge") then
                Isaac.CreateTimer(function()
                    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.Collectibles.GetCollectibleFromRandomPool(1, 3, rng), room:FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40), 0, true)) 
                end, 1, 0, false)
                Lib:SetPlayerLibData(player, false, "CrownOfKings", "IsBossChallenge")
            elseif roomType == RoomType.ROOM_BOSSRUSH and Lib:GetPlayerLibData(player, "CrownOfKings", "IsBossRush") then
                Isaac.CreateTimer(function()
                    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.Collectibles.GetCollectibleFromRandomPool(3, 3, rng), room:FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40), 0, true)) 
                end, 1, 0, false)
                Lib:SetPlayerLibData(player, false, "CrownOfKings", "IsBossRush")
            else
                Isaac.CreateTimer(function()
                    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Lib.Collectibles.GetCollectibleFromRandomPool(0, 3, rng), room:FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0, 40), 0, true)) 
                end, 1, 0, false)
            end
            Lib:SetPlayerLibData(player, false, "CrownOfKings", "BossFound")
            player:AnimateHappy()
        end
    end
end
CrownOfKings:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CrownOfKings.PreSpawnCleanAward)

function CrownOfKings:PostTakeDamage(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.CROWN_OF_KINGS) or not Lib:GetPlayerLibData(player, "CrownOfKings", "BossFound") then
        return
    end
    Lib:SetPlayerLibData(player, false, "CrownOfKings", "BossFound")
    Lib:SetPlayerLibData(player, false, "CrownOfKings", "IsBossRush")
    Lib:SetPlayerLibData(player, false, "CrownOfKings", "IsBossChallenge")
    player:AnimateSad()
end
CrownOfKings:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, CrownOfKings.PostTakeDamage, EntityType.ENTITY_PLAYER)

return CrownOfKings