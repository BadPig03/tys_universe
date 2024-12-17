local Lib = TYU
local OverloadBattery = Lib:NewModItem("Overload Battery", "OVERLOADBATTERY")

local function TryToAddCharge(player)
    local charge = Lib:GetPlayerLibData(player, "OverloadBattery", "Charge")
    while charge >= 4 do
        charge = charge - 4
        Lib:SetPlayerLibData(player, charge, "OverloadBattery", "Charge")
        if player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY) == 0 then
            if player:AddActiveCharge(1, ActiveSlot.SLOT_SECONDARY) == 0 then
                if player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET) == 0 then
                    player:AddActiveCharge(1, ActiveSlot.SLOT_POCKET2)
                end
            end
        end
    end
end

function OverloadBattery:PrePickupCollision(pickup, collider, low)
    local player = collider:ToPlayer()
    if not player or not player:HasCollectible(Lib.ModItemIDs.OVERLOADBATTERY) or pickup:IsShopItem() then
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
    local charge = Lib:GetPlayerLibData(player, "OverloadBattery", "Charge") or 0
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
    if (not player:CanPickGoldenHearts() and subType == HeartSubType.HEART_GOLDEN) or (not Lib.Players.CanPickEternalHearts(player) and subType == HeartSubType.HEART_ETERNAL) then
        charge = charge + 48
        pickedUp = true
    end
    if pickedUp then
        Lib:SetPlayerLibData(player, charge, "OverloadBattery", "Charge")
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.7)
        Lib.Entities.SpawnFakePickupSprite(pickup)
        TryToAddCharge(player)
        return { Collide = true, SkipCollisionEffects = true }    
    end
end
OverloadBattery:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, OverloadBattery.PrePickupCollision, PickupVariant.PICKUP_HEART)

return OverloadBattery