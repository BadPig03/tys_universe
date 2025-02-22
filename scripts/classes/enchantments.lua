local Enchantments = TYU:RegisterNewClass()

local PrivateField = {}

do
    function PrivateField.IsEnchantmentApplicable(player, enchantmentID)
        local effects = player:GetEffects()
        for id, info in pairs(TYU.ModEnchantmentInfos) do
            if id == enchantmentID and effects:GetNullEffectNum(id) >= info[4] then
                return false
            end
        end
        return true
    end
end

function Enchantments.GetARandomEnchantment(seed, includeCurse)
    includeCurse = includeCurse or false
    local enchantmentOutcomes = WeightedOutcomePicker()
    for id, info in pairs(TYU.ModEnchantmentInfos) do
        if info[5] then
            if includeCurse then
                enchantmentOutcomes:AddOutcomeWeight(id, info[3])
            end
        else
            enchantmentOutcomes:AddOutcomeWeight(id, info[3])
        end
    end
    if enchantmentOutcomes:GetNumOutcomes() == 0 then
        enchantmentOutcomes:AddOutcomeWeight(0, 1)
    end
    return enchantmentOutcomes:PickOutcome(RNG(seed))
end

function Enchantments.GetAnApplicableEnchantment(player, seed)
    local enchantmentOutcomes = WeightedOutcomePicker()
    for id, info in pairs(TYU.ModEnchantmentInfos) do
        if not info[5] and PrivateField.IsEnchantmentApplicable(player, id) then
            enchantmentOutcomes:AddOutcomeWeight(id, info[3])
        end
    end
    if enchantmentOutcomes:GetNumOutcomes() == 0 then
        enchantmentOutcomes:AddOutcomeWeight(0, 1)
    end
    return enchantmentOutcomes:PickOutcome(RNG(seed))
end

function Enchantments.GrantEnchantmentToPlayer(player, enchantmentID)
    local isChinese = Options.Language == "zh"
    if not PrivateField.IsEnchantmentApplicable(player, enchantmentID) then
        if isChinese then
            TYU.HUD:ShowFortuneText("该附魔已到最大等级")
        else
            TYU.HUD:ShowFortuneText("This enchantment", "has reached", "the maximum level")
        end    
        player:AnimateSad()
        return
    end
    if isChinese then
        TYU.HUD:ShowFortuneText("你获得了"..TYU.ModEnchantmentInfos[enchantmentID][1].."附魔")
    else
        TYU.HUD:ShowFortuneText("You granted", TYU.ModEnchantmentInfos[enchantmentID][2])
    end
    player:GetEffects():AddNullEffect(enchantmentID)
    if TYU.ModEnchantmentInfos[enchantmentID][5] then
        player:AnimateSad()
    else
        player:AnimateHappy()
    end
end

return Enchantments