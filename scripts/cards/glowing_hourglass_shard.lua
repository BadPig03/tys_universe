local Lib = TYU
local GlowingHourglassShard = Lib:NewModCard("Glowing Hourglass Shard", "GLOWING_HOURGLASS_SHARD")

local used = false

local function GetGlowingHourglassShards(player)
    local slots = {}
    for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        local card = player:GetCard(i)
        if card == Lib.ModCardIDs.GLOWING_HOURGLASS_SHARD then
            table.insert(slots, i)
        end
    end
    return slots
end

function GlowingHourglassShard:PostUseCard(card, player, useFlags)
    used = true
    player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_USE_CARD, GlowingHourglassShard.PostUseCard, Lib.ModCardIDs.GLOWING_HOURGLASS_SHARD)

function GlowingHourglassShard:PostNewRoom()
    if not used then
        return
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            local card = player:GetCard(i)
            if card == Lib.ModCardIDs.GLOWING_HOURGLASS_SHARD then
                player:RemovePocketItem(i)
                break
            end
        end
    end
    used = false
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, GlowingHourglassShard.PostNewRoom)

function GlowingHourglassShard:PostEntityTakeDMG(entity, damage, damageFlags, source, countdown)
    local player = entity:ToPlayer()
    if not player then
        return
    end
    local slots = GetGlowingHourglassShards(player)
    if #slots == 0 or not player:TryPreventDeath() then
        return
    end
    player:UseCard(Lib.ModCardIDs.GLOWING_HOURGLASS_SHARD, UseFlag.USE_OWNED)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_HELL_PORTAL2)
end
GlowingHourglassShard:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, GlowingHourglassShard.PostEntityTakeDMG, EntityType.ENTITY_PLAYER)

return GlowingHourglassShard