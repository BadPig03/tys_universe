local Lib = TYU

Lib.ClassPaths = {
    Collectibles = "collectibles",
    Enchantments = "enchantments",
    Entities = "entities",
    Foods = "foods",
    Levels = "levels",
    ModComponents = "mod_components",
    Players = "players",
    Rewind = "rewind",
    SaveAndLoad = "save_and_load",
    Stat = "stat",
    Table = "table",
    Utils = "utils"
}

Lib.Loaded = {}
function Lib:Require(path)
    if not Lib.Loaded[path] then
        Lib.Loaded[path] = include(path)
    end
    return Lib.Loaded[path]
end

Lib:Require("scripts/classes")
Lib:Require("scripts/data")
for key, path in pairs(Lib.ClassPaths) do
    local class = Lib:Require("scripts/class/"..path)
    Lib[key] = class
    class:Register()
end

function Lib:NewModItem(name, dataName) 
    return Lib.ModComponents.ModItem:New(name, dataName)
end
Lib.ModItems = {
    AbsenceNote = Lib:Require("scripts/items/absence_note"),
    Absolution = Lib:Require("scripts/items/absolution"),
    Anorexia = Lib:Require("scripts/items/anorexia"),
    AtonementVoucher = Lib:Require("scripts/items/atonement_voucher"),
    BeggarMask = Lib:Require("scripts/items/beggar_mask"),
    BlazeFly = Lib:Require("scripts/items/blaze_fly"),
    BlessedDestiny = Lib:Require("scripts/items/blessed_destiny"),
    BloodSacrifice = Lib:Require("scripts/items/blood_sacrifice"),
    BloodSample = Lib:Require("scripts/items/blood_sample"),
    BloodyDice = Lib:Require("scripts/items/bloody_dice"),
    BobsStomach = Lib:Require("scripts/items/bobs_stomach"),
    BoneInFishSteak = Lib:Require("scripts/items/bone_in_fish_steak"),
    ChefHat = Lib:Require("scripts/items/chef_hat"),
    ChocolatePancake = Lib:Require("scripts/items/chocolate_pancake"),
    Collapse = Lib:Require("scripts/items/collapse"),
    Conjunctivitis = Lib:Require("scripts/items/conjunctivitis"),
    ConservativeTreatment = Lib:Require("scripts/items/conservative_treatment"),
    Cornucopia = Lib:Require("scripts/items/cornucopia"),
    CrownOfKings = Lib:Require("scripts/items/crown_of_kings"),
    CursedDice = Lib:Require("scripts/items/cursed_dice"),
    CursedTreasure = Lib:Require("scripts/items/cursed_treasure"),
    EffervescentTablet = Lib:Require("scripts/items/effervescent_tablet"),
    EnchantedBook = Lib:Require("scripts/items/enchanted_book"),
    ExpiredGlue = Lib:Require("scripts/items/expired_glue"),
    ExplosionMaster = Lib:Require("scripts/items/explosion_master"),
    FallenSky = Lib:Require("scripts/items/fallen_sky"),
    Guilt = Lib:Require("scripts/items/guilt"),
    GuppysFood = Lib:Require("scripts/items/guppys_food"),
    HadesBlade = Lib:Require("scripts/items/hades_blade"),
    HephaestusSoul = Lib:Require("scripts/items/hephaestus_soul"),
    Landmine = Lib:Require("scripts/items/landmine"),
    LaserBlaster = Lib:Require("scripts/items/laser_blaster"),
    Magnifier = Lib:Require("scripts/items/magnifier"),
    MarriageCertificate = Lib:Require("scripts/items/marriage_certificate"),
    MirroringShard = Lib:Require("scripts/items/mirroring_shard"),
    Mirroring = Lib:Require("scripts/items/mirroring"),
    NoticeOfCriticalCondition = Lib:Require("scripts/items/notice_of_critical_condition"),
    OceanusSoul = Lib:Require("scripts/items/oceanus_soul"),
    Order = Lib:Require("scripts/items/order"),
    OverloadBattery = Lib:Require("scripts/items/overload_battery"),
    PeeledBanana = Lib:Require("scripts/items/peeled_banana"),
    PhilosophersStaff = Lib:Require("scripts/items/philosophers_staff"),
    PlanetariumTelescope = Lib:Require("scripts/items/planetarium_telescope"),
    ReconVision = Lib:Require("scripts/items/recon_vision"),
    Rewind = Lib:Require("scripts/items/rewind"),
    Ruby = Lib:Require("scripts/items/ruby"),
    Scapegoat = Lib:Require("scripts/items/scapegoat"),
    SinisterPact = Lib:Require("scripts/items/sinister_pact"),
    StickyBall = Lib:Require("scripts/items/sticky_ball"),
    StrangeSyringe = Lib:Require("scripts/items/strange_syringe"),
    SuspiciousStew = Lib:Require("scripts/items/suspicious_stew"),
    TheGospelOfJohn = Lib:Require("scripts/items/the_gospel_of_john"),
    ToolBox = Lib:Require("scripts/items/tool_box"),
    TwilightFox = Lib:Require("scripts/items/twilight_fox"),
    WakeUp = Lib:Require("scripts/items/wake_up")
}
Lib.ModItemTexts = {
    [Lib.ModItemIDs.ABSENCENOTE] = {"请假条", "遇到困难睡大觉"},
    [Lib.ModItemIDs.ABSOLUTION] = {"赦罪", "这不是你的错"},
    [Lib.ModItemIDs.ANOREXIA] = {"厌食症", "我吃不下了"},
    [Lib.ModItemIDs.ATONEMENTVOUCHER] = {"赎罪券", "承认我的罪过"},
    [Lib.ModItemIDs.BEGGARMASK] = {"丐帮面具", "忠诚"},
    [Lib.ModItemIDs.BLAZEFLY] = {"烈焰苍蝇", "太燃了"},
    [Lib.ModItemIDs.BLESSEDDESTINY] = {"神圣命运", "命中注定"},
    [Lib.ModItemIDs.BLOODSACRIFICE] = {"鲜血献祭", "以血肉铸就"},
    [Lib.ModItemIDs.BLOODSAMPLE] = {"血液样本", "血量提升"},
    [Lib.ModItemIDs.BLOODYDICE] = {"血之骰", "重置你的交易"},
    [Lib.ModItemIDs.BOBSSTOMACH] = {"鲍勃的胃", "快要溢出了"},
    [Lib.ModItemIDs.BONEINFISHSTEAK] = {"带骨鱼排", "小心地吃"},
    [Lib.ModItemIDs.CHEFHAT] = {"厨师帽", "烹饪时间到"},
    [Lib.ModItemIDs.CHOCOLATEPANCAKE] = {"巧克力煎饼", "恶魔的最爱"},
    [Lib.ModItemIDs.COLLAPSE] = {"坍缩", "超引力"},
    [Lib.ModItemIDs.CONJUNCTIVITIS] = {"结膜炎", "红眼睛"},
    [Lib.ModItemIDs.CONSERVATIVETREATMENT] = {"保守疗法", "不会再恶化了"},
    [Lib.ModItemIDs.CORNUCOPIA] = {"丰饶羊角", "变废为宝"},
    [Lib.ModItemIDs.CROWNOFKINGS] = {"主宰之冠", "权力易逝"},
    [Lib.ModItemIDs.CURSEDDICE] = {"被诅咒的骰子", "遮蔽你的命运"},
    [Lib.ModItemIDs.CURSEDTREASURE] = {"被诅咒的宝藏", "更多的商品...但代价是什么?"},
    [Lib.ModItemIDs.EFFERVESCENTTABLET] = {"泡腾片", "好多泡泡"},
    [Lib.ModItemIDs.ENCHANTEDBOOK] = {"附魔书", "附加能力"},
    [Lib.ModItemIDs.EXPIREDGLUE] = {"过期胶水", "好臭"},
    [Lib.ModItemIDs.EXPLOSIONMASTER] = {"爆炸大师", "艺术就是爆炸"},
    [Lib.ModItemIDs.FALLENSKY] = {"天坠", "直坠深渊"},
    [Lib.ModItemIDs.GUILT] = {"罪孽", "这就是你的错"},
    [Lib.ModItemIDs.GUPPYSFOOD] = {"嗝屁猫的罐头", "还没过期"},
    [Lib.ModItemIDs.HADESBLADE] = {"冥府之刃", "心怀鬼胎"},
    [Lib.ModItemIDs.HEPHAESTUSSOUL] = {"赫菲斯托斯之魂", "火焰化身"},
    [Lib.ModItemIDs.LANDMINE] = {"地雷", "一触即爆"},
    [Lib.ModItemIDs.LASERBLASTER] = {"激光发射器", "未来科技"},
    [Lib.ModItemIDs.MAGNIFIER] = {"放大镜", "放大你的敌人"},
    [Lib.ModItemIDs.MARRIAGECERTIFICATE] = {"结婚证明", "见证坚定不移的爱情"},
    [Lib.ModItemIDs.MIRRORINGSHARD] = {"镜像碎块", "另一个我"},
    [Lib.ModItemIDs.MIRRORING] = {"镜像", "另一个我"},
    [Lib.ModItemIDs.NOTICEOFCRITICALCONDITION] = {"病危通知书", "生死未卜"},
    [Lib.ModItemIDs.OCEANUSSOUL] = {"俄刻阿诺斯之魂", "海洋化身"},
    [Lib.ModItemIDs.ORDER] = {"秩序", "???"},
    [Lib.ModItemIDs.OVERLOADBATTERY] = {"过载电池", "<3=充能"},
    [Lib.ModItemIDs.PEELEDBANANA] = {"剥皮香蕉", "甜甜的感觉"},
    [Lib.ModItemIDs.PHILOSOPHERSSTAFF] = {"贤者权杖", "别碰它!"},
    [Lib.ModItemIDs.PLANETARIUMTELESCOPE] = {"星象望远镜", "远距离观察"},
    [Lib.ModItemIDs.RECONVISION] = {"洞察视界", "看穿一切"},
    [Lib.ModItemIDs.REWIND] = {"倒带", "似曾相识"},
    [Lib.ModItemIDs.RUBY] = {"红宝石", "财富的象征"},
    [Lib.ModItemIDs.SCAPEGOAT] = {"替罪羊", "承担所有的罪恶和污浊"},
    [Lib.ModItemIDs.SINISTERPACT] = {"邪恶契约", "他渴望你的誓言"},
    [Lib.ModItemIDs.STICKYBALL] = {"粘性球", "好粘"},
    [Lib.ModItemIDs.STRANGESYRINGE] = {"奇怪的针筒", "嗑药?"},
    [Lib.ModItemIDs.SUSPICIOUSSTEW] = {"迷之炖菜", "好奇怪"},
    [Lib.ModItemIDs.THEGOSPELOFJOHN] = {"约翰福音", "憧憬未来"},
    [Lib.ModItemIDs.TOOLBOX] = {"工具箱", "里面有什么?"},
    [Lib.ModItemIDs.TWILIGHTFOX] = {"暮光狐", "静寂的保护者"},
    [Lib.ModItemIDs.WAKEUP] = {"唤醒", "这是一场梦吗?"}
}

function Lib:NewModCard(name, dataName) 
    return Lib.ModComponents.ModCard:New(name, dataName)
end
Lib.ModCards = {
    EnchantedCard = Lib:Require("scripts/cards/enchanted_card"),
    GlowingHourglassShard = Lib:Require("scripts/cards/glowing_hourglass_shard")
}
Lib.ModCardTexts = {
    [Lib.ModCardIDs.ENCHANTEDCARD] = {"附魔卡", "随机附魔"},
    [Lib.ModCardIDs.GLOWINGHOURGLASSSHARD] = {"发光沙漏碎片", "逆转时间"}
}

function Lib:NewModEntity(name, dataName) 
    return Lib.ModComponents.ModEntity:New(name, dataName)
end
Lib.ModEntities = {
    BlazeFly = Lib:Require("scripts/entities/blaze_fly"),
    BobsStomachChargeBar = Lib:Require("scripts/entities/bobs_stomach_chargebar"),
    ChefBeggar = Lib:Require("scripts/entities/chef_beggar"),
    CollapseEffect = Lib:Require("scripts/entities/collapse_effect"),
    CrownOfKingsEffect = Lib:Require("scripts/entities/crown_of_kings_effect"),
    CursedPenny = Lib:Require("scripts/entities/cursed_penny"),
    FallenSkySword = Lib:Require("scripts/entities/fallen_sky_sword"),
    FoodItem = Lib:Require("scripts/entities/food_item"),
    HealingBeggar = Lib:Require("scripts/entities/healing_beggar"),
    HephaestusSoulChargeBar = Lib:Require("scripts/entities/hephaestus_soul_chargebar"),
    Landmine = Lib:Require("scripts/entities/landmine"),
    LaserOrb = Lib:Require("scripts/entities/laser_orb"),
    Magnifier = Lib:Require("scripts/entities/magnifier"),
    MeatEffigy = Lib:Require("scripts/entities/meat_effigy"),
    StickyBallSquirt = Lib:Require("scripts/entities/sticky_ball_squirt"),
    StickyBallTear = Lib:Require("scripts/entities/sticky_ball_tear"),
    ToolBox = Lib:Require("scripts/entities/tool_box"),
    TwilightFox = Lib:Require("scripts/entities/twilight_fox"),
    TwilightFoxHalo = Lib:Require("scripts/entities/twilight_fox_halo"),
    OceanusSoulChargeBar = Lib:Require("scripts/entities/oceanus_soul_chargebar")
}

function Lib:NewModEnchantment(name, dataName) 
    return Lib.ModComponents.ModEnchantment:New(name, dataName)
end
Lib.ModEnchantments = {
    AquaLord = Lib:Require("scripts/enchantments/aqua_lord"),
    BaneOfArthropods = Lib:Require("scripts/enchantments/bane_of_arthropods"),
    BlastProtection = Lib:Require("scripts/enchantments/blast_protection"),
    ChampionKiller = Lib:Require("scripts/enchantments/champion_killer"),
    CurseOfBinding = Lib:Require("scripts/enchantments/curse_of_binding"),
    CurseOfSalvaging = Lib:Require("scripts/enchantments/curse_of_salvaging"),
    CurseOfVanishing = Lib:Require("scripts/enchantments/curse_of_vanishing"),
    FireAspect = Lib:Require("scripts/enchantments/fire_aspect"),
    FireProtection = Lib:Require("scripts/enchantments/fire_protection"),
    Fortune = Lib:Require("scripts/enchantments/fortune"),
    Knockback = Lib:Require("scripts/enchantments/knockback"),
    Looting = Lib:Require("scripts/enchantments/looting"),
    ProjectileProtection = Lib:Require("scripts/enchantments/projectile_protection"),
    Smite = Lib:Require("scripts/enchantments/smite"),
    SpikeProtection = Lib:Require("scripts/enchantments/spike_protection"),
    SuperSonic = Lib:Require("scripts/enchantments/super_sonic"),
    Thorns = Lib:Require("scripts/enchantments/thorns")
}
Lib.ModEnchantmentInfos = {
    [Lib.ModEnchantmentIDs.AQUALORD] = {"水域领主", "Aqua Lord", 6, 1, false},
    [Lib.ModEnchantmentIDs.BANEOFARTHROPODS] = {"节肢杀手", "Bane Of Arthropods", 10, 5, false},
    [Lib.ModEnchantmentIDs.BLASTPROTECTION] = {"爆炸保护", "Blast Protection", 8, 4, false},
    [Lib.ModEnchantmentIDs.CHAMPIONKILLER] = {"精英杀手", "Champion Killer", 10, 5, false},
    [Lib.ModEnchantmentIDs.CURSEOFBINDING] = {"绑定诅咒", "Curse Of Binding", 1, 1, true},
    [Lib.ModEnchantmentIDs.CURSEOFSALVAGING] = {"拾荒诅咒", "Curse Of Salvaging", 1, 1, true},
    [Lib.ModEnchantmentIDs.CURSEOFVANISHING] = {"消失诅咒", "Curse Of Vanishing", 1, 1, true},
    [Lib.ModEnchantmentIDs.FIREASPECT] = {"火焰附加", "Fire Aspect", 6, 2, false},
    [Lib.ModEnchantmentIDs.FIREPROTECTION] = {"火焰保护", "Fire Protection", 8, 4, false},
    [Lib.ModEnchantmentIDs.FORTUNE] = {"时运", "Fortune", 6, 3, false},
    [Lib.ModEnchantmentIDs.KNOCKBACK] = {"击退", "Knockback", 6, 2, false},
    [Lib.ModEnchantmentIDs.LOOTING] = {"抢夺", "Looting", 6, 3, false},
    [Lib.ModEnchantmentIDs.PROJECTILEPROTECTION] = {"弹射物保护", "Projectile Protection", 8, 4, false},
    [Lib.ModEnchantmentIDs.SMITE] = {"亡灵杀手", "Smite", 10, 5, false},
    [Lib.ModEnchantmentIDs.SPIKEPROTECTION] = {"尖刺保护", "Spike Protection", 8, 4, false},
    [Lib.ModEnchantmentIDs.SUPERSONIC] = {"超音速", "Super Sonic", 6, 3, false},
    [Lib.ModEnchantmentIDs.THORNS] = {"荆棘", "Thorns", 6, 3, false}
}

function Lib:NewModPill(name, dataName) 
    return Lib.ModComponents.ModPill:New(name, dataName)
end
Lib.ModPills = {
    BaitAndSwitch = Lib:Require("scripts/pills/bait_and_switch")
}
Lib.ModPillTexts = {
    [Lib.ModPillEffectIDs.BAITANDSWITCH] = "偷天换日"
}

function Lib:NewModPlayer(name, tainted, dataName) 
    return Lib.ModComponents.ModPlayer:New(name, tainted, dataName)
end
Lib.ModPlayers = {
    Warfarin = Lib:Require("scripts/players/warfarin")
}

function Lib:NewModTrinket(name, dataName) 
    return Lib.ModComponents.ModTrinket:New(name, dataName)
end
Lib.ModTrinkets = {
    BethsSalvation = Lib:Require("scripts/trinkets/beths_salvation"),
    BrokenVision = Lib:Require("scripts/trinkets/broken_vision"),
    BrokenGlassEye = Lib:Require("scripts/trinkets/broken_glass_eye"),
    KeepersCore = Lib:Require("scripts/trinkets/keepers_core"),
    LostBottleCap = Lib:Require("scripts/trinkets/lost_bottle_cap"),
    StoneCarvingKnife = Lib:Require("scripts/trinkets/stone_carving_knife")
}
Lib.ModTrinketTexts = {
    [Lib.ModTrinketIDs.BETHSSALVATION] = {"伯大尼的救赎", "解脱于罪恶"},
    [Lib.ModTrinketIDs.BROKENVISION] = {"视力受损", "双倍道具?"},
    [Lib.ModTrinketIDs.BROKENGLASSEYE] = {"损坏的玻璃眼", "它曾经是完整的"},
    [Lib.ModTrinketIDs.KEEPERSCORE] = {"店主的核心", "积少成多"},
    [Lib.ModTrinketIDs.LOSTBOTTLECAP] = {"丢失的瓶盖", "再来一瓶!"},
    [Lib.ModTrinketIDs.STONECARVINGKNIFE] = {"石刻刀", "石雕"}
}

do
    if Options.Language ~= "zh" then
        return
    end
    for i = 733, Lib.ITEMCONFIG:GetCollectibles().Size - 1 do
        if ItemConfig.Config.IsValidCollectible(i) and Lib.ModItemTexts[i] then
            local collectible = Lib.ITEMCONFIG:GetCollectible(i)
            collectible.Name = Lib.ModItemTexts[i][1]
            collectible.Description = Lib.ModItemTexts[i][2]
            Lib.ModItemIDs[i] = Isaac.GetItemIdByName(Lib.ModItemTexts[i][1])
        end
    end
    for i = 190, Lib.ITEMCONFIG:GetTrinkets().Size - 1 do
        local trinket = Lib.ITEMCONFIG:GetTrinket(i)
        if trinket:IsTrinket() and Lib.ModTrinketTexts[i] then
            trinket.Name = Lib.ModTrinketTexts[i][1]
            trinket.Description = Lib.ModTrinketTexts[i][2]
            Lib.ModTrinketIDs[i] = Isaac.GetTrinketIdByName(Lib.ModTrinketTexts[i][1])
        end
    end
    for i = 98, Lib.ITEMCONFIG:GetCards().Size - 1 do
        local card = Lib.ITEMCONFIG:GetCard(i)
        if card:IsAvailable() and Lib.ModCardTexts[i] then
            card.Name = Lib.ModCardTexts[i][1]
            card.Description = Lib.ModCardTexts[i][2]
        end
    end
    for i = 50, Lib.ITEMCONFIG:GetPillEffects().Size - 1 do
        local pill = Lib.ITEMCONFIG:GetPillEffect(i)
        if pill:IsAvailable() and Lib.ModPillTexts[i] then
            pill.Name = Lib.ModPillTexts[i]
        end
    end
end

function Lib:PreItemTextDisplay(title, subTitle, isSticky, isCurseDisplay)
    if Options.Language ~= "zh" or isCurseDisplay or isSticky then
        return
    end
    if subTitle == EntityConfig.GetPlayer(Lib.ModPlayerIDs.WARFARIN):GetBirthrightDescription() then
        Lib.HUD:ShowItemText(title, "更好的转换")
        return false
    end
end
Lib:AddCallback(ModCallbacks.MC_PRE_ITEM_TEXT_DISPLAY, Lib.PreItemTextDisplay)

function Lib:PostPlayerUpdate(player)
    local oldCount = Lib:GetPlayerLibData(player, "SmeltedTrinketCount") or 0
    local newCount = 0
    for _, values in pairs(player:GetSmeltedTrinkets()) do
        newCount = newCount + values.trinketAmount + values.goldenTrinketAmount
    end
    if newCount ~= oldCount then
        Lib:SetPlayerLibData(player, newCount, "SmeltedTrinketCount")
        Isaac.RunCallback(Lib.Callbacks.TYU_POST_TRINKET_SMELTED, player, newCount - oldCount)
    end
end
Lib:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Lib.PostPlayerUpdate, 0)

function Lib:UseItem(itemID, rng, player, useFlags, activeSlot, varData)
    for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
        if ent:HasEntityFlags(Lib.ModEntityFlags.FLAG_NO_PAUSE) then
            ent:SetPauseTime(0)
        end
    end
end
Lib:AddCallback(ModCallbacks.MC_USE_ITEM, Lib.UseItem, CollectibleType.COLLECTIBLE_PAUSE)