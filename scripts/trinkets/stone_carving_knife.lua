local StoneCarvingKnife = TYU:NewModTrinket("Stone Carving Knife", "STONE_CARVING_KNIFE")

local Entities = TYU.Entities
local Players = TYU.Players

local ModTrinketIDs = TYU.ModTrinketIDs

function StoneCarvingKnife:PostGridRockDestroy(rock, type, immediate)
    local multiplier = Players.GetTotalTrinketMultiplier(ModTrinketIDs.STONE_CARVING_KNIFE)
    if multiplier == 0 or not rock:ToRock() then
        return
    end
    local seed = rock.Desc.SpawnSeed
    local rng = RNG(seed)
    if rng:RandomFloat() >= multiplier * 0.03 then
        return
    end
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, TYU.ITEMPOOL:GetCard(seed, false, true, true), rock.Position, rng:RandomVector() * rng:RandomInt(2, 5), nil)
end
StoneCarvingKnife:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, StoneCarvingKnife.PostGridRockDestroy)

return StoneCarvingKnife