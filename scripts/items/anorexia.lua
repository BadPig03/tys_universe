local Anorexia = TYU:NewModItem("Anorexia", "ANOREXIA")

local Collectibles = TYU.Collectibles
local Players = TYU.Players
local Entities = TYU.Entities
local Utils = TYU.Utils
local ModItemIDs = TYU.ModItemIDs

local PrivateField = {}

do -- 私有方法
    -- 模拟"呕血"的胶囊效果
    function PrivateField.SimulateHematemesisEffect(player)
        if player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY_B then -- 堕化伯大尼不能移除红心，否则会移除其红心充能
			player:AddHearts(-99)
			player:AddHearts(2)
		end

        local variant, subtype
		if player:GetHealthType() == HealthType.COIN then -- 角色为硬币血量时，生成硬币
            variant, subtype = PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY
        else -- 否则生成1颗心
            variant, subtype = PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL
        end

		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_YUM_HEART)
        for _ = 0, rng:RandomInt(4) do -- 生成1-4次掉落物
            Entities.Spawn(EntityType.ENTITY_PICKUP, variant, subtype, Utils.FindFreePickupSpawnPosition(player.Position))
        end
    end

end

-- 回调：检测玩家是否获得了道具
-- 如果获得了厌食症：（1）如果是第一次拾取，则触发模拟"呕血"的效果（2）如果拾取时角色拥有大胃王，则取消厌食症的人物外观
-- 如果已经拥有厌食症的情况下获得了大胃王，则直接取消厌食症的人物外观
function Anorexia:PostAddCollectible(collectibleType, charge, firstTime, slot, varData, player)
    if collectibleType == ModItemIDs.ANOREXIA then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
            Players.RemoveCostume(player, ModItemIDs.ANOREXIA)
        elseif firstTime then
            PrivateField.SimulateHematemesisEffect(player)
        end
        return
	elseif collectibleType == CollectibleType.COLLECTIBLE_BINGE_EATER and player:HasCollectible(ModItemIDs.ANOREXIA) then
        Players.RemoveCostume(player, ModItemIDs.ANOREXIA)
    end
end
Anorexia:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Anorexia.PostAddCollectible)

-- 回调：更新掉落物
-- 处理厌食症的具体逻辑
function Anorexia:PostPickupUpdate(pickup)
	if pickup.SubType == CollectibleType.COLLECTIBLE_NULL or pickup.Wait >= 5 then
		return -- 如果是空道具底座，或者Wait数大于等于5，则返回
	end

	if not TYU.ITEMCONFIG:GetCollectible(pickup.SubType) or not TYU.ITEMCONFIG:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_FOOD) then
		return -- 如果道具的 ItemConfig 不存在，或者道具拥有"食物"标签，则返回
	end

	if not Players.AnyoneHasCollectible(ModItemIDs.ANOREXIA) or Players.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) or Utils.IsInDeathCertificate() then
		return -- 如果角色没有厌食症，或者有大胃王，则返回
	end

    local rng = Isaac.GetPlayer(0):GetCollectibleRNG(ModItemIDs.ANOREXIA)
    local newType = Collectibles.GetCollectibleFromCurrentRoom(ItemConfig.TAG_FOOD, rng)

    if pickup.SubType ~= newType then -- 如果是正常重置
        Entities.Morph(pickup, nil, nil, newType)
    elseif pickup.SubType == CollectibleType.COLLECTIBLE_BREAKFAST then -- 如果是过空道具池
        if rng:RandomInt(100) < 75 then
            pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
            Entities.Morph(pickup, nil, nil, CollectibleType.COLLECTIBLE_BREAKFAST, nil, nil, nil, false)
            Entities.SpawnPoof(pickup.Position):GetSprite().Color:SetColorize(0, 0, 0, 1)
        else
            pickup:TryRemoveCollectible()
            Entities.SpawnPoof(pickup.Position)
        end
    end
end
Anorexia:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Anorexia.PostPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)

return Anorexia