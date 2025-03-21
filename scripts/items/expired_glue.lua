local ExpiredGlue = TYU:NewModItem("Expired Glue", "EXPIRED_GLUE")

local Entities = TYU.Entities
local Players = TYU.Players
local Reverie = TYU.Reverie

local ModItemIDs = TYU.ModItemIDs

function ExpiredGlue:PostPickupInit(pickup)
    if not Players.AnyoneHasCollectible(ModItemIDs.EXPIRED_GLUE) then
        return
    end
    if Reverie.WillAnyPlayerBuff() then
        if pickup.SubType == CoinSubType.COIN_NICKEL then
            return
        end
        Entities.Morph(pickup, nil, nil, CoinSubType.COIN_NICKEL)
    else
        if pickup.SubType == CoinSubType.COIN_STICKYNICKEL then
            return
        end
        Entities.Morph(pickup, nil, nil, CoinSubType.COIN_STICKYNICKEL)
    end
    local rng = RNG(pickup.InitSeed)
    local timeout = math.ceil(-math.log(rng:RandomFloat()) * 900)
    pickup.Timeout = timeout
end
ExpiredGlue:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ExpiredGlue.PostPickupInit, PickupVariant.PICKUP_COIN)

return ExpiredGlue