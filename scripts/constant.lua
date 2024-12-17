local Lib = TYU

local function Get(num)
    if num == -1 then
        return false
    end
    return num
end

Lib.Callbacks = {
    TYU_POST_LOAD = "TYU_POST_LOAD",
    TYU_POST_SAVE = "TYU_POST_SAVE",
    TYU_POST_RESTART = "TYU_POST_RESTART",
    TYU_POST_EXIT = "TYU_POST_EXIT",
    TYU_POST_TRINKET_SMELTED = "TYU_POST_TRINKET_SMELTED",
    TYU_POST_NEW_ROOM_OR_LOAD = "TYU_POST_NEW_ROOM_OR_LOAD"
}

Lib.Constants = {
    CHARGEBAR_PLAYBACKRATE = 190 / 141,
    GLITCHED_ITEM_ID = 4294967295
}

Lib.Colors = {
    SLOWING = Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863),
    GREEN = Color(0.5, 0.9, 0.4, 1, 0, 0, 0),
    STICKY = Color(1, 0.65, 0.8, 0.8, 0, 0, 0),
    PINK = Color(1, 1, 1, 1, 0, 0, 0, 4, 1, 2.6, 1)
}

Lib.RainbowColors = {
    {1 / 12, 5 / 6, 1 / 12},
    {5 / 69, 50 / 69, 14 / 69},
    {5 / 78, 25 / 39, 23 / 78},
    {5 / 87, 50 / 87, 32 / 87},
    {5 / 96, 25 / 48, 41 / 96},
    {1 / 21, 10 / 21, 10 / 21},
    {5 / 96, 41 / 96, 25 / 48},
    {5 / 87, 32 / 87, 50 / 87},
    {5 / 78, 23 / 78, 25 / 39},
    {5 / 69, 14 / 69, 50 / 69},
    {1 / 12, 1 / 12, 5 / 6},
    {14 / 69, 5 / 69, 50 / 69},
    {23 / 78, 5 / 78, 25 / 39},
    {32 / 87, 5 / 87, 50 / 87},
    {41 / 96, 5 / 96, 25 / 48},
    {10 / 21, 1 / 21, 10 / 21},
    {25 / 48, 5 / 96, 41 / 96},
    {50 / 87, 5 / 87, 32 / 87},
    {25 / 39, 5 / 78, 23 / 78},
    {50 / 69, 5 / 69, 14 / 69},
    {5 / 6, 1 / 12, 1 / 12},
    {50 / 69, 14 / 69, 5 / 69},
    {25 / 39, 23 / 78, 5 / 78},
    {50 / 87, 32 / 87, 5 / 87},
    {25 / 48, 41 / 96, 5 / 96},
    {10 / 21, 10 / 21, 1 / 21},
    {41 / 96, 25 / 48, 5 / 96},
    {32 / 87, 50 / 87, 5 / 87},
    {23 / 78, 25 / 39, 5 / 78},
    {14 / 69, 50 / 69, 5 / 69}
}

Lib.KColors = {
    RED = KColor(1, 0, 0, 1),
    WHITE = KColor(1, 1, 1, 1)
}

Lib.ModAchievementIDs = {
    PROMPTREAD = Isaac.GetAchievementIdByName("prompt_read")
}

Lib.ModBackdropIDs = {
    ICU = Isaac.GetBackdropIdByName("tyuniverse_icu")
}

Lib.ModCardIDs = {
    ENCHANTEDCARD = Get(Isaac.GetCardIdByName("Enchanted Card")) or Isaac.GetCardIdByName("附魔卡"),
    GLOWINGHOURGLASSSHARD = Get(Isaac.GetCardIdByName("Glowing Hourglass Shard")) or Isaac.GetCardIdByName("发光沙漏碎片")
}

Lib.ModFoodItemIDs = {
    FOODS = Isaac.GetEntitySubTypeByName("Foods (food item)"),
    APPLE = Isaac.GetEntitySubTypeByName("Apple (food item)"),
    BAKEDPOTATO = Isaac.GetEntitySubTypeByName("Baked Potato (food item)"),
    BEETROOT = Isaac.GetEntitySubTypeByName("Beetroot (food item)"),
    BROWNMUSHROOM = Isaac.GetEntitySubTypeByName("Brown Mushroom (food item)"),
    CARROT = Isaac.GetEntitySubTypeByName("Carrot (food item)"),
    CHORUSFRUIT = Isaac.GetEntitySubTypeByName("Chorus Fruit (food item)"),
    COCOABEANS = Isaac.GetEntitySubTypeByName("Cocoa Beans (food item)"),
    DRIEDKELP = Isaac.GetEntitySubTypeByName("Dried Kelp (food item)"),
    GLOWBERRIES = Isaac.GetEntitySubTypeByName("Glow Berries (food item)"),
    GOLDENAPPLE = Isaac.GetEntitySubTypeByName("Golden Apple (food item)"),
    GOLDENCARROT = Isaac.GetEntitySubTypeByName("Golden Carrot (food item)"),
    MELONSLICE = Isaac.GetEntitySubTypeByName("Melon Slice (food item)"),
    POTATO = Isaac.GetEntitySubTypeByName("Potato (food item)"),
    REDMUSHROOM = Isaac.GetEntitySubTypeByName("Red Mushroom (food item)"),
    SWEETBERRIES = Isaac.GetEntitySubTypeByName("Sweet Berries (food item)"),
    WHEAT = Isaac.GetEntitySubTypeByName("Wheat (food item)"),
    CABBAGE = Isaac.GetEntitySubTypeByName("Cabbage (food item)"),
    ONION = Isaac.GetEntitySubTypeByName("Onion (food item)"),
    PUMPKINSLICE = Isaac.GetEntitySubTypeByName("Pumpkin Slice (food item)"),
    TOMATO = Isaac.GetEntitySubTypeByName("Tomato (food item)"),
    MONSTERMEAT = Isaac.GetEntitySubTypeByName("Monster Meat (food item)")
}

Lib.ModEnchantmentIDs = {
    AQUALORD = Isaac.GetNullItemIdByName("Aqua Lord"),
    BANEOFARTHROPODS = Isaac.GetNullItemIdByName("Bane Of Arthropods"),
    BLASTPROTECTION = Isaac.GetNullItemIdByName("Blast Protection"),
    CHAMPIONKILLER = Isaac.GetNullItemIdByName("Champion Killer"),
    CURSEOFBINDING = Isaac.GetNullItemIdByName("Curse Of Binding"),
    CURSEOFSALVAGING = Isaac.GetNullItemIdByName("Curse Of Salvaging"),
    CURSEOFVANISHING = Isaac.GetNullItemIdByName("Curse Of Vanishing"),
    FIREASPECT = Isaac.GetNullItemIdByName("Fire Aspect"),
    FIREPROTECTION = Isaac.GetNullItemIdByName("Fire Protection"),
    FORTUNE = Isaac.GetNullItemIdByName("Fortune"),
    KNOCKBACK = Isaac.GetNullItemIdByName("Knockback"),
    LOOTING = Isaac.GetNullItemIdByName("Looting"),
    PROJECTILEPROTECTION = Isaac.GetNullItemIdByName("Projectile Protection"),
    SMITE = Isaac.GetNullItemIdByName("Smite"),
    SPIKEPROTECTION = Isaac.GetNullItemIdByName("Spike Protection"),
    SUPERSONIC = Isaac.GetNullItemIdByName("Super Sonic"),
    THORNS = Isaac.GetNullItemIdByName("Thorns")
}

Lib.ModEntityIDs = {
    BLAZEFLY = {
        Type = Isaac.GetEntityTypeByName("Blaze Fly"),
        Variant = Isaac.GetEntityVariantByName("Blaze Fly"),
        SubType = Isaac.GetEntitySubTypeByName("Blaze Fly")
    },
    BOBSSTOMACHCHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Bobs Stomach ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Bobs Stomach ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Bobs Stomach ChargeBar")
    },
    CHEFBEGGAR = {
        Type = Isaac.GetEntityTypeByName("Chef Beggar"),
        Variant = Isaac.GetEntityVariantByName("Chef Beggar"),
        SubType = Isaac.GetEntitySubTypeByName("Chef Beggar")
    },
    COLLAPSEEFFECT = {
        Type = Isaac.GetEntityTypeByName("Collapse Effect"),
        Variant = Isaac.GetEntityVariantByName("Collapse Effect"),
        SubType = Isaac.GetEntitySubTypeByName("Collapse Effect")
    },
    CROWNOFKINGSEFFECT = {
        Type = Isaac.GetEntityTypeByName("Crown of Kings Effect"),
        Variant = Isaac.GetEntityVariantByName("Crown of Kings Effect"),
        SubType = Isaac.GetEntitySubTypeByName("Crown of Kings Effect")
    },
    CURSEDPENNY = {
        Type = Isaac.GetEntityTypeByName("Cursed Penny"),
        Variant = Isaac.GetEntityVariantByName("Cursed Penny"),
        SubType = Isaac.GetEntitySubTypeByName("Cursed Penny")
    },
    FAKEPICKUP = {
        Type = Isaac.GetEntityTypeByName("Fake Pickup"),
        Variant = Isaac.GetEntityVariantByName("Fake Pickup"),
        SubType = Isaac.GetEntitySubTypeByName("Fake Pickup")
    },
    FALLENSKYSWORD = {
        Type = Isaac.GetEntityTypeByName("Fallen Sky Sword"),
        Variant = Isaac.GetEntityVariantByName("Fallen Sky Sword"),
        SubType = Isaac.GetEntitySubTypeByName("Fallen Sky Sword")
    },
    FOODSFOODITEM = {
        Type = Isaac.GetEntityTypeByName("Foods (food item)"),
        Variant = Isaac.GetEntityVariantByName("Foods (food item)"),
        SubType = Isaac.GetEntitySubTypeByName("Foods (food item)")
    },
    HEALINGBEGGAR = {
        Type = Isaac.GetEntityTypeByName("Healing Beggar"),
        Variant = Isaac.GetEntityVariantByName("Healing Beggar"),
        SubType = Isaac.GetEntitySubTypeByName("Healing Beggar")
    },
    HEPHAESTUSSOULCHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Hephaestus Soul ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Hephaestus Soul ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Hephaestus Soul ChargeBar")
    },
    ICUBED = {
        Type = Isaac.GetEntityTypeByName("ICU Bed"),
        Variant = Isaac.GetEntityVariantByName("ICU Bed"),
        SubType = Isaac.GetEntitySubTypeByName("ICU Bed")
    },
    LANDMINE = {
        Type = Isaac.GetEntityTypeByName("Landmine"),
        Variant = Isaac.GetEntityVariantByName("Landmine"),
        SubType = Isaac.GetEntitySubTypeByName("Landmine")
    },
    LASERORB = {
        Type = Isaac.GetEntityTypeByName("Laser Orb"),
        Variant = Isaac.GetEntityVariantByName("Laser Orb"),
        SubType = Isaac.GetEntitySubTypeByName("Laser Orb")
    },
    MAGNIFIER = {
        Type = Isaac.GetEntityTypeByName("Magnifier"),
        Variant = Isaac.GetEntityVariantByName("Magnifier"),
        SubType = Isaac.GetEntitySubTypeByName("Magnifier")
    },
    MEATEFFIGY = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy")
    },
    MEATEFFIGYSOUL = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy Soul"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy Soul"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy Soul")
    },
    MEATEFFIGYBROKEN = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy Broken"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy Broken"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy Broken")
    },
    STICKYBALLTEAR = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Tear"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Tear"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Tear")
    },
    STICKYBALLDIPLEVEL1 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 1"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 1"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 1")
    },
    STICKYBALLDIPLEVEL2 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 2"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 2"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 2")
    },
    STICKYBALLDIPLEVEL3 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 3"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 3"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 3")
    },
    STICKYBALLSQUIRTLEVEL1 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 1"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 1"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 1")
    },
    STICKYBALLSQUIRTLEVEL2 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 2"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 2"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 2")
    },
    STICKYBALLSQUIRTLEVEL3 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 3"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 3"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 3")
    },
    TOOLBOX = {
        Type = Isaac.GetEntityTypeByName("Tool Box"),
        Variant = Isaac.GetEntityVariantByName("Tool Box"),
        SubType = Isaac.GetEntitySubTypeByName("Tool Box")
    },
    TWILIGHTFOX = {
        Type = Isaac.GetEntityTypeByName("Twilight Fox"),
        Variant = Isaac.GetEntityVariantByName("Twilight Fox"),
        SubType = Isaac.GetEntitySubTypeByName("Twilight Fox")
    },
    TWILIGHTFOXHALO = {
        Type = Isaac.GetEntityTypeByName("Twilight Fox Halo"),
        Variant = Isaac.GetEntityVariantByName("Twilight Fox Halo"),
        SubType = Isaac.GetEntitySubTypeByName("Twilight Fox Halo")
    },
    OCEANUSSOULCHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Oceanus Soul ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Oceanus Soul ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Oceanus Soul ChargeBar")
    }
}

Lib.ModEntityFlags = {
    FLAG_NO_PAUSE = 1 << 60
}

Lib.ModGiantBookIDs = {
    THEGOSPELOFJOHN = Isaac.GetGiantBookIdByName("TheGospelOfJohnGiantBook"),
    WARFARININ = Isaac.GetGiantBookIdByName("WarfarinInGiantBook"),
    WARFARINOUT = Isaac.GetGiantBookIdByName("WarfarinOutGiantBook")
}

Lib.ModItemIDs = {
    ABSENCENOTE = Get(Isaac.GetItemIdByName("Absence Note")) or Isaac.GetItemIdByName("请假条"),
    ABSOLUTION = Get(Isaac.GetItemIdByName("Absolution")) or Isaac.GetItemIdByName("赦罪"),
    ANOREXIA = Get(Isaac.GetItemIdByName("Anorexia")) or Isaac.GetItemIdByName("厌食症"),
    ATONEMENTVOUCHER = Get(Isaac.GetItemIdByName("Atonement Voucher")) or Isaac.GetItemIdByName("赎罪券"),
    BEGGARMASK = Get(Isaac.GetItemIdByName("Beggar Mask")) or Isaac.GetItemIdByName("丐帮面具"),
    BLAZEFLY = Get(Isaac.GetItemIdByName("Blaze Fly")) or Isaac.GetItemIdByName("烈焰苍蝇"),
    BLESSEDDESTINY = Get(Isaac.GetItemIdByName("Blessed Destiny")) or Isaac.GetItemIdByName("神圣命运"),
    BLOODSACRIFICE = Get(Isaac.GetItemIdByName("Blood Sacrifice")) or Isaac.GetItemIdByName("鲜血献祭"),
    BLOODSAMPLE = Get(Isaac.GetItemIdByName("Blood Sample")) or Isaac.GetItemIdByName("血液样本"),
    BLOODYDICE = Get(Isaac.GetItemIdByName("Bloody Dice")) or Isaac.GetItemIdByName("血之骰"),
    BOBSSTOMACH = Get(Isaac.GetItemIdByName("Bob's Stomach")) or Isaac.GetItemIdByName("鲍勃的胃"),
    BONEINFISHSTEAK = Get(Isaac.GetItemIdByName("Bone-in Fish Steak")) or Isaac.GetItemIdByName("带骨鱼排"),
    CHEFHAT = Get(Isaac.GetItemIdByName("Chef Hat")) or Isaac.GetItemIdByName("厨师帽"),
    CHOCOLATEPANCAKE = Get(Isaac.GetItemIdByName("Chocolate Pancake")) or Isaac.GetItemIdByName("巧克力煎饼"),
    COLLAPSE = Get(Isaac.GetItemIdByName("Collapse")) or Isaac.GetItemIdByName("坍缩"),
    CONJUNCTIVITIS = Get(Isaac.GetItemIdByName("Conjunctivitis")) or Isaac.GetItemIdByName("结膜炎"),
    CONSERVATIVETREATMENT = Get(Isaac.GetItemIdByName("Conservative Treatment")) or Isaac.GetItemIdByName("保守疗法"),
    CORNUCOPIA = Get(Isaac.GetItemIdByName("Cornucopia")) or Isaac.GetItemIdByName("丰饶羊角"),
    CROWNOFKINGS = Get(Isaac.GetItemIdByName("Crown of Kings")) or Isaac.GetItemIdByName("主宰之冠"),
    CURSEDDICE = Get(Isaac.GetItemIdByName("Cursed Dice")) or Isaac.GetItemIdByName("被诅咒的骰子"),
    CURSEDTREASURE = Get(Isaac.GetItemIdByName("Cursed Treasure")) or Isaac.GetItemIdByName("被诅咒的宝藏"),
    EFFERVESCENTTABLET = Get(Isaac.GetItemIdByName("Effervescent Tablet")) or Isaac.GetItemIdByName("泡腾片"),
    ENCHANTEDBOOK = Get(Isaac.GetItemIdByName("Enchanted Book")) or Isaac.GetItemIdByName("附魔书"),
    EXPIREDGLUE = Get(Isaac.GetItemIdByName("Expired Glue")) or Isaac.GetItemIdByName("过期胶水"),
    EXPLOSIONMASTER = Get(Isaac.GetItemIdByName("Explosion Master")) or Isaac.GetItemIdByName("爆炸大师"),
    FALLENSKY = Get(Isaac.GetItemIdByName("Fallen Sky")) or Isaac.GetItemIdByName("天坠"),
    GUILT = Get(Isaac.GetItemIdByName("Guilt")) or Isaac.GetItemIdByName("罪孽"),
    GUPPYSFOOD = Get(Isaac.GetItemIdByName("Guppy's Food")) or Isaac.GetItemIdByName("嗝屁猫的罐头"),
    HADESBLADE = Get(Isaac.GetItemIdByName("Hades Blade")) or Isaac.GetItemIdByName("冥府之刃"),
    HEPHAESTUSSOUL = Get(Isaac.GetItemIdByName("Hephaestus' Soul")) or Isaac.GetItemIdByName("赫菲斯托斯之魂"),
    LANDMINE = Get(Isaac.GetItemIdByName("Landmine")) or Isaac.GetItemIdByName("地雷"),
    LASERBLASTER = Get(Isaac.GetItemIdByName("Laser Blaster")) or Isaac.GetItemIdByName("激光发射器"),
    MAGNIFIER = Get(Isaac.GetItemIdByName("Magnifier")) or Isaac.GetItemIdByName("放大镜"),
    MARRIAGECERTIFICATE = Get(Isaac.GetItemIdByName("Marriage Certificate")) or Isaac.GetItemIdByName("结婚证明"),
    MIRRORINGSHARD = Get(Isaac.GetItemIdByName("Mirroring Shard")) or Isaac.GetItemIdByName("镜像碎块"),
    MIRRORING = Get(Isaac.GetItemIdByName("Mirroring")) or Isaac.GetItemIdByName("镜像"),
    NOTICEOFCRITICALCONDITION = Get(Isaac.GetItemIdByName("Notice of Critical Condition")) or Isaac.GetItemIdByName("病危通知书"),
    OCEANUSSOUL = Get(Isaac.GetItemIdByName("Oceanus' Soul")) or Isaac.GetItemIdByName("俄刻阿诺斯之魂"),
    ORDER = Get(Isaac.GetItemIdByName("Order")) or Isaac.GetItemIdByName("秩序"),
    OVERLOADBATTERY = Get(Isaac.GetItemIdByName("Overload Battery")) or Isaac.GetItemIdByName("过载电池"),
    PEELEDBANANA = Get(Isaac.GetItemIdByName("Peeled Banana")) or Isaac.GetItemIdByName("剥皮香蕉"),
    PHILOSOPHERSSTAFF = Get(Isaac.GetItemIdByName("Philosopher's Staff")) or Isaac.GetItemIdByName("贤者权杖"),
    PLANETARIUMTELESCOPE = Get(Isaac.GetItemIdByName("Planetarium Telescope")) or Isaac.GetItemIdByName("星象望远镜"),
    RECONVISION = Get(Isaac.GetItemIdByName("Recon Vision")) or Isaac.GetItemIdByName("洞察视界"),
    REWIND = Get(Isaac.GetItemIdByName("Rewind")) or Isaac.GetItemIdByName("倒带"),
    RUBY = Get(Isaac.GetItemIdByName("Ruby")) or Isaac.GetItemIdByName("红宝石"),
    SCAPEGOAT = Get(Isaac.GetItemIdByName("Scapegoat")) or Isaac.GetItemIdByName("替罪羊"),
    SINISTERPACT = Get(Isaac.GetItemIdByName("Sinister Pact")) or Isaac.GetItemIdByName("邪恶契约"),
    STICKYBALL = Get(Isaac.GetItemIdByName("Sticky Ball")) or Isaac.GetItemIdByName("粘性球"),
    STRANGESYRINGE = Get(Isaac.GetItemIdByName("Strange Syringe")) or Isaac.GetItemIdByName("奇怪的针筒"),
    SUSPICIOUSSTEW = Get(Isaac.GetItemIdByName("Suspicious Stew")) or Isaac.GetItemIdByName("迷之炖菜"),
    THEGOSPELOFJOHN = Get(Isaac.GetItemIdByName("The Gospel of John")) or Isaac.GetItemIdByName("约翰福音"),
    TOOLBOX = Get(Isaac.GetItemIdByName("Tool Box")) or Isaac.GetItemIdByName("工具箱"),
    TWILIGHTFOX = Get(Isaac.GetItemIdByName("Twilight Fox")) or Isaac.GetItemIdByName("暮光狐"),
    WAKEUP = Get(Isaac.GetItemIdByName("Wake-up")) or Isaac.GetItemIdByName("唤醒")
}

Lib.ModItemPoolIDs = {
    ILLNESS = Isaac.GetPoolIdByName("tyuIllness")
}

Lib.ModNullItemIDs = {
    BLESSEDDESTINYEFFECT = Isaac.GetNullItemIdByName("Blessed Destiny Effect"),
    BLOODSACRIFICEREVIVE = Isaac.GetNullItemIdByName("Blood Sacrifice Revive"),
    EFFERVESCENTTABLETEFFECT = Isaac.GetNullItemIdByName("Effervescent Tablet Effect"),
    MARRIAGECERTIFICATESUBPLAYER = Isaac.GetNullItemIdByName("Marriage Certificate Subplayer"),
    SCAPEGOATREVIVE = Isaac.GetNullItemIdByName("Scapegoat Revive"),
    SUSPICIOUSSTEWEFFECT = Isaac.GetNullItemIdByName("Suspicious Stew Effect"),
    RUBYEFFECT = Isaac.GetNullItemIdByName("Ruby Effect"),
    WARFARINBLACKCANDLE = Isaac.GetNullItemIdByName("Warfarin Black Candle"),
    WARFARINCARDREADING = Isaac.GetNullItemIdByName("Warfarin Card Reading"),
    WARFARINCEREMONIALROBES = Isaac.GetNullItemIdByName("Warfarin Ceremonial Robes"),
    WARFARINESAUJRHAIR = Isaac.GetNullItemIdByName("Warfarin Esau Jr Hair"),
    WARFARINFROZENHAIR = Isaac.GetNullItemIdByName("Warfarin Frozen Hair"),
    WARFARINFROZENHAIR2 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 2"),
    WARFARINFROZENHAIR3 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 3"),
    WARFARINFROZENHAIR4 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 4"),
    WARFARINGUPPYWINGS = Isaac.GetNullItemIdByName("Warfarin Guppy Wings"),
    WARFARINHAEMOLACRIA = Isaac.GetNullItemIdByName("Warfarin Haemolacria"),
    WARFARINHAIR = Isaac.GetNullItemIdByName("Warfarin Hair"),
    WARFARINLEO = Isaac.GetNullItemIdByName("Warfarin Leo"),
    WARFARINMAGIC8BALL = Isaac.GetNullItemIdByName("Warfarin Magic 8 Ball"),
    WARFARINMOMSWIG = Isaac.GetNullItemIdByName("Warfarin Moms Wig"),
    WARFARINREVERSEEMPRESS = Isaac.GetNullItemIdByName("Warfarin Reverse Empress"),
    WARFARINTAURUS = Isaac.GetNullItemIdByName("Warfarin Taurus"),
    WARFARINWINGS = Isaac.GetNullItemIdByName("Warfarin Wings")
}

Lib.ModPillEffectIDs = {
    BAITANDSWITCH = Get(Isaac.GetPillEffectByName("Bait and Switch")) or Isaac.GetPillEffectByName("偷天换日")
}

Lib.ModPlayerIDs = {
    WARFARIN = Isaac.GetPlayerTypeByName("Warfarin")
}

Lib.ModProjectileFlags = {
    TEAR_BELONGTOPLAYER = 1 << 60,
    TEAR_HEPHAESTUSSOUL = 1 << 61,
    TEAR_HEPHAESTUSSOUL_X = 1 << 62
}

Lib.ModRoomIDs = {
    GUILTDEVILROOMS = {},
    ICUROOMS = {},
    WARFARINBLACKMARKETS = {},
    WAKEUPMAINROOM = -1
}

Lib.ModSoundIDs = {
    WARFARINPLAYERHURT = Isaac.GetSoundIdByName("Warfarin Player Hurt")
}

Lib.ModTearFlags = {
    TEAR_TRAILING = BitSet128(0, 1 << 24),
    TEAR_EXPLOSION_MASTER = BitSet128(0, 1 << 24),
    TEAR_TRAILED = BitSet128(0, 1 << 25),
    TEAR_FALLENSKY = BitSet128(0, 1 << 26),
    TEAR_STICKYBALL = BitSet128(0, 1 << 27)
}

Lib.ModTrinketIDs = {
    BETHSSALVATION = Get(Isaac.GetTrinketIdByName("Beth's Salvation")) or Isaac.GetTrinketIdByName("伯大尼的救赎"),
    BROKENVISION = Get(Isaac.GetTrinketIdByName("Broken Vision")) or Isaac.GetTrinketIdByName("视力受损"),
    BROKENGLASSEYE = Get(Isaac.GetTrinketIdByName("Broken Glass Eye")) or Isaac.GetTrinketIdByName("损坏的玻璃眼"),
    KEEPERSCORE = Get(Isaac.GetTrinketIdByName("Keeper's Core")) or Isaac.GetTrinketIdByName("店主的核心"),
    LOSTBOTTLECAP = Get(Isaac.GetTrinketIdByName("Lost Bottle Cap")) or Isaac.GetTrinketIdByName("丢失的瓶盖"),
    STONECARVINGKNIFE = Get(Isaac.GetTrinketIdByName("Stone Carving Knife")) or Isaac.GetTrinketIdByName("石刻刀")
}

Lib.TearVariantPriority = {
	[TearVariant.BOBS_HEAD] = 99999,
	[TearVariant.CHAOS_CARD] = 99999,
	[TearVariant.STONE] = 99999,
	[TearVariant.MULTIDIMENSIONAL] = 99999,
	[TearVariant.BELIAL] = 99999,
	[TearVariant.BALLOON] = 99999,
	[TearVariant.BALLOON_BRIMSTONE] = 99999,
	[TearVariant.BALLOON_BOMB] = 99999,
	[TearVariant.GRIDENT] = 99999,
	[TearVariant.KEY] = 99999,
	[TearVariant.KEY_BLOOD] = 99999,
	[TearVariant.ERASER] = 99999,
	[TearVariant.FIRE] = 99999,
	[TearVariant.SWORD_BEAM] = 99999,
	[TearVariant.TECH_SWORD_BEAM] = 99999,
	[TearVariant.FETUS] = 99999,
    [Lib.ModEntityIDs.STICKYBALLTEAR.Variant] = 4,
	[TearVariant.EGG] = 3,
	[TearVariant.COIN] = 3,
	[TearVariant.NEEDLE] = 3,
	[TearVariant.TOOTH] = 2,
	[TearVariant.RAZOR] = 2,
	[TearVariant.BLACK_TOOTH] = 2,
	[TearVariant.FIST] = 2,
	[TearVariant.GODS_FLESH] = 1,
	[TearVariant.GODS_FLESH_BLOOD] = 1,
	[TearVariant.EXPLOSIVO] = 1,
	[TearVariant.BOOGER] = 1,
	[TearVariant.SPORE] = 1,
	[TearVariant.EYE] = 0.5,
	[TearVariant.EYE_BLOOD] = 0.5,
	[TearVariant.BLUE] = 0,
	[TearVariant.BLOOD] = 0,
	[TearVariant.METALLIC] = 0,
	[TearVariant.FIRE_MIND] = 0,
	[TearVariant.DARK_MATTER] = 0,
	[TearVariant.MYSTERIOUS] = 0,
	[TearVariant.SCHYTHE] = 0,
	[TearVariant.LOST_CONTACT] = 0,
	[TearVariant.CUPID_BLUE] = 0,
	[TearVariant.CUPID_BLOOD] = 0,
	[TearVariant.NAIL] = 0,
	[TearVariant.PUPULA] = 0,
	[TearVariant.PUPULA_BLOOD] = 0,
	[TearVariant.DIAMOND] = 0,
	[TearVariant.NAIL_BLOOD] = 0,
	[TearVariant.GLAUCOMA] = 0,
	[TearVariant.GLAUCOMA_BLOOD] = 0,
	[TearVariant.BONE] = 0,
	[TearVariant.HUNGRY] = 0,
	[TearVariant.ICE] = 0,
	[TearVariant.ROCK] = 0
}