local WarfarinBlackmarketCrawlspace = TYU:NewModEntity("Warfarin Blackmarket Crawlspace", "WARFARIN_BLACKMARKET_CRAWLSPACE")

local Utils = TYU.Utils

local ModEntityIDs = TYU.ModEntityIDs

function WarfarinBlackmarketCrawlspace:PostEffectUpdate(effect)
    if Utils.IsRoomFirstVisit() or effect.SubType ~= ModEntityIDs.WARFARIN_BLACKMARKET_CRAWLSPACE.SubType or effect.Position:Distance(Vector(440, 160)) > 0 then
        return
    end
    local room = TYU.GAME:GetRoom()
    room:TrySpawnSecretShop(true)
    effect:Remove()
end
WarfarinBlackmarketCrawlspace:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, WarfarinBlackmarketCrawlspace.PostEffectUpdate, ModEntityIDs.WARFARIN_BLACKMARKET_CRAWLSPACE.Variant)

return WarfarinBlackmarketCrawlspace