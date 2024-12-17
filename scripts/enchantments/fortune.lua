local Lib = TYU
local Fortune = Lib:NewModEnchantment("Fortune", "FORTUNE")

function Fortune:PostGridRockDestroy(rock, type, immediate)
    if Lib.GAME:GetRoom():HasCurseMist() then
        return
    end
    local count = Lib.Players.GetNullEffectCounts(Lib.ModEnchantmentIDs.FORTUNE)
    if count == 0 or not rock:ToRock() then
        return
    end
    if type == GridEntityType.GRID_ROCKT or type == GridEntityType.GRID_ROCK_ALT or type == GridEntityType.GRID_ROCK_ALT2 or type == GridEntityType.GRID_ROCK_SS or type == GridEntityType.GRID_ROCK_GOLD then
        local seed = rock:GetSaveState().SpawnSeed
        local rng = RNG(seed)
        if rng:RandomInt(100) < count * 25 then
            Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, 0, 1, rock.Position, Vector(1, 0):Resized(3 + rng:RandomFloat() * 4):Rotated(rng:RandomInt(360)), nil, seed)
        end
    end
end
Fortune:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Fortune.PostGridRockDestroy)


return Fortune