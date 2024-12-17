local Lib = TYU
local Landmine = Lib:NewModItem("Landmine", "LANDMINE")

local function ReplaceSprite(landmine, player)
    local sprite = landmine:GetSprite()
    local data = Lib:GetTempEntityLibData(landmine, "Landmine")
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

local function SpawnALandmine(player)
    local room = Lib.GAME:GetRoom()
    local rng = player:GetCollectibleRNG(Lib.ModItemIDs.LANDMINE)
    local position = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetRandomTileIndex(rng:Next())), 0, true, false) + Vector(0, 10)
    local landmine = Lib.Entities.Spawn(Lib.ModEntityIDs.LANDMINE.Type, Lib.ModEntityIDs.LANDMINE.Variant, Lib.ModEntityIDs.LANDMINE.SubType, position):ToSlot()
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
    Lib:SetTempEntityLibData(landmine, data, "Landmine")
    ReplaceSprite(landmine, player)
    Lib.Entities.SpawnPoof(landmine.Position)
end

local function GetLandmineCount()
    local count = Isaac.CountEntities(nil, Lib.ModEntityIDs.LANDMINE.Type, Lib.ModEntityIDs.LANDMINE.Variant, Lib.ModEntityIDs.LANDMINE.SubType)
    return count
end

function Landmine:PostNewRoom()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.LANDMINE) then
        return
    end
    local room = Lib.GAME:GetRoom()
    if not room:IsFirstVisit() or Lib.LEVEL:GetCurrentRoomIndex() == Lib.LEVEL:GetStartingRoomIndex() then
        return
    end
    for i = 1, Lib.LEVEL:GetStage() do
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            SpawnALandmine(player)
        end
    end
end
Landmine:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Landmine.PostNewRoom)

function Landmine:PostUpdate(player)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.LANDMINE) then
        return
    end
    local room = Lib.GAME:GetRoom()
    local rng = RNG(room:GetAwardSeed())
    if room:IsClear() or room:GetFrameCount() % rng:RandomInt(150, 450) ~= 30 then
        return
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        SpawnALandmine(player)
    end
end
Landmine:AddCallback(ModCallbacks.MC_POST_UPDATE, Landmine.PostUpdate)

return Landmine