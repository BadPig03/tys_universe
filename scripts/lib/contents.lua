do
    TYU.Loaded = {}
    TYU.ClassesPaths = {
        Collectibles = "collectibles",
        Enchantments = "enchantments",
        Entities = "entities",
        Foods = "foods",
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
        BoneClayPot = TYU:Require("scripts/items/bone_clay_pot"),
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
        DarkMask = TYU:Require("scripts/items/dark_mask"),
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
        HypnosisPerfume = TYU:Require("scripts/items/hypnosis_perfume"),
        LaserBlaster = TYU:Require("scripts/items/laser_blaster"),
        LightSwitch = TYU:Require("scripts/items/light_switch"),
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
        PillCase = TYU:Require("scripts/items/pill_case"),
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
        [TYU.ModItemIDs.ABSENCE_NOTE] = {"请假条", "遇到困难睡大觉"},
        [TYU.ModItemIDs.ABSOLUTION] = {"赦罪", "这不是你的错"},
        [TYU.ModItemIDs.ANOREXIA] = {"厌食症", "我吃不下了"},
        [TYU.ModItemIDs.ATONEMENT_VOUCHER] = {"赎罪券", "承认我的罪过"},
        [TYU.ModItemIDs.BEGGAR_MASK] = {"丐帮面具", "忠诚"},
        [TYU.ModItemIDs.BLAZE_FLY] = {"烈焰苍蝇", "太燃了"},
        [TYU.ModItemIDs.BLESSED_DESTINY] = {"神圣命运", "命中注定"},
        [TYU.ModItemIDs.BLOOD_SACRIFICE] = {"鲜血献祭", "以血肉铸就"},
        [TYU.ModItemIDs.BLOOD_SAMPLE] = {"血液样本", "血量提升"},
        [TYU.ModItemIDs.BLOODY_DICE] = {"血之骰", "重置你的交易"},
        [TYU.ModItemIDs.BOBS_STOMACH] = {"鲍勃的胃", "快要溢出了"},
        [TYU.ModItemIDs.BONE_CLAY_POT] = {"骨陶罐", "心之容器"},
        [TYU.ModItemIDs.BONE_IN_FISH_STEAK] = {"带骨鱼排", "小心地吃"},
        [TYU.ModItemIDs.CHEF_HAT] = {"厨师帽", "烹饪时间到"},
        [TYU.ModItemIDs.CHOCOLATE_PANCAKE] = {"巧克力煎饼", "恶魔的最爱"},
        [TYU.ModItemIDs.COLLAPSE] = {"坍缩", "超引力"},
        [TYU.ModItemIDs.CONJUNCTIVITIS] = {"结膜炎", "红眼睛"},
        [TYU.ModItemIDs.CONSERVATIVE_TREATMENT] = {"保守疗法", "不会再恶化了"},
        [TYU.ModItemIDs.CORNUCOPIA] = {"丰饶羊角", "变废为宝"},
        [TYU.ModItemIDs.CROWN_OF_KINGS] = {"主宰之冠", "权力易逝"},
        [TYU.ModItemIDs.CURSED_DICE] = {"被诅咒的骰子", "遮蔽你的命运"},
        [TYU.ModItemIDs.CURSED_TREASURE] = {"被诅咒的宝藏", "更多的商品...但代价是什么?"},
        [TYU.ModItemIDs.DARK_MASK] = {"漆黑面具", "未完成的委托"},
        [TYU.ModItemIDs.EFFERVESCENT_TABLET] = {"泡腾片", "好多泡泡"},
        [TYU.ModItemIDs.ENCHANTED_BOOK] = {"附魔书", "附加能力"},
        [TYU.ModItemIDs.EXPIRED_GLUE] = {"过期胶水", "好臭"},
        [TYU.ModItemIDs.EXPLOSION_MASTER] = {"爆炸大师", "艺术就是爆炸"},
        [TYU.ModItemIDs.FALLEN_SKY] = {"天坠", "直坠深渊"},
        [TYU.ModItemIDs.GUILT] = {"罪孽", "这就是你的错"},
        [TYU.ModItemIDs.GUPPYS_FOOD] = {"嗝屁猫的罐头", "还没过期"},
        [TYU.ModItemIDs.HADES_BLADE] = {"冥府之刃", "心怀鬼胎"},
        [TYU.ModItemIDs.HEPHAESTUS_SOUL] = {"赫菲斯托斯之魂", "火焰化身"},
        [TYU.ModItemIDs.HYPNOSIS_PERFUME] = {"魅惑香水", "致命诱惑"},
        [TYU.ModItemIDs.LANDMINE] = {"地雷", "一触即爆"},
        [TYU.ModItemIDs.LASER_BLASTER] = {"激光发射器", "未来科技"},
        [TYU.ModItemIDs.LIGHT_SWITCH] = {"灯光开关", "关闭灯光"},
        [TYU.ModItemIDs.MAGNIFIER] = {"放大镜", "放大你的敌人"},
        [TYU.ModItemIDs.MARRIAGE_CERTIFICATE] = {"结婚证明", "见证坚定不移的爱情"},
        [TYU.ModItemIDs.MIRRORING_SHARD] = {"镜像碎块", "另一个我"},
        [TYU.ModItemIDs.MIRRORING] = {"镜像", "另一个我"},
        [TYU.ModItemIDs.NOTICE_OF_CRITICAL_CONDITION] = {"病危通知书", "生死未卜"},
        [TYU.ModItemIDs.OCEANUS_SOUL] = {"俄刻阿诺斯之魂", "海洋化身"},
        [TYU.ModItemIDs.ORDER] = {"秩序", "???"},
        [TYU.ModItemIDs.OVERLOAD_BATTERY] = {"过载电池", "<3=充能"},
        [TYU.ModItemIDs.PEELED_BANANA] = {"剥皮香蕉", "甜甜的感觉"},
        [TYU.ModItemIDs.PHILOSOPHERS_STAFF] = {"贤者权杖", "别碰它!"},
        [TYU.ModItemIDs.PILL_CASE] = {"胶囊盒", "双倍胶囊"},
        [TYU.ModItemIDs.PLANETARIUM_TELESCOPE] = {"星象望远镜", "远距离观察"},
        [TYU.ModItemIDs.RECON_VISION] = {"洞察视界", "看穿一切"},
        [TYU.ModItemIDs.REWIND] = {"倒带", "似曾相识"},
        [TYU.ModItemIDs.RUBY] = {"红宝石", "财富的象征"},
        [TYU.ModItemIDs.SCAPEGOAT] = {"替罪羊", "承担所有的罪恶和污浊"},
        [TYU.ModItemIDs.SINISTER_PACT] = {"邪恶契约", "他渴望你的誓言"},
        [TYU.ModItemIDs.STICKY_BALL] = {"粘性球", "好粘"},
        [TYU.ModItemIDs.STRANGE_SYRINGE] = {"奇怪的针筒", "嗑药?"},
        [TYU.ModItemIDs.SUSPICIOUS_STEW] = {"迷之炖菜", "好奇怪"},
        [TYU.ModItemIDs.THE_GOSPEL_OF_JOHN] = {"约翰福音", "憧憬未来"},
        [TYU.ModItemIDs.TOOL_BOX] = {"工具箱", "里面有什么?"},
        [TYU.ModItemIDs.TWILIGHT_FOX] = {"暮光狐", "静寂的保护者"},
        [TYU.ModItemIDs.WAKE_UP] = {"唤醒", "这是一场梦吗?"}
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
        [TYU.ModCardIDs.ENCHANTED_CARD] = {"附魔卡", "随机附魔"},
        [TYU.ModCardIDs.GLOWING_HOURGLASS_SHARD] = {"发光沙漏碎片", "逆转时间"}
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
        HypnosisPerfumeCloud = TYU:Require("scripts/entities/hypnosis_perfume_cloud"),
        Landmine = TYU:Require("scripts/entities/landmine"),
        LaserOrb = TYU:Require("scripts/entities/laser_orb"),
        Magnifier = TYU:Require("scripts/entities/magnifier"),
        MeatEffigy = TYU:Require("scripts/entities/meat_effigy"),
        OceanusSoulChargeBar = TYU:Require("scripts/entities/oceanus_soul_chargebar"),
        StickyBallSquirt = TYU:Require("scripts/entities/sticky_ball_squirt"),
        StickyBallTear = TYU:Require("scripts/entities/sticky_ball_tear"),
        ToolBox = TYU:Require("scripts/entities/tool_box"),
        TwilightFox = TYU:Require("scripts/entities/twilight_fox"),
        TwilightFoxHalo = TYU:Require("scripts/entities/twilight_fox_halo"),
        WarfarinBlackmarketCrawlspace = TYU:Require("scripts/entities/warfarin_blackmarket_crawlspace")
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
        [TYU.ModEnchantmentIDs.AQUA_LORD] = {"水域领主", "Aqua Lord", 6, 1, false},
        [TYU.ModEnchantmentIDs.BANE_OF_ARTHROPODS] = {"节肢杀手", "Bane Of Arthropods", 10, 5, false},
        [TYU.ModEnchantmentIDs.BLAST_PROTECTION] = {"爆炸保护", "Blast Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.CHAMPION_KILLER] = {"精英杀手", "Champion Killer", 10, 5, false},
        [TYU.ModEnchantmentIDs.CURSE_OF_BINDING] = {"绑定诅咒", "Curse Of Binding", 1, 1, true},
        [TYU.ModEnchantmentIDs.CURSE_OF_SALVAGING] = {"拾荒诅咒", "Curse Of Salvaging", 1, 1, true},
        [TYU.ModEnchantmentIDs.CURSE_OF_VANISHING] = {"消失诅咒", "Curse Of Vanishing", 1, 1, true},
        [TYU.ModEnchantmentIDs.FIRE_ASPECT] = {"火焰附加", "Fire Aspect", 6, 2, false},
        [TYU.ModEnchantmentIDs.FIRE_PROTECTION] = {"火焰保护", "Fire Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.FORTUNE] = {"时运", "Fortune", 6, 3, false},
        [TYU.ModEnchantmentIDs.KNOCKBACK] = {"击退", "Knockback", 6, 2, false},
        [TYU.ModEnchantmentIDs.LOOTING] = {"抢夺", "Looting", 6, 3, false},
        [TYU.ModEnchantmentIDs.PROJECTILE_PROTECTION] = {"弹射物保护", "Projectile Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.SMITE] = {"亡灵杀手", "Smite", 10, 5, false},
        [TYU.ModEnchantmentIDs.SPIKE_PROTECTION] = {"尖刺保护", "Spike Protection", 8, 4, false},
        [TYU.ModEnchantmentIDs.SUPER_SONIC] = {"超音速", "Super Sonic", 6, 3, false},
        [TYU.ModEnchantmentIDs.THORNS] = {"荆棘", "Thorns", 6, 3, false}
    }
end

do
    function TYU:NewModPill(name, dataName) 
        return TYU.ModComponents.ModPill:New(name, dataName)
    end
    TYU.ModPills = {
        BaitAndSwitch = TYU:Require("scripts/pills/bait_and_switch"),
        Bleh = TYU:Require("scripts/pills/bleh"),
        BloodExtraction = TYU:Require("scripts/pills/blood_extraction")
        
    }
    TYU.ModPillTexts = {
        [TYU.ModPillEffectIDs.BAIT_AND_SWITCH] = "偷天换日",
        [TYU.ModPillEffectIDs.BLEH] = "口岁!",
        [TYU.ModPillEffectIDs.BLOOD_EXTRACTION] = "血液提取"
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
        MealTicket = TYU:Require("scripts/trinkets/meal_ticket"),
        StoneCarvingKnife = TYU:Require("scripts/trinkets/stone_carving_knife"),
        TwistedLovers = TYU:Require("scripts/trinkets/twisted_lovers")
    }
    TYU.ModTrinketTexts = {
        [TYU.ModTrinketIDs.BETHS_SALVATION] = {"伯大尼的救赎", "解脱于罪恶"},
        [TYU.ModTrinketIDs.BROKEN_VISION] = {"视力受损", "双倍道具?"},
        [TYU.ModTrinketIDs.BROKEN_GLASS_EYE] = {"损坏的玻璃眼", "它曾经是完整的"},
        [TYU.ModTrinketIDs.KEEPERS_CORE] = {"店主的核心", "积少成多"},
        [TYU.ModTrinketIDs.LOST_BOTTLE_CAP] = {"丢失的瓶盖", "再来一瓶!"},
        [TYU.ModTrinketIDs.MEAL_TICKET] = {"餐券", "免费赠品"},
        [TYU.ModTrinketIDs.STONE_CARVING_KNIFE] = {"石刻刀", "石雕"},
        [TYU.ModTrinketIDs.TWISTED_LOVERS] = {"扭曲之契", "反转命运"}
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