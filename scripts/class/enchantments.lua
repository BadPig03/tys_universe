local Lib = TYU
local Enchantments = Lib:RegisterNewClass()

local function IsEnchantmentApplicable(player, enchantmentID)
    local effects = player:GetEffects()
    for id, info in pairs(Lib.ModEnchantmentInfos) do
        if id == enchantmentID and effects:GetNullEffectNum(id) >= info[4] then
            return false
        end
    end
    return true
end

function Enchantments.GetARandomEnchantment(seed, includeCurse)
    includeCurse = includeCurse or false
    local enchantmentOutcomes = WeightedOutcomePicker()
    for id, info in pairs(Lib.ModEnchantmentInfos) do
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
    for id, info in pairs(Lib.ModEnchantmentInfos) do
        if not info[5] and IsEnchantmentApplicable(player, id) then
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
    if not IsEnchantmentApplicable(player, enchantmentID) then
        if isChinese then
            Lib.HUD:ShowFortuneText("该附魔已到最大等级")
        else
            Lib.HUD:ShowFortuneText("This enchantment", "has reached", "the maximum level")
        end    
        player:AnimateSad()
        return
    end
    if isChinese then
        Lib.HUD:ShowFortuneText("你获得了"..Lib.ModEnchantmentInfos[enchantmentID][1].."附魔")
    else
        Lib.HUD:ShowFortuneText("You granted", Lib.ModEnchantmentInfos[enchantmentID][2])
    end
    player:GetEffects():AddNullEffect(enchantmentID)
    if Lib.ModEnchantmentInfos[enchantmentID][5] then
        player:AnimateSad()
    else
        player:AnimateHappy()
    end
end

return Enchantments