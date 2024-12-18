local Lib = TYU
local KeepersCore = Lib:NewModTrinket("Keeper's Core", "KEEPERS_CORE")

local chestTable = {
    [PickupVariant.PICKUP_CHEST] = true,
    [PickupVariant.PICKUP_BOMBCHEST] = true,
    [PickupVariant.PICKUP_SPIKEDCHEST] = true,
    [PickupVariant.PICKUP_MIMICCHEST] = true,
    [PickupVariant.PICKUP_OLDCHEST] = true,
    [PickupVariant.PICKUP_WOODENCHEST] = true,
    [PickupVariant.PICKUP_MEGACHEST] = true,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = true,
    [PickupVariant.PICKUP_LOCKEDCHEST] = true,
    [PickupVariant.PICKUP_GRAB_BAG] = true,
    [PickupVariant.PICKUP_REDCHEST] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true
}

function KeepersCore:PostPickupInit(pickup)
    if not chestTable[pickup.Variant] or (Lib:GetGlobalLibData("KeepersCore", "LootTable") and Lib:GetGlobalLibData("KeepersCore", "LootTable")[tostring(pickup.InitSeed)]) then
        return
    end
    local lootList = pickup:GetLootList():GetEntries()
    local lootTable = {}
    for _, lootListEntry in pairs(lootList) do
        local rng = lootListEntry:GetRNG()
        if rng then
            rng = rng:GetSeed()
        else
            rng = -1
        end
        table.insert(lootTable, {Type = lootListEntry:GetType(), Variant = lootListEntry:GetVariant(), SubType = lootListEntry:GetSubType(), Seed = lootListEntry:GetSeed(), RNG = rng})
    end
    Lib:SetGlobalLibData(lootTable, "KeepersCore", "LootTable", tostring(pickup.InitSeed))
    pickup:UpdatePickupGhosts()
end
KeepersCore:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, KeepersCore.PostPickupInit)

function KeepersCore:PrePickupGetLootList(pickup, shouldAdvance)
    local multiplier = Lib.Players.GetTotalTrinketMultiplier(Lib.ModTrinketIDs.KEEPERS_CORE)
    local lootTable = Lib:GetGlobalLibData("KeepersCore", "LootTable") and Lib:GetGlobalLibData("KeepersCore", "LootTable")[tostring(pickup.InitSeed)]
    if multiplier == 0 or not lootTable or not chestTable[pickup.Variant] then
        return
    end
    local lootList = LootList()
    for _, lootListEntry in pairs(lootTable) do
        local rng = lootListEntry.RNG
        if rng == -1 then
            rng = nil
        else
            rng = RNG(rng)
        end
        lootList:PushEntry(lootListEntry.Type, lootListEntry.Variant, lootListEntry.SubType, lootListEntry.Seed, rng)
    end
    for i = 1, multiplier do
        lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY)
    end
    return lootList
end
KeepersCore:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, KeepersCore.PrePickupGetLootList)

function KeepersCore:PostTriggerTrinketChanged(player, trinket, _)
    if trinket ~= Lib.ModTrinketIDs.KEEPERS_CORE and trinket ~= Lib.ModTrinketIDs.KEEPERS_CORE | TrinketType.TRINKET_GOLDEN_FLAG then
        return
    end
    local room = Lib.GAME:GetRoom()
    room:InvalidatePickupVision()
end
KeepersCore:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, KeepersCore.PostTriggerTrinketChanged)
KeepersCore:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, KeepersCore.PostTriggerTrinketChanged)

function KeepersCore:PostNewLevel()
    Lib:SetGlobalLibData({}, "KeepersCore", "LootTable")
end
KeepersCore:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, KeepersCore.PostNewLevel)

return KeepersCore