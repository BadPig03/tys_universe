TYU = RegisterMod("ty's Universe", 1)

if REPENTANCE_PLUS then
    Isaac.ConsoleOutput(TYU.Name.."无法在忏悔+下运行！\n")
    return
end

TYU.VERSION = "PreDev Test v29"
TYU.REPTENTOGONVERSION = "1.0.12e"

TYU.GAME = Game()
TYU.LEVEL = Game():GetLevel()
TYU.HUD = Game():GetHUD()
TYU.SEEDS = Game():GetSeeds()
TYU.ITEMCONFIG = Isaac.GetItemConfig()
TYU.ITEMPOOL = Game():GetItemPool()
TYU.SFXMANAGER = SFXManager()
TYU.JSON = include("json")

local teamMeatFont10 = Font()
teamMeatFont10:Load("font/teammeatfont10.fnt")
local teamMeatFontExtended10 = Font()
teamMeatFontExtended10:Load("font/teammeatfontextended10.fnt")
local lanaPixel = Font()
lanaPixel:Load("font/cjk/lanapixel.fnt")
local terminus8 = Font()
terminus8:Load("font/terminus8.fnt")
local pfTempestaSevenCondensed = Font()
pfTempestaSevenCondensed:Load("font/pftempestasevencondensed.fnt")
local mplus12b = Font()
mplus12b:Load("font/mplus_12b.fnt")
TYU.Fonts = {
    TeamMeatFont10 = teamMeatFont10,
    TeamMeatFontExtended10 = teamMeatFontExtended10,
    LanaPixel = lanaPixel,
    Terminus8 = terminus8,
    PFTempestaSevenCondensed = pfTempestaSevenCondensed,
    MPlus12b = mplus12b
}

if not REPENTOGON then
    local zhText = {
        "ty's Universe需要前置API\"Repentogon\"来运行!",
        "请参考群公告的教程下载并开启它!"
    }
    local enText = {
        "ty's Universe requires the mod api \"Repentogon\" to work properly!",
        "Please refer to the tutorial on how to download and install it!"
    }
    local function PostRender(mod)
        local zh = Options.Language == "zh"
        local font = (zh and TYU.Fonts.LanaPixel) or TYU.Fonts.PFTempestaSevenCondense
        local texts = (zh and zhText) or enText
        local screenWidth = Isaac.GetScreenWidth()
        local screenHeight = Isaac.GetScreenHeight()
        for index, text in ipairs(texts) do
            local width = font:GetStringWidthUTF8(text)
            font:DrawStringUTF8(text, (screenWidth - width) / 2, (screenHeight + (index - 2) * 40) / 2, TYU.KColors.RED, width, true)
        end
    end    
	TYU:AddCallback(ModCallbacks.MC_POST_RENDER, PostRender)
    return
end

TYU.AMBUSH = Ambush
TYU.ITEMOVERLAY = ItemOverlay
TYU.PERSISTENDGAMEDATA = Isaac.GetPersistentGameData()
TYU.GENERICPROMPT = GenericPrompt()

include("scripts/constant")
include("scripts/preload")
include("scripts/contents")
if EID then
    include("scripts/eid")
end

Console.PrintWarning(TYU.Name.." "..TYU.VERSION.." loaded.")

