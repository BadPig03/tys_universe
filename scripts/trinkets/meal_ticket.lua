local MealTicket = TYU:NewModTrinket("Meal Ticket", "MEAL_TICKET")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModTrinketIDs = TYU.ModTrinketIDs

local PrivateField = {}

do
    PrivateField.FoodItemList = {}
    for _, item in ipairs(TYU.ITEMCONFIG:GetTaggedItems(ItemConfig.TAG_FOOD)) do
        table.insert(PrivateField.FoodItemList, item.ID)
    end
end

do
    function PrivateField.GetItemPosition()
        local pos = Vector(320, 240)
        if TYU.GAME:IsGreedMode() then
            pos = Vector(580, 240)
        end
        return Utils.FindFreePickupSpawnPosition(pos)
    end
end

function MealTicket:PostPlayerNewRoomTempEffects(player)
    local multiplier = player:GetTrinketMultiplier(ModTrinketIDs.MEAL_TICKET)
    if multiplier == 0 or not Utils.IsRoomType(RoomType.ROOM_SHOP) then
        return
    end
    local rng = player:GetTrinketRNG(ModTrinketIDs.MEAL_TICKET)
    for i = 1, multiplier do
        local item = Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, TYU.ITEMPOOL:GetCollectibleFromList(PrivateField.FoodItemList, rng:Next()), PrivateField.GetItemPosition())
        Entities.SpawnPoof(item.Position)
        player:TryRemoveTrinket(ModTrinketIDs.MEAL_TICKET)
    end
    player:AnimateHappy()
end
MealTicket:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, MealTicket.PostPlayerNewRoomTempEffects)

return MealTicket