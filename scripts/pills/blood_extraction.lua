local BloodExtraction = TYU:NewModPill("Blood Extraction", "BLOOD_EXTRACTION")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModPillEffectIDs = TYU.ModPillEffectIDs

function BloodExtraction:EvaluateFamiliarMultiplier(familiar, multiplier, player)
    if familiar.Hearts ~= 2003 or familiar.Coins ~= 7 or familiar.Keys ~= 30 or multiplier ~= 1.0 or player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        return
    end
    return 2.0
end
BloodExtraction:AddCallback(ModCallbacks.MC_EVALUATE_FAMILIAR_MULTIPLIER, BloodExtraction.EvaluateFamiliarMultiplier, FamiliarVariant.BLOOD_BABY)

function BloodExtraction:UsePill(pillEffect, player, useFlags, pillColor)
    local isHorsePill = Utils.HasFlags(pillColor, PillColor.PILL_GIANT_FLAG)
    local count = player:GetGoldenHearts() + player:GetEternalHearts() + player:GetHearts() - player:GetRottenHearts()
    for i = 1, count - 2 do
        player:SpawnClot(player.Position, false)
    end
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY)) do
        if ent.FrameCount == 0 then
            local clot = ent:ToFamiliar()
            clot.HitPoints = clot.HitPoints * 2
            if isHorsePill then
                clot:AddHearts(2003)
                clot:AddCoins(7)
                clot:AddKeys(30)
                clot:InvalidateCachedMultiplier()
            end
        end
    end
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
    player:AnimateHappy()
end
BloodExtraction:AddCallback(ModCallbacks.MC_USE_PILL, BloodExtraction.UsePill, ModPillEffectIDs.BLOOD_EXTRACTION)

return BloodExtraction