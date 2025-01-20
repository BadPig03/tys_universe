local Foods = TYU:RegisterNewClass()

local PrivateField = {}

do
    PrivateField.FoodStats = {
        [TYU.ModFoodItemIDs.FOODS] = { 0, 0, 0, 0, 0, 0 },
        [TYU.ModFoodItemIDs.APPLE] = { 2, 1, 1, 0, 0, 0 },
        [TYU.ModFoodItemIDs.BAKED_POTATO] = { 2, 2, 2, 0, 0, 0 },
        [TYU.ModFoodItemIDs.BEETROOT] = { 0, 1, 1, 2, 0, 0 },
        [TYU.ModFoodItemIDs.BROWN_MUSHROOM] = { 0, 2, 1, 0, 2, 0 },
        [TYU.ModFoodItemIDs.CARROT] = { 2, 2, 1, 0, 0, 0 },
        [TYU.ModFoodItemIDs.CHORUS_FRUIT] = { 2, 1, 1, 0, 0, 0 },
        [TYU.ModFoodItemIDs.COCOA_BEANS] = { 0, 0, 1, 2, 0, 2 },
        [TYU.ModFoodItemIDs.DRIED_KELP] = { 0, 0, 2, 1, 0, 2 },
        [TYU.ModFoodItemIDs.GLOW_BERRIES] = { 0, 0, 2, 2, 2, 0 },
        [TYU.ModFoodItemIDs.GOLDEN_APPLE] = { 3, 3, 2, 0, 0, 0 },
        [TYU.ModFoodItemIDs.GOLDEN_CARROT] = { 4, 4, 4, 0, 0, 0 },
        [TYU.ModFoodItemIDs.MELON_SLICE] = { 0, 2, 1, 0, 1, 0 },
        [TYU.ModFoodItemIDs.POTATO] = { 0, 0, 2, 2, 0, 2 },
        [TYU.ModFoodItemIDs.RED_MUSHROOM] = { 0, 2, 1, 0, 2, 0 },
        [TYU.ModFoodItemIDs.SWEET_BERRIES] = { 0, 0, 2, 2, 2, 0 },
        [TYU.ModFoodItemIDs.WHEAT] = { 0, 1, 1, 2, 0, 0 },
        [TYU.ModFoodItemIDs.CABBAGE] = { 0, 2, 1, 0, 1, 0 },
        [TYU.ModFoodItemIDs.ONION] = { 0, 2, 1, 0, 1, 0 },
        [TYU.ModFoodItemIDs.PUMPKIN_SLICE] = { 1, 1, 0, 2, 0, 0 },
        [TYU.ModFoodItemIDs.TOMATO] = { 0, 0, 2, 2, 0, 2 },
        [TYU.ModFoodItemIDs.MONSTER_MEAT] = { 0, 0, 0, 2, 2, 2 }
    }

    PrivateField.StandardValues = { 0.25, 0.2, 0.1, 0.4, 0.04, 0.025 }
end

do
    PrivateField.Outcomes = WeightedOutcomePicker()
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.APPLE, 6)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.BAKED_POTATO, 4)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.BEETROOT, 9)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.BROWN_MUSHROOM, 8)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.CARROT, 5)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.CHORUS_FRUIT, 6)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.COCOA_BEANS, 10)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.DRIED_KELP, 10)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.GLOW_BERRIES, 9)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.GOLDEN_APPLE, 2)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.GOLDEN_CARROT, 3)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.MELON_SLICE, 8)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.POTATO, 10)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.RED_MUSHROOM, 8)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.SWEET_BERRIES, 9)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.WHEAT, 9)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.CABBAGE, 8)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.ONION, 8)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.PUMPKIN_SLICE, 7)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.TOMATO, 10)
    PrivateField.Outcomes:AddOutcomeWeight(TYU.ModFoodItemIDs.MONSTER_MEAT, 10)
end

function Foods.ApplySpecialEffect(food, player, rng)
    local effects = player:GetEffects()
    local seed = rng:Next()
    if food == TYU.ModFoodItemIDs.CHORUS_FRUIT then
        TYU.GAME:MoveToRandomRoom(false, seed, player)
    elseif food == TYU.ModFoodItemIDs.GOLDEN_APPLE then
        player:AddHearts(4)
        player:AddSoulHearts(2)
    elseif food == TYU.ModFoodItemIDs.MONSTER_MEAT then
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
    return PrivateField.StandardValues
end

function Foods.GetNourishmentValue(food)
    return PrivateField.FoodStats[food] or { 0, 0, 0, 0, 0, 0 }
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
    return PrivateField.Outcomes:PickOutcome(rng)
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