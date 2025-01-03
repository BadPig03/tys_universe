local BloodSacrifice = TYU:NewModItem("Blood Sacrifice", "BLOOD_SACRIFICE")
local Entities = TYU.Entities
local Players = TYU.Players
local Stat = TYU.Stat
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModNullItemIDs = TYU.ModNullItemIDs
local PrivateField = {}

local function SetGlobalLibData(value, ...)
    TYU:SetGlobalLibData(value, "BloodSacrifice", ...)
end

local function GetGlobalLibData(...)
    return TYU:GetGlobalLibData("BloodSacrifice", ...)
end

do
    PrivateField.Teleported = false

    function PrivateField.AddReviveEffect(player)
        player:GetEffects():AddNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():AddNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():AddNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        end
    end

    function PrivateField.RemoveReviveEffect(player, count)
        player:GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, count)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, count)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE, count)
        end
    end

    function PrivateField.RevivePlayer(player)
        player:Revive()
        player:SetMinDamageCooldown(120)
        player.Visible = true
        player:GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        if (Players.IsJacobOrEsau(player) or Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            local otherTwin = player:GetOtherTwin()
            otherTwin:Revive()
            otherTwin:SetMinDamageCooldown(120)
            otherTwin.Visible = true
            otherTwin:GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        end
        if Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            local flippedForm = player:GetFlippedForm()
            flippedForm:Revive()
            flippedForm:SetMinDamageCooldown(120)
            flippedForm.Visible = true
            flippedForm:GetEffects():RemoveNullEffect(ModNullItemIDs.BLOOD_SACRIFICE_REVIVE)
        end
    end

    function PrivateField.SpawnMeatEffigy(player, soul)
        local bloodEffect1 = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
        local bloodEffect2 = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
        local effigy = nil
        if soul then
            effigy = Entities.Spawn(EntityType.ENTITY_SLOT, ModEntityIDs.MEAT_EFFIGY_SOUL.Variant, 0, Utils.FindFreePickupSpawnPosition(player.Position))
            bloodEffect1:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
            bloodEffect2:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
        else
            effigy = Entities.Spawn(EntityType.ENTITY_SLOT, ModEntityIDs.MEAT_EFFIGY.Variant, 0, Utils.FindFreePickupSpawnPosition(player.Position))
        end
        Entities.SpawnPoof(effigy.Position)
        PrivateField.AddReviveEffect(player)
        local data = GetGlobalLibData("Effigies")
        table.insert(data, { PositionX = effigy.Position.X, PositionY = effigy.Position.Y, RoomIndex = TYU.LEVEL:GetCurrentRoomIndex(), Dimension = TYU.LEVEL:GetDimension(), InitSeed = effigy.InitSeed, SoulState = (effigy.Variant == ModEntityIDs.MEAT_EFFIGY_SOUL.Variant) })
        local addCount = (player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)) and 2 or 1
        SetGlobalLibData(GetGlobalLibData("Counts") + addCount, "Counts")
    end

    function PrivateField.IsRedOnlyCharacter(player)
        local playerType = player:GetPlayerType()
        return playerType == PlayerType.PLAYER_BETHANY or playerType == ModPlayerIDs.WARFARIN
    end

    function PrivateField.ChangeLostCurseState(player, remove)
        local effects = player:GetEffects()
        if remove then
            effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE)
        else
            effects:AddNullEffect(NullItemID.ID_LOST_CURSE)
        end
    end

    function PrivateField.SetHealthAndTeleport(data)
        local effigyTable = data[#data]
        local dimension = effigyTable.Dimension    
        for _, player in pairs(Players.GetPlayers(true)) do
            local playerType = player:GetPlayerType()
            if playerType ~= PlayerType.PLAYER_BETHANY then
                player:AddSoulHearts(-99)
            end
            player:AddBoneHearts(-99)
            player:AddMaxHearts(-99)
            if playerType ~= PlayerType.PLAYER_BETHANY_B then
                player:AddHearts(-99)
            end
            if playerType == PlayerType.PLAYER_THEFORGOTTEN then
                player:ResetDamageCooldown()
                player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK)
                player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK).Cooldown = 1
                player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(player), 30)
                player:SetMinDamageCooldown(120)
            elseif playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
                goto continue
            end
            if playerType == PlayerType.PLAYER_THEFORGOTTEN or playerType == PlayerType.PLAYER_THESOUL then
                player:AddBoneHearts(1)
                player:AddHearts(2)
                player:AddSoulHearts(2)
            else
                if effigyTable.SoulState then
                    if player:GetHealthType() == HealthType.COIN or PrivateField.IsRedOnlyCharacter(player) then
                        player:AddMaxHearts(2)
                        player:AddHearts(2)
                    else
                        player:AddSoulHearts(2)
                    end
                else
                    if player:GetHealthType() == HealthType.COIN then
                        player:AddMaxHearts(2)
                        player:AddHearts(2)
                    end
                    player:AddBoneHearts(1)
                    player:AddHearts(2)
                end
            end
            ::continue::
            player:AnimateTeleport(true)
            PrivateField.ChangeLostCurseState(player, dimension ~= Dimension.MIRROR)
        end
        TYU.GAME:StartRoomTransition(effigyTable.RoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE_MIRROR, Isaac.GetPlayer(0), dimension)
        TYU.SFXMANAGER:Stop(SoundEffect.SOUND_MIRROR_EXIT, 0.6)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.6)
        PrivateField.Teleported = true
    end

    function PrivateField.BreakEffigy(data)
        local effigyTable = data[#data]
        local effigy = effigyTable and Entities.GetEntityBySeed(effigyTable.InitSeed)
        if effigy then
            for _, player in pairs(Players.GetPlayers(true)) do
                player:Teleport(Vector(effigyTable.PositionX, effigyTable.PositionY), false, true)
                local bloodEffect1 = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, player.Position)
                local bloodEffect2 = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
                local bloodEffect3 = Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
                local brokenEffigy = Entities.Spawn(ModEntityIDs.MEAT_EFFIGY_BROKEN.Type, ModEntityIDs.MEAT_EFFIGY_BROKEN.Variant, ModEntityIDs.MEAT_EFFIGY_BROKEN.SubType, effigy.Position)
                local brokenSprite = brokenEffigy:GetSprite()
                brokenEffigy.DepthOffset = -1
                if effigy.Variant == ModEntityIDs.MEAT_EFFIGY_SOUL.Variant then
                    brokenSprite:ReplaceSpritesheet(0, "gfx/items/slots/meat_effigy_soul.png", true)
                    bloodEffect1:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                    bloodEffect2:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                    bloodEffect3:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                    local color = Color(1, 0, 0, 1)
                    color:SetColorize(0.0235, 0.712, 1, 5)
                    TYU.GAME:SpawnParticles(player.Position, EffectVariant.BLOOD_PARTICLE, 150, 2, color)
                    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                        player:SwapForgottenForm(true, true)
                    end
                else
                    TYU.GAME:SpawnParticles(player.Position, EffectVariant.BLOOD_PARTICLE, 150, 2)
                    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                        player:SwapForgottenForm(true, true)
                    end
                end
            end
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_DEMON_HIT, 0.6)
            effigy:Remove()
            table.remove(data)
        end
        PrivateField.Teleported = false
    end
end

function BloodSacrifice:EvaluateCache(player, cacheFlag)
	local count = GetGlobalLibData("Counts")
	if count and count > 0 then
		Stat:AddFlatDamage(player, 0.4 * count)
	end
end
BloodSacrifice:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BloodSacrifice.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function BloodSacrifice:PostNewLevel()
    SetGlobalLibData({}, "Effigies")
    if GetGlobalLibData("Counts") == nil then
        SetGlobalLibData(0, "Counts")
    end
    for _, player in pairs(Players.GetPlayers(true)) do
        PrivateField.RemoveReviveEffect(player, -1)
    end
end
BloodSacrifice:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BloodSacrifice.PostNewLevel)

function BloodSacrifice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if Utils.HasFlags(useFlags, UseFlag.USE_CARBATTERY) or Utils.IsRoomIndex(GridRooms.ROOM_DEBUG_IDX) then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local healthType = player:GetHealthType()
    if Players.IsInLostCurse(player) then
        PrivateField.SpawnMeatEffigy(player, true)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        return { Discharge = true, Remove = true, ShowAnim = true }
    end
    if healthType == HealthType.COIN then
        return { Discharge = false, Remove = false, ShowAnim = true }
    elseif healthType == HealthType.LOST then
        PrivateField.SpawnMeatEffigy(player, true)
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        return { Discharge = true, Remove = true, ShowAnim = true }
    else
        if player:GetMaxHearts() > 0 then
            player:AddMaxHearts(-2)
            PrivateField.SpawnMeatEffigy(player, false)
        elseif player:GetBoneHearts() > 0 then
            player:AddBoneHearts(-1)
            PrivateField.SpawnMeatEffigy(player, false)
        elseif player:GetSoulHearts() > 0 then
            player:AddSoulHearts(-4)
            PrivateField.SpawnMeatEffigy(player, true)
        else
            return { Discharge = false, Remove = false, ShowAnim = true }
        end
    end
    player:TakeDamage(0, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 30)
    TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
    return { Discharge = true, Remove = false, ShowAnim = true }    
end
BloodSacrifice:AddCallback(ModCallbacks.MC_USE_ITEM, BloodSacrifice.UseItem, ModItemIDs.BLOOD_SACRIFICE)

function BloodSacrifice:PreTriggerPlayerDeath(player)
    local data = GetGlobalLibData("Effigies")
    if not data or #data == 0 or type(data[#data]) ~= "table" then
        return
    end
    PrivateField.RevivePlayer(player)
    Utils.CreateTimer(function()
        PrivateField.SetHealthAndTeleport(data)
    end, 1, 0, false)
end
BloodSacrifice:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, BloodSacrifice.PreTriggerPlayerDeath)

function BloodSacrifice:PostNewRoom()
    local data = GetGlobalLibData("Effigies")
    if not PrivateField.Teleported or not data or #data == 0 or type(data[#data]) ~= "table" then
        return
    end
    PrivateField.BreakEffigy(data)
end
BloodSacrifice:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BloodSacrifice.PostNewRoom)

return BloodSacrifice