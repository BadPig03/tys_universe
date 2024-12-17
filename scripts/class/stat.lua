local Lib = TYU
local Stat = Lib:RegisterNewClass()

local Private = {}

local function GetPlayerData(player, ...)
    return Lib:GetTempEntityLibData(player, "Stats", ...)
end
local function SetPlayerData(player, value, ...)
    Lib:SetTempEntityLibData(player, value, "Stats", ...)
end

local function AddTearsModifier(tears, value, reverse)
    if reverse then
        return tears - value
    else
        return tears + value
    end
end
local function MultiplyTearsModifier(tears, value, reverse)
    if reverse then
        return tears / value
    else
        return tears * value
    end
end
local function ResetDamageCaches(player)
    SetPlayerData(player, nil, "DamageMultiplier")
    SetPlayerData(player, nil, "DamageUp")
    SetPlayerData(player, nil, "DamageFlat")
end
local function ResetTearsCaches(player)
    SetPlayerData(player, nil, "TearsUp")
    SetPlayerData(player, nil, "TearsModifiers")
end

do
    do
        Private.PlayerTearsUps = {
            [PlayerType.PLAYER_SAMSON] = -0.1,
            [PlayerType.PLAYER_AZAZEL] = 0.5,
            [PlayerType.PLAYER_KEEPER] = -1.9,
            [PlayerType.PLAYER_JACOB] = 5/18,
            [PlayerType.PLAYER_ESAU] = -0.1,
            [PlayerType.PLAYER_XXX_B] = -0.35,
            [PlayerType.PLAYER_EVE_B] = -0.1,
            [PlayerType.PLAYER_SAMSON_B] = -0.1,
            [PlayerType.PLAYER_LAZARUS2_B] = -0.1,
            [PlayerType.PLAYER_KEEPER_B] = -2.2,
            [PlayerType.PLAYER_APOLLYON_B] = -0.5,
            [PlayerType.PLAYER_JACOB_B] = 5/18,
            [PlayerType.PLAYER_JACOB2_B] = 5/18,
        }
        Private.CollectibleTearsUps = {
            [CollectibleType.COLLECTIBLE_SAD_ONION] = 0.7,
            [CollectibleType.COLLECTIBLE_NUMBER_ONE] = 1.5,
            [CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER] = 0.7,
            [CollectibleType.COLLECTIBLE_ROSARY] = 0.5,
            [CollectibleType.COLLECTIBLE_PACT] = 0.7,
            [CollectibleType.COLLECTIBLE_SMALL_ROCK] = 0.2,
            [CollectibleType.COLLECTIBLE_HALO] = 0.2,
            [CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN] = 1.7,
            [CollectibleType.COLLECTIBLE_SACRED_HEART] = -0.4,
            [CollectibleType.COLLECTIBLE_TOOTH_PICKS] = 0.7,
            [CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = 0.2,
            [CollectibleType.COLLECTIBLE_SQUEEZY] = 0.4,
            [CollectibleType.COLLECTIBLE_DEATHS_TOUCH] = -0.3,
            [CollectibleType.COLLECTIBLE_SCREW] = 0.5,
            [CollectibleType.COLLECTIBLE_GODHEAD] = -0.3,
            [CollectibleType.COLLECTIBLE_TORN_PHOTO] = 0.7,
            [CollectibleType.COLLECTIBLE_BLUE_CAP] = 0.7,
            [CollectibleType.COLLECTIBLE_MR_DOLLY] = 0.7,
            [CollectibleType.COLLECTIBLE_EDENS_BLESSING] = 0.7,
            [CollectibleType.COLLECTIBLE_MARKED] = 0.7,
            [CollectibleType.COLLECTIBLE_BINKY] = 0.75,
            [CollectibleType.COLLECTIBLE_APPLE] = 0.3,
            [CollectibleType.COLLECTIBLE_ANALOG_STICK] = 0.35,
            [CollectibleType.COLLECTIBLE_DIVORCE_PAPERS] = 0.7,
            [CollectibleType.COLLECTIBLE_BAR_OF_SOAP] = 0.5,
            [CollectibleType.COLLECTIBLE_PLUTO] = 0.7,
            [CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = 0.7,
            [CollectibleType.COLLECTIBLE_SAUSAGE] = 0.5,
            -- Cannot Detect Candy Heart, Soul Locket
        }
        Private.CollectibleTearsUps = {
            [TrinketType.TRINKET_HOOK_WORM] = 0.4,
            [TrinketType.TRINKET_RING_WORM] = 0.4,
            [TrinketType.TRINKET_WIGGLE_WORM] = 0.4,
            [TrinketType.TRINKET_OUROBOROS_WORM] = 0.4,
            [TrinketType.TRINKET_DIM_BULB] = function(player)
                local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                if activeItem > 0 then
                    if player:GetActiveCharges(ActiveSlot.SLOT_PRIMARY) + player:GetBatteryCharges(ActiveSlot.SLOT_PRIMARY) <= 0 then
                        return 0.5
                    end
                end
                return 0
            end,
            [TrinketType.TRINKET_VIBRANT_BULB] = function(player)
                local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                if activeItem > 0 then
                    local maxCharges = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
                    if player:GetActiveCharges(ActiveSlot.SLOT_PRIMARY) + player:GetBatteryCharges(ActiveSlot.SLOT_PRIMARY) + player:GetEffectiveSoulCharges() + player:GetEffectiveBloodCharges() >= maxCharges then
                        return 0.2
                    end
                end
                return 0
            end,
        }
        Private.VanillaTearsModifiers = {
            {
                function(player, tears, reverse)
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS) then
                        tears = MultiplyTearsModifier(tears, 1.2, reverse)
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local crownCount = player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN)
                    if crownCount > 0 then
                        local multiplier = 0.2 * crownCount
                        if reverse then
                            tears = (tears + multiplier * 30 / 11) / (multiplier + 1)
                        else
                            tears = tears + multiplier * (tears - 30 / 11)
                        end
                    end
                    if player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
                        local multiplier = -0.25
                        if reverse then
                            tears = (tears + multiplier * 30 / 11) / (multiplier + 1)
                        else
                            tears = tears + multiplier * (tears - 30 / 11)
                        end
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local effects = player:GetEffects()
                    local num
                    -- Cannot detect Missing No | Void | Black Rune | Death's List | Brittle Bones | Consolation Prize
                    num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GUILLOTINE) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CRICKETS_BODY) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MOMS_PERFUME) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAPRICORN) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PISCES)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 0.5 * num, reverse)
                    end
                    num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT)
                    if num > 0 then
                        tears = AddTearsModifier(tears, player:GetFireDelayModifier(), reverse)
                    end
                    num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TRACTOR_BEAM)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 1 * num, reverse)
                    end
                    num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PURITY)
                    if num > 0 and player:GetPurityState() == PurityState.BLUE then
                        tears = AddTearsModifier(tears, 2, reverse)
                    end
                    num = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MILK)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 1 * num, reverse)
                    end
                    if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN) then
                        tears = AddTearsModifier(tears, 2, reverse)
                    end
                    num = effects:GetNullEffectNum(NullItemID.ID_IT_HURTS)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 0.8 + 0.4 * num, reverse)
                    end
                    num = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_PASCHAL_CANDLE)
                    if num > 0 then
                        tears = AddTearsModifier(tears,  0.4 * num, reverse)
                    end
                    num = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WAVY_CAP)
                    if num > 0 then
                        tears = AddTearsModifier(tears,  0.75 * num, reverse)
                    end
                    num = effects:GetNullEffectNum(NullItemID.ID_LUNA)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 0.5 + 0.5 * num, reverse)
                    end
                    num = player:GetTrinketMultiplier(TrinketType.TRINKET_CANCER)
                    if num > 0 then
                        tears = AddTearsModifier(tears, 1 * num, reverse)
                    end
                    if effects:HasNullEffect(NullItemID.ID_REVERSE_EMPRESS) then
                        tears = AddTearsModifier(tears, 1.5, reverse)
                    end
                    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_LIQUID_POOP)) do
                        local playerPosition = ent.Position + (player.Position - ent.Position) * Vector(1, 12/13)
                        if ent.Position:Distance(playerPosition) <= 20 then
                            tears = AddTearsModifier(tears, 1.5, reverse)
                            break
                        end
                    end
                    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
                        num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ANTI_GRAVITY)
                        if num > 0 then
                            tears = AddTearsModifier(tears, 1 * num, reverse)
                        end
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local effects = player:GetEffects()
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
                        tears = MultiplyTearsModifier(tears, 0.42, reverse)
                    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or effects:HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then
                        tears = MultiplyTearsModifier(tears, 0.51, reverse)
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local cSection = player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION)
                    local brimstone = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
                        if cSection then
                            tears = 30 * tears / (30 + 4 * tears)
                        else
                            local playerType = player:GetPlayerType()
                            local multiplier = 1/3
                            local flat = 2
                            if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                                multiplier = 4.3/3
                                flat = 4.3
                            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
                                multiplier = 1/3
                                flat = 3
                            elseif playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
                                multiplier = 2/3
                            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
                                multiplier = 2/3
                            end
                            if reverse then
                                tears = tears * flat / (1- tears * multiplier)
                            else
                                tears = tears / (multiplier * tears + flat)
                            end
                        end
                        if brimstone then
                            tears = 30 * tears / (30 + 20 * tears)
                        end
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local playerType = player:GetPlayerType()
                    local effects = player:GetEffects()
                    local haemolacria = player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)
                    local brimstone = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
                    local drFetus = player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
                    local lung = player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
                    local ipecac = player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC)
                    local berserk = effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
                    local azazel = playerType == PlayerType.PLAYER_AZAZEL
                    local forgotten = playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THEFORGOTTEN_B
                    if azazel then
                        if not drFetus and not brimstone and not haemolacria and not berserk then
                            tears = MultiplyTearsModifier(tears, 4/15, reverse)
                        end
                    elseif playerType == PlayerType.PLAYER_AZAZEL_B then
                        if not drFetus and not brimstone and not haemolacria and not berserk then
                            tears = MultiplyTearsModifier(tears, 1/3, reverse)
                        end
                    elseif forgotten then
                        if not haemolacria and not berserk then
                            tears = MultiplyTearsModifier(tears, 4/15, reverse)
                        end
                    elseif playerType == PlayerType.PLAYER_EVE_B then
                        tears = MultiplyTearsModifier(tears, 0.66, reverse)
                    end
                    if not haemolacria and not berserk and not forgotten then
                        if drFetus then
                            tears = MultiplyTearsModifier(tears, 0.4, reverse)
                        elseif brimstone then
                            tears = MultiplyTearsModifier(tears, 1/3, reverse)
                        elseif ipecac and not azazel then
                            tears = MultiplyTearsModifier(tears, 1/3, reverse)
                        end
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
                        tears = MultiplyTearsModifier(tears, 2/3, reverse)
                    end
                    if lung and not azazel and not forgotten and not berserk then
                        tears = MultiplyTearsModifier(tears, 10/43, reverse)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA) then
                        tears = MultiplyTearsModifier(tears, 0.66, reverse)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
                        tears = MultiplyTearsModifier(tears, 4, reverse)
                    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
                        tears = MultiplyTearsModifier(tears, 5.5, reverse)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
                        tears = MultiplyTearsModifier(tears, (math.floor(player:GetEpiphoraCharge() / 90) + 3) / 3, reverse)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_KIDNEY_STONE) then
                        tears = MultiplyTearsModifier(tears, 1 + player:GetPeeBurstCooldown() / 72, reverse)
                    end
                    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND)) do
                        local playerPos = ent.Position + (player.Position - ent.Position) * Vector(1 /ent.SpriteScale.X, 1 /ent.SpriteScale.Y)
                        if ent.Position:Distance(playerPos) < 80 then
                            tears = MultiplyTearsModifier(tears, 2.5, reverse)
                            break
                        end
                    end
                    if effects:HasNullEffect(NullItemID.ID_REVERSE_CHARIOT) or effects:HasNullEffect(NullItemID.ID_REVERSE_CHARIOT_ALT) then
                        tears = MultiplyTearsModifier(tears, 2.5, reverse)
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local effects = player:GetEffects()
                    local berserk = effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
                    if (berserk) then
                        if (reverse) then
                            tears = (tears - 2) / 0.5
                        else
                            tears = tears * 0.5 + 2
                        end
                    end
                    return tears
                end
            },
            {
                function(player, tears, reverse)
                    local lustCount = math.min(player:GetBloodLustCounter(), 6)
                    if lustCount > 0 then
                        tears = AddTearsModifier(tears, 0.05 * lustCount^ 2 + 0.2 * lustCount, reverse)
                    end
                    return tears
                end
            }
        }
        Private.MiscTearsUps = function(player)
            local tearsUp = 0
            if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
                tearsUp = tearsUp - 1.9
            end
            if player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
                tearsUp = tearsUp - 0.3
            end
            return tearsUp
        end
    end
    do
        Private.EvilItems = {
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_GOAT_HEAD },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_ABADDON },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_BLACK_CANDLE },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_MISSING_PAGE_2 },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_SAFETY_PIN },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_MATCH_BOOK },
            { Type = PickupVariant.PICKUP_COLLECTIBLE, ID = CollectibleType.COLLECTIBLE_FALSE_PHD },
            { Type = PickupVariant.PICKUP_TRINKET, ID = TrinketType.TRINKET_DAEMONS_TAIL },
            { Type = PickupVariant.PICKUP_TRINKET, ID = TrinketType.TRINKET_BLACK_LIPSTICK },
        }
        Private.CharacterMultipliers = {
            [PlayerType.PLAYER_CAIN] = 1.2,
            [PlayerType.PLAYER_JUDAS] = 1.35,
            [PlayerType.PLAYER_XXX] = 1.05,
            [PlayerType.PLAYER_AZAZEL] = 1.5,
            [PlayerType.PLAYER_LAZARUS2] = 1.4,
            [PlayerType.PLAYER_BLACKJUDAS] = 2,
            [PlayerType.PLAYER_KEEPER] = 1.2,
            [PlayerType.PLAYER_THEFORGOTTEN] = 1.5,
            [PlayerType.PLAYER_MAGDALENA_B] = 0.75,
            [PlayerType.PLAYER_AZAZEL_B] = 1.5,
            [PlayerType.PLAYER_THELOST_B] = 1.3,
            [PlayerType.PLAYER_THEFORGOTTEN_B] = 1.5,
            [PlayerType.PLAYER_LAZARUS2_B] = 1.5,
        }
        Private.DamageSteps1 = {
            function(damage, player, reverse)
                if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN) then
                    if not reverse then
                        damage = 0.9 * damage - 0.4
                    else
                        damage = (damage + 0.4) / 0.9
                    end
                end
                return damage
            end,
            function(damage, player, reverse)
                local effects = player:GetEffects()
                local boost = 0
                boost = boost + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_THE_NAIL) * 2
                boost = boost + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_LUSTY_BLOOD) * 0.5
                boost = boost + effects:GetTrinketEffectNum(TrinketType.TRINKET_SAMSONS_LOCK) * 0.5
                boost = boost + effects:GetNullEffectNum(NullItemID.ID_LAZARUS_BOOST) * 0.5
                boost = boost + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_RAZOR_BLADE) * 1.2
                boost = boost + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_GOLDEN_RAZOR) * 1.2
                boost = boost + effects:GetNullEffectNum(NullItemID.ID_DARK_ARTS) * 0.25
                boost = boost + effects:GetNullEffectNum(NullItemID.ID_CAMO_BOOST) * 0.35
                boost = boost + effects:GetTrinketEffectNum(TrinketType.TRINKET_RED_PATCH) * 1.8
                local blackFeatherNum = player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER)
                if blackFeatherNum > 0 then
                    local blackFeatherBoost = 0
                    for _, evilItem in pairs(Private.EvilItems) do
                        if evilItem.Type == PickupVariant.PICKUP_COLLECTIBLE then
                            blackFeatherBoost = blackFeatherBoost + player:GetCollectibleNum(evilItem.ID, true)
                        elseif evilItem.Type == PickupVariant.PICKUP_TRINKET then
                            blackFeatherBoost = blackFeatherBoost + player:GetTrinketMultiplier(evilItem.ID)
                        end
                    end
                    boost = boost + blackFeatherBoost * blackFeatherNum
                end
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_PURITY) and player:GetPurityState() == PurityState.RED then
                    boost = boost + 4
                end
                if not reverse then
                    damage = damage + boost
                else
                    damage = damage - boost
                end
                return damage
            end,
            function(damage, player, reverse)
                if not reverse then
                    damage = 3.5 * (1.2 * damage + 1) ^ 0.5
                else
                    damage = ((damage / 3.5) ^ 2 - 1) / 1.2 
                end
                return damage
            end,
        }
        Private.DamageSteps2 = {
            function(damage, player, reverse)
                if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
                    if (player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:HasWeaponType(WeaponType.WEAPON_FETUS)) then
                        if not reverse then
                            damage = damage + 5
                        else
                            damage = damage - 5
                        end
                    else
                        if not reverse then
                            damage = damage * 2 + 8
                        else
                            damage = (damage - 8) / 2
                        end
                    end
                end
                return damage
            end,
            function(damage, player, reverse)
                local multi = 1
                local effects = player:GetEffects()
                local playerType = player:GetPlayerType()
                if effects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP) then
                    multi = 1.5
                elseif playerType == PlayerType.PLAYER_EVE then
                    if not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
                        multi = 0.75
                    end
                elseif playerType == PlayerType.PLAYER_EVE_B then
                    if not effects:HasNullEffect(NullItemID.ID_BLOODY_BABYLON) then
                        multi = 1.2
                    end
                else
                    multi = Private.CharacterMultipliers[playerType] or 1
                end
                if not reverse then
                    damage = damage * multi
                else
                    damage = damage / multi
                end
                return damage
            end,
            function(damage, player, reverse)
                local boost = 0
                local effects = player:GetEffects()
                local playerType = player:GetPlayerType()
                if playerType == PlayerType.PLAYER_EDEN or playerType == PlayerType.PLAYER_EDEN_B then
                    boost = player:GetEdenDamage()
                elseif playerType == PlayerType.PLAYER_JACOB then
                    boost = -0.75
                elseif playerType == PlayerType.PLAYER_ESAU then
                    boost = 0.25
                end
                if effects:HasNullEffect(NullItemID.ID_ESAU_JR) then
                    boost = boost + 2
                end
                if not reverse then
                    damage = damage + boost
                else
                    damage = damage - boost
                end
                return damage
            end,
            function(damage, player, reverse)
                local multi = 1
                local effects = player:GetEffects()
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
                    multi = 4
                end
                if not reverse then
                    damage = damage * multi
                else
                    damage = damage / multi
                end
                return damage
            end,
            function(damage, player, reverse)
                local effects = player:GetEffects()
                if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and effects:HasNullEffect(NullItemID.ID_SOUL_FORGOTTEN) then
                    if not reverse then
                        damage = damage * 3 + 6
                    else
                        damage = (damage - 6) / 3
                    end
                end
                return damage
            end,
            function(damage, player, reverse)
                local boost = 0
                local effects = player:GetEffects()
                -- Cannot Detect Potato Peeler | Candy Heart | Soul Locket
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
                    boost = boost + 3
                end
                boost = boost + player:GetDamageModifier()
                boost = boost + player:GetTrinketMultiplier(TrinketType.TRINKET_CURVED_HORN) * 2
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOZO) then
                    boost = boost + 0.1
                end
                if effects:HasNullEffect(NullItemID.ID_HUGE_GROWTH) then
                    boost = boost + 7
                end
                if player:HasWeaponType(WeaponType.WEAPON_BONE) and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                    boost = boost + 4
                end
                if not reverse then
                    damage = damage + boost
                else
                    damage = damage - boost
                end
                return damage
            end,
        }
        Private.DamageSteps3 = {
            function(damage, player, reverse)
                local effects = player:GetEffects()
                local lustCount = player:GetBloodLustCounter()
                if lustCount > 0 then
                    lustCount = math.min(lustCount, (player:GetPlayerType() == PlayerType.PLAYER_SAMSON and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 10) or 6)
                    if not reverse then
                        damage = damage + lustCount * (lustCount + 1) * 0.1 + 0.3 * lustCount
                    else
                        damage = damage - lustCount * (lustCount + 1) * 0.1 - 0.3 * lustCount
                    end
                end
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
                    if not reverse then
                        damage = damage * 2
                    else
                        damage = damage / 2
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) then
                    if not reverse then
                        damage = damage * 2.3 + 1
                    else
                        damage = (damage - 1) / 2.3
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
                    if not reverse then
                        damage = damage * 1.4 + 1
                    else
                        damage = (damage - 1) / 1.4
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) then
                    if not reverse then
                        damage = damage * 2.3 + 1
                    else
                        damage = (damage - 1) / 2.3
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_ADRENALINE) then
                    local emptyHeartContainers = math.floor((player:GetEffectiveMaxHearts() - player:GetHearts()) / 2)
                    emptyHeartContainers = math.max(0, emptyHeartContainers)
                    local amount = 0.1 * (2 * emptyHeartContainers) ^ 1.6
                    if not reverse then
                        damage = damage + amount
                    else
                        damage = damage - amount
                    end
                end
                return damage
            end,
            function(damage, player, reverse)
                local multi = 1
                local effects = player:GetEffects()
                local playerType = player:GetPlayerType()
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
                    if effects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP) or playerType == PlayerType.PLAYER_AZAZEL or playerType == PlayerType.PLAYER_AZAZEL_B then
                        if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
                            multi = multi * 0.5
                        elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                            multi = multi * 0.65
                        end
                    end
                end
                local brimstoneCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)
                if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                    if brimstoneCount >= 2 then
                        multi = multi * 1.2
                    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
                        multi = multi * 1.5
                    end
                elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
                        multi = multi * 1.5
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
                    multi = multi * 1.5
                end
                if not reverse then
                    damage = damage * multi
                else
                    damage = damage / multi
                end
                return damage
            end,
            function(damage, player, reverse)
                local boost = 0
                if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
                    if player:HasWeaponType(WeaponType.WEAPON_TEARS) or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) or player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                        boost = 40
                    else
                        boost = 2
                    end
                end
                if not reverse then
                    damage = damage + boost
                else
                    damage = damage - boost
                end
                return damage
            end,
            function(damage, player, reverse)
                local multi = 1
                local effects = player:GetEffects()
                if player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) or player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) or (player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_MARTYR) and effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)) then
                    multi = multi * 1.5
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA) then
                    multi = multi * 2
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
                    multi = multi * 0.3
                elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
                    multi = multi * 0.2
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
                    multi = multi * 0.8
                end
                multi = multi * (1 + 0.25 * player:GetDeadEyeCharge())
                multi = multi * player:GetD8DamageModifier()
                for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SUCCUBUS)) do
                    if ent.Position:DistanceSquared(player.Position) <= 14400 then
                        multi = multi * 1.5
                        break
                    end
                end
                if not reverse then
                    damage = damage * multi
                else
                    damage = damage / multi
                end
                return damage
            end,
            function(damage, player, reverse)
                local crackedCrownNum = player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN)
                local multi = 0.2 * crackedCrownNum
                if not reverse then
                    if damage > 3.5 then
                        return (multi + 1) * damage - multi * 3.5
                    end
                else
                    if damage > 3.5 then
                        return (damage + multi * 3.5) / (multi + 1)
                    end
                end
                return damage
            end
        }
        Private.DamageStepsList = {
            Private.DamageSteps1,
            Private.DamageSteps2,
            Private.DamageSteps3
        }
    end
end

do
    do
        function Stat:GetSpeedLimit(player)
            return GetPlayerData(player, "SpeedLimit") or -1
        end
        function Stat:SetSpeedLimit(player, value)
            SetPlayerData(player, value, "SpeedLimit")
        end
        function Stat:GetSpeedLowerLimit(player)
            return GetPlayerData(player, "SpeedLowerLimit") or -1
        end
        function Stat:SetSpeedLowerLimit(player, value)
            SetPlayerData(player, value, "SpeedLowerLimit")
        end
        function Stat:GetSpeedUp(player)
            return GetPlayerData(player, "MoveSpeed") or 0
        end
        function Stat:SetSpeedUp(player, value)
            SetPlayerData(player, value, "MoveSpeed")
        end
        function Stat:AddSpeedUp(player, value)
            self:SetSpeedUp(player, self:GetSpeedUp(player) + value)
        end
        function Stat:GetSpeedMultiplier(player)
            return GetPlayerData(player, "MoveSpeedMultiplier") or 1
        end
        function Stat:SetSpeedMultiplier(player, value)
            SetPlayerData(player, value, "MoveSpeedMultiplier")
        end
        function Stat:MultiplySpeed(player, value)
            self:SetSpeedMultiplier(player, self:GetSpeedMultiplier(player) * value)
        end
    end
    do
        function Stat:GetAddFireRate(firedelay, addition)
            return 30 / (30 / (firedelay + 1) + addition) - 1
        end
        function Stat:GetTearsUp(player)
            return GetPlayerData(player, "TearsUp") or 0
        end
        function Stat:SetTearsUp(player, value)
            SetPlayerData(player, value, "TearsUp")
        end
        function Stat:AddTearsUp(player, value)
            self:SetTearsUp(player, self:GetTearsUp(player) + value)
        end
        function Stat:AddTearsModifier(player, func, priority)
            priority = priority or 0
            local tearModifiers = GetPlayerData(player, "TearsModifiers")
            if not tearModifiers then
                tearModifiers = {}
                SetPlayerData(player, tearModifiers, "TearsModifiers")
            end
            local pos = #tearModifiers + 1
            for i, tearModifiers in ipairs(tearModifiers) do
                if priority < tearModifiers.Priority then
                    pos = i
                    break
                end
            end
            table.insert(tearModifiers, pos, {Func = func, Priority = priority} )
        end
        function Stat:AddFlatTears(player, value, priority)
            Stat:AddTearsModifier(player, function(tears) return value + tears end, priority or 0)
        end
        function Stat:AddTearsMultiplier(player, value, priority)
            Stat:AddTearsModifier(player, function(tears) return tears * value end, priority or 100)
        end
        function Stat:GetTearsModifiers(player)
            return GetPlayerData(player, "TearsModifiers")
        end
        function Stat:GetEvaluatedTears(player)
            local origin = 30 / (player.MaxFireDelay + 1)
            local tears = origin
            local modMultiplier = 1
            local maxTearsUp = 2
            local maxMultiplier = 1.4
            local minMultiplier = 0.6
            local modTearsUp = Stat:GetTearsUp(player)
            if modTearsUp > maxTearsUp then
                modMultiplier = maxMultiplier
            elseif modTearsUp > 0 then
                modMultiplier = -((maxMultiplier - 1) / maxTearsUp ^ 2) * (modTearsUp - maxTearsUp) ^ 2 + maxMultiplier
            else
                modMultiplier = (1 - minMultiplier) * (0.5 ^ modTearsUp - 1) + 1
            end
            tears = tears * modMultiplier
            local tearModifiers = Stat:GetTearsModifiers(player)
            if tearModifiers then
                for _, modi in ipairs(tearModifiers) do
                    tears = modi.Func(tears, origin)
                end
            end
            if player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and tears < 30 / 11 then
                return 30 / 11
            end
            return tears
        end
    end
    do
        function Stat:GetDamageUp(player)
            return GetPlayerData(player, "DamageUp") or 0
        end
        function Stat:SetDamageUp(player, value)
            SetPlayerData(player, value, "DamageUp")
        end
        function Stat:AddDamageUp(player, value)
            self:SetDamageUp(player, self:GetDamageUp(player) + value)
        end
        function Stat:GetFlatDamage(player)
            return GetPlayerData(player, "DamageFlat") or 0
        end
        function Stat:SetFlatDamage(player, value)
            SetPlayerData(player, value, "DamageFlat")
        end
        function Stat:AddFlatDamage(player, value)
            self:SetFlatDamage(player, self:GetFlatDamage(player) + value)
        end
        function Stat:GetDamageMultiplier(player)
            return GetPlayerData(player, "DamageMultiplier") or 1
        end
        function Stat:SetDamageMultiplier(player, value)
            SetPlayerData(player, value, "DamageMultiplier")
        end
        function Stat:MultiplyDamage(player, value)
            self:SetDamageMultiplier(player, self:GetDamageMultiplier(player) * value)
        end
        function Stat:GetDamageUpValue(player)
            local damage = player.Damage
            for i = #Private.DamageStepsList, 1, -1 do
                local steps = Private.DamageStepsList[i]
                for j = #steps, 1, -1 do
                    local step = steps[j]
                    damage = step(damage, player, true)
                end
            end
            return damage
        end
        function Stat:GetEvaluatedDamage(player, damageUp, flat, multiplier)
            local damage = damageUp
            for i = 1, #Private.DamageSteps1 do
                local step = Private.DamageSteps1[i]
                damage = step(damage, player, false)
            end
            for i = 1, #Private.DamageSteps2 do
                local step = Private.DamageSteps2[i]
                damage = step(damage, player, false)
            end
            damage = damage + flat
            for i = 1, #Private.DamageSteps3 do
                local step = Private.DamageSteps3[i]
                damage = step(damage, player, false)
            end
            damage = damage * multiplier
            if player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and damage < 3.5 then
                return 3.5
            end
            return damage
        end
    end
end

do
    function Stat:EvaluateCache(player, cache)
        if cache == CacheFlag.CACHE_DAMAGE then
            local damageUp = Stat:GetDamageUpValue(player) + Stat:GetDamageUp(player)
            local flat = Stat:GetFlatDamage(player)
            local multiplier = Stat:GetDamageMultiplier(player)
            player.Damage = Stat:GetEvaluatedDamage(player, damageUp, flat, multiplier)
            ResetDamageCaches(player)
        elseif cache == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = 30 / Stat:GetEvaluatedTears(player) - 1
            ResetTearsCaches(player)
        elseif cache == CacheFlag.CACHE_SPEED then
            local upperLimit = Stat:GetSpeedLimit(player)
            local lowerLimit = Stat:GetSpeedLowerLimit(player)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_PONY) or player:HasCollectible(CollectibleType.COLLECTIBLE_WHITE_PONY) then
                lowerLimit = 1.5
            end
            local speedUp = Stat:GetSpeedUp(player)
            local speedMultiplier = Stat:GetSpeedMultiplier(player)
            local speed = player.MoveSpeed
            local addition = (speed + speedUp) * speedMultiplier - speed
            if upperLimit >= 0 and addition > 0 then
                addition = math.min(upperLimit - speed, addition)
            end
            if lowerLimit >= 0 and addition < 0 then
                addition = math.max(lowerLimit - speed, addition)
            end
            if player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and speed + addition < 1 then
                player.MoveSpeed = 1
            else
                player.MoveSpeed = speed + addition
            end
            Stat:SetSpeedUp(player, nil)
            Stat:SetSpeedMultiplier(player, nil)
            Stat:SetSpeedLimit(player, nil)
            Stat:SetSpeedLowerLimit(player, nil)
        elseif cache == CacheFlag.CACHE_RANGE and player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and player.TearRange < 260 then
            player.TearRange = 260
            player.TearHeight = -23.75
        end
        if cache == CacheFlag.CACHE_SHOTSPEED and player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and player.ShotSpeed < 1 then
            player.ShotSpeed = 1
        end
        if cache == CacheFlag.CACHE_LUCK and player:HasCollectible(Lib.ModItemIDs.CONSERVATIVETREATMENT) and player.Luck < 0 then
            player.Luck = 0
        end
    end
    Stat:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, 101, Stat.EvaluateCache)
end

return Stat