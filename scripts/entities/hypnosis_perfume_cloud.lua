local HypnosisPerfumeCloud = TYU:NewModEntity("Hypnosis Perfume Cloud", "HYPNOSIS_PERFUME_CLOUD")

local Entities = TYU.Entities
local Players = TYU.Players

local ModEntityIDs = TYU.ModEntityIDs
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do
    function PrivateField.IsCloudNearby(entity)
        for _, ent in pairs(Isaac.FindByType(ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.Type, ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.Variant, ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.SubType)) do
            if entity.Position:Distance(ent.Position) <= 30 then
                return true
            end
        end
        return false
    end
end

function HypnosisPerfumeCloud:PostEffectUpdate(effect)
    local timeout = effect.Timeout
    if timeout <= 10 and timeout > 0 then
        effect.Color = Color(1, 1, 1, timeout / 10)
    elseif timeout  == 0 then
        effect:Remove()
    end
end
HypnosisPerfumeCloud:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, HypnosisPerfumeCloud.PostEffectUpdate, ModEntityIDs.HYPNOSIS_PERFUME_CLOUD.Variant)

function HypnosisPerfumeCloud:PostUpdate()
    for _, ent in pairs(Isaac.GetRoomEntities()) do
        local npc = ent:ToNPC()
        if not npc and not Entities.IsValidEnemy(ent) then
            goto continue
        end
        local player = Players.FirstCollectibleOwner(ModItemIDs.HYPNOSIS_PERFUME)
        if PrivateField.IsCloudNearby(npc) then
            local time = (npc:IsBoss() and 300) or -1
            npc:AddCharmed(EntityRef(player), time)
        end
        ::continue::
    end
end
HypnosisPerfumeCloud:AddCallback(ModCallbacks.MC_POST_UPDATE, HypnosisPerfumeCloud.PostUpdate)

return HypnosisPerfumeCloud