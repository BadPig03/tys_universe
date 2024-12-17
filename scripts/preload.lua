local Lib = TYU

do 
    Lib.GENERICPROMPT:Initialize()
    if Options.Language == "zh" then
        Lib.GENERICPROMPT:SetText("<<ty的宇宙>>", "欢迎你的到来，朋友!", "由于目前仍处于测试阶段，只重做了部分道具", "碰到BUG请反馈，也请定期查看群来获得更新", "祝你玩的愉快!")
    else
        Lib.GENERICPROMPT:SetText("Welcome to", "ty's Universe!", "Thanks for playing!", "Have fun!")
    end
end
local isPromptShowed = false

local function MeetsVersion(targetVersion)
    local version = {}
    local target = {}
    for num in REPENTOGON.Version:gsub("a", ".1"):gsub("b", ".2"):gsub("c", ".3"):gsub("d", ".4"):gsub("e", ".5"):gmatch("%d+") do
        table.insert(version, tonumber(num))
    end
    for num in targetVersion:gsub("a", ".1"):gsub("b", ".2"):gsub("c", ".3"):gsub("d", ".4"):gsub("e", ".5"):gmatch("%d+") do
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

local meetsVersion = MeetsVersion(Lib.REPTENTOGONVERSION)

local function PostRender(mod)
    local zh = Options.Language == "zh"
    local font = zh and Lib.Fonts.LanaPixel or Lib.Fonts.PFTempestaSevenCondensed
    local text = zh and "请更新Repentogon的版本至"..Lib.REPTENTOGONVERSION.."!" or "Please update the Repentogon to version "..Lib.REPTENTOGONVERSION.."!"
    local screenWidth = Isaac.GetScreenWidth()
    local screenHeight = Isaac.GetScreenHeight()
    if meetsVersion then
        font:DrawStringUTF8(Lib.VERSION, screenWidth - font:GetStringWidthUTF8(Lib.VERSION) - 1, 0, Lib.KColors.WHITE, false)
    else
        local width = font:GetStringWidthUTF8(text)
        font:DrawStringUTF8(text, (screenWidth - width) / 2, screenHeight / 2, Lib.KColors.RED, width, true)
    end
    Lib.GENERICPROMPT:Render()
end  
Lib:AddCallback(ModCallbacks.MC_POST_RENDER, PostRender)

local function PostUpdate(mod)
    Lib.GENERICPROMPT:Update(true)
    if isPromptShowed and not Lib.GENERICPROMPT:IsActive() then
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            player.ControlsCooldown = 0
        end
        isPromptShowed = false
    end
end 
Lib:AddCallback(ModCallbacks.MC_POST_UPDATE, PostUpdate)

local function PostGameStarted(mod) 
    if not Lib.PERSISTENDGAMEDATA:Unlocked(Lib.ModAchievementIDs.PROMPTREAD) then
        for _, player in pairs(Lib.Players.GetPlayers(true)) do
            player:AddControlsCooldown(8192)
        end
        Lib.GENERICPROMPT:Show()
        Lib.PERSISTENDGAMEDATA:TryUnlock(Lib.ModAchievementIDs.PROMPTREAD, true)
        isPromptShowed = true
    end
end 
Lib:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PostGameStarted)