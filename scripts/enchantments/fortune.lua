local Fortune = TYU:NewModEnchantment("Fortune", "FORTUNE")
local Entities = TYU.Entities
local Players = TYU.Players
local Utils = TYU.Utils
local ModEnchantmentIDs = TYU.ModEnchantmentIDs
local ModItemIDs = TYU.ModItemIDs

function Fortune:PostGridRockDestroy(rock, type, immediate)
    if Utils.HasCurseMist() then
        return
    end
    local count = Players.GetNullEffectCounts(ModEnchantmentIDs.FORTUNE)
    if count == 0 or not rock:ToRock() then
        return
    end
    if type ~= GridEntityType.GRID_ROCKT and type ~= GridEntityType.GRID_ROCK_ALT and type ~= GridEntityType.GRID_ROCK_ALT2 and type ~= GridEntityType.GRID_ROCK_SS and type ~= GridEntityType.GRID_ROCK_GOLD then
        return
    end
    local seed = rock:GetSaveState().SpawnSeed
    local rng = RNG(seed)
    if rng:RandomInt(100) < count * 25 then
        Entities.Spawn(EntityType.ENTITY_PICKUP, 0, 1, rock.Position, Vector(1, 0):Resized(3 + rng:RandomFloat() * 4):Rotated(rng:RandomInt(360)), nil, seed)
    end
end
Fortune:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, Fortune.PostGridRockDestroy)


return Fortune