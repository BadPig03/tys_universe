local Lib = TYU
local ExpiredGlue = Lib:NewModItem("Expired Glue", "EXPIRED_GLUE")

function ExpiredGlue:PostPickupInit(pickup)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.EXPIRED_GLUE) or pickup.SubType == CoinSubType.COIN_STICKYNICKEL then
        return
    end
    Lib.Entities.Morph(pickup, nil, nil, CoinSubType.COIN_STICKYNICKEL)
    local rng = RNG(pickup.InitSeed)
    local timeout = math.ceil(-math.log(rng:RandomFloat()) * 900)
    pickup.Timeout = timeout
end
ExpiredGlue:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ExpiredGlue.PostPickupInit, PickupVariant.PICKUP_COIN)

return ExpiredGlue