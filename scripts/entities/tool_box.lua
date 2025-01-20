local ToolBox = TYU:NewModEntity("Tool Box", "TOOL_BOX")

local Entities = TYU.Entities
local Utils = TYU.Utils

local ModCardIDs = TYU.ModCardIDs
local ModItemIDs = TYU.ModItemIDs
local ModEntityIDs = TYU.ModEntityIDs

local PrivateField = {}

do
    PrivateField.ItemOutcomes = WeightedOutcomePicker()
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_CHAOS, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_CREDIT, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_RULES, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_HUMANITY, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_GET_OUT_OF_JAIL, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_QUESTIONMARK, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_DICE_SHARD, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_EMERGENCY_CONTACT, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_HOLY, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_HUGE_GROWTH, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_ANCIENT_RECALL, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_ERA_WALK, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_CRACKED_KEY, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(Card.CARD_WILD, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(ModCardIDs.ENCHANTED_CARD, 1)
    PrivateField.ItemOutcomes:AddOutcomeWeight(ModCardIDs.GLOWING_HOURGLASS_SHARD, 1)
end

do
    function PrivateField.GetOutcomes(rng)
        return PrivateField.ItemOutcomes:PickOutcome(rng)
    end
end

function ToolBox:FamiliarInit(familiar)
    local sprite = familiar:GetSprite()
    sprite:Play("Appear", true)
    familiar:AddToFollowers()
end
ToolBox:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ToolBox.FamiliarInit, ModEntityIDs.TOOL_BOX.Variant)

function ToolBox:FamiliarUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()
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
    if familiar.Coins < limit then
        return
    end
    local rng = player:GetCollectibleRNG(ModItemIDs.TOOL_BOX)
    Entities.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, PrivateField.GetOutcomes(rng), Utils.FindFreePickupSpawnPosition(familiar.Position))
    familiar.Coins = 0
    sprite:Play("Appear", true)
end
ToolBox:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ToolBox.FamiliarUpdate, ModEntityIDs.TOOL_BOX.Variant)

function ToolBox:PreSpawnCleanAward(rng, spawnPosition)
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, ModEntityIDs.TOOL_BOX.Variant)) do
        local familiar = ent:ToFamiliar()
        familiar:AddCoins(1)
    end
end
ToolBox:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ToolBox.PreSpawnCleanAward)

return ToolBox