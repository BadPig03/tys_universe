local FallenSkySword = TYU:NewModEntity("Fallen Sky Sword", "FALLEN_SKY_SWORD")

local Entities = TYU.Entities

local ModEntityIDs = TYU.ModEntityIDs

local PrivateField = {}

local function SetTempEntityLibData(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, "FallenSky")
end

local function GetTempEntityLibData(entity, ...)
    return TYU:GetTempEntityLibData(entity, "FallenSky")
end

do
    function PrivateField.HarmTheEnemy(enemy, player, multiplier)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
            multiplier = multiplier * 3
        end
        local extraDamage = 3 * player.ShotSpeed ^ 1.5 * player.Damage * multiplier
        if enemy.Type == EntityType.ENTITY_BEAST and enemy.Variant > 0 and enemy.Variant % 10 == 0 then
            extraDamage = extraDamage + 50
        end
        enemy:TakeDamage(extraDamage, DamageFlag.DAMAGE_SPIKES, EntityRef(player), 0)
        if extraDamage >= 50 then
            TYU.GAME:ShakeScreen(5)
        end
        local cooldown = enemy:GetBossStatusEffectCooldown()
        enemy:SetBossStatusEffectCooldown(0)
        enemy:AddBleeding(EntityRef(player), 150)
        enemy:GetBossStatusEffectCooldown(cooldown)
        Entities.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, enemy.Position)
        enemy:BloodExplode()
    end

    function PrivateField.MarkTheEnemy(enemy, player, parent, multiplier)
        local newData = {}
        newData.Player = player
        newData.Parent = parent
        newData.Timeout = 120
        newData.Multiplier = multiplier
        SetTempEntityLibData(enemy, newData)
    end

    function PrivateField.HarmNearbyEnemies(effect)
        local effectData = GetTempEntityLibData(effect)
        local player = effectData.Player
        local target = effectData.Target or player
        local multiplier = effectData.Multiplier
        local enemyFound = false
        for _, enemy in pairs(Isaac.FindInRadius(effect.Position, player.TearRange / 2, EntityPartition.ENEMY)) do
            if GetPtrHash(enemy) == GetPtrHash(target) then
                PrivateField.HarmTheEnemy(enemy, player, multiplier)
                if GetTempEntityLibData(enemy) == nil then
                    PrivateField.MarkTheEnemy(enemy, player, nil, multiplier)
                end
            elseif Entities.IsValidEnemy(enemy) then
                if enemy.Position:Distance(effect.Position) <= 24 then
                    PrivateField.HarmTheEnemy(enemy, player, multiplier)
                    enemyFound = true
                end
                if GetTempEntityLibData(enemy) == nil then
                    PrivateField.MarkTheEnemy(enemy, player, target, multiplier)
                end
            end
        end
        if enemyFound then
            TYU.SFXMANAGER:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6)
        end
        TYU.SFXMANAGER:Play(SoundEffect.SOUND_GOOATTACH0, 0.6)
    end
end

function FallenSkySword:UpdateSword(effect)
    local sprite = effect:GetSprite()
    local data = GetTempEntityLibData(effect)
    if sprite:IsPlaying("Fall") and data.Position > 0 then
        if data.Delay > 0 then
            data.Delay = data.Delay - 1
        else
            if sprite.PlaybackSpeed == 0 then
                sprite.PlaybackSpeed = 1.5
            end
            data.Position = data.Position - 50
            if not data.Group then
                effect.Position = data.Target.Position - Vector(0, data.Position)
            else
                effect.Position = effect.Position + Vector(0, 50)
            end
        end
    end
    if sprite:IsFinished("Fall") then
        sprite.PlaybackSpeed = 1
        sprite:Play("Disappear", true)
    end
    if sprite:IsFinished("Disappear") then
        effect:Remove()
    end
    if sprite:IsEventTriggered("Hit") then
        PrivateField.HarmNearbyEnemies(effect)
    end
end
FallenSkySword:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FallenSkySword.UpdateSword, ModEntityIDs.FALLEN_SKY_SWORD.Variant)

return FallenSkySword