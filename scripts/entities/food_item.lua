local Lib = TYU
local FoodItem = Lib:NewModEntity("Foods (food item)", "FOODS")

local bankSprite = Sprite("gfx/ui/ui_foods_bank.anm2", true)
bankSprite:Play("Empty", true)
local foodSprite = Sprite("gfx/ui/ui_foods.anm2", true)
foodSprite:Play("Idle", true)
foodSprite.Scale = Vector(0.5, 0.5)

function FoodItem:PostHUDRender()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEF_HAT) or not Lib.HUD:IsVisible() then
        return
    end
    local hudOffset = Options.HUDOffset
    local pos = Vector(50 + 20 * hudOffset, Isaac.GetScreenHeight() - 12 - 12 * hudOffset)
    local bank = Lib:GetGlobalLibData("Foods", "Bank")
    if not bank then
        Lib:SetGlobalLibData({ -1, -1, -1, -1 }, "Foods", "Bank")
        bank = Lib:GetGlobalLibData("Foods", "Bank")
    end
    local found = false
    for i = 4, 1, -1 do
        if not bank[i] then
            return
        end
        if bank[i] ~= -1 then
            if not found then
                bankSprite:Play("Selected", true)
                bankSprite:Render(pos + Vector(15 * i, 0))    
                found = true
            end
            foodSprite:SetFrame(bank[i])
            foodSprite:Render(pos + Vector(15 * i, 0))    
        else
            bankSprite:Play("Empty", true)
            bankSprite:Render(pos + Vector(15 * i, 0))
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, FoodItem.PostHUDRender)

function FoodItem:PostPickupUpdate(pickup)
    local sprite = pickup:GetSprite()
    if sprite:IsEventTriggered("DropSound") then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_SCAMPER)
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, FoodItem.PostPickupUpdate, Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant)

function FoodItem:PostPickupCollision(pickup, collider, low)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEF_HAT) then
        return
    end
    local player = collider:ToPlayer()
    if not player then
        return
    end
    local bank = Lib:GetGlobalLibData("Foods", "Bank")
    for i = 1, 4 do
        if bank[i] == -1 then
            Lib:SetGlobalLibData(pickup.SubType - 1, "Foods", "Bank", i)
            Lib.Entities.SpawnFakePickupSprite(pickup)
            Lib.SFXMANAGER:Play(SoundEffect.SOUND_SHELLGAME)
            break
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, FoodItem.PostPickupCollision, Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant)

function FoodItem:PostRender()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEF_HAT) then
        return
    end
    local bank = Lib:GetGlobalLibData("Foods", "Bank")
    if not bank or bank[1] == -1 then
        return
    end
    local timeout = Lib:GetGlobalLibData("Foods", "DropTimeout") or 0
    local player = Isaac.GetPlayer(0)
    local isDropPressed = Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex)
    if isDropPressed then
        Lib:SetGlobalLibData(timeout + 1, "Foods", "DropTimeout")
    else
        Lib:SetGlobalLibData(0, "Foods", "DropTimeout")
    end
    if timeout < 120 then
        return
    end
    local room = Lib.GAME:GetRoom()
    for i = 4, 1, -1 do
        if bank[i] ~= -1 then
            Lib.Entities.Spawn(Lib.ModEntityIDs.FOODS_FOOD_ITEM.Type, Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant, bank[i] + 1, room:FindFreePickupSpawnPosition(player.Position, 0, true, false))
            Lib:SetGlobalLibData(-1, "Foods", "Bank", i)
            Lib:SetGlobalLibData(0, "Foods", "DropTimeout")
            break
        end
    end
end
FoodItem:AddCallback(ModCallbacks.MC_POST_RENDER, FoodItem.PostRender)

function FoodItem:PreEntitySpawn(type, variant, subType, position, velocity, spawner, seed)
    if type ~= Lib.ModEntityIDs.FOODS_FOOD_ITEM.Type or variant ~= Lib.ModEntityIDs.FOODS_FOOD_ITEM.Variant or subType ~= Lib.ModFoodItemIDs.FOODS then
        return
    end
    local rng = RNG(seed)
    local newSubType = Lib.Foods.GetRandomFood(rng)
    return { type, variant, newSubType, seed }
end
FoodItem:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, FoodItem.PreEntitySpawn)

function FoodItem:PostNewLevel()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEF_HAT) then
        return
    end
    Lib:SetGlobalLibData({}, "Foods", "Effects")
end
FoodItem:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FoodItem.PostNewLevel)

return FoodItem