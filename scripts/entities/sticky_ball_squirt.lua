local StickyBallSquirt = TYU:NewModEntity("Sticky Ball Squirt Level 2", "STICKY_BALL_SQUIRT_LEVEL_2")

local Entities = TYU.Entities

local ModEntityIDs = TYU.ModEntityIDs

function StickyBallSquirt:PostNPCDeath(npc)
    local variant = npc.Variant
    if variant ~= ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Variant and variant ~= ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.Variant and variant ~= ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.Variant then
        return
    end
    for _, ent in pairs(Isaac.FindByType(ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Type, 0, 0)) do
        if ent.FrameCount == 0 and ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM) then
            if variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Variant then
                local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.SubType, ent.Position, Vector(0, 0), npc):ToNPC()
                dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
            elseif variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.Variant then
                local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.SubType, ent.Position, Vector(0, 0), npc):ToNPC()
                dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
            elseif variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.Variant then
                local dip = Entities.Spawn(ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.Type, ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.Variant, ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.SubType, ent.Position, Vector(0, 0), npc):ToNPC()
                dip:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
            end
            ent:Remove()
        end
    end
end
StickyBallSquirt:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, StickyBallSquirt.PostNPCDeath, ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Type)

function StickyBallSquirt:PostNewRoom()
    for _, ent in pairs(Isaac.FindByType(ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Type, 0, 0)) do
        local variant = ent.Variant
        if variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_1.Variant or variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_2.Variant or variant == ModEntityIDs.STICKY_BALL_SQUIRT_LEVEL_3.Variant then
            ent:Remove()
        end
    end
    for _, ent in pairs(Isaac.FindByType(ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Type, 0, 0)) do
        local variant = ent.Variant
        if variant == ModEntityIDs.STICKY_BALL_DIP_LEVEL_1.Variant or variant == ModEntityIDs.STICKY_BALL_DIP_LEVEL_2.Variant or variant == ModEntityIDs.STICKY_BALL_DIP_LEVEL_3.Variant then
            ent:Remove()
        end
    end
end
StickyBallSquirt:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, StickyBallSquirt.PostNewRoom)

return StickyBallSquirt