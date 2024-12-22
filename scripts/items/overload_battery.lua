local OverloadBattery = TYU:NewModItem("Overload Battery", "OVERLOAD_BATTERY")
local Players = TYU.Players
local Entities = TYU.Entities
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetPlayerLibData(player, value, ...)
    TYU:SetPlayerLibData(player, value, "OverloadBattery", ...)
end

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "OverloadBattery", ...)
end

do
    function PrivateField.TryToAddCharge(player)
        local charge = GetPlayerLibData(player, "Charge")
        while charge >= 4 do
            charge = charge - 4
            SetPlayerLibData(player, charge, "Charge")
            if player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY) == 0 then
                if player:AddActiveCharge(1, ActiveSlot.SLOT_SECONDARY) == 0 then
                    if player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET) == 0 then
                        player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET2)
                    end
                end
            end
        end
    end

    function PrivateField.CanPickEternalHearts(player)
        local limit = player:GetHeartLimit()
        if player:GetMaxHearts() == limit and player:GetEternalHearts() == 1 then
            return false
        end
        return true
    end
end

function OverloadBattery:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not player:HasCollectible(ModItemIDs.OVERLOAD_BATTERY) or pickup:IsShopItem() then
        return
    end
    local needsCharge = false
    for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        if player:NeedsCharge(i) then
            needsCharge = true
        end
    end
    if not needsCharge then
        return
    end
    local charge = GetPlayerLibData(player, "Charge") or 0
    local subType = pickup.SubType
    local pickedUp = false
    if not player:CanPickRedHearts() then
        if subType == HeartSubType.HEART_HALF then
            charge = charge + 1
            pickedUp = true
        elseif subType == HeartSubType.HEART_FULL or subType == HeartSubType.HEART_SCARED then
            charge = charge + 2
            pickedUp = true
        elseif subType == HeartSubType.HEART_DOUBLEPACK then
            charge = charge + 4
            pickedUp = true
        end
    end
    if not player:CanPickSoulHearts() then
        if subType == HeartSubType.HEART_SOUL then
            charge = charge + 4
            pickedUp = true
        elseif subType == HeartSubType.HEART_HALF_SOUL then
            charge = charge + 2
            pickedUp = true
        end
    end
    if not player:CanPickRedHearts() and not player:CanPickSoulHearts() and subType == HeartSubType.HEART_BLENDED then
        charge = charge + 3
        pickedUp = true
    end
    if not player:CanPickRottenHearts() and subType == HeartSubType.HEART_ROTTEN then
        charge = charge + 2
        pickedUp = true
    end
    if not player:CanPickBlackHearts() and subType == HeartSubType.HEART_BLACK then
        charge = charge + 4
        pickedUp = true
    end
    if not player:CanPickBoneHearts() and subType == HeartSubType.HEART_BONE then
        charge = charge + 4
        pickedUp = true
    end
    if (not player:CanPickGoldenHearts() and subType == HeartSubType.HEART_GOLDEN) or (not PrivateField.CanPickEternalHearts(player) and subType == HeartSubType.HEART_ETERNAL) then
        charge = charge + 48
        pickedUp = true
    end
    if pickedUp then
        SetPlayerLibData(player, charge, "Charge")
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.7)
        Entities.SpawnFakePickupSprite(pickup)
        PrivateField.TryToAddCharge(player)
        return { Collide = true, SkipCollisionEffects = true }    
    end
end
OverloadBattery:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, OverloadBattery.PrePickupCollision, PickupVariant.PICKUP_HEART)

return OverloadBattery