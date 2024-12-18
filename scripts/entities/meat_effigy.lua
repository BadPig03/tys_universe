local MeatEffigy = TYU:NewModEntity("Meat Effigy", "MEAT_EFFIGY")
local MeatEffigySoul = TYU:NewModEntity("Meat Effigy Soul", "MEAT_EFFIGY_SOUL")
local MeatEffigyBroken = TYU:NewModEntity("Meat Effigy Broken", "MEAT_EFFIGY_BROKEN")
local Entities = TYU.Entities
local Players = TYU.Players
local ModEntityIDs = TYU.ModEntityIDs
local ModNullItemIDs = TYU.ModNullItemIDs
local PrivateField = {}

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("BloodSacrifice", ...)
end

do
    function PrivateField.RemoveEffigyData(seed)
        local data = GetGlobalLibData("Effigies")
        for index, tbl in ipairs(data) do
            if tbl.InitSeed == seed then
                table.remove(data, index)
            end
        end
    end
end

function MeatEffigy:PreSlotCreateExplosionDrops(effigy)
    if effigy.Variant ~= ModEntityIDs.MEAT_EFFIGY_SOUL.Variant and effigy.Variant ~= ModEntityIDs.MEAT_EFFIGY.Variant then
        return
    end
    PrivateField.RemoveEffigyData(effigy.InitSeed)
    for _, player in pairs(Players.GetPlayers(true)) do
        player:GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, 1)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, 1)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, 1)
        end
    end
    local rng = effigy:GetDropRNG()
    local heartVariant = HeartSubType.HEART_BONE
    local brokenSprite = Entities.Spawn(ModEntityIDs.MEAT_EFFIGY_BROKEN.Type, ModEntityIDs.MEAT_EFFIGY_BROKEN.Variant, ModEntityIDs.MEAT_EFFIGY_BROKEN.SubType, effigy.Position):GetSprite()
    if effigy.Variant == ModEntityIDs.MEAT_EFFIGY_SOUL.Variant then
        heartVariant = HeartSubType.HEART_SOUL
        brokenSprite:ReplaceSpritesheet(0, "gfx/items/slots/meat_effigy_soul.png", true)
    end
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartVariant, effigy.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
    effigy:BloodExplode()
    effigy:Remove()
    return false
end
MeatEffigy:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, MeatEffigy.PreSlotCreateExplosionDrops)

return MeatEffigy