local DarkMask = TYU:NewModItem("Dark Mask", "DARK_MASK")

local Collectibles = TYU.Collectibles
local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModEntityFlags = TYU.ModEntityFlags

local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "DarkMask", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("DarkMask", ...)
end

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "DarkMask", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "DarkMask", ...)
end

do
    PrivateField.EffectSprite = Sprite("gfx/effects/dark_mask_mark.anm2", true)
    PrivateField.EffectSprite:Play("Idle", true)
end

do
    function PrivateField.GetValidEnemiesCount()
        local count = 0
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            local npc = ent:ToNPC()
            if npc and Entities.IsValidEnemy(npc) and not npc:IsBoss() and not npc.Child then
                count = count + 1
            end
        end
        return count
    end

    function PrivateField.GetRandomEnemyInitSeed(seed)
        local enemiesList = {}
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            local npc = ent:ToNPC()
            if npc and Entities.IsValidEnemy(npc) and not npc:IsBoss() and not npc.Child then
                table.insert(enemiesList, npc.InitSeed)
            end
        end
        if #enemiesList == 0 then
            return -1
        end
        local rng = RNG(seed)
        local index = rng:RandomInt(#enemiesList) + 1
        return enemiesList[index]
    end

    function PrivateField.FindBothEnemies()
        local markedEnemy = nil
        local normalEnemy = nil
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            local npc = ent:ToNPC()
            if npc and Entities.IsValidEnemy(npc) then
                if npc:HasEntityFlags(ModEntityFlags.FLAG_DARK_MASK_MARKED) and not markedEnemy then
                    markedEnemy = npc
                elseif not npc:HasEntityFlags(ModEntityFlags.FLAG_DARK_MASK_MARKED) and not normalEnemy then
                    normalEnemy = npc
                end
            end
        end
        return markedEnemy, normalEnemy
    end

    function PrivateField.MarkAnEntityBySeed(seed)
        local entity = Entities.GetEntityBySeed(seed)
        if not entity then
            return
        end
        entity.MaxHitPoints = entity.MaxHitPoints * 5
        entity.HitPoints = entity.HitPoints * 5
        entity:AddEntityFlags(ModEntityFlags.FLAG_DARK_MASK_MARKED | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_EXTRA_GORE)
    end

    function PrivateField.GetRandomReward(rng)
        local outcomes = WeightedOutcomePicker()
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_HEART, 15)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_COIN, 15)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_BOMB, 15)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_KEY, 15)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_TAROTCARD, 5)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_PILL, 5)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_CHEST, 5)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_TRINKET, 5)
        outcomes:AddOutcomeWeight(PickupVariant.PICKUP_COLLECTIBLE, 1)
        local variant = outcomes:PickOutcome(rng)
        local subType = 0
        if variant == PickupVariant.PICKUP_COLLECTIBLE then
            subType = Collectibles.GetCollectibleFromRandomPool(1, 3, rng)
        end
        return variant, subType
    end

    function PrivateField.GetRandomItemPool()
        local rng = Players.FirstCollectibleOwner(ModItemIDs.DARK_MASK):GetCollectibleRNG(ModItemIDs.DARK_MASK)
        local itemPoolType = TYU.ITEMPOOL:GetRandomPool(rng)
        return itemPoolType
    end
end

function DarkMask:EvaluateCache(player, cacheFlag)
    local count = player:GetCollectibleNum(ModItemIDs.DARK_MASK)
    if count == 0 then
        return
    end
    Stat:SetDamageMultiplier(player, 1.2)
end
DarkMask:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DarkMask.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function DarkMask:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.DARK_MASK) then
        return
    end
    if Utils.IsRoomType(RoomType.ROOM_BOSS) then
        local itemPoolType = GetGlobalLibData("ItemPoolType") or ItemPoolType.POOL_BOSS
        local room = TYU.GAME:GetRoom()
        room:SetItemPool(itemPoolType)
    end
    local count = PrivateField.GetValidEnemiesCount()
    if count <= 1 then
        return
    end
    local roomDesc = TYU.LEVEL:GetCurrentRoomDesc()
    local markedEnemySeed = PrivateField.GetRandomEnemyInitSeed(roomDesc.SpawnSeed)
    SetGlobalLibData(markedEnemySeed, "Seeds", tostring(roomDesc.ListIndex))
    PrivateField.MarkAnEntityBySeed(markedEnemySeed)
end
DarkMask:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DarkMask.PostNewRoom)

function DarkMask:PostNewLevel()
    SetGlobalLibData({}, "Seeds")
end
DarkMask:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, DarkMask.PostNewLevel)

function DarkMask:PostUpdate()
    if not Players.AnyoneHasCollectible(ModItemIDs.DARK_MASK) then
        return
    end
    local markedEnemy, normalEnemy = PrivateField.FindBothEnemies()
    if markedEnemy and not normalEnemy then
        markedEnemy:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
        markedEnemy:Die()
    end
end
DarkMask:AddCallback(ModCallbacks.MC_POST_UPDATE, DarkMask.PostUpdate)

function DarkMask:PostNPCRender(npc, offset)
    if not npc:HasEntityFlags(ModEntityFlags.FLAG_DARK_MASK_MARKED) then
        return
    end
    local sprite = npc:GetSprite()
    if not sprite or not sprite:GetNullFrame("OverlayEffect") or (sprite:GetNullFrame("OverlayEffect"):GetPos():Length() == 0) then
        return
    end
    local renderPosition = Isaac.WorldToScreen(npc.Position) + sprite:GetNullFrame("OverlayEffect"):GetPos() + Vector(0, -10)
    PrivateField.EffectSprite:Render(renderPosition)
    PrivateField.EffectSprite:Update()
    local player = Isaac.GetPlayer(0)
    local cooldown = npc:GetBossStatusEffectCooldown()
    if npc:IsBoss() and cooldown > 0 then
        npc:SetBossStatusEffectCooldown(0)
    end
    npc:AddConfusion(EntityRef(player), 2)
    if npc:IsBoss() and cooldown > 0 then
        npc:SetBossStatusEffectCooldown(cooldown)
    end
end
DarkMask:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, DarkMask.PostNPCRender)

function DarkMask:PostNPCDeath(npc)
    if not npc:HasEntityFlags(ModEntityFlags.FLAG_DARK_MASK_MARKED) or npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
        return
    end
    local rng = RNG(npc.InitSeed)
    for i = 1, rng:RandomInt(2, 4) do
        local position = Utils.FindFreePickupSpawnPosition(npc.Position)
        local variant, subType = PrivateField.GetRandomReward(rng)
        Entities.Spawn(EntityType.ENTITY_PICKUP, variant, subType, position)
    end
    local killCount = GetGlobalLibData("KillCount") or 0
    if killCount >= 5 then
        local room = TYU.GAME:GetRoom()
        TYU.GAME:ShowHallucination(30, room:GetBackdropType())
        local itemPoolType = PrivateField.GetRandomItemPool()
        SetGlobalLibData(itemPoolType, "ItemPoolType")
        SetGlobalLibData(0, "KillCount")
    else
        SetGlobalLibData(killCount + 1, "KillCount")
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_THUMBSUP, 0.6)
end
DarkMask:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, DarkMask.PostNPCDeath)

return DarkMask