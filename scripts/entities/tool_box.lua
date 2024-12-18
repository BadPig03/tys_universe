local Lib = TYU
local ToolBox = Lib:NewModEntity("Tool Box", "TOOL_BOX")

local itemOutcomes = WeightedOutcomePicker()
itemOutcomes:AddOutcomeWeight(Card.CARD_CHAOS, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_CREDIT, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_RULES, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_HUMANITY, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_GET_OUT_OF_JAIL, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_QUESTIONMARK, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_DICE_SHARD, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_EMERGENCY_CONTACT, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_HOLY, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_HUGE_GROWTH, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_ANCIENT_RECALL, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_ERA_WALK, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_CRACKED_KEY, 1)
itemOutcomes:AddOutcomeWeight(Card.CARD_WILD, 1)
itemOutcomes:AddOutcomeWeight(Lib.ModCardIDs.ENCHANTED_CARD, 1)
itemOutcomes:AddOutcomeWeight(Lib.ModCardIDs.GLOWING_HOURGLASS_SHARD, 1)

function ToolBox:FamiliarUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()
    local room = Lib.GAME:GetRoom()
    if sprite:IsFinished("Appear") or sprite:IsFinished("Idle") then
        sprite:Play("Float", true)
    end
    if sprite:IsPlaying("Float") then
        familiar:FollowParent()
    end
    local limit = 5
    if familiar:GetMultiplier() > 1 then
        limit = 4
    end
    if familiar.Coins >= limit then
        local rng = player:GetCollectibleRNG(Lib.ModItemIDs.TOOL_BOX)
        Lib.Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, itemOutcomes:PickOutcome(rng), room:FindFreePickupSpawnPosition(familiar.Position, 0, true, false))
        familiar.Coins = 0
        sprite:Play("Appear", true)
    end
end
ToolBox:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ToolBox.FamiliarUpdate, Lib.ModEntityIDs.TOOL_BOX.Variant)

function ToolBox:PreSpawnCleanAward(rng, spawnPosition)
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Lib.ModEntityIDs.TOOL_BOX.Variant)) do
        local familiar = ent:ToFamiliar()
        familiar:AddCoins(1)
    end
end
ToolBox:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ToolBox.PreSpawnCleanAward)

return ToolBox