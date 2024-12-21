local GlowingHourglassShard = TYU:NewModCard("Glowing Hourglass Shard", "GLOWING_HOURGLASS_SHARD")
local Players = TYU.Players
local ModCardIDs = TYU.ModCardIDs
local PrivateField = {}

do
    PrivateField.Used = false

    function PrivateField.GetGlowingHourglassShards(player)
        local slots = {}
        for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            local card = player:GetCard(i)
            if card == ModCardIDs.GLOWING_HOURGLASS_SHARD then
                table.insert(slots, i)
            end
        end
        return slots
    end
end

function GlowingHourglassShard:PostUseCard(card, player, useFlags)
    PrivateField.Used = true
    player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_USE_CARD, GlowingHourglassShard.PostUseCard, ModCardIDs.GLOWING_HOURGLASS_SHARD)

function GlowingHourglassShard:PostNewRoom()
    if not PrivateField.Used then
        return
    end
    for _, player in pairs(Players.GetPlayers(true)) do
        for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            local card = player:GetCard(i)
            if card == ModCardIDs.GLOWING_HOURGLASS_SHARD then
                player:RemovePocketItem(i)
                break
            end
        end
    end
    PrivateField.Used = false
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, GlowingHourglassShard.PostNewRoom)

function GlowingHourglassShard:PostEntityTakeDMG(entity, damage, damageFlags, source, countdown)
    local player = entity:ToPlayer()
    if not player then
        return
    end
    local slots = PrivateField.GetGlowingHourglassShards(player)
    if #slots == 0 or not player:TryPreventDeath() then
        return
    end
    player:UseCard(ModCardIDs.GLOWING_HOURGLASS_SHARD, UseFlag.USE_OWNED)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_HELL_PORTAL2)
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, GlowingHourglassShard.PostEntityTakeDMG, EntityType.ENTITY_PLAYER)

return GlowingHourglassShard