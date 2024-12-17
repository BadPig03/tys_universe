local Lib = TYU
local ChefHat = Lib:NewModItem("Chef Hat", "CHEFHAT")

function ChefHat:PostNewLevel()
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEFHAT) then
        return
    end
    local room = Lib.GAME:GetRoom()
    local pos = Vector(520, 360)
    if Lib.GAME:IsGreedMode() then
        pos = Vector(520, 640)
    end
    local slot = Lib.Entities.Spawn(Lib.ModEntityIDs.CHEFBEGGAR.Type, Lib.ModEntityIDs.CHEFBEGGAR.Variant, Lib.ModEntityIDs.CHEFBEGGAR.SubType, room:FindFreePickupSpawnPosition(pos, 0, true, false))
    Lib.Entities.SpawnPoof(slot.Position)
end
ChefHat:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ChefHat.PostNewLevel)

function ChefHat:PostNPCDeath(npc)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.CHEFHAT) then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.LOOTING)
    local rng = RNG(npc.InitSeed + npc.Index)
    if (not npc.SpawnerEntity and rng:RandomInt(100) < 6 + 2 * count) or (npc.SpawnerEntity and rng:RandomInt(100) < 3 + count) then
        Lib.Entities.Spawn(Lib.ModEntityIDs.FOODSFOODITEM.Type, Lib.ModEntityIDs.FOODSFOODITEM.Variant, Lib.ModEntityIDs.FOODSFOODITEM.SubType, npc.Position, Vector(0, 0), nil, rng:Next()) 
    end
end
ChefHat:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, ChefHat.PostNPCDeath)

function ChefHat:PostTriggerCollectibleRemoved(player, type)
    local bank = Lib:GetGlobalLibData("Foods", "Bank")
    if not bank then
        return
    end
    local room = Lib.GAME:GetRoom()
    for i = 4, 1, -1 do
        if bank[i] ~= -1 then
            Lib.Entities.Spawn(Lib.ModEntityIDs.FOODSFOODITEM.Type, Lib.ModEntityIDs.FOODSFOODITEM.Variant, bank[i] + 1, room:FindFreePickupSpawnPosition(player.Position, 0, true, false)) 
        end
    end
    Lib:SetGlobalLibData({ -1, -1, -1, -1 }, "Foods", "Bank")
end
ChefHat:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, ChefHat.PostTriggerCollectibleRemoved, Lib.ModItemIDs.CHEFHAT)

return ChefHat