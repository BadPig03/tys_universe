local ChefHat = TYU:NewModItem("Chef Hat", "CHEFHAT")
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "Foods", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("Foods", ...)
end

function ChefHat:PostNPCDeath(npc)
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.CHEFHAT) then
        return
    end
    local count = Players.GetNullEffectCounts(TYU.ModEnchantmentIDs.LOOTING)
    local rng = RNG(npc.InitSeed + npc.Index)
    if (not npc.SpawnerEntity and rng:RandomInt(100) < 6 + 2 * count) or (npc.SpawnerEntity and rng:RandomInt(100) < 3 + count) then
        Entities.Spawn(TYU.ModEntityIDs.FOODSFOODITEM.Type, TYU.ModEntityIDs.FOODSFOODITEM.Variant, TYU.ModEntityIDs.FOODSFOODITEM.SubType, Utils.FindFreePickupSpawnPosition(npc.Position), Vector(0, 0), nil, rng:Next())
    end
end
ChefHat:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ChefHat.PostNPCDeath)

function ChefHat:PostNewLevel()
    if not Players.AnyoneHasCollectible(TYU.ModItemIDs.CHEFHAT) then
        return
    end
    local room = TYU.GAME:GetRoom()
    local pos = Vector(520, 360)
    if TYU.GAME:IsGreedMode() then
        pos = Vector(520, 640)
    end
    local slot = Entities.Spawn(TYU.ModEntityIDs.CHEFBEGGAR.Type, TYU.ModEntityIDs.CHEFBEGGAR.Variant, TYU.ModEntityIDs.CHEFBEGGAR.SubType, Utils.FindFreePickupSpawnPosition(pos))
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
            Entities.Spawn(TYU.ModEntityIDs.FOODSFOODITEM.Type, TYU.ModEntityIDs.FOODSFOODITEM.Variant, bank[i] + 1, Utils.FindFreePickupSpawnPosition(player.Position)) 
        end
    end
    SetGlobalLibData({ -1, -1, -1, -1 }, "Bank")
end
ChefHat:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, ChefHat.PostTriggerCollectibleRemoved, TYU.ModItemIDs.CHEFHAT)

return ChefHat