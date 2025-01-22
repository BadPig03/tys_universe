local function MeetsVersion(targetVersion)
    local version = {}
    local target = {}
    local function GetVersionNum(version)
        return version:gsub("a", ".1"):gsub("b", ".2"):gsub("c", ".3"):gsub("d", ".4"):gsub("e", ".5"):gsub("f", ".6"):gsub("g", ".7"):gmatch("%d+")
    end
    for num in GetVersionNum(REPENTOGON.Version) do
        table.insert(version, tonumber(num))
    end
    for num in GetVersionNum(targetVersion) do
        table.insert(target, tonumber(num))
    end
    for i = 1, math.max(#version, #target) do
        local v = version[i] or 0
        local t = target[i] or 0
        if v < t then
            return false
        elseif v > t then
            return true
        end
    end
    return true
end

local meetsVersion = MeetsVersion(TYU.REPENTOGONVERSION)

TYU:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local zh = Options.Language == "zh"
    local font = (zh and TYU.Fonts.LanaPixel) or TYU.Fonts.PFTempestaSevenCondensed
    local text = (zh and "请更新Repentogon的版本至"..TYU.REPENTOGONVERSION.."!") or ("Please update the Repentogon to version "..TYU.REPENTOGONVERSION.."!")
    local screenWidth = Isaac.GetScreenWidth()
    local screenHeight = Isaac.GetScreenHeight()
    if meetsVersion then
        font:DrawStringUTF8(TYU.VERSION, screenWidth - font:GetStringWidthUTF8(TYU.VERSION) - 1, 0, TYU.KColors.WHITE, false)
    else
        local width = font:GetStringWidthUTF8(text)
        font:DrawStringUTF8(text, (screenWidth - width) / 2, screenHeight / 2, TYU.KColors.RED, width, true)
    end
    TYU.GENERICPROMPT:Render()
end)