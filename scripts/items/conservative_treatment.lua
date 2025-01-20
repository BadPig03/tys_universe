local ConservativeTreatment = TYU:NewModItem("Conservative Treatment", "CONSERVATIVE_TREATMENT")

local ModItemIDs = TYU.ModItemIDs

function ConservativeTreatment:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    local healthType = player:GetHealthType()
    if healthType == HealthType.BONE then
        if player:GetBoneHearts() < 3 then
            player:AddBoneHearts(3 - player:GetBoneHearts())
            player:AddHearts(math.max(0, 6 - player:GetHearts()))
        end
    elseif healthType == HealthType.SOUL then
        if player:GetSoulHearts() < 6 then
            player:AddSoulHearts(6 - player:GetSoulHearts())
        end
    else
        if player:GetMaxHearts() < 6 then
            player:AddMaxHearts(6 - player:GetMaxHearts())
            player:AddHearts(math.max(0, 6 - player:GetHearts()))
        end
    end
end
ConservativeTreatment:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ConservativeTreatment.PostAddCollectible, ModItemIDs.CONSERVATIVE_TREATMENT)

return ConservativeTreatment