local Lib = TYU
local StoneCarvingKnife = Lib:NewModTrinket("Stone Carving Knife", "STONE_CARVING_KNIFE")

function StoneCarvingKnife:PostGridRockDestroy(rock, type, immediate)
    local multiplier = Lib.Players.GetTotalTrinketMultiplier(Lib.ModTrinketIDs.STONE_CARVING_KNIFE)
    if multiplier == 0 or not rock:ToRock() then
        return
    end
    local seed = rock.Desc.SpawnSeed
    local rng = RNG(seed)
    if rng:RandomFloat() < multiplier * 0.03 then
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Lib.ITEMPOOL:GetCard(seed, false, true, true), rock.Position, rng:RandomVector() * rng:RandomInt(2, 5), nil)
    end
end
StoneCarvingKnife:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, StoneCarvingKnife.PostGridRockDestroy)

return StoneCarvingKnife