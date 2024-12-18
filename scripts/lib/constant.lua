local function Get(num)
    if num == -1 then
        return false
    end
    return num
end

TYU.Callbacks = {
    TYU_POST_LOAD = "TYU_POST_LOAD",
    TYU_POST_SAVE = "TYU_POST_SAVE",
    TYU_POST_RESTART = "TYU_POST_RESTART",
    TYU_POST_EXIT = "TYU_POST_EXIT",
    TYU_POST_TRINKET_SMELTED = "TYU_POST_TRINKET_SMELTED",
    TYU_POST_NEW_ROOM_OR_LOAD = "TYU_POST_NEW_ROOM_OR_LOAD"
}

TYU.Constants = {
    CHARGEBAR_PLAYBACKRATE = 190 / 141,
    GLITCHED_ITEM_ID = 4294967295
}

TYU.Colors = {
    SLOWING = Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863),
    GREEN = Color(0.5, 0.9, 0.4, 1, 0, 0, 0),
    STICKY = Color(1, 0.65, 0.8, 0.8, 0, 0, 0),
    PINK = Color(1, 1, 1, 1, 0, 0, 0, 4, 1, 2.6, 1)
}

TYU.RainbowColors = {
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

TYU.KColors = {
    RED = KColor(1, 0, 0, 1),
    WHITE = KColor(1, 1, 1, 1)
}

TYU.ModAchievementIDs = {
    PROMPT_READ = Isaac.GetAchievementIdByName("prompt_read")
}

TYU.ModBackdropIDs = {
    ICU = Isaac.GetBackdropIdByName("tyuniverse_icu")
}

TYU.ModCardIDs = {
    ENCHANTED_CARD = Get(Isaac.GetCardIdByName("Enchanted Card")) or Isaac.GetCardIdByName("附魔卡"),
    GLOWING_HOURGLASS_SHARD = Get(Isaac.GetCardIdByName("Glowing Hourglass Shard")) or Isaac.GetCardIdByName("发光沙漏碎片")
}

TYU.ModFoodItemIDs = {
    FOODS = Isaac.GetEntitySubTypeByName("Foods (food item)"),
    APPLE = Isaac.GetEntitySubTypeByName("Apple (food item)"),
    BAKED_POTATO = Isaac.GetEntitySubTypeByName("Baked Potato (food item)"),
    BEETROOT = Isaac.GetEntitySubTypeByName("Beetroot (food item)"),
    BROWN_MUSHROOM = Isaac.GetEntitySubTypeByName("Brown Mushroom (food item)"),
    CARROT = Isaac.GetEntitySubTypeByName("Carrot (food item)"),
    CHORUS_FRUIT = Isaac.GetEntitySubTypeByName("Chorus Fruit (food item)"),
    COCOA_BEANS = Isaac.GetEntitySubTypeByName("Cocoa Beans (food item)"),
    DRIED_KELP = Isaac.GetEntitySubTypeByName("Dried Kelp (food item)"),
    GLOW_BERRIES = Isaac.GetEntitySubTypeByName("Glow Berries (food item)"),
    GOLDEN_APPLE = Isaac.GetEntitySubTypeByName("Golden Apple (food item)"),
    GOLDEN_CARROT = Isaac.GetEntitySubTypeByName("Golden Carrot (food item)"),
    MELON_SLICE = Isaac.GetEntitySubTypeByName("Melon Slice (food item)"),
    POTATO = Isaac.GetEntitySubTypeByName("Potato (food item)"),
    RED_MUSHROOM = Isaac.GetEntitySubTypeByName("Red Mushroom (food item)"),
    SWEET_BERRIES = Isaac.GetEntitySubTypeByName("Sweet Berries (food item)"),
    WHEAT = Isaac.GetEntitySubTypeByName("Wheat (food item)"),
    CABBAGE = Isaac.GetEntitySubTypeByName("Cabbage (food item)"),
    ONION = Isaac.GetEntitySubTypeByName("Onion (food item)"),
    PUMPKIN_SLICE = Isaac.GetEntitySubTypeByName("Pumpkin Slice (food item)"),
    TOMATO = Isaac.GetEntitySubTypeByName("Tomato (food item)"),
    MONSTER_MEAT = Isaac.GetEntitySubTypeByName("Monster Meat (food item)")
}

TYU.ModEnchantmentIDs = {
    AQUA_LORD = Isaac.GetNullItemIdByName("Aqua Lord"),
    BANE_OF_ARTHROPODS = Isaac.GetNullItemIdByName("Bane Of Arthropods"),
    BLAST_PROTECTION = Isaac.GetNullItemIdByName("Blast Protection"),
    CHAMPION_KILLER = Isaac.GetNullItemIdByName("Champion Killer"),
    CURSE_OF_BINDING = Isaac.GetNullItemIdByName("Curse Of Binding"),
    CURSE_OF_SALVAGING = Isaac.GetNullItemIdByName("Curse Of Salvaging"),
    CURSE_OF_VANISHING = Isaac.GetNullItemIdByName("Curse Of Vanishing"),
    FIRE_ASPECT = Isaac.GetNullItemIdByName("Fire Aspect"),
    FIRE_PROTECTION = Isaac.GetNullItemIdByName("Fire Protection"),
    FORTUNE = Isaac.GetNullItemIdByName("Fortune"),
    KNOCKBACK = Isaac.GetNullItemIdByName("Knockback"),
    LOOTING = Isaac.GetNullItemIdByName("Looting"),
    PROJECTILE_PROTECTION = Isaac.GetNullItemIdByName("Projectile Protection"),
    SMITE = Isaac.GetNullItemIdByName("Smite"),
    SPIKE_PROTECTION = Isaac.GetNullItemIdByName("Spike Protection"),
    SUPER_SONIC = Isaac.GetNullItemIdByName("Super Sonic"),
    THORNS = Isaac.GetNullItemIdByName("Thorns")
}

TYU.ModEntityIDs = {
    BLAZE_FLY = {
        Type = Isaac.GetEntityTypeByName("Blaze Fly"),
        Variant = Isaac.GetEntityVariantByName("Blaze Fly"),
        SubType = Isaac.GetEntitySubTypeByName("Blaze Fly")
    },
    BOBS_STOMACH_CHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Bobs Stomach ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Bobs Stomach ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Bobs Stomach ChargeBar")
    },
    CHEF_BEGGAR = {
        Type = Isaac.GetEntityTypeByName("Chef Beggar"),
        Variant = Isaac.GetEntityVariantByName("Chef Beggar"),
        SubType = Isaac.GetEntitySubTypeByName("Chef Beggar")
    },
    COLLAPSE_EFFECT = {
        Type = Isaac.GetEntityTypeByName("Collapse Effect"),
        Variant = Isaac.GetEntityVariantByName("Collapse Effect"),
        SubType = Isaac.GetEntitySubTypeByName("Collapse Effect")
    },
    CROWN_OF_KINGS_EFFECT = {
        Type = Isaac.GetEntityTypeByName("Crown of Kings Effect"),
        Variant = Isaac.GetEntityVariantByName("Crown of Kings Effect"),
        SubType = Isaac.GetEntitySubTypeByName("Crown of Kings Effect")
    },
    CURSED_PENNY = {
        Type = Isaac.GetEntityTypeByName("Cursed Penny"),
        Variant = Isaac.GetEntityVariantByName("Cursed Penny"),
        SubType = Isaac.GetEntitySubTypeByName("Cursed Penny")
    },
    FAKE_PICKUP = {
        Type = Isaac.GetEntityTypeByName("Fake Pickup"),
        Variant = Isaac.GetEntityVariantByName("Fake Pickup"),
        SubType = Isaac.GetEntitySubTypeByName("Fake Pickup")
    },
    FALLEN_SKY_SWORD = {
        Type = Isaac.GetEntityTypeByName("Fallen Sky Sword"),
        Variant = Isaac.GetEntityVariantByName("Fallen Sky Sword"),
        SubType = Isaac.GetEntitySubTypeByName("Fallen Sky Sword")
    },
    FOODS_FOOD_ITEM = {
        Type = Isaac.GetEntityTypeByName("Foods (food item)"),
        Variant = Isaac.GetEntityVariantByName("Foods (food item)"),
        SubType = Isaac.GetEntitySubTypeByName("Foods (food item)")
    },
    HEALING_BEGGAR = {
        Type = Isaac.GetEntityTypeByName("Healing Beggar"),
        Variant = Isaac.GetEntityVariantByName("Healing Beggar"),
        SubType = Isaac.GetEntitySubTypeByName("Healing Beggar")
    },
    HEPHAESTUS_SOUL_CHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Hephaestus Soul ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Hephaestus Soul ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Hephaestus Soul ChargeBar")
    },
    ICU_BED = {
        Type = Isaac.GetEntityTypeByName("ICU Bed"),
        Variant = Isaac.GetEntityVariantByName("ICU Bed"),
        SubType = Isaac.GetEntitySubTypeByName("ICU Bed")
    },
    LANDMINE = {
        Type = Isaac.GetEntityTypeByName("Landmine"),
        Variant = Isaac.GetEntityVariantByName("Landmine"),
        SubType = Isaac.GetEntitySubTypeByName("Landmine")
    },
    LASER_ORB = {
        Type = Isaac.GetEntityTypeByName("Laser Orb"),
        Variant = Isaac.GetEntityVariantByName("Laser Orb"),
        SubType = Isaac.GetEntitySubTypeByName("Laser Orb")
    },
    MAGNIFIER = {
        Type = Isaac.GetEntityTypeByName("Magnifier"),
        Variant = Isaac.GetEntityVariantByName("Magnifier"),
        SubType = Isaac.GetEntitySubTypeByName("Magnifier")
    },
    MEAT_EFFIGY = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy")
    },
    MEAT_EFFIGY_SOUL = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy Soul"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy Soul"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy Soul")
    },
    MEAT_EFFIGY_BROKEN = {
        Type = Isaac.GetEntityTypeByName("Meat Effigy Broken"),
        Variant = Isaac.GetEntityVariantByName("Meat Effigy Broken"),
        SubType = Isaac.GetEntitySubTypeByName("Meat Effigy Broken")
    },
    STICKY_BALL_TEAR = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Tear"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Tear"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Tear")
    },
    STICKY_BALL_DIP_LEVEL_1 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 1"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 1"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 1")
    },
    STICKY_BALL_DIP_LEVEL_2 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 2"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 2"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 2")
    },
    STICKY_BALL_DIP_LEVEL_3 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Dip Level 3"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Dip Level 3"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Dip Level 3")
    },
    STICKY_BALL_SQUIRT_LEVEL_1 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 1"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 1"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 1")
    },
    STICKY_BALL_SQUIRT_LEVEL_2 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 2"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 2"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 2")
    },
    STICKY_BALL_SQUIRT_LEVEL_3 = {
        Type = Isaac.GetEntityTypeByName("Sticky Ball Squirt Level 3"),
        Variant = Isaac.GetEntityVariantByName("Sticky Ball Squirt Level 3"),
        SubType = Isaac.GetEntitySubTypeByName("Sticky Ball Squirt Level 3")
    },
    TOOL_BOX = {
        Type = Isaac.GetEntityTypeByName("Tool Box"),
        Variant = Isaac.GetEntityVariantByName("Tool Box"),
        SubType = Isaac.GetEntitySubTypeByName("Tool Box")
    },
    TWILIGHT_FOX = {
        Type = Isaac.GetEntityTypeByName("Twilight Fox"),
        Variant = Isaac.GetEntityVariantByName("Twilight Fox"),
        SubType = Isaac.GetEntitySubTypeByName("Twilight Fox")
    },
    TWILIGHT_FOX_HALO = {
        Type = Isaac.GetEntityTypeByName("Twilight Fox Halo"),
        Variant = Isaac.GetEntityVariantByName("Twilight Fox Halo"),
        SubType = Isaac.GetEntitySubTypeByName("Twilight Fox Halo")
    },
    OCEANUS_SOUL_CHARGEBAR = {
        Type = Isaac.GetEntityTypeByName("Oceanus Soul ChargeBar"),
        Variant = Isaac.GetEntityVariantByName("Oceanus Soul ChargeBar"),
        SubType = Isaac.GetEntitySubTypeByName("Oceanus Soul ChargeBar")
    }
}

TYU.ModGiantBookIDs = {
    THE_GOSPEL_OF_JOHN = Isaac.GetGiantBookIdByName("TheGospelOfJohnGiantBook"),
    WARFARIN_IN = Isaac.GetGiantBookIdByName("WarfarinInGiantBook"),
    WARFARIN_OUT = Isaac.GetGiantBookIdByName("WarfarinOutGiantBook")
}

TYU.ModItemIDs = {
    ABSENCE_NOTE = Get(Isaac.GetItemIdByName("Absence Note")) or Isaac.GetItemIdByName("请假条"),
    ABSOLUTION = Get(Isaac.GetItemIdByName("Absolution")) or Isaac.GetItemIdByName("赦罪"),
    ANOREXIA = Get(Isaac.GetItemIdByName("Anorexia")) or Isaac.GetItemIdByName("厌食症"),
    ATONEMENT_VOUCHER = Get(Isaac.GetItemIdByName("Atonement Voucher")) or Isaac.GetItemIdByName("赎罪券"),
    BEGGAR_MASK = Get(Isaac.GetItemIdByName("Beggar Mask")) or Isaac.GetItemIdByName("丐帮面具"),
    BLAZE_FLY = Get(Isaac.GetItemIdByName("Blaze Fly")) or Isaac.GetItemIdByName("烈焰苍蝇"),
    BLESSED_DESTINY = Get(Isaac.GetItemIdByName("Blessed Destiny")) or Isaac.GetItemIdByName("神圣命运"),
    BLOOD_SACRIFICE = Get(Isaac.GetItemIdByName("Blood Sacrifice")) or Isaac.GetItemIdByName("鲜血献祭"),
    BLOOD_SAMPLE = Get(Isaac.GetItemIdByName("Blood Sample")) or Isaac.GetItemIdByName("血液样本"),
    BLOODY_DICE = Get(Isaac.GetItemIdByName("Bloody Dice")) or Isaac.GetItemIdByName("血之骰"),
    BOBS_STOMACH = Get(Isaac.GetItemIdByName("Bob's Stomach")) or Isaac.GetItemIdByName("鲍勃的胃"),
    BONE_IN_FISH_STEAK = Get(Isaac.GetItemIdByName("Bone-in Fish Steak")) or Isaac.GetItemIdByName("带骨鱼排"),
    CHEF_HAT = Get(Isaac.GetItemIdByName("Chef Hat")) or Isaac.GetItemIdByName("厨师帽"),
    CHOCOLATE_PANCAKE = Get(Isaac.GetItemIdByName("Chocolate Pancake")) or Isaac.GetItemIdByName("巧克力煎饼"),
    COLLAPSE = Get(Isaac.GetItemIdByName("Collapse")) or Isaac.GetItemIdByName("坍缩"),
    CONJUNCTIVITIS = Get(Isaac.GetItemIdByName("Conjunctivitis")) or Isaac.GetItemIdByName("结膜炎"),
    CONSERVATIVE_TREATMENT = Get(Isaac.GetItemIdByName("Conservative Treatment")) or Isaac.GetItemIdByName("保守疗法"),
    CORNUCOPIA = Get(Isaac.GetItemIdByName("Cornucopia")) or Isaac.GetItemIdByName("丰饶羊角"),
    CROWN_OF_KINGS = Get(Isaac.GetItemIdByName("Crown of Kings")) or Isaac.GetItemIdByName("主宰之冠"),
    CURSED_DICE = Get(Isaac.GetItemIdByName("Cursed Dice")) or Isaac.GetItemIdByName("被诅咒的骰子"),
    CURSED_TREASURE = Get(Isaac.GetItemIdByName("Cursed Treasure")) or Isaac.GetItemIdByName("被诅咒的宝藏"),
    EFFERVESCENT_TABLET = Get(Isaac.GetItemIdByName("Effervescent Tablet")) or Isaac.GetItemIdByName("泡腾片"),
    ENCHANTED_BOOK = Get(Isaac.GetItemIdByName("Enchanted Book")) or Isaac.GetItemIdByName("附魔书"),
    EXPIRED_GLUE = Get(Isaac.GetItemIdByName("Expired Glue")) or Isaac.GetItemIdByName("过期胶水"),
    EXPLOSION_MASTER = Get(Isaac.GetItemIdByName("Explosion Master")) or Isaac.GetItemIdByName("爆炸大师"),
    FALLEN_SKY = Get(Isaac.GetItemIdByName("Fallen Sky")) or Isaac.GetItemIdByName("天坠"),
    GUILT = Get(Isaac.GetItemIdByName("Guilt")) or Isaac.GetItemIdByName("罪孽"),
    GUPPYS_FOOD = Get(Isaac.GetItemIdByName("Guppy's Food")) or Isaac.GetItemIdByName("嗝屁猫的罐头"),
    HADES_BLADE = Get(Isaac.GetItemIdByName("Hades Blade")) or Isaac.GetItemIdByName("冥府之刃"),
    HEPHAESTUS_SOUL = Get(Isaac.GetItemIdByName("Hephaestus' Soul")) or Isaac.GetItemIdByName("赫菲斯托斯之魂"),
    LANDMINE = Get(Isaac.GetItemIdByName("Landmine")) or Isaac.GetItemIdByName("地雷"),
    LASER_BLASTER = Get(Isaac.GetItemIdByName("Laser Blaster")) or Isaac.GetItemIdByName("激光发射器"),
    MAGNIFIER = Get(Isaac.GetItemIdByName("Magnifier")) or Isaac.GetItemIdByName("放大镜"),
    MARRIAGE_CERTIFICATE = Get(Isaac.GetItemIdByName("Marriage Certificate")) or Isaac.GetItemIdByName("结婚证明"),
    MIRRORING_SHARD = Get(Isaac.GetItemIdByName("Mirroring Shard")) or Isaac.GetItemIdByName("镜像碎块"),
    MIRRORING = Get(Isaac.GetItemIdByName("Mirroring")) or Isaac.GetItemIdByName("镜像"),
    NOTICE_OF_CRITICAL_CONDITION = Get(Isaac.GetItemIdByName("Notice of Critical Condition")) or Isaac.GetItemIdByName("病危通知书"),
    OCEANUS_SOUL = Get(Isaac.GetItemIdByName("Oceanus' Soul")) or Isaac.GetItemIdByName("俄刻阿诺斯之魂"),
    ORDER = Get(Isaac.GetItemIdByName("Order")) or Isaac.GetItemIdByName("秩序"),
    OVERLOAD_BATTERY = Get(Isaac.GetItemIdByName("Overload Battery")) or Isaac.GetItemIdByName("过载电池"),
    PEELED_BANANA = Get(Isaac.GetItemIdByName("Peeled Banana")) or Isaac.GetItemIdByName("剥皮香蕉"),
    PHILOSOPHERS_STAFF = Get(Isaac.GetItemIdByName("Philosopher's Staff")) or Isaac.GetItemIdByName("贤者权杖"),
    PLANETARIUM_TELESCOPE = Get(Isaac.GetItemIdByName("Planetarium Telescope")) or Isaac.GetItemIdByName("星象望远镜"),
    RECON_VISION = Get(Isaac.GetItemIdByName("Recon Vision")) or Isaac.GetItemIdByName("洞察视界"),
    REWIND = Get(Isaac.GetItemIdByName("Rewind")) or Isaac.GetItemIdByName("倒带"),
    RUBY = Get(Isaac.GetItemIdByName("Ruby")) or Isaac.GetItemIdByName("红宝石"),
    SCAPEGOAT = Get(Isaac.GetItemIdByName("Scapegoat")) or Isaac.GetItemIdByName("替罪羊"),
    SINISTER_PACT = Get(Isaac.GetItemIdByName("Sinister Pact")) or Isaac.GetItemIdByName("邪恶契约"),
    STICKY_BALL = Get(Isaac.GetItemIdByName("Sticky Ball")) or Isaac.GetItemIdByName("粘性球"),
    STRANGE_SYRINGE = Get(Isaac.GetItemIdByName("Strange Syringe")) or Isaac.GetItemIdByName("奇怪的针筒"),
    SUSPICIOUS_STEW = Get(Isaac.GetItemIdByName("Suspicious Stew")) or Isaac.GetItemIdByName("迷之炖菜"),
    THE_GOSPEL_OF_JOHN = Get(Isaac.GetItemIdByName("The Gospel of John")) or Isaac.GetItemIdByName("约翰福音"),
    TOOL_BOX = Get(Isaac.GetItemIdByName("Tool Box")) or Isaac.GetItemIdByName("工具箱"),
    TWILIGHT_FOX = Get(Isaac.GetItemIdByName("Twilight Fox")) or Isaac.GetItemIdByName("暮光狐"),
    WAKE_UP = Get(Isaac.GetItemIdByName("Wake-up")) or Isaac.GetItemIdByName("唤醒")
}

TYU.ModTrinketIDs = {
    BETHS_SALVATION = Get(Isaac.GetTrinketIdByName("Beth's Salvation")) or Isaac.GetTrinketIdByName("伯大尼的救赎"),
    BROKEN_VISION = Get(Isaac.GetTrinketIdByName("Broken Vision")) or Isaac.GetTrinketIdByName("视力受损"),
    BROKEN_GLASS_EYE = Get(Isaac.GetTrinketIdByName("Broken Glass Eye")) or Isaac.GetTrinketIdByName("损坏的玻璃眼"),
    KEEPERS_CORE = Get(Isaac.GetTrinketIdByName("Keeper's Core")) or Isaac.GetTrinketIdByName("店主的核心"),
    LOST_BOTTLE_CAP = Get(Isaac.GetTrinketIdByName("Lost Bottle Cap")) or Isaac.GetTrinketIdByName("丢失的瓶盖"),
    STONE_CARVING_KNIFE = Get(Isaac.GetTrinketIdByName("Stone Carving Knife")) or Isaac.GetTrinketIdByName("石刻刀")
}

TYU.ModNullItemIDs = {
    BLESSED_DESTINY_EFFECT = Isaac.GetNullItemIdByName("Blessed Destiny Effect"),
    BLOOD_SACRIFICE_REVIVE = Isaac.GetNullItemIdByName("Blood Sacrifice Revive"),
    EFFERVESCENT_TABLET_EFFECT = Isaac.GetNullItemIdByName("Effervescent Tablet Effect"),
    MARRIAGE_CERTIFICATE_SUBPLAYER = Isaac.GetNullItemIdByName("Marriage Certificate Subplayer"),
    SCAPEGOAT_REVIVE = Isaac.GetNullItemIdByName("Scapegoat Revive"),
    SUSPICIOUS_STEW_EFFECT = Isaac.GetNullItemIdByName("Suspicious Stew Effect"),
    RUBY_EFFECT = Isaac.GetNullItemIdByName("Ruby Effect"),
    WARFARIN_BLACK_CANDLE = Isaac.GetNullItemIdByName("Warfarin Black Candle"),
    WARFARIN_CARD_READING = Isaac.GetNullItemIdByName("Warfarin Card Reading"),
    WARFARIN_CEREMONIAL_ROBES = Isaac.GetNullItemIdByName("Warfarin Ceremonial Robes"),
    WARFARIN_ESAU_JR_HAIR = Isaac.GetNullItemIdByName("Warfarin Esau Jr Hair"),
    WARFARIN_FROZEN_HAIR = Isaac.GetNullItemIdByName("Warfarin Frozen Hair"),
    WARFARIN_FROZEN_HAIR_2 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 2"),
    WARFARIN_FROZEN_HAIR_3 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 3"),
    WARFARIN_FROZEN_HAIR_4 = Isaac.GetNullItemIdByName("Warfarin Frozen Hair 4"),
    WARFARIN_GUPPY_WINGS = Isaac.GetNullItemIdByName("Warfarin Guppy Wings"),
    WARFARIN_HAEMOLACRIA = Isaac.GetNullItemIdByName("Warfarin Haemolacria"),
    WARFARIN_HAIR = Isaac.GetNullItemIdByName("Warfarin Hair"),
    WARFARIN_LEO = Isaac.GetNullItemIdByName("Warfarin Leo"),
    WARFARIN_MAGIC_8_BALL = Isaac.GetNullItemIdByName("Warfarin Magic 8 Ball"),
    WARFARIN_MOMS_WIG = Isaac.GetNullItemIdByName("Warfarin Moms Wig"),
    WARFARIN_REVERSE_EMPRESS = Isaac.GetNullItemIdByName("Warfarin Reverse Empress"),
    WARFARIN_TAURUS = Isaac.GetNullItemIdByName("Warfarin Taurus"),
    WARFARIN_WINGS = Isaac.GetNullItemIdByName("Warfarin Wings")
}

TYU.ModPillEffectIDs = {
    BAIT_AND_SWITCH = Get(Isaac.GetPillEffectByName("Bait and Switch")) or Isaac.GetPillEffectByName("偷天换日")
}

TYU.ModPlayerIDs = {
    WARFARIN = Isaac.GetPlayerTypeByName("Warfarin")
}

TYU.ModEntityFlags = {
    FLAG_NO_PAUSE = 1 << 60
}

TYU.ModProjectileFlags = {
    TEAR_BELONGTOPLAYER = 1 << 60,
    TEAR_HEPHAESTUSSOUL = 1 << 61,
    TEAR_HEPHAESTUSSOUL_X = 1 << 62
}

TYU.ModRoomIDs = {
    GUILT_DEVIL_ROOMS = {},
    ICU_ROOMS = {},
    WARFARIN_BLACK_MARKETS = {},
    WAKE_UP_MAIN_ROOM = -1
}

TYU.ModSoundIDs = {
    WARFARIN_PLAYER_HURT = Isaac.GetSoundIdByName("Warfarin Player Hurt")
}

TYU.ModTearFlags = {
    TEAR_TRAILING = BitSet128(0, 1 << 24),
    TEAR_EXPLOSION_MASTER = BitSet128(0, 1 << 24),
    TEAR_TRAILED = BitSet128(0, 1 << 25),
    TEAR_FALLENSKY = BitSet128(0, 1 << 26),
    TEAR_STICKYBALL = BitSet128(0, 1 << 27)
}

TYU.ModItemPoolIDs = {
    ILLNESS = Isaac.GetPoolIdByName("tyuIllness")
}

TYU.TearVariantPriority = {
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
    [TYU.ModEntityIDs.STICKY_BALL_TEAR.Variant] = 4,
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