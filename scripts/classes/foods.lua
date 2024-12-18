local Lib = TYU
local Foods = Lib:RegisterNewClass()

local foodStats = {
    [Lib.ModFoodItemIDs.FOODS] = { 0, 0, 0, 0, 0, 0 },
    [Lib.ModFoodItemIDs.APPLE] = { 2, 1, 1, 0, 0, 0 },
    [Lib.ModFoodItemIDs.BAKEDPOTATO] = { 2, 2, 2, 0, 0, 0 },
    [Lib.ModFoodItemIDs.BEETROOT] = { 0, 1, 1, 2, 0, 0 },
    [Lib.ModFoodItemIDs.BROWNMUSHROOM] = { 0, 2, 1, 0, 2, 0 },
    [Lib.ModFoodItemIDs.CARROT] = { 2, 2, 1, 0, 0, 0 },
    [Lib.ModFoodItemIDs.CHORUSFRUIT] = { 2, 1, 1, 0, 0, 0 },
    [Lib.ModFoodItemIDs.COCOABEANS] = { 0, 0, 1, 2, 0, 2 },
    [Lib.ModFoodItemIDs.DRIEDKELP] = { 0, 0, 2, 1, 0, 2 },
    [Lib.ModFoodItemIDs.GLOWBERRIES] = { 0, 0, 2, 2, 2, 0 },
    [Lib.ModFoodItemIDs.GOLDENAPPLE] = { 3, 3, 2, 0, 0, 0 },
    [Lib.ModFoodItemIDs.GOLDENCARROT] = { 4, 4, 4, 0, 0, 0 },
    [Lib.ModFoodItemIDs.MELONSLICE] = { 0, 2, 1, 0, 1, 0 },
    [Lib.ModFoodItemIDs.POTATO] = { 0, 0, 2, 2, 0, 2 },
    [Lib.ModFoodItemIDs.REDMUSHROOM] = { 0, 2, 1, 0, 2, 0 },
    [Lib.ModFoodItemIDs.SWEETBERRIES] = { 0, 0, 2, 2, 2, 0 },
    [Lib.ModFoodItemIDs.WHEAT] = { 0, 1, 1, 2, 0, 0 },
    [Lib.ModFoodItemIDs.CABBAGE] = { 0, 2, 1, 0, 1, 0 },
    [Lib.ModFoodItemIDs.ONION] = { 0, 2, 1, 0, 1, 0 },
    [Lib.ModFoodItemIDs.PUMPKINSLICE] = { 1, 1, 0, 2, 0, 0 },
    [Lib.ModFoodItemIDs.TOMATO] = { 0, 0, 2, 2, 0, 2 },
    [Lib.ModFoodItemIDs.MONSTERMEAT] = { 0, 0, 0, 2, 2, 2 }
}

local standardValues = { 0.25, 0.2, 0.1, 0.4, 0.04, 0.025 }

local outcomes = WeightedOutcomePicker()
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.APPLE, 6)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.BAKEDPOTATO, 4)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.BEETROOT, 9)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.BROWNMUSHROOM, 8)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.CARROT, 5)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.CHORUSFRUIT, 6)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.COCOABEANS, 10)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.DRIEDKELP, 10)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.GLOWBERRIES, 9)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.GOLDENAPPLE, 2)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.GOLDENCARROT, 3)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.MELONSLICE, 8)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.POTATO, 10)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.REDMUSHROOM, 8)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.SWEETBERRIES, 9)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.WHEAT, 9)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.CABBAGE, 8)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.ONION, 8)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.PUMPKINSLICE, 7)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.TOMATO, 10)
outcomes:AddOutcomeWeight(Lib.ModFoodItemIDs.MONSTERMEAT, 10)

function Foods.ApplySpecialEffect(food, player, rng)
    local effects = player:GetEffects()
    local seed = rng:Next()
    if food == Lib.ModFoodItemIDs.CHORUSFRUIT then
        Lib.GAME:MoveToRandomRoom(false, seed, player)
    elseif food == Lib.ModFoodItemIDs.GOLDENAPPLE then
        player:AddHearts(4)
        player:AddSoulHearts(2)
    elseif food == Lib.ModFoodItemIDs.MONSTERMEAT then
        player:AddRottenHearts(1)
    end
end

function Foods.CombineValues(origin)
    local combined = 0
    for i, v in ipairs(origin) do
        local value = v or 0
        combined = combined | (value << ((4 - i) * 8))
    end
    return combined
end

function Foods.ExtractValues(origin)
    local values = {}
    for i = 1, 4 do
        local value = (origin >> ((4 - i) * 8)) & 0xFF
        table.insert(values, value)
    end
    return values
end

function Foods.GetStatStandardValues()
    return standardValues
end

function Foods.GetNourishmentValue(food)
    return foodStats[food] or { 0, 0, 0, 0, 0, 0 }
end

function Foods.GetValidEmptySlot(origin)
    local count = 0
    local bank = Foods.ExtractValues(origin)
    for i = 1, 4 do
        if bank[i] == 0 then
            count = count + 1
        end
    end
    return count
end

function Foods.GetRandomFood(rng)
    return outcomes:PickOutcome(rng)
end

function Foods.GetStatsTranslation()
    local language = (EID:getLanguage() == "zh_cn" and 1) or 2
    local translation = {
        { "{{Tears}} 射速修正", "{{Damage}} 伤害修正", "{{Luck}} 幸运", "{{Range}} 射程", "{{Speed}} 移速", "{{Shotspeed}} 弹速" },
        { "{{Tears}} Fire rate ", "{{Damage}} Damage ", "{{Luck}} Luck ", "{{Range}} Range ", "{{Speed}} Move speed ", "{{Shotspeed}} Shot speed " }
    }
    return translation[language]
end

function Foods.GetSpecialEffectTranslation(bank)
    local result = ""
    local language = (EID:getLanguage() == "zh_cn" and 1) or 2
    local translation = {
        { "#将角色传送到随机房间，错误房除外", "#获得", "颗红心和", "颗魂心", "颗腐心" },
        { "#Teleports Isaac into a random room, except I AM ERROR rooms", "#Grants ", " red hearts and ", " soul heart(s)", " rotten heart(s)" }
    }
    local teleportFlag = true
    local goldenApples = 0
    local monsterMeats = 0
    for i = 1, 4 do
        local food = bank[i]
        if food == 6 and teleportFlag then
            result = result..translation[language][1]
            teleportFlag = false
        end
        if food == 10 then
            goldenApples = goldenApples + 1
        end
        if food == 21 then
            monsterMeats = monsterMeats + 1
        end
    end
    if goldenApples > 0 then
        result = result..translation[language][2]..(goldenApples * 2)..translation[language][3]..goldenApples..translation[language][4]
    end
    if monsterMeats > 0 then
        result = result..translation[language][2]..monsterMeats..translation[language][5]
    end
    return result
end

function Foods.GetSuspiciousStewResult(combined)
    if combined == 0 then
        return (EID:getLanguage() == "zh_cn" and "#获得一份死亡证明") or "#Grants a death certification"
    end
    local bank = Foods.ExtractValues(combined)
    local stats = { 0, 0, 0, 0, 0, 0 }
    local statStandardValues = Foods.GetStatStandardValues()
    local result = ""
    local translation = Foods.GetStatsTranslation()
    for i = 1, 4 do
        local food = bank[i]
        local nourishmentValue = Foods.GetNourishmentValue(food)
        for j = 1, 6 do
            stats[j] = stats[j] + (nourishmentValue[j] * statStandardValues[j])
        end
    end
    for i = 1, 6 do
        if stats[i] > 0 then
            result = result.."#"..translation[i].."+"..stats[i]
        end
    end
    result = result..Foods.GetSpecialEffectTranslation(bank)
    return result
end

function Foods.GetFoodResult(food)
    local stats = { 0, 0, 0, 0, 0, 0 }
    local statStandardValues = Foods.GetStatStandardValues()
    local result = ""
    local translation = Foods.GetStatsTranslation()
    local nourishmentValue = Foods.GetNourishmentValue(food)
    for j = 1, 6 do
        stats[j] = stats[j] + (nourishmentValue[j] * statStandardValues[j])
    end
    for i = 1, 6 do
        if stats[i] > 0 then
            result = result.."#"..translation[i].."+"..stats[i]
        end
    end
    result = result..Foods.GetSpecialEffectTranslation({ food, 0, 0, 0 })
    return result
end

return Foods