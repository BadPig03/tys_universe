local FoodItem = TYU:NewModEntity("Foods (food item)", "FOODS")
local Entities = TYU.Entities
local Foods = TYU.Foods
local Players = TYU.Players
local Utils = TYU.Utils
local ModEntityIDs = TYU.ModEntityIDs
local ModFoodItemIDs = TYU.ModFoodItemIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Foods", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Foods", ...)
end

do
    PrivateField.BankSprite = Sprite("gfx/ui/ui_foods_bank.anm2", true)
    PrivateField.BankSprite:Play("Empty", true)
    PrivateField.FoodSprite = Sprite("gfx/ui/ui_foods.anm2", true)
    PrivateField.FoodSprite:Play("Idle", true)
    PrivateField.FoodSprite.Scale = Vector(0.5, 0.5)
end

function FoodItem:PostHUDRender()
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) or not TYU.HUD:IsVisible() then
        return
    end
    local hudOffset = Options.HUDOffset
    local pos = Vector(50 + 20 * hudOffset, Isaac.GetScreenHeight() - 12 * (hudOffset + 1))
    local bank = GetGlobalLibData("Bank")
    if not bank then
        SetGlobalLibData({ -1, -1, -1, -1 }, "Bank")
        bank = GetGlobalLibData("Bank")
    end
    local found = false
    for i = 4, 1, -1 do
        if not bank[i] then
            return
        end
        if bank[i] ~= -1 then
            if not found then
                PrivateField.BankSprite:Play("Selected", true)
                PrivateField.BankSprite:Render(pos + Vector(15 * i, 0))    
                found = true
            end
            PrivateField.FoodSprite:SetFrame(bank[i])
            PrivateField.FoodSprite:Render(pos + Vector(15 * i, 0))    
        else
            PrivateField.BankSprite:Play("Empty", true)
            PrivateField.BankSprite:Render(pos + Vector(15 * i, 0))
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, FoodItem.PostHUDRender)

function FoodItem:PostPickupUpdate(pickup)
    local sprite = pickup:GetSprite()
    if not sprite:IsEventTriggered("DropSound") then
        return
    end
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
end
FoodItem:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, FoodItem.PostPickupUpdate, ModEntityIDs.FOODS_FOOD_ITEM.Variant)

function FoodItem:PostPickupCollision(pickup, collider, low)
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) then
        return
    end
    local player = collider:ToPlayer()
    if not player then
        return
    end
    local bank = GetGlobalLibData("Bank")
    for i = 1, 4 do
        if bank[i] == -1 then
            SetGlobalLibData(pickup.SubType - 1, "Bank", i)
            Entities.SpawnFakePickupSprite(pickup)
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_SHELLGAME)
            break
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, FoodItem.PostPickupCollision, ModEntityIDs.FOODS_FOOD_ITEM.Variant)

function FoodItem:PostRender()
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) then
        return
    end
    local bank = GetGlobalLibData("Bank")
    if not bank or bank[1] == -1 then
        return
    end
    local timeout = GetGlobalLibData("DropTimeout") or 0
    local player = Isaac.GetPlayer(0)
    local isDropPressed = Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex)
    if isDropPressed then
        SetGlobalLibData(timeout + 1, "DropTimeout")
    else
        SetGlobalLibData(0, "DropTimeout")
    end
    if timeout < 120 then
        return
    end
    for i = 4, 1, -1 do
        if bank[i] ~= -1 then
            Entities.Spawn(ModEntityIDs.FOODS_FOOD_ITEM.Type, ModEntityIDs.FOODS_FOOD_ITEM.Variant, bank[i] + 1, Utils.FindFreePickupSpawnPosition(player.Position))
            SetGlobalLibData(-1, "Bank", i)
            SetGlobalLibData(0, "DropTimeout")
            break
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_RENDER, FoodItem.PostRender)

function FoodItem:PreEntitySpawn(type, variant, subType, position, velocity, spawner, seed)
    if type ~= ModEntityIDs.FOODS_FOOD_ITEM.Type or variant ~= ModEntityIDs.FOODS_FOOD_ITEM.Variant or subType ~= ModFoodItemIDs.FOODS then
        return
    end
    local rng = RNG(seed)
    local newSubType = Foods.GetRandomFood(rng)
    return { type, variant, newSubType, seed }
end
FoodItem:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, FoodItem.PreEntitySpawn)

function FoodItem:PostNewLevel()
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) then
        return
    end
    SetGlobalLibData({}, "Effects")
end
FoodItem:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FoodItem.PostNewLevel)

return FoodItem