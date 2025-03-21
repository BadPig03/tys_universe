local ChefHat = TYU:NewModItem("Chef Hat", "CHEF_HAT")

local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModEnchantmentIDs = TYU.ModEnchantmentIDs

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Foods", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Foods", ...)
end

function ChefHat:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.LOOTING)
    local rng = RNG(npc.InitSeed + npc.Index)
    if (not npc.SpawnerEntity and rng:RandomInt(100) < 6 + 2 * count) or (npc.SpawnerEntity and rng:RandomInt(100) < 3 + count) then
        Entities.Spawn(ModEntityIDs.FOODS_FOOD_ITEM.Type, ModEntityIDs.FOODS_FOOD_ITEM.Variant, ModEntityIDs.FOODS_FOOD_ITEM.SubType, Utils.FindFreePickupSpawnPosition(npc.Position), Vector(0, 0), nil, rng:Next())
    end
end
ChefHat:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ChefHat.PostNPCDeath)

function ChefHat:PostNewLevel()
    if not Players.AnyoneHasCollectible(ModItemIDs.CHEF_HAT) then
        return
    end
    local pos = Vector(520, 360)
    if TYU.GAME:IsGreedMode() then
        pos = Vector(520, 640)
    end
    local slot = Entities.Spawn(ModEntityIDs.CHEF_BEGGAR.Type, ModEntityIDs.CHEF_BEGGAR.Variant, ModEntityIDs.CHEF_BEGGAR.SubType, Utils.FindFreePickupSpawnPosition(pos))
    Entities.SpawnPoof(slot.Position)
end
ChefHat:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ChefHat.PostNewLevel)

function ChefHat:PostTriggerCollectibleRemoved(player, type)
    local bank = GetGlobalLibData("Bank")
    if not bank then
        return
    end
    local room = TYU.GAME:GetRoom()
    for i = 4, 1, -1 do
        if bank[i] ~= -1 then
            Entities.Spawn(ModEntityIDs.FOODS_FOOD_ITEM.Type, ModEntityIDs.FOODS_FOOD_ITEM.Variant, bank[i] + 1, Utils.FindFreePickupSpawnPosition(player.Position)) 
        end
    end
    SetGlobalLibData({ -1, -1, -1, -1 }, "Bank")
end
ChefHat:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, ChefHat.PostTriggerCollectibleRemoved, ModItemIDs.CHEF_HAT)

return ChefHat