local Lib = TYU
local BloodSacrifice = Lib:NewModItem("Blood Sacrifice", "BLOODSACRIFICE")

local teleported = false

local function AddReviveEffect(player)
    player:GetEffects():AddNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
        player:GetOtherTwin():GetEffects():AddNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    end
    if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
        player:GetFlippedForm():GetEffects():AddNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    end
end

local function RevivePlayerWithDamageCooldown(player)
    player:Revive()
    player:SetMinDamageCooldown(120)
    player.Visible = true
    player:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
        local player2 = player:GetOtherTwin()
        player2:Revive()
        player2:SetMinDamageCooldown(120)
        player2.Visible = true
        player2:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    end
    if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
        local player2 = player:GetFlippedForm()
        player2:Revive()
        player2:SetMinDamageCooldown(120)
        player2.Visible = true
        player2:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE)
    end
end

local function SpawnMeatEffigy(player, soul)
    local room = Lib.GAME:GetRoom()
    local bloodEffect1 = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
    local bloodEffect2 = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
    local effigy
    if soul then
        effigy = Lib.Entities.Spawn(EntityType.ENTITY_SLOT, Lib.ModEntityIDs.MEATEFFIGYSOUL.Variant, 0, room:FindFreePickupSpawnPosition(player.Position, 0, true))
        bloodEffect1:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
        bloodEffect2:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
    else
        effigy = Lib.Entities.Spawn(EntityType.ENTITY_SLOT, Lib.ModEntityIDs.MEATEFFIGY.Variant, 0, room:FindFreePickupSpawnPosition(player.Position, 0, true))
    end
    Lib.Entities.SpawnPoof(effigy.Position)
    AddReviveEffect(player)
    local data = Lib:GetGlobalLibData("BloodSacrifice", "Effigies")
    table.insert(data, { PositionX = effigy.Position.X, PositionY = effigy.Position.Y, RoomIndex = Lib.LEVEL:GetCurrentRoomIndex(), Dimension = Lib.LEVEL:GetDimension(), InitSeed = effigy.InitSeed, SoulState = effigy.Variant == Lib.ModEntityIDs.MEATEFFIGYSOUL.Variant })
    local count = Lib:GetGlobalLibData("BloodSacrifice", "Counts")
    local addCount = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and 2 or 1
    Lib:SetGlobalLibData(count + addCount, "BloodSacrifice", "Counts")
end

function BloodSacrifice:EvaluateCache(player, cacheFlag)
	local count = Lib:GetGlobalLibData("BloodSacrifice", "Counts")
	if count and count > 0 then
		Lib.Stat:AddFlatDamage(player, 0.4 * count)
	end
end
BloodSacrifice:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BloodSacrifice.EvaluateCache, CacheFlag.CACHE_DAMAGE)

function BloodSacrifice:PostNewLevel()
    Lib:SetGlobalLibData({}, "BloodSacrifice", "Effigies")
    if Lib:GetGlobalLibData("BloodSacrifice", "Counts") == nil then
        Lib:SetGlobalLibData(0, "BloodSacrifice", "Counts")
    end
    for _, player in pairs(Lib.Players.GetPlayers(true)) do
        player:GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, -1)
        if (Lib.Players.IsJacobOrEsau(player) or Lib.Players.IsTaintedForgottenAndSoul(player)) and player:GetOtherTwin() then
            player:GetOtherTwin():GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, -1)
        end
        if Lib.Players.IsTaintedLazarusOrFlippedLazarus(player) and player:GetFlippedForm() then
            player:GetFlippedForm():GetEffects():RemoveNullEffect(Lib.ModNullItemIDs.BLOODSACRIFICEREVIVE, -1)
        end
    end
end
BloodSacrifice:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BloodSacrifice.PostNewLevel)

function BloodSacrifice:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY or Lib.Levels.IsInDebugRoom() then
        return { Discharge = false, Remove = false, ShowAnim = false }
    end
    local healthType = player:GetHealthType()
    if Lib.Players.IsInLostCurse(player) then
        SpawnMeatEffigy(player, true)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        return { Discharge = true, Remove = true, ShowAnim = true }
    end
    if healthType == HealthType.COIN then
        return { Discharge = false, Remove = false, ShowAnim = true }
    elseif healthType == HealthType.LOST then
        SpawnMeatEffigy(player, true)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        return { Discharge = true, Remove = true, ShowAnim = true }
    else
        if player:GetMaxHearts() > 0 then
            player:AddMaxHearts(-2)
            SpawnMeatEffigy(player, false)
        elseif player:GetBoneHearts() > 0 then
            player:AddBoneHearts(-1)
            SpawnMeatEffigy(player, false)
        elseif player:GetSoulHearts() > 0 then
            player:AddSoulHearts(-4)
            SpawnMeatEffigy(player, true)
        else
            return { Discharge = false, Remove = false, ShowAnim = true }
        end
    end
    player:TakeDamage(0, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 30)
    Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
    return { Discharge = true, Remove = false, ShowAnim = true }    
end
BloodSacrifice:AddCallback(ModCallbacks.MC_USE_ITEM, BloodSacrifice.UseItem, Lib.ModItemIDs.BLOODSACRIFICE)

function BloodSacrifice:PreTriggerPlayerDeath(player)
    local data = Lib:GetGlobalLibData("BloodSacrifice", "Effigies")
    if not data or #data == 0 or type(data[#data]) ~= "table" then
        return
    end
    local effigyTable = data[#data]
    local dimension = effigyTable.Dimension
    RevivePlayerWithDamageCooldown(player)
    Isaac.CreateTimer(function() 
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
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
            if Lib.Players.IsForgottenOrSoul(player) then
                player:AddBoneHearts(1)
                player:AddHearts(2)
                player:AddSoulHearts(2)
            else
                if effigyTable.SoulState then
                    if player:GetHealthType() == HealthType.COIN or Lib.Players.IsRedOnlyCharacter(player) then
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
            Lib.Players.AddLostCurse(player, dimension ~= Dimension.MIRROR)
        end
        Lib.GAME:StartRoomTransition(effigyTable.RoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE_MIRROR, player, dimension)
        Lib.SFXMANAGER:Stop(SoundEffect.SOUND_MIRROR_EXIT, 0.6)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.6)
        teleported = true
    end, 1, 0, false)
end
BloodSacrifice:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, BloodSacrifice.PreTriggerPlayerDeath)

function BloodSacrifice:PostNewRoom()
    if not teleported then
        return
    end
    local data = Lib:GetGlobalLibData("BloodSacrifice", "Effigies")
    local effigyTable = data[#data]
    local effigy = effigyTable and Lib.Entities.GetEntityBySeed(effigyTable.InitSeed)
    if effigy then
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            player:Teleport(Vector(effigyTable.PositionX, effigyTable.PositionY), false, true)
            local bloodEffect1 = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, player.Position)
            local bloodEffect2 = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player.Position)
            local bloodEffect3 = Lib.Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position)
            local brokenEffigy = Lib.Entities.Spawn(Lib.ModEntityIDs.MEATEFFIGYBROKEN.Type, Lib.ModEntityIDs.MEATEFFIGYBROKEN.Variant, Lib.ModEntityIDs.MEATEFFIGYBROKEN.SubType, effigy.Position)
            brokenEffigy.DepthOffset = -1
            local brokenSprite = brokenEffigy:GetSprite()
            if effigy.Variant == Lib.ModEntityIDs.MEATEFFIGYSOUL.Variant then
                brokenSprite:ReplaceSpritesheet(0, "gfx/items/slots/meat_effigy_soul.png", true)
                bloodEffect1:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                bloodEffect2:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                bloodEffect3:GetSprite().Color:SetColorize(0.0235, 0.712, 1, 5)
                local color = Color(1, 0, 0, 1)
                color:SetColorize(0.0235, 0.712, 1, 5)
                Lib.GAME:SpawnParticles(player.Position, EffectVariant.BLOOD_PARTICLE, 150, 2, color)
                if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                    player:SwapForgottenForm(true, true)
                end
            else
                Lib.GAME:SpawnParticles(player.Position, EffectVariant.BLOOD_PARTICLE, 150, 2)
                if player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                    player:SwapForgottenForm(true, true)
                end
            end
        end
        Lib.SFXMANAGER:Play(SoundEffect.SOUND_DEMON_HIT, 0.6)
        effigy:Remove()
        table.remove(data)
    end
    teleported = false
end
BloodSacrifice:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BloodSacrifice.PostNewRoom)

return BloodSacrifice