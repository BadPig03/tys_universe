TYU = RegisterMod("ty's Universe", 1)
TYU.VERSION = "Alpha Test v5"
TYU.REPENTOGONVERSION = "1.0.12e"

if REPENTANCE_PLUS then
    local zh = Options.Language == "zh"
    local text = (zh and TYU.Name.."无法在忏悔+下运行！\n") or (TYU.Name.." can't work in Repentance Plus!\n")
    Isaac.ConsoleOutput(text)
    return
end

include("scripts/lib/fonts")

if include("scripts/lib/repentogon") then
    return
end

include("scripts/lib/constant")

include("scripts/lib/version_check")

include("scripts/lib/contents")

if EID then
    include("scripts/eid")
end

Console.PrintWarning(TYU.Name.." "..TYU.VERSION.." loaded!")