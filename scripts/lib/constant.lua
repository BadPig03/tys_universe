local function IsValidID(num)
    if num == -1 then
        return false
    end
    return num
end

local function GetAchievementInfo(name)
    return Isaac.GetAchievementIdByName(name)
end

local function GetBackdropInfo(name)
    return Isaac.GetBackdropIdByName(name)
end

local function GetCardInfo(en, zh)
    return IsValidID(Isaac.GetCardIdByName(en)) or Isaac.GetCardIdByName(zh)
end

local function GetFoodInfo(name)
    return Isaac.GetEntitySubTypeByName(name)
end

local function GetEnchantmentInfo(name)
    return Isaac.GetNullItemIdByName(name)
end

local function GetEntityInfos(name)
    local type = Isaac.GetEntityTypeByName(name)
    local variant = Isaac.GetEntityVariantByName(name)
    local subType = Isaac.GetEntitySubTypeByName(name)
    return { Type = type, Variant = variant, SubType = subType }
end

local function GetItemInfo(en, zh)
    return IsValidID(Isaac.GetItemIdByName(en)) or Isaac.GetItemIdByName(zh)
end

local function GetTrinketInfo(en, zh)
    return IsValidID(Isaac.GetTrinketIdByName(en)) or Isaac.GetTrinketIdByName(zh)
end

local function GetNullItemInfo(name)
    return Isaac.GetNullItemIdByName(name)
end

local function GetPillInfo(en, zh)
    return IsValidID(Isaac.GetPillEffectByName(en)) or Isaac.GetPillEffectByName(zh)
end

local function GetPlayerInfo(name)
    return Isaac.GetPlayerTypeByName(name)
end

local function GetGiantBookInfo(name)
    return Isaac.GetGiantBookIdByName(name)
end

local function GetSoundInfo(name)
    return Isaac.GetSoundIdByName(name)
end

local function GetItemPoolInfo(name)
    return Isaac.GetPoolIdByName(name)
end

TYU.ModAchievementIDs = {
    PROMPT_READ = GetAchievementInfo("prompt_read")
}

TYU.ModBackdropIDs = {
    ICU = GetBackdropInfo("tyuniverse_icu")
}

TYU.ModCardIDs = {
    ENCHANTED_CARD = GetCardInfo("Enchanted Card", "附魔卡"),
    GLOWING_HOURGLASS_SHARD = GetCardInfo("Glowing Hourglass Shard", "发光沙漏碎片")
}

TYU.ModFoodItemIDs = {
    FOODS = GetFoodInfo("Foods (food item)"),
    APPLE = GetFoodInfo("Apple (food item)"),
    BAKED_POTATO = GetFoodInfo("Baked Potato (food item)"),
    BEETROOT = GetFoodInfo("Beetroot (food item)"),
    BROWN_MUSHROOM = GetFoodInfo("Brown Mushroom (food item)"),
    CARROT = GetFoodInfo("Carrot (food item)"),
    CHORUS_FRUIT = GetFoodInfo("Chorus Fruit (food item)"),
    COCOA_BEANS = GetFoodInfo("Cocoa Beans (food item)"),
    DRIED_KELP = GetFoodInfo("Dried Kelp (food item)"),
    GLOW_BERRIES = GetFoodInfo("Glow Berries (food item)"),
    GOLDEN_APPLE = GetFoodInfo("Golden Apple (food item)"),
    GOLDEN_CARROT = GetFoodInfo("Golden Carrot (food item)"),
    MELON_SLICE = GetFoodInfo("Melon Slice (food item)"),
    POTATO = GetFoodInfo("Potato (food item)"),
    RED_MUSHROOM = GetFoodInfo("Red Mushroom (food item)"),
    SWEET_BERRIES = GetFoodInfo("Sweet Berries (food item)"),
    WHEAT = GetFoodInfo("Wheat (food item)"),
    CABBAGE = GetFoodInfo("Cabbage (food item)"),
    ONION = GetFoodInfo("Onion (food item)"),
    PUMPKIN_SLICE = GetFoodInfo("Pumpkin Slice (food item)"),
    TOMATO = GetFoodInfo("Tomato (food item)"),
    MONSTER_MEAT = GetFoodInfo("Monster Meat (food item)")
}

TYU.ModEnchantmentIDs = {
    AQUA_LORD = GetEnchantmentInfo("Aqua Lord"),
    BANE_OF_ARTHROPODS = GetEnchantmentInfo("Bane Of Arthropods"),
    BLAST_PROTECTION = GetEnchantmentInfo("Blast Protection"),
    CHAMPION_KILLER = GetEnchantmentInfo("Champion Killer"),
    CURSE_OF_BINDING = GetEnchantmentInfo("Curse Of Binding"),
    CURSE_OF_SALVAGING = GetEnchantmentInfo("Curse Of Salvaging"),
    CURSE_OF_VANISHING = GetEnchantmentInfo("Curse Of Vanishing"),
    FIRE_ASPECT = GetEnchantmentInfo("Fire Aspect"),
    FIRE_PROTECTION = GetEnchantmentInfo("Fire Protection"),
    FORTUNE = GetEnchantmentInfo("Fortune"),
    KNOCKBACK = GetEnchantmentInfo("Knockback"),
    LOOTING = GetEnchantmentInfo("Looting"),
    PROJECTILE_PROTECTION = GetEnchantmentInfo("Projectile Protection"),
    SMITE = GetEnchantmentInfo("Smite"),
    SPIKE_PROTECTION = GetEnchantmentInfo("Spike Protection"),
    SUPER_SONIC = GetEnchantmentInfo("Super Sonic"),
    THORNS = GetEnchantmentInfo("Thorns")
}

TYU.ModEntityIDs = {
    BLAZE_FLY = GetEntityInfos("Blaze Fly"),
    BOBS_STOMACH_CHARGEBAR = GetEntityInfos("Bobs Stomach ChargeBar"),
    CHEF_BEGGAR = GetEntityInfos("Chef Beggar"),
    COLLAPSE_EFFECT = GetEntityInfos("Collapse Effect"),
    CROWN_OF_KINGS_EFFECT = GetEntityInfos("Crown of Kings Effect"),
    CURSED_PENNY = GetEntityInfos("Cursed Penny"),
    FAKE_PICKUP = GetEntityInfos("Fake Pickup"),
    FALLEN_SKY_SWORD = GetEntityInfos("Fallen Sky Sword"),
    FOODS_FOOD_ITEM = GetEntityInfos("Foods (food item)"),
    HEALING_BEGGAR = GetEntityInfos("Healing Beggar"),
    HEPHAESTUS_SOUL_CHARGEBAR = GetEntityInfos("Hephaestus Soul ChargeBar"),
    ICU_BED = GetEntityInfos("ICU Bed"),
    LANDMINE = GetEntityInfos("Landmine"),
    LASER_ORB = GetEntityInfos("Laser Orb"),
    MAGNIFIER = GetEntityInfos("Magnifier"),
    MEAT_EFFIGY = GetEntityInfos("Meat Effigy"),
    MEAT_EFFIGY_SOUL = GetEntityInfos("Meat Effigy Soul"),
    MEAT_EFFIGY_BROKEN = GetEntityInfos("Meat Effigy Broken"),
    STICKY_BALL_TEAR = GetEntityInfos("Sticky Ball Tear"),
    STICKY_BALL_DIP_LEVEL_1 = GetEntityInfos("Sticky Ball Dip Level 1"),
    STICKY_BALL_DIP_LEVEL_2 = GetEntityInfos("Sticky Ball Dip Level 2"),
    STICKY_BALL_DIP_LEVEL_3 = GetEntityInfos("Sticky Ball Dip Level 3"),
    STICKY_BALL_SQUIRT_LEVEL_1 = GetEntityInfos("Sticky Ball Squirt Level 1"),
    STICKY_BALL_SQUIRT_LEVEL_2 = GetEntityInfos("Sticky Ball Squirt Level 2"),
    STICKY_BALL_SQUIRT_LEVEL_3 = GetEntityInfos("Sticky Ball Squirt Level 3"),
    TOOL_BOX = GetEntityInfos("Tool Box"),
    TWILIGHT_FOX = GetEntityInfos("Twilight Fox"),
    TWILIGHT_FOX_HALO = GetEntityInfos("Twilight Fox Halo"),
    OCEANUS_SOUL_CHARGEBAR = GetEntityInfos("Oceanus Soul ChargeBar")
}

TYU.ModItemIDs = {
    ABSENCE_NOTE = GetItemInfo("Absence Note", "请假条"),
    ABSOLUTION = GetItemInfo("Absolution", "赦罪"),
    ANOREXIA = GetItemInfo("Anorexia", "厌食症"),
    ATONEMENT_VOUCHER = GetItemInfo("Atonement Voucher", "赎罪券"),
    BEGGAR_MASK = GetItemInfo("Beggar Mask", "丐帮面具"),
    BLAZE_FLY = GetItemInfo("Blaze Fly", "烈焰苍蝇"),
    BLESSED_DESTINY = GetItemInfo("Blessed Destiny", "神圣命运"),
    BLOOD_SACRIFICE = GetItemInfo("Blood Sacrifice", "鲜血献祭"),
    BLOOD_SAMPLE = GetItemInfo("Blood Sample", "血液样本"),
    BLOODY_DICE = GetItemInfo("Bloody Dice", "血之骰"),
    BOBS_STOMACH = GetItemInfo("Bob's Stomach", "鲍勃的胃"),
    BONE_IN_FISH_STEAK = GetItemInfo("Bone-in Fish Steak", "带骨鱼排"),
    CHEF_HAT = GetItemInfo("Chef Hat", "厨师帽"),
    CHOCOLATE_PANCAKE = GetItemInfo("Chocolate Pancake", "巧克力煎饼"),
    COLLAPSE = GetItemInfo("Collapse", "坍缩"),
    CONJUNCTIVITIS = GetItemInfo("Conjunctivitis", "结膜炎"),
    CONSERVATIVE_TREATMENT = GetItemInfo("Conservative Treatment", "保守疗法"),
    CORNUCOPIA = GetItemInfo("Cornucopia", "丰饶羊角"),
    CROWN_OF_KINGS = GetItemInfo("Crown of Kings", "主宰之冠"),
    CURSED_DICE = GetItemInfo("Cursed Dice", "被诅咒的骰子"),
    CURSED_TREASURE = GetItemInfo("Cursed Treasure", "被诅咒的宝藏"),
    EFFERVESCENT_TABLET = GetItemInfo("Effervescent Tablet", "泡腾片"),
    ENCHANTED_BOOK = GetItemInfo("Enchanted Book", "附魔书"),
    EXPIRED_GLUE = GetItemInfo("Expired Glue", "过期胶水"),
    EXPLOSION_MASTER = GetItemInfo("Explosion Master", "爆炸大师"),
    FALLEN_SKY = GetItemInfo("Fallen Sky", "天坠"),
    GUILT = GetItemInfo("Guilt", "罪孽"),
    GUPPYS_FOOD = GetItemInfo("Guppy's Food", "嗝屁猫的罐头"),
    HADES_BLADE = GetItemInfo("Hades Blade", "冥府之刃"),
    HEPHAESTUS_SOUL = GetItemInfo("Hephaestus' Soul", "赫菲斯托斯之魂"),
    LANDMINE = GetItemInfo("Landmine", "地雷"),
    LASER_BLASTER = GetItemInfo("Laser Blaster", "激光发射器"),
    LIGHT_SWITCH = GetItemInfo("Light Switch", "光开关"),
    MAGNIFIER = GetItemInfo("Magnifier", "放大镜"),
    MARRIAGE_CERTIFICATE = GetItemInfo("Marriage Certificate", "结婚证明"),
    MIRRORING_SHARD = GetItemInfo("Mirroring Shard", "镜像碎块"),
    MIRRORING = GetItemInfo("Mirroring", "镜像"),
    NOTICE_OF_CRITICAL_CONDITION = GetItemInfo("Notice of Critical Condition", "病危通知书"),
    OCEANUS_SOUL = GetItemInfo("Oceanus' Soul", "俄刻阿诺斯之魂"),
    ORDER = GetItemInfo("Order", "秩序"),
    OVERLOAD_BATTERY = GetItemInfo("Overload Battery", "过载电池"),
    PEELED_BANANA = GetItemInfo("Peeled Banana", "剥皮香蕉"),
    PHILOSOPHERS_STAFF = GetItemInfo("Philosopher's Staff", "贤者权杖"),
    PLANETARIUM_TELESCOPE = GetItemInfo("Planetarium Telescope", "星象望远镜"),
    RECON_VISION = GetItemInfo("Recon Vision", "洞察视界"),
    REWIND = GetItemInfo("Rewind", "倒带"),
    RUBY = GetItemInfo("Ruby", "红宝石"),
    SCAPEGOAT = GetItemInfo("Scapegoat", "替罪羊"),
    SINISTER_PACT = GetItemInfo("Sinister Pact", "邪恶契约"),
    STICKY_BALL = GetItemInfo("Sticky Ball", "粘性球"),
    STRANGE_SYRINGE = GetItemInfo("Strange Syringe", "奇怪的针筒"),
    SUSPICIOUS_STEW = GetItemInfo("Suspicious Stew", "迷之炖菜"),
    THE_GOSPEL_OF_JOHN = GetItemInfo("The Gospel of John", "约翰福音"),
    TOOL_BOX = GetItemInfo("Tool Box", "工具箱"),
    TWILIGHT_FOX = GetItemInfo("Twilight Fox", "暮光狐"),
    WAKE_UP = GetItemInfo("Wake-up", "唤醒")
}

TYU.ModTrinketIDs = {
    BETHS_SALVATION = GetTrinketInfo("Beth's Salvation", "伯大尼的救赎"),
    BROKEN_VISION = GetTrinketInfo("Broken Vision", "视力受损"),
    BROKEN_GLASS_EYE = GetTrinketInfo("Broken Glass Eye", "损坏的玻璃眼"),
    KEEPERS_CORE = GetTrinketInfo("Keeper's Core", "店主的核心"),
    LOST_BOTTLE_CAP = GetTrinketInfo("Lost Bottle Cap", "丢失的瓶盖"),
    MEAL_TICKET = GetTrinketInfo("Meal Ticket", "餐券"),
    STONE_CARVING_KNIFE = GetTrinketInfo("Stone Carving Knife", "石刻刀")
}

TYU.ModNullItemIDs = {
    BLESSED_DESTINY_EFFECT = GetNullItemInfo("Blessed Destiny Effect"),
    BLOOD_SACRIFICE_REVIVE = GetNullItemInfo("Blood Sacrifice Revive"),
    EFFERVESCENT_TABLET_EFFECT = GetNullItemInfo("Effervescent Tablet Effect"),
    MARRIAGE_CERTIFICATE_SUBPLAYER = GetNullItemInfo("Marriage Certificate Subplayer"),
    SCAPEGOAT_REVIVE = GetNullItemInfo("Scapegoat Revive"),
    SUSPICIOUS_STEW_EFFECT = GetNullItemInfo("Suspicious Stew Effect"),
    RUBY_EFFECT = GetNullItemInfo("Ruby Effect"),
    WARFARIN_BLACK_CANDLE = GetNullItemInfo("Warfarin Black Candle"),
    WARFARIN_CARD_READING = GetNullItemInfo("Warfarin Card Reading"),
    WARFARIN_CEREMONIAL_ROBES = GetNullItemInfo("Warfarin Ceremonial Robes"),
    WARFARIN_ESAU_JR_HAIR = GetNullItemInfo("Warfarin Esau Jr Hair"),
    WARFARIN_FROZEN_HAIR = GetNullItemInfo("Warfarin Frozen Hair"),
    WARFARIN_FROZEN_HAIR_2 = GetNullItemInfo("Warfarin Frozen Hair 2"),
    WARFARIN_FROZEN_HAIR_3 = GetNullItemInfo("Warfarin Frozen Hair 3"),
    WARFARIN_FROZEN_HAIR_4 = GetNullItemInfo("Warfarin Frozen Hair 4"),
    WARFARIN_GUPPY_WINGS = GetNullItemInfo("Warfarin Guppy Wings"),
    WARFARIN_HAEMOLACRIA = GetNullItemInfo("Warfarin Haemolacria"),
    WARFARIN_HAIR = GetNullItemInfo("Warfarin Hair"),
    WARFARIN_LEO = GetNullItemInfo("Warfarin Leo"),
    WARFARIN_MAGIC_8_BALL = GetNullItemInfo("Warfarin Magic 8 Ball"),
    WARFARIN_MOMS_WIG = GetNullItemInfo("Warfarin Moms Wig"),
    WARFARIN_REVERSE_EMPRESS = GetNullItemInfo("Warfarin Reverse Empress"),
    WARFARIN_TAURUS = GetNullItemInfo("Warfarin Taurus"),
    WARFARIN_WINGS = GetNullItemInfo("Warfarin Wings")
}

TYU.ModPillEffectIDs = {
    BAIT_AND_SWITCH = GetPillInfo("Bait and Switch", "偷天换日")
}

TYU.ModPlayerIDs = {
    WARFARIN = GetPlayerInfo("Warfarin")
}

TYU.ModGiantBookIDs = {
    THE_GOSPEL_OF_JOHN = GetGiantBookInfo("TheGospelOfJohnGiantBook"),
    WARFARIN_IN = GetGiantBookInfo("WarfarinInGiantBook"),
    WARFARIN_OUT = GetGiantBookInfo("WarfarinOutGiantBook")
}

TYU.ModSoundIDs = {
    WARFARIN_PLAYER_HURT = GetSoundInfo("Warfarin Player Hurt")
}

TYU.ModItemPoolIDs = {
    ILLNESS = GetItemPoolInfo("tyuIllness")
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

TYU.ModTearFlags = {
    TEAR_TRAILING = BitSet128(0, 1 << 24),
    TEAR_EXPLOSION_MASTER = BitSet128(0, 1 << 24),
    TEAR_TRAILED = BitSet128(0, 1 << 25),
    TEAR_FALLENSKY = BitSet128(0, 1 << 26),
    TEAR_STICKYBALL = BitSet128(0, 1 << 27)
}

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
    GLITCHED_ITEM_ID = 4294967295,
    COLOR_GREEN = Color(0.5, 0.9, 0.4, 1, 0, 0, 0)
}

TYU.Colors = {
    SLOWING = Color(1, 1, 1.3, 1, 0.156863, 0.156863, 0.156863),
    GREEN = Color(0.5, 0.9, 0.4, 1, 0, 0, 0),
    STICKY = Color(1, 0.65, 0.8, 0.8, 0, 0, 0),
    PINK = Color(1, 1, 1, 1, 0, 0, 0, 4, 1, 2.6, 1)
}

TYU.KColors = {
    RED = KColor(1, 0, 0, 1),
    WHITE = KColor(1, 1, 1, 1)
}