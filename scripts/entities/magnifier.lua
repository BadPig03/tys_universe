local Lib = TYU
local Magnifier = Lib:NewModEntity("Magnifier", "MAGNIFIER")

function Magnifier:FamiliarUpdate(familiar)
    local sprite = familiar:GetSprite()
    local player = familiar.Player
    local target = Lib.Entities.GetLowestHealthEnemy(familiar.Position) or player
    familiar:FollowPosition(target.Position - Vector(0, target.Size / 2))
    familiar.Target = target
    if sprite:IsFinished("Appear") then
        sprite:Play("Float", true)
    end
end
Magnifier:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Magnifier.FamiliarUpdate, Lib.ModEntityIDs.MAGNIFIER.Variant)

function Magnifier:PostNPCInit(npc)
    if not npc:IsActiveEnemy() then
        return
    end
    Lib:SetTempEntityLibData(npc, npc.Scale, "Magnifier", "Scale")
    Lib:SetTempEntityLibData(npc, npc.SizeMulti, "Magnifier", "SizeMulti")
end
Magnifier:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Magnifier.PostNPCInit)

function Magnifier:PostNPCRender(npc)
    if not npc:IsActiveEnemy() then
        return
    end
    local scale = Lib:GetTempEntityLibData(npc, "Magnifier", "Scale") or 1
    local sizeMulti = Lib:GetTempEntityLibData(npc, "Magnifier", "SizeMulti") or Vector(1, 1)
    local magnifiers = Isaac.FindByType(Lib.ModEntityIDs.MAGNIFIER.Type, Lib.ModEntityIDs.MAGNIFIER.Variant, Lib.ModEntityIDs.MAGNIFIER.SubType)
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
    if not Lib.Entities.IsValidEnemy(entity) or #Isaac.FindByType(Lib.ModEntityIDs.MAGNIFIER.Type, Lib.ModEntityIDs.MAGNIFIER.Variant, Lib.ModEntityIDs.MAGNIFIER.SubType) == 0 then
        return
    end
    local npc = entity:ToNPC()
    return { Damage = amount * npc.Scale ^ 0.8 }
end
Magnifier:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Magnifier.TakeDamage)

return Magnifier