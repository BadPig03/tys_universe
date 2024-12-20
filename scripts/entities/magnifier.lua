local Magnifier = TYU:NewModEntity("Magnifier", "MAGNIFIER")
local Entities = TYU.Entities
local ModEntityIDs = TYU.ModEntityIDs
local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "Magnifier", ...)
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "Magnifier", ...)
end

do
    function PrivateField.GetLowestHealthEnemy(position)
        local minHealth = math.maxinteger
        local minHealthEnemy = nil
        for _, ent in pairs(Isaac.FindInRadius(position, 8192, EntityPartition.ENEMY)) do
            if Entities.IsValidEnemy(ent) and ent.HitPoints < minHealth then
                minHealth = ent.HitPoints
                minHealthEnemy = ent
            end
        end
        return minHealthEnemy
    end
end

function Magnifier:FamiliarInit(familiar)
    local sprite = familiar:GetSprite()
    sprite:Play("Appear", true)
    familiar.DepthOffset = 9999
end
Magnifier:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Magnifier.FamiliarInit, ModEntityIDs.MAGNIFIER.Variant)

function Magnifier:FamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()
    local player = familiar.Player
    local target = PrivateField.GetLowestHealthEnemy(familiar.Position) or player
    familiar:FollowPosition(target.Position - Vector(0, target.Size / 2))
    familiar.Target = target
    if sprite:IsFinished("Appear") then
        sprite:Play("Float", true)
    end
end
Magnifier:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Magnifier.FamiliarUpdate, ModEntityIDs.MAGNIFIER.Variant)

function Magnifier:PostNPCInit(npc)
    if not npc:IsActiveEnemy() then
        return
    end
    SetTempEntityLibData(npc, npc.Scale, "Scale")
    SetTempEntityLibData(npc, npc.SizeMulti, "SizeMulti")
end
Magnifier:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Magnifier.PostNPCInit)

function Magnifier:PostNPCRender(npc)
    if not npc:IsActiveEnemy() then
        return
    end
    local scale = GetTempEntityLibData(npc, "Scale") or 1
    local sizeMulti = GetTempEntityLibData(npc, "SizeMulti") or Vector(1, 1)
    local magnifiers = Isaac.FindByType(ModEntityIDs.MAGNIFIER.Type, ModEntityIDs.MAGNIFIER.Variant, ModEntityIDs.MAGNIFIER.SubType)
    if #magnifiers == 0 then
        npc.Scale = scale
        npc.SizeMulti = sizeMulti
        return
    end
    local maxScaleFactor = 0
    for _, ent in ipairs(magnifiers) do
        local familiar = ent:ToFamiliar()
        local target = familiar.Target or familiar.Player
        local distance = (familiar.Position - Vector(0, target.Size / 2) - npc.Position):Length()
        local scaleFactor = 1 + (128 - math.min(distance, 128)) / 128
        maxScaleFactor = math.max(maxScaleFactor, scaleFactor)
    end
    npc.Scale = scale * maxScaleFactor
    npc.SizeMulti = sizeMulti * math.sqrt(maxScaleFactor)
end
Magnifier:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, Magnifier.PostNPCRender)

function Magnifier:TakeDamage(entity, amount, flags, source, countdown)
    local npc = entity:ToNPC()
    if not npc or not Entities.IsValidEnemy(entity) or #Isaac.FindByType(ModEntityIDs.MAGNIFIER.Type, ModEntityIDs.MAGNIFIER.Variant, ModEntityIDs.MAGNIFIER.SubType) == 0 then
        return
    end
    return { Damage = amount * npc.Scale ^ 0.8 }
end
Magnifier:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Magnifier.TakeDamage)

return Magnifier