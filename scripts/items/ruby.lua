local Lib = TYU
local Ruby = Lib:NewModItem("Ruby", "RUBY")

local function GetDiscountedPrice(price, discount)
    local discountedPrice = price * (1 - discount / 10)
    if price >= 6 then
        discountedPrice = math.floor(discountedPrice)
    else
        discountedPrice = math.ceil(discountedPrice)
    end
    if discountedPrice == 0 then
        discountedPrice = PickupPrice.PRICE_FREE
    end
    return discountedPrice
end

function Ruby:PostPickupUpdate(pickup)
    if not Lib.Players.AnyoneHasCollectible(Lib.ModItemIDs.RUBY) or not pickup:IsShopItem() or (pickup.Price <= 0 and pickup.Price > PickupPrice.PRICE_FREE and pickup.Price ~= PickupPrice.PRICE_SPIKES) then
        return
    end
    local room = Lib.GAME:GetRoom()
    local rng = RNG(pickup.InitSeed + pickup.ShopItemId)
    local price = room:TryGetShopDiscount(pickup.ShopItemId, room:GetShopItemPrice(pickup.Variant, pickup.SubType, pickup.ShopItemId))
    local discountedPrice = GetDiscountedPrice(price, rng:RandomInt(2, 4))
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        pickup.AutoUpdatePrice = true
        pickup.Price = discountedPrice
    elseif not Lib.Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) then
        if Isaac.GetPlayer(0):GetNumCoins() < discountedPrice then
            pickup.AutoUpdatePrice = false
            pickup.Price = PickupPrice.PRICE_SPIKES    
        else
            pickup.AutoUpdatePrice = true
            pickup.Price = discountedPrice
        end
    end
end
Ruby:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CallbackPriority.EARLY, Ruby.PostPickupUpdate)

function Ruby:PostPlayerUpdate(player)
    if not player:HasCollectible(Lib.ModItemIDs.RUBY) then
        return
    end
    local found = false
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local pickup = ent:ToPickup()
        if pickup:IsShopItem() and pickup.Price > 0 then
            found = true
            break
        end
    end
    local effects = player:GetEffects()
    if found and not effects:HasNullEffect(Lib.ModNullItemIDs.RUBYEFFECT) then
        effects:AddNullEffect(Lib.ModNullItemIDs.RUBYEFFECT)
    end
    if not found and effects:HasNullEffect(Lib.ModNullItemIDs.RUBYEFFECT) then
        effects:RemoveNullEffect(Lib.ModNullItemIDs.RUBYEFFECT)
    end
end
Ruby:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Ruby.PostPlayerUpdate, 0)

return Ruby