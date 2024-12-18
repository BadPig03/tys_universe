do
    TYU.Loaded = {}
    TYU.ClassesPaths = {
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

    function TYU:Require(path)
        if not TYU.Loaded[path] then
            TYU.Loaded[path] = include(path)
        end
        return TYU.Loaded[path]
    end

    TYU:Require("scripts/classes")
    TYU:Require("scripts/data")

    for key, path in pairs(TYU.ClassesPaths) do
        local class = TYU:Require("scripts/classes/"..path)
        TYU[key] = class
        class:Register()
    end
end

do
    function TYU:NewModItem(name, dataName) 
        return TYU.ModComponents.ModItem:New(name, dataName)
    end
    TYU.ModItems = {
        AbsenceNote = TYU:Require("scripts/items/absence_note"),
        Absolution = TYU:Require("scripts/items/absolution"),
        Anorexia = TYU:Require("scripts/items/anorexia"),
        AtonementVoucher = TYU:Require("scripts/items/atonement_voucher"),
        BeggarMask = TYU:Require("scripts/items/beggar_mask"),
        BlazeFly = TYU:Require("scripts/items/blaze_fly"),
        BlessedDestiny = TYU:Require("scripts/items/blessed_destiny"),
        BloodSacrifice = TYU:Require("scripts/items/blood_sacrifice"),
        BloodSample = TYU:Require("scripts/items/blood_sample"),
        BloodyDice = TYU:Require("scripts/items/bloody_dice"),
        BobsStomach = TYU:Require("scripts/items/bobs_stomach"),
        BoneInFishSteak = TYU:Require("scripts/items/bone_in_fish_steak"),
        ChefHat = TYU:Require("scripts/items/chef_hat"),
        ChocolatePancake = TYU:Require("scripts/items/chocolate_pancake"),
        Collapse = TYU:Require("scripts/items/collapse"),
        Conjunctivitis = TYU:Require("scripts/items/conjunctivitis"),
        ConservativeTreatment = TYU:Require("scripts/items/conservative_treatment"),
        Cornucopia = TYU:Require("scripts/items/cornucopia"),
        CrownOfKings = TYU:Require("scripts/items/crown_of_kings"),
        CursedDice = TYU:Require("scripts/items/cursed_dice"),
        CursedTreasure = TYU:Require("scripts/items/cursed_treasure"),
        EffervescentTablet = TYU:Require("scripts/items/effervescent_tablet"),
        EnchantedBook = TYU:Require("scripts/items/enchanted_book"),
        ExpiredGlue = TYU:Require("scripts/items/expired_glue"),
        ExplosionMaster = TYU:Require("scripts/items/explosion_master"),
        FallenSky = TYU:Require("scripts/items/fallen_sky"),
        Guilt = TYU:Require("scripts/items/guilt"),
        GuppysFood = TYU:Require("scripts/items/guppys_food"),
        HadesBlade = TYU:Require("scripts/items/hades_blade"),
        HephaestusSoul = TYU:Require("scripts/items/hephaestus_soul"),
        Landmine = TYU:Require("scripts/items/landmine"),
        LaserBlaster = TYU:Require("scripts/items/laser_blaster"),
        Magnifier = TYU:Require("scripts/items/magnifier"),
        MarriageCertificate = TYU:Require("scripts/items/marriage_certificate"),
        MirroringShard = TYU:Require("scripts/items/mirroring_shard"),
        Mirroring = TYU:Require("scripts/items/mirroring"),
        NoticeOfCriticalCondition = TYU:Require("scripts/items/notice_of_critical_condition"),
        OceanusSoul = TYU:Require("scripts/items/oceanus_soul"),
        Order = TYU:Require("scripts/items/order"),
        OverloadBattery = TYU:Require("scripts/items/overload_battery"),
        PeeledBanana = TYU:Require("scripts/items/peeled_banana"),
        PhilosophersStaff = TYU:Require("scripts/items/philosophers_staff"),
        PlanetariumTelescope = TYU:Require("scripts/items/planetarium_telescope"),
        ReconVision = TYU:Require("scripts/items/recon_vision"),
        Rewind = TYU:Require("scripts/items/rewind"),
        Ruby = TYU:Require("scripts/items/ruby"),
        Scapegoat = TYU:Require("scripts/items/scapegoat"),
        SinisterPact = TYU:Require("scripts/items/sinister_pact"),
        StickyBall = TYU:Require("scripts/items/sticky_ball"),
        StrangeSyringe = TYU:Require("scripts/items/strange_syringe"),
        SuspiciousStew = TYU:Require("scripts/items/suspicious_stew"),
        TheGospelOfJohn = TYU:Require("scripts/items/the_gospel_of_john"),
        ToolBox = TYU:Require("scripts/items/tool_box"),
        TwilightFox = TYU:Require("scripts/items/twilight_fox"),
        WakeUp = TYU:Require("scripts/items/wake_up")
    }
    TYU.ModItemTexts = {
        [TYU.ModItemIDs.ABSENCENOTE] = {"请假条", "遇到困难睡大觉"},
        [TYU.ModItemIDs.ABSOLUTION] = {"赦罪", "这不是你的错"},
        [TYU.ModItemIDs.ANOREXIA] = {"厌食症", "我吃不下了"},
        [TYU.ModItemIDs.ATONEMENTVOUCHER] = {"赎罪券", "承认我的罪过"},
        [TYU.ModItemIDs.BEGGARMASK] = {"丐帮面具", "忠诚"},
        [TYU.ModItemIDs.BLAZEFLY] = {"烈焰苍蝇", "太燃了"},
        [TYU.ModItemIDs.BLESSEDDESTINY] = {"神圣命运", "命中注定"},
        [TYU.ModItemIDs.BLOODSACRIFICE] = {"鲜血献祭", "以血肉铸就"},
        [TYU.ModItemIDs.BLOODSAMPLE] = {"血液样本", "血量提升"},
        [TYU.ModItemIDs.BLOODYDICE] = {"血之骰", "重置你的交易"},
        [TYU.ModItemIDs.BOBSSTOMACH] = {"鲍勃的胃", "快要溢出了"},
        [TYU.ModItemIDs.BONEINFISHSTEAK] = {"带骨鱼排", "小心地吃"},
        [TYU.ModItemIDs.CHEFHAT] = {"厨师帽", "烹饪时间到"},
        [TYU.ModItemIDs.CHOCOLATEPANCAKE] = {"巧克力煎饼", "恶魔的最爱"},
        [TYU.ModItemIDs.COLLAPSE] = {"坍缩", "超引力"},
        [TYU.ModItemIDs.CONJUNCTIVITIS] = {"结膜炎", "红眼睛"},
        [TYU.ModItemIDs.CONSERVATIVETREATMENT] = {"保守疗法", "不会再恶化了"},
        [TYU.ModItemIDs.CORNUCOPIA] = {"丰饶羊角", "变废为宝"},
        [TYU.ModItemIDs.CROWNOFKINGS] = {"主宰之冠", "权力易逝"},
        [TYU.ModItemIDs.CURSEDDICE] = {"被诅咒的骰子", "遮蔽你的命运"},
        [TYU.ModItemIDs.CURSEDTREASURE] = {"被诅咒的宝藏", "更多的商品...但代价是什么?"},
        [TYU.ModItemIDs.EFFERVESCENTTABLET] = {"泡腾片", "好多泡泡"},
        [TYU.ModItemIDs.ENCHANTEDBOOK] = {"附魔书", "附加能力"},
        [TYU.ModItemIDs.EXPIREDGLUE] = {"过期胶水", "好臭"},
        [TYU.ModItemIDs.EXPLOSIONMASTER] = {"爆炸大师", "艺术就是爆炸"},
        [TYU.ModItemIDs.FALLENSKY] = {"天坠", "直坠深渊"},
        [TYU.ModItemIDs.GUILT] = {"罪孽", "这就是你的错"},
        [TYU.ModItemIDs.GUPPYSFOOD] = {"嗝屁猫的罐头", "还没过期"},
        [TYU.ModItemIDs.HADESBLADE] = {"冥府之刃", "心怀鬼胎"},
        [TYU.ModItemIDs.HEPHAESTUSSOUL] = {"赫菲斯托斯之魂", "火焰化身"},
        [TYU.ModItemIDs.LANDMINE] = {"地雷", "一触即爆"},
        [TYU.ModItemIDs.LASERBLASTER] = {"激光发射器", "未来科技"},
        [TYU.ModItemIDs.MAGNIFIER] = {"放大镜", "放大你的敌人"},
        [TYU.ModItemIDs.MARRIAGECERTIFICATE] = {"结婚证明", "见证坚定不移的爱情"},
        [TYU.ModItemIDs.MIRRORINGSHARD] = {"镜像碎块", "另一个我"},
        [TYU.ModItemIDs.MIRRORING] = {"镜像", "另一个我"},
        [TYU.ModItemIDs.NOTICEOFCRITICALCONDITION] = {"病危通知书", "生死未卜"},
        [TYU.ModItemIDs.OCEANUSSOUL] = {"俄刻阿诺斯之魂", "海洋化身"},
        [TYU.ModItemIDs.ORDER] = {"秩序", "???"},
        [TYU.ModItemIDs.OVERLOADBATTERY] = {"过载电池", "<3=充能"},
        [TYU.ModItemIDs.PEELEDBANANA] = {"剥皮香蕉", "甜甜的感觉"},
        [TYU.ModItemIDs.PHILOSOPHERSSTAFF] = {"贤者权杖", "别碰它!"},
        [TYU.ModItemIDs.PLANETARIUMTELESCOPE] = {"星象望远镜", "远距离观察"},
        [TYU.ModItemIDs.RECONVISION] = {"洞察视界", "看穿一切"},
        [TYU.ModItemIDs.REWIND] = {"倒带", "似曾相识"},
        [TYU.ModItemIDs.RUBY] = {"红宝石", "财富的象征"},
        [TYU.ModItemIDs.SCAPEGOAT] = {"替罪羊", "承担所有的罪恶和污浊"},
        [TYU.ModItemIDs.SINISTERPACT] = {"邪恶契约", "他渴望你的誓言"},
        [TYU.ModItemIDs.STICKYBALL] = {"粘性球", "好粘"},
        [TYU.ModItemIDs.STRANGESYRINGE] = {"奇怪的针筒", "嗑药?"},
        [TYU.ModItemIDs.SUSPICIOUSSTEW] = {"迷之炖菜", "好奇怪"},
        [TYU.ModItemIDs.THEGOSPELOFJOHN] = {"约翰福音", "憧憬未来"},
        [TYU.ModItemIDs.TOOLBOX] = {"工具箱", "里面有什么?"},
        [TYU.ModItemIDs.TWILIGHTFOX] = {"暮光狐", "静寂的保护者"},
        [TYU.ModItemIDs.WAKEUP] = {"唤醒", "这是一场梦吗?"}
    }
end

do
    function TYU:NewModCard(name, dataName) 
        return TYU.ModComponents.ModCard:New(name, dataName)
    end
    TYU.ModCards = {
        EnchantedCard = TYU:Require("scripts/cards/enchanted_card"),
        GlowingHourglassShard = TYU:Require("scripts/cards/glowing_hourglass_shard")
    }
    TYU.ModCardTexts = {
        [TYU.ModCardIDs.ENCHANTEDCARD] = {"附魔卡", "随机附魔"},
        [TYU.ModCardIDs.GLOWINGHOURGLASSSHARD] = {"发光沙漏碎片", "逆转时间"}
    }
end

do
    function TYU:NewModEntity(name, dataName) 
        return TYU.ModComponents.ModEntity:New(name, dataName)
    end
    TYU.ModEntities = {
        BlazeFly = TYU:Require("scripts/entities/blaze_fly"),
        BobsStomachChargeBar = TYU:Require("scripts/entities/bobs_stomach_chargebar"),
        ChefBeggar = TYU:Require("scripts/entities/chef_beggar"),
        CollapseEffect = TYU:Require("scripts/entities/collapse_effect"),
        CrownOfKingsEffect = TYU:Require("scripts/entities/crown_of_kings_effect"),
        CursedPenny = TYU:Require("scripts/entities/cursed_penny"),
        FallenSkySword = TYU:Require("scripts/entities/fallen_sky_sword"),
        FoodItem = TYU:Require("scripts/entities/food_item"),
        HealingBeggar = TYU:Require("scripts/entities/healing_beggar"),
        HephaestusSoulChargeBar = TYU:Require("scripts/entities/hephaestus_soul_chargebar"),
        Landmine = TYU:Require("scripts/entities/landmine"),
        LaserOrb = TYU:Require("scripts/entities/laser_orb"),
        Magnifier = TYU:Require("scripts/entities/magnifier"),
        MeatEffigy = TYU:Require("scripts/entities/meat_effigy"),
        StickyBallSquirt = TYU:Require("scripts/entities/sticky_ball_squirt"),
        StickyBallTear = TYU:Require("scripts/entities/sticky_ball_tear"),
        ToolBox = TYU:Require("scripts/entities/tool_box"),
        TwilightFox = TYU:Require("scripts/entities/twilight_fox"),
        TwilightFoxHalo = TYU:Require("scripts/entities/twilight_fox_halo"),
        OceanusSoulChargeBar = TYU:Require("scripts/entities/oceanus_soul_chargebar")
    }
end

do
    function TYU:NewModEnchantment(name, dataName) 
        return TYU.ModComponents.ModEnchantment:New(name, dataName)
    end
    TYU.ModEnchantments = {
        AquaLord = TYU:Require("scripts/enchantments/aqua_lord"),
        BaneOfArthropods = TYU:Require("scripts/enchantments/bane_of_arthropods"),
        BlastProtection = TYU:Require("scripts/enchantments/blast_protection"),
        ChampionKiller = TYU:Require("scripts/enchantments/champion_killer"),
        CurseOfBinding = TYU:Require("scripts/enchantments/curse_of_binding"),
        CurseOfSalvaging = TYU:Require("scripts/enchantments/curse_of_salvaging"),
        CurseOfVanishing = TYU:Require("scripts/enchantments/curse_of_vanishing"),
        FireAspect = TYU:Require("scripts/enchantments/fire_aspect"),
        FireProtection = TYU:Require("scripts/enchantments/fire_protection"),
        Fortune = TYU:Require("scripts/enchantments/fortune"),
        Knockback = TYU:Require("scripts/enchantments/knockback"),
        Looting = TYU:Require("scripts/enchantments/looting"),
        ProjectileProtection = TYU:Require("scripts/enchantments/projectile_protection"),
        Smite = TYU:Require("scripts/enchantments/smite"),
        SpikeProtection = TYU:Require("scripts/enchantments/spike_protection"),
        SuperSonic = TYU:Require("scripts/enchantments/super_sonic"),
        Thorns = TYU:Require("scripts/enchantments/thorns")
    }
    TYU.ModEnchantmentInfos = {
        [TYU.ModEnchantmentIDs.AQUALORD] = {"水域领主", "Aqua Lord", 6, 1, false},
        [TYU.ModEnchantmentIDs.BANEOFARTHROPODS] = {"节肢杀手", "Bane Of Arthropods", 10, 5, false},
        [TYU.ModEnchantmentIDs.BLASTPROTECTION] = {"爆炸保护", "Blast Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.CHAMPIONKILLER] = {"精英杀手", "Champion Killer", 10, 5, false},
        [TYU.ModEnchantmentIDs.CURSEOFBINDING] = {"绑定诅咒", "Curse Of Binding", 1, 1, true},
        [TYU.ModEnchantmentIDs.CURSEOFSALVAGING] = {"拾荒诅咒", "Curse Of Salvaging", 1, 1, true},
        [TYU.ModEnchantmentIDs.CURSEOFVANISHING] = {"消失诅咒", "Curse Of Vanishing", 1, 1, true},
        [TYU.ModEnchantmentIDs.FIREASPECT] = {"火焰附加", "Fire Aspect", 6, 2, false},
        [TYU.ModEnchantmentIDs.FIREPROTECTION] = {"火焰保护", "Fire Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.FORTUNE] = {"时运", "Fortune", 6, 3, false},
        [TYU.ModEnchantmentIDs.KNOCKBACK] = {"击退", "Knockback", 6, 2, false},
        [TYU.ModEnchantmentIDs.LOOTING] = {"抢夺", "Looting", 6, 3, false},
        [TYU.ModEnchantmentIDs.PROJECTILEPROTECTION] = {"弹射物保护", "Projectile Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.SMITE] = {"亡灵杀手", "Smite", 10, 5, false},
        [TYU.ModEnchantmentIDs.SPIKEPROTECTION] = {"尖刺保护", "Spike Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.SUPERSONIC] = {"超音速", "Super Sonic", 6, 3, false},
        [TYU.ModEnchantmentIDs.THORNS] = {"荆棘", "Thorns", 6, 3, false}
    }
end

do
    function TYU:NewModPill(name, dataName) 
        return TYU.ModComponents.ModPill:New(name, dataName)
    end
    TYU.ModPills = {
        BaitAndSwitch = TYU:Require("scripts/pills/bait_and_switch")
    }
    TYU.ModPillTexts = {
        [TYU.ModPillEffectIDs.BAITANDSWITCH] = "偷天换日"
    }
end

do
    function TYU:NewModPlayer(name, tainted, dataName) 
        return TYU.ModComponents.ModPlayer:New(name, tainted, dataName)
    end
    TYU.ModPlayers = {
        Warfarin = TYU:Require("scripts/players/warfarin")
    }
end

do
    function TYU:NewModTrinket(name, dataName) 
        return TYU.ModComponents.ModTrinket:New(name, dataName)
    end
    TYU.ModTrinkets = {
        BethsSalvation = TYU:Require("scripts/trinkets/beths_salvation"),
        BrokenVision = TYU:Require("scripts/trinkets/broken_vision"),
        BrokenGlassEye = TYU:Require("scripts/trinkets/broken_glass_eye"),
        KeepersCore = TYU:Require("scripts/trinkets/keepers_core"),
        LostBottleCap = TYU:Require("scripts/trinkets/lost_bottle_cap"),
        StoneCarvingKnife = TYU:Require("scripts/trinkets/stone_carving_knife")
    }
    TYU.ModTrinketTexts = {
        [TYU.ModTrinketIDs.BETHSSALVATION] = {"伯大尼的救赎", "解脱于罪恶"},
        [TYU.ModTrinketIDs.BROKENVISION] = {"视力受损", "双倍道具?"},
        [TYU.ModTrinketIDs.BROKENGLASSEYE] = {"损坏的玻璃眼", "它曾经是完整的"},
        [TYU.ModTrinketIDs.KEEPERSCORE] = {"店主的核心", "积少成多"},
        [TYU.ModTrinketIDs.LOSTBOTTLECAP] = {"丢失的瓶盖", "再来一瓶!"},
        [TYU.ModTrinketIDs.STONECARVINGKNIFE] = {"石刻刀", "石雕"}
    }
end

do
    if Options.Language == "zh" then
        for i = 733, TYU.ITEMCONFIG:GetCollectibles().Size - 1 do
            if ItemConfig.Config.IsValidCollectible(i) and TYU.ModItemTexts[i] then
                local collectible = TYU.ITEMCONFIG:GetCollectible(i)
                collectible.Name = TYU.ModItemTexts[i][1]
                collectible.Description = TYU.ModItemTexts[i][2]
                TYU.ModItemIDs[i] = Isaac.GetItemIdByName(TYU.ModItemTexts[i][1])
            end
        end
        for i = 190, TYU.ITEMCONFIG:GetTrinkets().Size - 1 do
            local trinket = TYU.ITEMCONFIG:GetTrinket(i)
            if trinket:IsTrinket() and TYU.ModTrinketTexts[i] then
                trinket.Name = TYU.ModTrinketTexts[i][1]
                trinket.Description = TYU.ModTrinketTexts[i][2]
                TYU.ModTrinketIDs[i] = Isaac.GetTrinketIdByName(TYU.ModTrinketTexts[i][1])
            end
        end
        for i = 98, TYU.ITEMCONFIG:GetCards().Size - 1 do
            local card = TYU.ITEMCONFIG:GetCard(i)
            if card:IsAvailable() and TYU.ModCardTexts[i] then
                card.Name = TYU.ModCardTexts[i][1]
                card.Description = TYU.ModCardTexts[i][2]
            end
        end
        for i = 50, TYU.ITEMCONFIG:GetPillEffects().Size - 1 do
            local pill = TYU.ITEMCONFIG:GetPillEffect(i)
            if pill:IsAvailable() and TYU.ModPillTexts[i] then
                pill.Name = TYU.ModPillTexts[i]
            end
        end
    end
end

do
    TYU:AddCallback(ModCallbacks.MC_PRE_ITEM_TEXT_DISPLAY, function(mod, title, subTitle, isSticky, isCurseDisplay)
        if Options.Language ~= "zh" or isCurseDisplay or isSticky then
            return
        end
        if subTitle == EntityConfig.GetPlayer(TYU.ModPlayerIDs.WARFARIN):GetBirthrightDescription() then
            TYU.HUD:ShowItemText(title, "更好的转换")
            return false
        end
    end)

    TYU:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(mod, player)
        local oldCount = TYU:GetPlayerLibData(player, "SmeltedTrinketCount") or 0
        local newCount = 0
        for _, values in pairs(player:GetSmeltedTrinkets()) do
            newCount = newCount + values.trinketAmount + values.goldenTrinketAmount
        end
        if newCount ~= oldCount then
            TYU:SetPlayerLibData(player, newCount, "SmeltedTrinketCount")
            Isaac.RunCallback(TYU.Callbacks.TYU_POST_TRINKET_SMELTED, player, newCount - oldCount)
        end
    end, 0)

    TYU:AddCallback(ModCallbacks.MC_USE_ITEM, function(mod, itemID, rng, player, useFlags, activeSlot, varData)
        for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT)) do
            if ent:HasEntityFlags(TYU.ModEntityFlags.FLAG_NO_PAUSE) then
                ent:SetPauseTime(0)
            end
        end
    end, CollectibleType.COLLECTIBLE_PAUSE)
end