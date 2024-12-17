local Lib = TYU
local Landmine = Lib:NewModEntity("Landmine", "LANDMINE")

local function Explode(landmine, passive)
    passive = passive or false
    local data = Lib:GetTempEntityLibData(landmine, "Landmine")
    local player = data.Player
    local bomb = Lib.Entities.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, landmine.Position, Vector(0, 0), player):ToBomb()
    bomb:SetExplosionCountdown(0)
    bomb.Visible = false
    if data.Fast then
        bomb:AddTearFlags(TearFlags.TEAR_FAST_BOMB)
    end
    if passive and data.Fetus then
        bomb.ExplosionDamage = bomb.ExplosionDamage * 2
    end
    if not passive and data.Epic then
        bomb.ExplosionDamage = bomb.ExplosionDamage * 2
    end
    if data.Sad then
        bomb:AddTearFlags(TearFlags.TEAR_SAD_BOMB)
    end
    if data.Hot then
        bomb:AddTearFlags(TearFlags.TEAR_BURN)
    end
    if data.Mega then
        bomb.ExplosionDamage = bomb.ExplosionDamage * 1.85
    end
    if data.Bob then
        bomb:AddTearFlags(TearFlags.TEAR_POISON)
    end
    if data.Butt then
        bomb:AddTearFlags(TearFlags.TEAR_BUTT_BOMB)
    end
    if data.Bomber then
        bomb:AddTearFlags(TearFlags.TEAR_CROSS_BOMB)
    end
    if data.Ghost then
        bomb:AddTearFlags(TearFlags.TEAR_GHOST_BOMB)
    end
    if data.Blood then
        bomb:AddTearFlags(TearFlags.TEAR_BLOOD_BOMB)
    end
    if data.Scatter then
        bomb:AddTearFlags(TearFlags.TEAR_SCATTER_BOMB)
    end
    if data.Glitter then
        bomb:AddTearFlags(TearFlags.TEAR_GLITTER_BOMB)
    end
    bomb:AddTearFlags(Lib.ModTearFlags.TEAR_EXPLOSION_MASTER)
    landmine:Remove()
end

function Landmine:PostSlotUpdate(landmine)
    local data = Lib:GetTempEntityLibData(landmine, "Landmine")
    if not data then
        local bomb = Lib.Entities.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, landmine.Position, Vector(0, 0), landmine):ToBomb()
        bomb:SetExplosionCountdown(0)
        bomb.Visible = false
        bomb:AddTearFlags(Lib.ModTearFlags.TEAR_EXPLOSION_MASTER)
        landmine:Remove()
        return
    end
    local sprite = landmine:GetSprite()
    if sprite:IsPlaying("Idle") then
        sprite:Play("Glowing", true)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER, 0.6)
    end
    local target = Lib.Entities.GetNearestEnemy(landmine.Position)
    if target then
        local speed = 1 / (((target.Position - landmine.Position):Length() - target.Size) / 120)
        local maxSpeed = data.Bobby and 3 or 6
        if speed > 1 then
            sprite.PlaybackSpeed = speed
            if speed > maxSpeed then
                Explode(landmine)
            end
        else
            sprite.PlaybackSpeed = 1
        end
    else
        if sprite.PlaybackSpeed ~= 1 then
            sprite.PlaybackSpeed = 1
        end
    end
    local maxTouch = data.Fast and 2 or 10
    if landmine:GetTouch() >= maxTouch then
        Explode(landmine)
    end
end
Landmine:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, Landmine.PostSlotUpdate, Lib.ModEntityIDs.LANDMINE.Variant)

function Landmine:PreSlotCreateExplosionDrops(landmine)
    Explode(landmine, true)
    return false
end
Landmine:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, Landmine.PreSlotCreateExplosionDrops, Lib.ModEntityIDs.LANDMINE.Variant)

function Landmine:PreRoomExit()
    for _, landmine in pairs(Isaac.FindByType(Lib.ModEntityIDs.LANDMINE.Type, Lib.ModEntityIDs.LANDMINE.Variant, Lib.ModEntityIDs.LANDMINE.SubType)) do
        landmine:Remove()
    end
end
Landmine:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, Landmine.PreRoomExit)
Landmine:AddCallback(Lib.Callbacks.TYU_POST_LOAD, Landmine.PreRoomExit)

return Landmine