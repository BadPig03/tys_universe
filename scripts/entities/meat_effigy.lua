local Lib = TYU
local MeatEffigy = Lib:NewModEntity("Meat Effigy", "MEATEFFIGY")
local MeatEffigySoul = Lib:NewModEntity("Meat Effigy Soul", "MEATEFFIGYSOUL")
local MeatEffigyBroken = Lib:NewModEntity("Meat Effigy Broken", "MEATEFFIGYBROKEN")

local function RemoveEffigyData(seed)
    local data = Lib:GetGlobalLibData("BloodSacrifice", "Effigies")
    for index, tbl in ipairs(data) do
        if tbl.InitSeed == seed then
            table.remove(data, index)
        end
    end
end

function MeatEffigy:PreSlotCreateExplosionDrops(effigy)
    if effigy.Variant ~= Lib.ModEntityIDs.MEATEFFIGYSOUL.Variant and effigy.Variant ~= Lib.ModEntityIDs.MEATEFFIGY.Variant then
        return
    end
    RemoveEffigyData(effigy.InitSeed)
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        player:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, 1)
        if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, 1)
        end
        if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, 1)
        end
    end
    local rng = effigy:GetDropRNG()
    local heartVariant = HeartSubType.HEART_BONE
    local brokenSprite = Lib.Entities.Spawn(Lib.ModEntityIDs.MEATEFFIGYBROKEN.Type, Lib.ModEntityIDs.MEATEFFIGYBROKEN.Variant, Lib.ModEntityIDs.MEATEFFIGYBROKEN.SubType, effigy.Position):GetSprite()
    if effigy.Variant == Lib.ModEntityIDs.MEATEFFIGYSOUL.Variant then
        heartVariant = HeartSubType.HEART_SOUL
        brokenSprite:ReplaceSpritesheet(0, "gfx/items/slots/meat_effigy_soul.png", true)
    end
    Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartVariant, effigy.Position, Vector(1, 0):Resized(2 + rng:RandomFloat() * 3):Rotated(rng:RandomInt(360)))
    effigy:BloodExplode()
    effigy:Remove()
    return false
end
MeatEffigy:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, MeatEffigy.PreSlotCreateExplosionDrops)

return MeatEffigy