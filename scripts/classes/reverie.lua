local Reverie = TYU:RegisterNewClass()

local PrivateField = {}

do
    function PrivateField.IsReverieEnabled()
        return CuerLib and THI
    end
end

function Reverie.GetPlayerBuffLevel(player)
    if PrivateField.IsReverieEnabled() then
        return THI.Players.Seija:GetPlayerBuffLevel(player)
    end
    return 0
end

function Reverie.GetPlayerExtraBuffLevel(player)
    if PrivateField.IsReverieEnabled() then
        return THI.Players.Seija:GetPlayerExtraBuffLevel(player)
    end
    return 0
end

function Reverie.WillPlayerBuff(player)
    if PrivateField.IsReverieEnabled() then
        return THI.Players.Seija:WillPlayerBuff(player)
    end
    return false
end

function Reverie.WillPlayerNerf(player)
    if PrivateField.IsReverieEnabled() then
        return THI.Players.Seija:WillPlayerNerf(player)
    end
    return false
end

function Reverie.WillAnyPlayerBuff()
    if PrivateField.IsReverieEnabled() then
        local buff = false
        for _, player in ipairs(TYU.Players.GetPlayers(true)) do
            if THI.Players.Seija:WillPlayerBuff(player) then
                buff = true
                break
            end
        end
        return buff
    end
    return false
end

function Reverie.WillAnyPlayerNerf()
    if PrivateField.IsReverieEnabled() then
        local nerf = false
        for _, player in ipairs(TYU.Players.GetPlayers(true)) do
            if THI.Players.Seija:WillPlayerNerf(player) then
                nerf = true
                break
            end
        end
        return nerf
    end
    return false
end

return Reverie