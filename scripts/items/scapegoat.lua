local Scapegoat = TYU:NewModItem("Scapegoat", "SCAPEGOAT")
local Entities = TYU.Entities
local Players = TYU.Players
local ModNullItemIDs = TYU.ModNullItemIDs
local ModItemIDs = TYU.ModItemIDs
local PrivateField = {}

do
    function PrivateField.AddReviveEffect(player)
        player:GetEffects():AddNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():AddNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():AddNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        end
    end

    function PrivateField.RevivePlayer(player)
        player:Revive()
        player:SetMinDamageCooldown(120)
        player.Visible = true
        player:GetEffects():RemoveNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            local otherTwin = player:GetOtherTwin()
            otherTwin:Revive()
            otherTwin:SetMinDamageCooldown(120)
            otherTwin.Visible = true
            otherTwin:GetEffects():RemoveNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            local flippedForm = player:GetFlippedForm()
            flippedForm:Revive()
            flippedForm:SetMinDamageCooldown(120)
            flippedForm.Visible = true
            flippedForm:GetEffects():RemoveNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE)
        end
    end
end

function Scapegoat:PostAddCollectible(type, charge, firstTime, slot, varData, player)
    if not firstTime then
        return
    end
    PrivateField.AddReviveEffect(player)
end
Scapegoat:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Scapegoat.PostAddCollectible, ModItemIDs.SCAPEGOAT)

function Scapegoat:TriggerPlayerDeathPostCheckRevives(player)
    if not player:GetEffects():HasNullEffect(ModNullItemIDs.SCAPEGOAT_REVIVE) then
        return
    end
    player:RemoveCollectible(ModItemIDs.SCAPEGOAT)
    player:AnimateCollectible(ModItemIDs.SCAPEGOAT, "UseItem")
    PrivateField.RevivePlayer(player)
    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_AZAZEL_B then
        player:QueueItem(TYU.ITEMCONFIG:GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT))
    elseif playerType == PlayerType.PLAYER_ESAU then
        local twinPlayer = player:GetOtherTwin()
        if twinPlayer then
            twinPlayer:RemoveCollectible(ModItemIDs.SCAPEGOAT)
            twinPlayer:AnimateCollectible(ModItemIDs.SCAPEGOAT, "UseItem")
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
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position)
    Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_UNHOLY, 0.6)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_FLASHBACK, 0.6)
end
Scapegoat:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, Scapegoat.TriggerPlayerDeathPostCheckRevives)

return Scapegoat