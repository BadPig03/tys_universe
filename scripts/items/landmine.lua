local Landmine = TYU:NewModItem("Landmine", "LANDMINE")
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "Landmine", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "Landmine", ...)
end

do
    function PrivateField.ReplaceSprite(landmine, player)
        local sprite = landmine:GetSprite()
        local data = GetTempEntityLibData(landmine)
        data.Player = player
        if data.Glitter then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_glitter.png", true)
            goto continue
        end
        if data.Scatter then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_scatter.png", true)
            goto continue
        end
        if data.Blood then
            sprite:Load("gfx/items/slots/landmine_nolight.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_blood.png", true)
            goto continue
        end
        if data.Ghost then
            sprite:Load("gfx/items/slots/landmine_nolight.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_ghost.png", true)
            goto continue
        end
        if data.Bomber then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_bomber.png", true)
            goto continue
        end
        if data.Butt then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_butt.png", true)
            goto continue
        end
        if data.Bob then
            sprite:Load("gfx/items/slots/landmine_green.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_bob.png", true)
            goto continue
        end
        if data.Mega then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_mega.png", true)
            goto continue
        end
        if data.Hot then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_hot.png", true)
            goto continue
        end
        if data.Sad then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_sad.png", true)
            goto continue
        end
        if data.Bobby then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_bobby.png", true)
            goto continue
        end
        if data.Epic then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_epic.png", true)
            goto continue
        end
        if data.Fetus then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_fetus.png", true)
            goto continue
        end
        if data.Fast then
            sprite:Load("gfx/items/slots/landmine.anm2", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/landmine_fast.png", true)
            goto continue
        end
        ::continue::
        sprite:Play("Glowing", true)
    end

    
    function PrivateField.SpawnALandmine(player)
        local rng = player:GetCollectibleRNG(ModItemIDs.LANDMINE)
        local room = TYU.GAME:GetRoom()
        local position = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetRandomTileIndex(rng:Next())), 0, true, false) + Vector(0, 10)
        local landmine = Entities.Spawn(ModEntityIDs.LANDMINE.Type, ModEntityIDs.LANDMINE.Variant, ModEntityIDs.LANDMINE.SubType, position):ToSlot()
        local data = {}
        data.Glitter = player:HasCollectible(CollectibleType.COLLECTIBLE_GLITTER_BOMBS)
        data.Scatter = player:HasCollectible(CollectibleType.COLLECTIBLE_SCATTER_BOMBS)
        data.Blood = player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS)
        data.Ghost = player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS)
        data.Bomber = player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
        data.Butt = player:HasCollectible(CollectibleType.COLLECTIBLE_BUTT_BOMBS)
        data.Bob = player:HasCollectible(CollectibleType.COLLECTIBLE_BOBS_CURSE)
        data.Mega = player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA)
        data.Hot = player:HasCollectible(CollectibleType.COLLECTIBLE_HOT_BOMBS)
        data.Sad = player:HasCollectible(CollectibleType.COLLECTIBLE_SAD_BOMBS)
        data.Bobby = player:HasCollectible(CollectibleType.COLLECTIBLE_BOBBY_BOMB)
        data.Epic = player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS)
        data.Fetus = player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
        data.Fast = player:HasCollectible(CollectibleType.COLLECTIBLE_FAST_BOMBS)
        SetTempEntityLibData(landmine, data)
        PrivateField.ReplaceSprite(landmine, player)
        Entities.SpawnPoof(landmine.Position)
    end
end

function Landmine:PostNewRoom()
    if not Players.AnyoneHasCollectible(ModItemIDs.LANDMINE) or not Utils.IsRoomFirstVisit() or Utils.IsStartingRoom() then
        return
    end
    for i = 1, TYU.LEVEL:GetStage() do
        for _, player in pairs(Players.GetPlayers(true)) do
            PrivateField.SpawnALandmine(player)
        end
    end
end
Landmine:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Landmine.PostNewRoom)

function Landmine:PostUpdate(player)
    if not Players.AnyoneHasCollectible(ModItemIDs.LANDMINE) then
        return
    end
    local room = TYU.GAME:GetRoom()
    local rng = RNG(room:GetAwardSeed())
    if room:IsClear() or room:GetFrameCount() % rng:RandomInt(150, 450) ~= 30 then
        return
    end
    for _, player in pairs(Players.GetPlayers(true)) do
        PrivateField.SpawnALandmine(player)
    end
end
Landmine:AddCallback(ModCallbacks.MC_POST_UPDATE, Landmine.PostUpdate)

return Landmine