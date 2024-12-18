local Lib = TYU
local MirroringShard = Lib:NewModItem("Mirroring Shard", "MIRRORING_SHARD")

local function ChangePlayerToNonTaintedVersion(player)
    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_JUDAS_B and Lib:GetPlayerLibData(player, "Mirroring", "BlackJudas") then
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

function MirroringShard:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or activeSlot < ActiveSlot.SLOT_PRIMARY then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local room = Lib.GAME:GetRoom()
    local playerType = player:GetPlayerType()
    local playerConfig = EntityConfig.GetPlayer(playerType)
    if playerType == PlayerType.PLAYER_ESAU or playerType == PlayerType.PLAYER_LAZARUS2 or playerType == PlayerType.PLAYER_LAZARUS2_B or playerType== Lib.ModPlayerIDs.WARFARIN or not playerConfig:GetTaintedCounterpart() then
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_BREAK)
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, room:FindFreePickupSpawnPosition(player.Position))
        return { Discharge = false, Remove = true, ShowAnim = true }
    end
    if playerConfig:IsTainted() then
        ChangePlayerToNonTaintedVersion(player)
        player:RemoveCollectible(Lib.ModItemIDs.MIRRORING_SHARD, false, activeSlot)
        player:AddCollectible(Lib.ModItemIDs.MIRRORING, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MIRROR_EXIT)
        player:AnimateSad()
        Lib.SFXMANAGER:Stop(SoundEffect.SOUND_THUMBS_DOWN)
        Lib.GAME:ShowHallucination(5, room:GetBackdropType())
        Lib.SFXMANAGER:Stop(SoundEffect.SOUND_DEATH_CARD)
        return { Discharge = true, Remove = false, ShowAnim = false }    
    else
        player:RemoveCollectible(Lib.ModItemIDs.MIRRORING_SHARD, false, activeSlot)
        player:AddCollectible(Lib.ModItemIDs.MIRRORING, player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot), false, activeSlot, varData)
        return { Discharge = false, Remove = false, ShowAnim = true }
    end
end
MirroringShard:AddCallback(ModCallbacks.MC_USE_ITEM, MirroringShard.UseItem, Lib.ModItemIDs.MIRRORING_SHARD)

return MirroringShard