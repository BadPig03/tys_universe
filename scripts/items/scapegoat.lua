local Lib = TYU
local Scapegoat = Lib:NewModItem("Scapegoat", "SCAPEGOAT")

local function AddReviveEffect(player)
    player:GetEffects():AddNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
        player:GetOtherTwin():GetEffects():AddNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    end
    if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
        player:GetFlippedForm():GetEffects():AddNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    end
end

local function RevivePlayerWithDamageCooldown(player)
    player:Revive()
    player:SetMinDamageCooldown(120)
    player.Visible = true
    player:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
        local player2 = player:GetOtherTwin()
        player2:Revive()
        player2:SetMinDamageCooldown(120)
        player2.Visible = true
        player2:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    end
    if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
        local player2 = player:GetFlippedForm()
        player2:Revive()
        player2:SetMinDamageCooldown(120)
        player2.Visible = true
        player2:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE)
    end
end

function Scapegoat:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    AddReviveEffect(player)
end
Scapegoat:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Scapegoat.PostAddCollectible, Lib.ModItemIDs.SCAPEGOAT)

function Scapegoat:TriggerPlayerDeathPostCheckRevives(player)
    if not player:GetEffects():HasNullEffect(Lib.ModNullItemIDs.SCAPEGOATREVIVE) then
        return
    end
    player:RemoveCollectible(Lib.ModItemIDs.SCAPEGOAT)
    player:AnimateCollectible(Lib.ModItemIDs.SCAPEGOAT, "UseItem")
    RevivePlayerWithDamageCooldown(player)
    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_AZAZEL_B then
        player:QueueItem(Lib.ITEMCONFIG:GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT))
    elseif playerType == PlayerType.PLAYER_ESAU then
        local twinPlayer = player:GetOtherTwin()
        if twinPlayer then
            twinPlayer:RemoveCollectible(Lib.ModItemIDs.SCAPEGOAT)
            twinPlayer:AnimateCollectible(Lib.ModItemIDs.SCAPEGOAT, "UseItem")
            twinPlayer:ChangePlayerType(PlayerType.PLAYER_AZAZEL)
            twinPlayer:AddBlackHearts(2)
        else
            player:ChangePlayerType(PlayerType.PLAYER_AZAZEL)
            player:AddBlackHearts(2)
        end
    else
        player:ChangePlayerType(PlayerType.PLAYER_AZAZEL)
        player:AddBlackHearts(2)
    end
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
    Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_UNHOLY, 0.6)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_FLASHBACK, 0.6)
end
Scapegoat:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, Scapegoat.TriggerPlayerDeathPostCheckRevives)

return Scapegoat