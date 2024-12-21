local MirroringShard = TYU:NewModItem("Mirroring Shard", "MIRRORING_SHARD")
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local ModPlayerIDs = TYU.ModPlayerIDs
local PrivateField = {}

local function GetPlayerLibData(player, ...)
    return TYU:GetPlayerLibData(player, "Mirroring", ...)
end

do
    function PrivateField.ChangePlayerToNonTaintedVersion(player)
        local playerType = player:GetPlayerType()
        if playerType == PlayerType.PLAYER_JUDAS_B and GetPlayerLibData(player, "BlackJudas") then
            player:ChangePlayerType(PlayerType.PLAYER_BLACKJUDAS)
        elseif playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
            player:ChangePlayerType(PlayerType.PLAYER_THEFORGOTTEN)
            player:AddSoulHearts(-1)
        elseif playerType == PlayerType.PLAYER_BETHANY_B then
            local charge = player:GetSoulHearts()
            local health = math.max(2, player:GetBloodCharge())
            player:ChangePlayerType(PlayerType.PLAYER_BETHANY)
            player:AddMaxHearts(-99)
            player:AddHearts(-99)
            player:AddSoulHearts(-99)
            player:AddMaxHearts(health)
            player:AddHearts(health)
            player:AddSoulCharge(charge)
        else
            player:ChangePlayerType(EntityConfig.GetPlayer(playerType):GetTaintedCounterpart():GetPlayerType())
        end
    end
end

function MirroringShard:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local playerType = player:GetPlayerType()
    local playerConfig = EntityConfig.GetPlayer(playerType)
    if playerType == PlayerType.PLAYER_ESAU or playerType == PlayerType.PLAYER_LAZARUS2 or playerType == PlayerType.PLAYER_LAZARUS2_B or playerType== ModPlayerIDs.WARFARIN or not playerConfig:GetTaintedCounterpart() then
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_BREAK)
        Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, Utils.FindFreePickupSpawnPosition(player.Position))
        return { Discharge = false, Remove = true, ShowAnim = true }
    end
    if playerConfig:IsTainted() then
        local room = TYU.GAME:GetRoom()
        PrivateField.ChangePlayerToNonTaintedVersion(player)
        player:RemoveCollectible(ModItemIDs.MIRRORING_SHARD, false, activeSlot)
        player:AddCollectible(ModItemIDs.MIRRORING, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_EXIT)
        player:AnimateSad()
        TYU.SFXMANAGER:Stop(SoundEffect.SOUND_THUMBS_DOWN)
        TYU.GAME:ShowHallucination(5, room:GetBackdropType())
        TYU.SFXMANAGER:Stop(SoundEffect.SOUND_DEATH_CARD)
        return { Discharge = true, Remove = false, ShowAnim = false }    
    else
        player:RemoveCollectible(ModItemIDs.MIRRORING_SHARD, false, activeSlot)
        player:AddCollectible(ModItemIDs.MIRRORING, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
end
MirroringShard:AddCallback(ModCallbacks.MC_USE_ITEM, MirroringShard.UseItem, ModItemIDs.MIRRORING_SHARD)

return MirroringShard