local zh = Options.Language == "zh"

if REPENTOGON then
    TYU.GAME = Game()
    TYU.LEVEL = Game():GetLevel()
    TYU.HUD = Game():GetHUD()
    TYU.SEEDS = Game():GetSeeds()
    TYU.ITEMCONFIG = Isaac.GetItemConfig()
    TYU.ITEMPOOL = Game():GetItemPool()
    TYU.SFXMANAGER = SFXManager()
    TYU.JSON = include("json")
    TYU.AMBUSH = Ambush
    TYU.ITEMOVERLAY = ItemOverlay
    TYU.PERSISTENDGAMEDATA = Isaac.GetPersistentGameData()
    TYU.GENERICPROMPT = GenericPrompt()

    do
        TYU.GENERICPROMPT:Initialize()
        if zh then
            TYU.GENERICPROMPT:SetText("<<ty的宇宙>>", "欢迎你的到来，朋友!", "由于目前仍处于测试阶段", "祝你玩的愉快!")
        else
            TYU.GENERICPROMPT:SetText("Welcome to", "ty's Universe!", "Thanks for playing!", "Have fun!")
        end
        local isPromptShowed = false

        TYU:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
            TYU.GENERICPROMPT:Update(true)
            if isPromptShowed and not TYU.GENERICPROMPT:IsActive() then
                for _, player in pairs(TYU.Players.GetPlayers(true)) do
                    player.ControlsCooldown = 0
                end
                isPromptShowed = false
            end
        end)

        TYU:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
            if not TYU.PERSISTENDGAMEDATA:Unlocked(TYU.ModAchievementIDs.PROMPT_READ) then
                for _, player in pairs(TYU.Players.GetPlayers(true)) do
                    player:AddControlsCooldown(8192)
                end
                TYU.GENERICPROMPT:Show()
                TYU.PERSISTENDGAMEDATA:TryUnlock(TYU.ModAchievementIDs.PROMPT_READ, true)
                isPromptShowed = true
            end
        end)
    end
    
    return false
else
    TYU:AddCallback(ModCallbacks.MC_POST_RENDER, function()
        local font = (zh and TYU.Fonts.LanaPixel) or TYU.Fonts.PFTempestaSevenCondense
        local text = (zh and TYU.Name.."需要前置API REPENTOGON 来运行!") or (TYU.Name.."requires the mod API REPENTOGON to work properly!") 
        local width = font:GetStringWidthUTF8(text)
        font:DrawStringUTF8(text, (Isaac.GetScreenWidth() - width) / 2, (Isaac.GetScreenHeight() - 40) / 2, KColor(1, 0, 0, 1), width, true)
    end)

    return true
end