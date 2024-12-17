local Lib = TYU
local ConservativeTreatment = Lib:NewModItem("Conservative Treatment", "CONSERVATIVETREATMENT")

function ConservativeTreatment:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    if player:GetHealthType() == HealthType.BONE then
        if player:GetBoneHearts() < 3 then
            player:AddBoneHearts(3 - player:GetBoneHearts())
            player:AddHearts(math.max(0, 6 - player:GetHearts()))
        end
    elseif player:GetHealthType() == HealthType.RED or player:GetHealthType() == HealthType.KEEPER then
        if player:GetMaxHearts() < 6 then
            player:AddMaxHearts(6 - player:GetMaxHearts())
            player:AddHearts(math.max(0, 6 - player:GetHearts()))
        end
    elseif player:GetHealthType() == HealthType.SOUL then
        if player:GetSoulHearts() < 6 then
            player:AddSoulHearts(6 - player:GetSoulHearts())
        end
    end
end
ConservativeTreatment:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ConservativeTreatment.PostAddCollectible, Lib.ModItemIDs.CONSERVATIVETREATMENT)

return ConservativeTreatment