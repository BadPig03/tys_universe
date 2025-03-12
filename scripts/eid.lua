local EIDInfo = {}
local EIDLanguage = { "zh_cn", "en_us" }
local Enchantments = TYU.Enchantments
local Foods = TYU.Foods
local ModItemIDs = TYU.ModItemIDs
local ModTrinketIDs = TYU.ModTrinketIDs
local ModPillEffectIDs = TYU.ModPillEffectIDs
local ModFoodItemIDs = TYU.ModFoodItemIDs
local ModPlayerIDs = TYU.ModPlayerIDs
local ModCardIDs = TYU.ModCardIDs
local ModEntityIDs = TYU.ModEntityIDs
local ModItemPoolIDs = TYU.ModItemPoolIDs
local ModEnchantmentInfos = TYU.ModEnchantmentInfos

EIDInfo.Collectibles = {
    [ModItemIDs.ABSENCE_NOTE] = {
        {
            Name = "请假条",
            Desc = "#进入新的{{ChallengeRoom}}挑战房、{{BossRushRoom}}头目挑战房或头目车轮战房时会生成一张床"..
            "#上述房间的总波次数量减半并向上取整"
        },
        {
            Name = "Absence Note",
            Desc = "#A bed will spawn when entering a new {{ChallengeRoom}}challenge room or {{BossRushRoom}}boss challenge room"..
            "#The total number of waves in the above room is halved and rounded up"
        }
    },
    [ModItemIDs.ABSOLUTION] = {
        {
            Name = "赦罪",
            Desc = "#{{ArrowUp}} 非自伤的伤害均视作自伤"..
            "#原本就属于自伤的伤害只造成一半伤害，最低半颗心"..
            "#免疫{{Collectible577}}达摩克利斯之剑的伤害"
        },
        {
            Name = "Absolution",
            Desc = "#{{ArrowUp}} All damage taken from any source is treated as self-damage"..
            "#Damages that were originally self-damage deal only half damage to Isaac, with a minimum of half a heart"..
            "#Immune to {{Collectible577}}Damocles"
        }
    },
    [ModItemIDs.ANOREXIA] = {
        {
            Name = "厌食症",
            Desc = "#{{Heart}} 触发一次\"呕血\"效果"..
            "#自动重置\"食物\"标签的道具"..
            "#{{Warning}} 被{{Collectible664}}大胃王覆盖"
        },
        {
            Name = "Anorexia",
            Desc = "#{{Heart}} Triggers the \"Hematemesis\" effect once"..
            "#Rerolls any item which contains the \"food\" tag"..
            "#{{Warning}} Overriden by the {{Collectible664}}Binge Eater"
        }
    },
    [ModItemIDs.ATONEMENT_VOUCHER] = {
        {
            Name = "赎罪券",
            Desc = "#{{AngelChance}} 本层天使房的几率为100%"..
            "#{{Warning}} 下一层失去赎罪券"..
            "#{{DevilChance}} 若进行过恶魔交易，则改为获得{{Collectible673}}赎罪"
        },
        {
            Name = "Atonement Voucher",
            Desc = "#{{AngelChance}} Causes the Angel Room to always spawn for the current floor"..
            "#{{Warning}} The item disappears on next floor"..
            "#{{DevilChance}} If a Devil Deal was taken previously, grants a {{Collectible673}}Redemption instead"
        }
    },
    [ModItemIDs.BEGGAR_MASK] = {
        {
            Name = "丐帮面具",
            Desc = "#部分房间第一次进入时会生成一个对应的乞丐"..
            "#当乞丐因生成道具或饰品而离开时，有概率再次生成该乞丐"
        },
        {
            Name = "Beggar Mask",
            Desc = "#Some rooms will spawn a corresponding beggar the first time Isaac enters"..
            "#When a beggar leaves after dropping an item or trinket, there is a chance that the beggar will respawn"
        }
    },
    [ModItemIDs.BLAZE_FLY] = {
        {
            Name = "烈焰苍蝇",
            Desc = "#斜向移动"..
            "#可阻挡弹幕"..
            "#{{Damage}} 每秒造成42点火焰伤害"..
            "#{{Burning}} 移动时留下火焰"
        },
        {
            Name = "Blaze Fly",
            Desc = "#Moves diagonally"..
            "#Blocks enemy projectiles"..
            "#{{Damage}} Deals 42 fire contact damage per second"..
            "#{{Burning}} Leaves flames when moving"
        }
    },
    [ModItemIDs.BLESSED_DESTINY] = {
        {
            Name = "神圣命运",
            Desc = "#{{AngelRoom}} 首次进入房间时有概率变为教堂的样式，道具池变为天使房道具池"..
            "#{{AngelChance}} 恶魔房开启率转换为天使房开启率"..
            "#{{Warning}} 离开房间后恢复为原来的样式，在教堂层始终生效"
        },
        {
            Name = "Blessed Destiny",
            Desc = "#{{AngelRoom}} Upon first entering a room, there is a chance its appearance will change to a Cathedral theme, and the item pool will be the Angel Room item pool"..
            "#{{AngelChance}} The Devil Room chance is converted to an Angel Room chance"..
            "#{{Warning}} After leaving the room, it reverts to its original appearance. This effect is always active in the Cathedral"
        }
    },
    [ModItemIDs.BLOOD_SACRIFICE] = {
        {
            Name = "鲜血献祭",
            Desc = "#消耗1心之容器或2魂心生成肉块雕像并+0.4伤害修正"..
            "#角色死亡时从本层最后放置的肉块雕像处复活"..
            "#肉块雕像被炸毁后掉落一颗骨心或魂心",
            BookOfVirtues = "生成血量为8，伤害为3的红色魂火",
            BookOfBelial = "额外获得0.4伤害提升",
            CarBattery = "无效果"
        },
        {
            Name = "Blood Sacrifice",
            Desc = "#Consumes 1 heart container or 2 soul hearts to spawn a Meat Effigy, and grants a +0.4 damage modifier"..
            "#Isaac respawns at the last placed Meat Effigy on the current floor upon death"..
            "#After being bombed, the Meat Effigy drops a bone heart or a soul heart",
            BookOfVirtues = "Spawns a red wisp with 8 health and can deal 3 damage to enemies",
            BookOfBelial = "Grants extra +0.4 damage modifier",
            CarBattery = "No Effect"
        }
    },
    [ModItemIDs.BLOOD_SAMPLE] = {
        {
            Name = "血液样本",
            Desc = "#{{EmptyHeart}} +1空心之容器"..
            "#只能通过造成伤害进行充能",
            CarBattery = "无效果"
        },
        {
            Name = "Blood Sample",
            Desc = "#{{EmptyHeart}} Grants an empty health container"..
            "#Can only be charged by dealing damage to enemies",
            CarBattery = "No Effect"
        }
    },
    [ModItemIDs.BLOODY_DICE] = {
        {
            Name = "血之骰",
            Desc = "#重置离角色最近的恶魔交易，并使其免费"..
            "#只能通过造成伤害进行充能",
            CarBattery = "无效果"
        },
        {
            Name = "Bloody Dice",
            Desc = "#Rerolls and makes the nearest devil deal free"..
            "#Can only be charged by dealing damage to enemies",
            CarBattery = "No Effect"
        }
    },
    [ModItemIDs.BOBS_STOMACH] = {
        {
            Name = "鲍勃的胃",
            Desc = "#{{Chargeable}} 蓄力一段时间可射出爆炸泪弹"..
            "#{{Damage}} 泪弹造成15+250%角色伤害"
        },
        {
            Name = "Bob's Stomach",
            Desc = "#{{Chargeable}} Charging for a while will fire an explosive and poisoning tear"..
            "#{{Damage}} Deals damage equal to 15 + 250% of Isaac's damage"
        }
    },
    [ModItemIDs.BONE_IN_FISH_STEAK] = {
        {
            Name = "带骨鱼排",
            Desc = "#{{BoneHeart}} 获得一个骨心"..
            "#每吞下一个饰品时："..
            "#{{Collectible486}} 使角色受伤但不掉血"..
            "#{{Tears}} +0.5射速修正",
            BingeEater = "{{ArrowUp}} +1额外伤害"..
            "#{{ArrowUp}} +1幸运"..
            "#{{ArrowDown}} -0.03移速"
        },
        {
            Name = "Bone-in Fish Steak",
            Desc = "#{{BoneHeart}} Grants a bone heart"..
            "#Whenever Isaac consumes any trinket: "..
            "#{{Collectible486}} Causes Isaac to take damage without taking away health"..
            "#{{Tears}} +0.5 Fire rate",
            BingeEater = "{{ArrowUp}} +1 Extra damage"..
            "#{{ArrowUp}} +1 Luck"..
            "#{{ArrowDown}} -0.03 Speed"
        }
    },
    [ModItemIDs.CHEF_HAT] = {
        {
            Name = "厨师帽",
            Desc = "#在每层的初始房间生成一个厨师乞丐"..
            "#击杀敌人有概率掉落食材"..
            "#{{Warning}} 角色可储存最多4个食材"
        },
        {
            Name = "Chef Hat",
            Desc = "#Spawns a chef beggar in the starting room of each floor"..
            "#Enemies have chance to drop a food item on death"..
            "#{{Warning}} Isaac can only store up to 4 food items"
        }
    },
    [ModItemIDs.CHOCOLATE_PANCAKE] = {
        {
            Name = "巧克力煎饼",
            Desc = "#{{EmptyHeart}} +1空心之容器"..
            "#{{BlackHeart}} 击杀敌人时有2.5%概率掉落一颗黑心"..
            "#{{Warning}} 概率不可叠加",
            BingeEater = "{{ArrowUp}} +1幸运"..
            "#{{ArrowUp}} +0.2弹速"..
            "#{{ArrowDown}} -0.03移速"
        },
        {
            Name = "Chocolate Pancake",
            Desc = "#{{EmptyHeart}} Grants an empty heart container"..
            "#{{BlackHeart}} Enemies have a 2.5% chance to drop a black heart on death"..
            "#{{Warning}} The chance is not stackable",
            BingeEater = "{{ArrowUp}} +1 Luck"..
            "#{{ArrowUp}} +0.2 Shotspeed"..
            "#{{ArrowDown}} -0.03 Speed"
        }
    },
    [ModItemIDs.COLLAPSE] = {
        {
            Name = "坍缩",
            Desc = "#{{Magnetize}} 角色会吸引周围的实体"..
            "#{{HolyMantle}} 敌人无法碰撞角色，且接触角色时会受到伤害"..
            "#免疫来自炸弹的爆炸伤害和敌人的接触伤害"
        },
        {
            Name = "Collapse",
            Desc = "#{{Magnetize}} Isaac attracts nearby entities"..
            "#{{HolyMantle}} Enemies are not able to collide with Isaac and nearby enemies will take damage"..
            "#Prevents explosion damage from bombs and contact damage from enemies"
        }
    },
    [ModItemIDs.CONJUNCTIVITIS] = {
        {
            Name = "结膜炎",
            Desc = "#泪弹会产生拖尾"..
            "#拖尾泪弹造成角色50%伤害"
        },
        {
            Name = "Conjunctivitis",
            Desc = "#Isaac's tears leave a trail"..
            "Trailing tears deal x0.5 damage"
        }
    },
    [ModItemIDs.CONSERVATIVE_TREATMENT] = {
        {
            Name = "保守疗法",
            Desc = "#{{ArrowUp}} 属性值不会低于{{Player0}}以撒的属性初始值"..
            "#{{Heart}} 补充至三颗心之容器"
        },
        {
            Name = "Conservative Treatment",
            Desc = "#{{ArrowUp}} The attribute values will not be lower than {{Player0}}Isaac's initial attribute values"..
            "#{{Heart}} Isaac is replenished to three heart containers"
        }
    },
    [ModItemIDs.CORNUCOPIA] = {
        {
            Name = "丰饶羊角",
            Desc = "#使用后，吸收角色接触的所有掉落物、道具和饰品，并转换为充能"..
            "#充能满后使用，如果当前房间内有底座道具，则为所有道具增加一个道具选择"..
            "#否则生成一个来自当前房间道具池的道具",
            BookOfVirtues = "有概率额外生成一个天使房道具",
            BookOfBelial = "有概率额外生成一个恶魔房道具",
            CarBattery = "无效果"
        },
        {
            Name = "Cornucopia",
            Desc = "#When used, absorbs all pickups, collectibles and trinkets that the player comes into contact with, and converts them into charges"..
            "#Use it when fully charged: if there are items in the current room, it adds an additional item choice to all of them; otherwise, it spawns an item from the current room's item pool",
            BookOfVirtues = "Has chance to spawn an extra Angel Room item",
            BookOfBelial = "Has chance to spawn an extra Devil Room item",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.CROWN_OF_KINGS] = {
        {
            Name = "主宰之冠",
            Desc = "#在未受到伤害的情况下，清理初始含头目的房间："..
            "#{{Collectible}} 掉落一个来自随机道具池的品质不高于3的道具"
        },
        {
            Name = "Crown of Kings",
            Desc = "#Cleaning a room containing any boss when entering without being hit:"..
            "#{{Collectible}} Spawns a collectible of at most quality 3 from random item pools"
        }
    },
    [ModItemIDs.CURSED_DICE] = {
        {
            Name = "被诅咒的骰子",
            Desc = "#重置并用{{CurseBlind}}致盲诅咒的效果遮蔽所在房间的底座道具"..
            "#已遮蔽的底座道具将被重置为诅咒硬币",
            BookOfVirtues = "有10%概率不遮蔽道具",
            BookOfBelial = "有15%概率不遮蔽道具",
            CarBattery = "无效果"
        },
        {
            Name = "Cursed Dice",
            Desc = "#Rerolls and hides the pedestal items in the room with the effect of the {{CurseBlind}} Blind Curse"..
            "#Rerolling hidden pedestal items will cause them to disappear",
            BookOfVirtues = "There is a 10% chance to not hide the item",
            BookOfBelial = "There is a 15% chance to not hide the item",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.CURSED_TREASURE] = {
        {
            Name = "被诅咒的宝藏",
            Desc = "#将所有种类的硬币替换为诅咒硬币，拾取后触发一次随机硬币系列饰品的效果"..
            "#商店内只售卖道具"
        },
        {
            Name = "Cursed Treasure",
            Desc = "#Replace all types of coins with cursed coins, picking up triggers the effect of a random coin trinket once"..
            "#Pick ups sold in the shop will be replaced with collectibles",
        }
    },
    [ModItemIDs.DARK_MASK] = {
        {
            Name = "漆黑面具",
            Desc = "#{{Damage}} 伤害修正x120%"..
            "#进入新房间时，随机指定一名敌人作为委托目标"..
            "#{{BossRoom}} 每击杀6个委托目标，头目房的道具池会随机变化一次"..
            "#{{Warning}} 委托目标会获得永久混乱效果，且击杀时生成2-4个基础掉落物，但血量提升至500%"..
            "#{{Warning}} 委托目标会在房间内仅剩自己时立刻死亡，但不计入击杀数量也不生成击杀奖励"
        },
        {
            Name = "Dark Mask",
            Desc = "#{{Damage}} x1.2 Damage multiplier"..
            "#When entering a new room, a random enemy is designated as the commission target"..
            "#{{BossRoom}} For every 6 commission targets killed, the item pool of the Boss room will change randomly once"..
            "#{{Warning}} The commission target will receive a permanent confusion effect and, upon being killed, will spawn 2-4 pick ups, but its health will increase to 500%"..
            "#{{Warning}} The commission target will die instantly when it is the only one left in the room, but it will not count toward the kill count and will not spawn kill rewards",
        }
    },
    [ModItemIDs.EFFERVESCENT_TABLET] = {
        {
            Name = "泡腾片",
            Desc = "#提供4秒以下效果："..
            "#{{ArrowUp}} x250%射速"..
            "#{{ArrowDown}} x10%移速和伤害"..
            "#{{ArrowDown}} x50%弹速"..
            "#攻击造成强力击退并击晕",
            BookOfVirtues = "生成发射击退泪弹的魂火，持续8秒",
            BookOfBelial = "改为x50%伤害",
            CarBattery = {4, 8}
        },
        {
            Name = "Effervescent Tablet",
            Desc = "#Provides the following effects for 4 seconds:"..
            "#{{ArrowUp}} x2.5 Fire rate multiplier"..
            "#{{ArrowDown}} x0.1 Move speed and damage multiplier"..
            "#{{ArrowDown}} x0.5 Shotspeed multiplier"..
            "#Isaac's attack inflicts confusion and extreme knockback",
            BookOfVirtues = "Spawns a wisp that shoots knockback tears, lasts for 8 seconds",
            BookOfBelial = "x0.5 Damage multiplier instead",
            CarBattery = {4, 8}
        }
    },
    [ModItemIDs.EXPIRED_GLUE] = {
        {
            Name = "过期胶水",
            Desc = "#硬币在生成时会被替换为黏性镍币"..
            "#{{Warning}} 替换后的硬币会在随机时间后或离开房间时消失"
        },
        {
            Name = "Expired Glue",
            Desc = "#Coins are replaced with sticky nickels when spawned",
            "#{{Warning}} The replaced coins will disappear at a random time or after leaving the room"
        }
    },
    [ModItemIDs.ENCHANTED_BOOK] = {
        {
            Name = "附魔书",
            Desc = "#获得1条随机附魔"..
            "#附魔可叠加来提升等级，但存在等级上限",
            BookOfVirtues = "额外生成一张附魔卡",
            BookOfBelial = "额外生成一张附魔卡",
            CarBattery = {1, 2}
        },
        {
            Name = "Enchanted Book",
            Desc = "#Grants a random enchantment"..
            "#The enchantment can be leveled up through stacking, but there is a level cap",
            BookOfVirtues = "Spawns an extra enchanted card",
            BookOfBelial = "Spawns an extra enchanted card",
            CarBattery = {"a random enchantment", "two random enchantments"}
        }
    },
    [ModItemIDs.EXPLOSION_MASTER] = {
        {
            Name = "爆炸大师",
            Desc = "#敌方泪弹有20%概率被替换成不伤害角色的炸弹"
        },
        {
            Name = "Explosion Master",
            Desc = "#Enemy projectiles have a 20% chance to be replaced by bombs that do no harm to Isaac"
        }
    },
    [ModItemIDs.FALLEN_SKY] = {
        {
            Name = "天坠",
            Desc = "#有10%概率发射追踪剑气泪弹，击中敌人后坠下圣剑"..
            "#圣剑会连锁一定范围的其他敌人并给予燃烧效果，4秒后坠下新的圣剑"..
            "#{{Luck}} 幸运16: 50%"
        },
        {
            Name = "Fallen Sky",
            Desc = "#There is a 10% chance to fire a sword projectile that falls a holy sword after hitting an enemy"..
            "#After hitting an enemy, the holy sword will chain other enemies within a certain range and inflict a burning effect"..
            "#After 4 seconds, another holy sword will fall down again"..
            "#{{Luck}} Luck 16: 50%"
        }
    },
    [ModItemIDs.GUILT] = {
        {
            Name = "罪孽",
            Desc = "#{{ArrowUp}} 恶魔房拥有更好的布局"..
            "#{{DevilChance}} 每次恶魔交易增加5%恶魔房开启几率"..
            "#{{Warning}} 不足两次交易后下层会移除恶魔房道具池中数个道具"..
            "#击杀坎卜斯时掉落2个恶魔房道具"
        },
        {
            Name = "Guilt",
            Desc = "{{ArrowUp}} The Devil Room owns a better layout"..
            "#{{DevilChance}} Increases the chance to open the Devil Room by 5% each devil deals"..
            "#{{Warning}} After making fewer than two deals, several items will be removed from the Devil Room item pool in the next floor"..
            "#Killing the Krampus drops 2 Devil Room items"
        }
    },
    [ModItemIDs.GUPPYS_FOOD] = {
        {
            Name = "嗝屁猫的罐头",
            Desc = "#{{ArrowUp}} +1心之容器"..
            "#{{Heart}} 治疗2红心",
            BingeEater = "{{ArrowUp}} +1运气"..
            "#{{ArrowUp}} +0.2弹速"..
            "#{{ArrowDown}} -0.03移速"
        },
        {
            Name = "Guppy's Food",
            Desc = "#{{ArrowUp}} +1 Health up"..
            "#{{Heart}} Heals 2 hearts",
            BingeEater = "{{ArrowUp}} +1 luck"..
            "#{{ArrowUp}} +0.2 Shot Speed"..
            "#{{ArrowDown}} -0.03 Speed"
        }
    },
    [ModItemIDs.HADES_BLADE] = {
        {
            Name = "冥府之刃",
            Desc = "#如果成功移除1个心之容器或3颗魂心，则获得一个来自恶魔房道具池的跟班"..
            "#{{BoneHeart}} 骨心优先",
            BookOfVirtues = "生成血量为10，伤害为2的红色魂火",
            BookOfBelial = "额外获得0.2伤害提升",
            CarBattery = "无效果"
        },
        {
            Name = "Hades Blade",
            Desc = "#{{Heart}} if successfully removed one red heart container or three soul hearts, grants a familiar from the Devil Room item pool"..
            "#{{BoneHeart}} Bone hearts have a higher priority",
            BookOfVirtues = "Spawns a red wisp with 10 health and can deal 2 damage to enemies",
            BookOfBelial = "Grants +0.2 damage up",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.HEPHAESTUS_SOUL] = {
        {
            Name = "赫菲斯托斯之魂",
            Desc = "#{{Chargeable}} 蓄力一段时间可射出一堆火焰"..
            "#{{Damage}} 火焰造成角色12+400%伤害且可以摧毁石头"..
            "#获得飞行并免疫火焰伤害"
        },
        {
            Name = "Hephaestus' Soul",
            Desc = "#{{Chargeable}} Charging for a while will release a burst of flames"..
            "#{{Damage}} The flames deal 12 + 400% of Isaac's damage and can destroy rocks"..
            "#Grants flight and is immune to fire damage"
        }
    },
    [ModItemIDs.HYPNOSIS_PERFUME] = {
        {
            Name = "魅惑香水",
            Desc = "#{{Charm}} 当敌人死亡时，有10%概率留下存在10秒的魅惑雾"..
            "#{{Charm}} 接触魅惑雾的非头目敌人会变为友好敌人，头目敌人则会被魅惑10秒"
        },
        {
            Name = "Hypnosis Perfume",
            Desc = "#{{Charm}} Enemies have a 10% chance to leave a charming smoke cloud that lasts for 10 seconds upon death"..
            "#{{Charm}} Non-boss enemies that come into contact with the charming smoke cloud will become friendly enemies, while boss enemies will be charmed for 10 seconds"
        }
    },
    [ModItemIDs.LANDMINE] = {
        {
            Name = "地雷",
            Desc = "#进入新房间时生成一些地雷"..
            "#在未清理的房间内会持续生成地雷"..
            "#{{Warning}} 地雷不会伤害角色"
        },
        {
            Name = "Landmine",
            Desc = "#Spawns some landmines when entering a new room"..
            "#Landmines will be continuously spawned in uncleared rooms"..
            "#{{Warning}} Landmines won't do damage to Isaac"
        }
    },
    [ModItemIDs.LASER_BLASTER] = {
        {
            Name = "激光发射器",
            Desc = "#生成一个缓慢移动的激光球"..
            "#它会主动攻击附近一定范围内的敌人",
            BookOfVirtues = "激光球的伤害额外增加25%",
            BookOfBelial = "激光球的伤害额外增加50%",
            CarBattery = "激光球的伤害额外增加100%"
        },
        {
            Name = "Laser Blaster",
            Desc = "#Spawns a laser orb that slowly moves"..
            "#It will automatically attack enemies within a certain range nearby",
            BookOfVirtues = "The damage of laser orb increases by 25%",
            BookOfBelial = "The damage of laser orb increases by 50%",
            CarBattery = "The damage of laser orb increases by 100%"
        }
    },
    [ModItemIDs.LIGHT_SWITCH] = {
        {
            Name = "灯光开关",
            Desc = "#{{CurseDarkness}} 使所在房间内陷入黑暗，仅保留角色周围视野"..
            "#{{Freezing}} 黑暗中的敌人会始终处于石化状态"
        },
        {
            Name = "Light Switch",
            Desc = "#{{CurseDarkness}} Cause the room to fall into darkness, leaving only Isaac's surrounding vision"..
            "#{{Freezing}} Enemies in the darkness will always be petrified"
        }
    },
    [ModItemIDs.MAGNIFIER] = {
        {
            Name = "放大镜",
            Desc = "#放大周围的敌人，导致其受到的伤害增加和碰撞变大"..
            "#自动追踪血量最少的敌人"
        },
        {
            Name = "Magnifier",
            Desc = "#Enlarges nearby enemies, causing them to take increased damage and have larger collision sizes"..
            "#Automatically tracks the enemy with the lowest health"
        }
    },
    [ModItemIDs.MARRIAGE_CERTIFICATE] = {
        {
            Name = "结婚证明",
            Desc = "#{{Player5}} 生成夏娃作为副角色，拾取的道具会转移到角色上"..
            "#夏娃死亡后变为灵魂形态，下层后复活"..
            "#下层时若未死亡，则再复制角色最后获得的三个道具"
        },
        {
            Name = "Marriage Certificate",
            Desc = "#{{Player5}} Summons Eve as a secondary character, and any items collected will be transferred to Isaac"..
            "#After Eve's death, she transforms into a spirit form and revives on the next floor"..
            "#If Eve is alive when going to the next floor, Eve duplicates the last three items Isaac obtained"
        }
    },
    [ModItemIDs.MIRRORING] = {
        {
            Name = "镜像",
            Desc = "#将正常角色转换为对应的堕化角色"..
            "#犹大和犹大之影均转换为堕化犹大"..
            "#复活的拉撒路、以扫和ff0无法转换",
            BookOfVirtues = "生成血量为6的不可发射泪弹的黑色魂火",
            BookOfBelial = "无效果",
            CarBattery = "无效果"
        },
        {
            Name = "Mirroring",
            Desc = "#Transforms the non-tainted character into the corresponding tainted character"..
            "#Both Judas and Dark Judas are transformed into Tainted Judas"..
            "#Lazarus Risen, Esau and ff0 can't be transformed",
            BookOfVirtues = "Spawns a black wisp with 6 health which can't shoot",
            BookOfBelial = "No effect",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.MIRRORING_SHARD] = {
        {
            Name = "镜像碎块",
            Desc = "#将堕化角色转换为对应的正常角色"..
            "#死亡的堕化拉撒路无法转换",
            BookOfVirtues = "生成血量为9的不可发射泪弹的白色魂火",
            BookOfBelial = "无效果",
            CarBattery = "无效果"
        },
        {
            Name = "Mirroring Shard",
            Desc = "#Transforms the tainted character into the corresponding non-tainted character"..
            "#Dead Tainted Lazarus can't be transformed",
            BookOfVirtues = "Spawns a white wisp with 9 health which can't shoot",
            BookOfBelial = "No effect",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.NOTICE_OF_CRITICAL_CONDITION] = {
        {
            Name = "病危通知书",
            Desc = "#{{Pill}} 使用正面胶囊时有概率消除一颗碎心"..
            "#每次进入新层时会获得两颗碎心，并有概率生成ICU房间"
        },
        {
            Name = "Notice Of Critical Condition",
            Desc = "#{{Pill}} Taking positive pills has chance to remove a broken heart"..
            "#Gains 2 broken hearts each time Isaac enters a new floor, with a chance to spawn an ICU room"
        }
    },
    [ModItemIDs.OCEANUS_SOUL] = {
        {
            Name = "俄刻阿诺斯之魂",
            Desc = "#{{Chargeable}} 蓄力一段时间可在房间内产生强大的水流"..
            "#{{Water}} 水流可推动敌人撞到障碍物或房间墙壁并受伤，同时对静止的敌人造成伤害"..
            "#飞行敌人仍然受到影响"
        },
        {
            Name = "Oceanus' Soul",
            Desc = "#{{Chargeable}} Charging for a while generates a powerful water flow within the room"..
            "#{{Water}} The water flow can push enemies into obstacles or room walls, causing damage, while also dealing damage to stationary enemies"..
            "#Flying enemies are still affected"
        }
    },
    [ModItemIDs.ORDER] = {
        {
            Name = "秩序",
            Desc = "#底座道具现在会从每层初始确定的道具池中产生"..
            "#生成1心、1炸弹和1钥匙"
        },
        {
            Name = "Order",
            Desc = "#All items are chosen from the item pool determined at the start of each floor"..
            "#Spawns a red heart, a bomb and a key"
        }
    },
    [ModItemIDs.OVERLOAD_BATTERY] = {
        {
            Name = "过载电池",
            Desc = "#当角色无法容纳要拾取的心掉落物时，将其转化为充能"..
            "#{{Warning}} 2{{Heart}}/{{RottenHeart}}=1{{SoulHeart}}/{{BlackHeart}}/{{EmptyBoneHeart}}=1充能，1{{GoldHeart}}/{{EternalHeart}}=12充能"
        },
        {
            Name = "Overload Battery",
            Desc = "#When Isaac can't collect the heart pick up he touches, it will be converted into charge"..
            "#{{Warning}} 2{{Heart}}/{{RottenHeart}}=1{{SoulHeart}}/{{BlackHeart}}/{{EmptyBoneHeart}}=1 charge, 1{{GoldHeart}}/{{EternalHeart}}=12 charges"
        }
    },
    [ModItemIDs.PEELED_BANANA] = {
        {
            Name = "剥皮香蕉",
            Desc = "#{{ArrowUp}} +1心之容器并治疗1红心"..
            "#{{Heart}} 进入新房间有一定概率治疗半红心",
            BingeEater = "{{ArrowUp}} +2.5射程"..
            "#{{ArrowUp}} +1幸运"..
            "#{{ArrowDown}} -0.03移速"
        },
        {
            Name = "Peeled Banana",
            Desc = "#{{ArrowUp}} +1 Health up and heals 1 red heart"..
            "#{{Heart}} Entering a new room gives a chance to heal half a red heart",
            BingeEater = "{{ArrowUp}} +2.5 Tear range"..
            "#{{ArrowUp}} +1 Luck"..
            "#{{ArrowDown}} -0.03 Speed"
        }
    },
    [ModItemIDs.PHILOSOPHERS_STAFF] = {
        {
            Name = "贤者权杖",
            Desc = "#{{ArrowUp}} 持有时，转化持有的饰品为对应金饰品"..
            "#使用后，摧毁房间内所有饰品，每次摧毁生成4-8个硬币"..
            "#击杀敌人有概率掉落饰品",
            BookOfVirtues = "有概率发射点金术眼泪",
            BookOfBelial = "额外生成3个随机硬币",
            CarBattery = "无效果"
        },
        {
            Name = "Philosopher's Staff",
            Desc = "#{{ArrowUp}} When held, transforms trinkets on Isaac into the golden version"..
            "#Upon use, consume all trinkets in the room"..
            "#For each trinket consumed, spawns 4-8 random coins"..
            "#Enemies have chance to drop a trinket on death",
            BookOfVirtues = "Has chance to fire {{Collectible202}} Midas' Touch tears",
            BookOfBelial = "Spawns 3 random coins",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.PILL_CASE] = {
        {
            Name = "胶囊盒",
            Desc = "#{{Pill}} 识别拥有的胶囊"..
            "#拾取的胶囊会变成大胶囊"
        },
        {
            Name = "Pill Case",
            Desc = "#{{Pill}} Identifies pills Isaac owns"..
            "#Pills always become horse pills when picked up"
        }
    },
    [ModItemIDs.PLANETARIUM_TELESCOPE] = {
        {
            Name = "星象望远镜",
            Desc = "#{{Card}} 生成一张'XVII-星星'卡牌"..
            "#{{Planetarium}} 根据幸运值增加星象房的基础开启概率"..
            "#{{Luck}} 每个'星星'标签道具提供+2幸运值"
        },
        {
            Name = "Planetarium Telescope",
            Desc = "#{{Card}} Spawns a tarot card 'XVII-Star'"..
            "#{{Planetarium}} Increases the base chance of Planetarium based on Luck"..
            "#{{Luck}} Each collectible with a 'star' tag grants +2 luck"
        }
    },
    [ModItemIDs.RECON_VISION] = {
        {
            Name = "洞察视界",
            Desc = "#{{CurseBlind}} 揭示所有被替换为问号的道具"..
            "#对支线层宝箱房内的道具仍然生效"
        },
        {
            Name = "Recon Vision",
            Desc = "#{{CurseBlind}} Reveals all item sprites replaced with a question mark"..
            "#Also works for the extra item on the alt path"
        }
    },
    [ModItemIDs.REWIND] = {
        {
            Name = "倒带",
            Desc = "#使用后进入一个全新房间"..
            "#此房间将会是曾进入过的特殊房间之一",
            BookOfVirtues = "有10%概率进入一个天使房",
            BookOfBelial = "有10%概率进入一个恶魔房",
            CarBattery = "无效果"
        },
        {
            Name = "Rewind",
            Desc = "#Upon use, enters a new room that will be one of the special rooms Isaac have previously visited",
            BookOfVirtues = "There is a 10% chance to randomly enter an Angel Room",
            BookOfBelial = "There is a 10% chance to randomly enter a Devil Room",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.RUBY] = {
        {
            Name = "红宝石",
            Desc = "#{{Shop}} 商店物品价格-20%到-40%"..
            "#{{Shop}} 当角色的金钱不足时，非道具物品被尖刺环绕"
        },
        {
            Name = "Ruby",
            Desc = "#{{Shop}} Shop items cost 20-40% less"..
            "#{{Shop}} When Isaac lacks enough money, consumables in shops are surrounded by spikes"
        }
    },
    [ModItemIDs.SCAPEGOAT] = {
        {
            Name = "替罪羊",
            Desc = "#死亡后在当前房间以{{Player7}}阿撒泻勒重生，并获得1颗黑心"..
            "#若角色为{{Player28}}堕化阿撒泻勒，则改为获得{{Collectible82}}深渊领主"..
            "#{{Warning}} 复活的优先级最低"
        },
        {
            Name = "Scapegoat",
            Desc = "#{{ArrowUp}} Grants Isaac an extra life"..
            "#When Isaac dies, he will respawn as {{Player7}}the Azazel permanently in the current room and receive an additional black heart"..
            "#If Isaac is {{Player28}}the Tainted Azazel, he will be granted a {{Collectible82}}Lord of the Pit instead"..
            "#{{Warning}} The revival has the lowest priority"
        }
    },
    [ModItemIDs.SINISTER_PACT] = {
        {
            Name = "邪恶契约",
            Desc = "{{BlackHeart}} +1黑心"..
            "#消耗血量进行血量交易后会立刻补货"
        },
        {
            Name = "Sinister Pact",
            Desc = "{{BlackHeart}} +1 Black heart"..
            "#Buying an item by heart containers restocks it instantly"
        }
    },
    [ModItemIDs.STICKY_BALL] = {
        {
            Name = "粘性球",
            Desc = "#有25%概率发射粘性泪弹，命中时会使敌人的粘性等级提升1级(最大5级)，且有概率生成友好的粘性液滴跟班"..
            "#{{Slow}} 拥有粘性等级的敌人会获得5秒的减速"..
            "#{{Luck}} 幸运12: 100%" 
        },
        {
            Name = "Sticky Ball",
            Desc = "#There is a 25% chance to fire sticky tears, which increase the enemy's sticky level by 1 upon hit (max 5), and have a chance to spawn friendly sticky squirts"..
            "#{{Slow}} Enemies with at least 1 sticky level will be slowed for 5 seconds"..
            "#{{Luck}} Luck 12: 100%" 
        }
    },
    [ModItemIDs.STRANGE_SYRINGE] = {
        {
            Name = "奇怪的针筒",
            Desc = "#{{Heart}} 随机受到0-6次半心的伤害"..
            "#使{{Spun}}嗑药！的套装进度+3"..
            "#{{Warning}} 一次性",
            BookOfVirtues = "使{{Seraphim}}撒拉弗！的套装进度+1",
            BookOfBelial = "使{{Leviathan}}利维坦！的套装进度+1",
            CarBattery = "无效果"
        },
        {
            Name = "Strange Syringe",
            Desc = "{{Heart}} Deals 0-6 times half hearts of damage to Isaac randomly"..
            "#Increases the count by 3 items toward {{Spun}} Spun transformation progress"..
            "#{{Warning}} SINGLE USE",
            BookOfVirtues = "Increases the count by 1 item toward {{Seraphim}} Seraphim transformation progress",
            BookOfBelial = "Increases the count by 1 item toward {{Leviathan}} Leviathan transformation progress",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.SUSPICIOUS_STEW] = {
        {
            Name = "迷之炖菜",
            Desc = "#{{ArrowUp}} 使用后获得以下效果：",
            BookOfVirtues = "获得1颗魂心",
            BookOfBelial = "获得1颗黑心",
            CarBattery = "无效果"
        },
        {
            Name = "Suspicious Stew",
            Desc = "#{{ArrowUp}} Grants the following effects after use:",
            BookOfVirtues = "Grants a soul heart",
            BookOfBelial = "Grants a black heart",
            CarBattery = "No effect"
        }
    },
    [ModItemIDs.THE_GOSPEL_OF_JOHN] = {
        {
            Name = "约翰福音",
            Desc = "#重置所在房间的底座道具为品质3/4级的天使被动道具，每重置一个就获得1/2碎心"..
            "#若即将因碎心溢出而死亡，则停止重置的过程"..
            "#若房间内没有底座道具，则消除1颗碎心",
            BookOfVirtues = "有25%概率生成一个天使房道具魂火跟班",
            BookOfBelial = "有25%概率生成一个恶魔房道具魂火跟班",
            CarBattery = {"1颗", "2颗"}
        },
        {
            Name = "The Gospel of John",
            Desc = "#Rerolls the collectibles in the current room to quality 3/4 Angel Room passive items. For each reset, Isaac gains 1/2 broken hearts",
            "#If Issac is about to die due to broken heart overflow, the reroll process will stop"..
            "#If there are no collectibles in the room, remove 1 broken heart",
            BookOfVirtues = "Has 25% chance to spawn an Angel item wisp",
            BookOfBelial = "Has 25% chance to spawn a Devil item wisp",
            CarBattery = {"1 broken heart", "2 broken hearts"}
        }
    },
    [ModItemIDs.TOOL_BOX] = {
        {
            Name = "工具箱",
            Desc = "#生成一个工具箱跟班"..
            "#{{Card}} 每清理五个房间后生成一张随机特殊卡牌"
        },
        {
            Name = "Tool Box",
            Desc = "#Spawns a tool box familiar"..
            "#{{Card}} Randomly spawns a special card every 5 rooms"
        }
    },
    [ModItemIDs.TWILIGHT_FOX] = {
        {
            Name = "暮光狐",
            Desc = "#生成一个跟随角色且会阻挡敌人泪弹的跟班"..
            "#跟班拥有两个光圈，可以吸收敌方泪弹和使敌人虚弱"..
            "#{{ArrowUp}} 每吸收一个泪弹，虚弱光圈的半径会增大"..
            "#{{Warning}} 进入新层后会重置半径"
        },
        {
            Name = "Twilight Fox",
            Desc = "#Spawns a familiar that follows Isaac and blocks enemy projectiles"..
            "It has two auras, capable of absorbing enemy projectiles and weakening enemies"..
            "#{{ArrowUp}} With each absorbed projectile, the radius of the weakening aura increases"..
            "#{{Warning}} The radius resets upon entering a new floor"
        }
    },
    [ModItemIDs.WAKE_UP] = {
        {
            Name = "唤醒",
            Desc = "#传送至教条房间，并生成3个最低品质为3的攻击道具"..
            "#击败后获得{{Collectible633}}教条并返回"..
            "#{{Warning}} 无法在第五章及以后使用"..
            "#{{Warning}} 一次性",
            BookOfVirtues = "道具来自天使房道具池",
            BookOfBelial = "道具来自恶魔房道具池",
            CarBattery = "无效果"
        },
        {
            Name = "Wake-up",
            Desc = "#Teleports Isaac to a room where he can fight the Dogma and spawns 3 offensive items of at least quality 3 from random item pools"..
            "#Grants {{Collectible633}} the Dogma and returns if the Dogma is killed"..
            "#{{Warning}} Can't be used in Chapter 5 and beyond"..
            "#{{Warning}} SINGLE USE",
            BookOfVirtues = "Collectibles are selected from Angel Room item pool instead",
            BookOfBelial = "Collectibles are selected from Devil Room item pool instead",
            CarBattery = "No effect"
        }
    }
}

EIDInfo.Trinkets = {
    [ModTrinketIDs.BETHS_SALVATION] = {
        {
            Name = "伯大尼的救赎",
            Desc = "#到下一层时有50%的概率传送到{{AngelRoom}}天使房"..
            "#拥有{{Collectible499}}圣餐时一定触发"
        },
        {
            Name = "Beth's Salvation",
            Desc = "#Entering a new floor, there is a 50% chance of being teleported to {{AngelRoom}} the Angel Room"..
            "#Always triggers if Isaac has {{Collectible499}} the Eucharist"
        }
    },
    [ModTrinketIDs.BROKEN_VISION] = {
        {
            Name = "视力受损",
            Desc = "#拾取的被动道具有70%的概率会变为角色拥有的最后一个被动道具，\"任务\"道具除外"..
            "#{{Warning}} 变化后的道具不计入套装",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "70",
                "80", 
                "90"
            }
        },
        {
            Name = "Broken Vision",
            Desc = "#Picked up passive items have a 70% chance to transform into the last passive item owned by Issac, but 'quest' items are excluded"..
            "#{{Warning}} The rerolled item don't count toward transformations",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "70",
                "80", 
                "90"
            }
        }
    },
    [ModTrinketIDs.BROKEN_GLASS_EYE] = {
        {
            Name = "损坏的玻璃眼",
            Desc = "#{{ArrowUp}} 额外发射一颗泪弹"..
            "#{{ArrowDown}} -40%射速修正",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "40",
                "25", 
                "10"
            }
        },
        {
            Name = "Broken Glass Eye",
            Desc = "#{{ArrowUp}} Isaac shoots an extra tear"..
            "#{{ArrowDown}} 60% Fire rate multiplier",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "60",
                "75", 
                "90"
            }
        }
    },
    [ModTrinketIDs.KEEPERS_CORE] = {
        {
            Name = "店主的核心",
            Desc = "#箱子和福袋中至少含有1枚硬币",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "1",
                "2", 
                "3"
            }
        },
        {
            Name = "Keeper's Core",
            Desc = "#The chest and grab bags contain at least 1 coin",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "1 coin",
                "2 coins", 
                "3 coins"
            }
        }
    },
    [ModTrinketIDs.LOST_BOTTLE_CAP] = {
        {
            Name = "丢失的瓶盖",
            Desc = "#使用主动道具后有33%的概率恢复一半的充能"..
            "#{{Warning}} 对额外充能条无效",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "33",
                "66", 
                "100"
            }
        },
        {
            Name = "Lost Bottle Cap",
            Desc = "#Using an active item has a 33% chance to restore half of its charge"..
            "#{{Warning}} Does't work on additional charge bars",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "33",
                "66", 
                "100"
            }
        }
    },
    [ModTrinketIDs.MEAL_TICKET] = {
        {
            Name = "餐券",
            Desc = "#{{Shop}} 进入商店时生成1个随机\"食物\"标签的道具"..
            "#{{Warning}} 生成后移除该饰品",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "1",
                "2", 
                "3"
            }
        },
        {
            Name = "Meal Ticket",
            Desc = "#{{Shop}} Upon entering a shop, spawns 1 random collectible with the \"Food\" tag"..
            "#{{Warning}} Removes the trinket after spawning",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "1",
                "2", 
                "3"
            }
        }
    },
    [ModTrinketIDs.STONE_CARVING_KNIFE] = {
        {
            Name = "石刻刀",
            Desc = "#{{Rune}} 摧毁岩石有3%几率掉落符文或魂石",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "3",
                "6", 
                "9"
            }
        },
        {
            Name = "Stone Carving Knife",
            Desc = "#{{Rune}} Destroying rocks has a 3% chance to spawn a rune or soul stone",
            GoldenInfo = {findReplace = true},
            GoldenEffect = {
                "3",
                "6", 
                "9"
            }
        }
    },
    [ModTrinketIDs.TWISTED_LOVERS] = {
        {
            Name = "扭曲之契",
            Desc = "#{{Card}} 使用正位塔罗牌时，视作使用对应的逆位塔罗牌"..
            "#{{BrokenHeart}} 同时，将1心之容器或2魂心转换为1碎心"
        },
        {
            Name = "Twisted Lovers",
            Desc = "#{{Card}} When using a Tarot card, it is treated as using the corresponding reversed Tarot card"..
            "#{{BrokenHeart}}Turns 1 heart container or 1 Bone Heart or 2 Soul Hearts into a Broken Heart"
        }
    }
}

EIDInfo.Cards = {
    [ModCardIDs.ENCHANTED_CARD] = {
        {
            Name = "附魔卡",
            Desc = "#拾取后获得附魔词条：",
            MimicCharge = nil,
            IsRune = false,
            TarotCloth = nil
        },
        {
            Name = "Enchanted Card",
            Desc = "#Obtains the following enchantment when picked up:",
            MimicCharge = nil,
            IsRune = false,
            TarotCloth = nil
        }
    },
    [ModCardIDs.GLOWING_HOURGLASS_SHARD] = {
        {
            Name = "发光沙漏碎片",
            Desc = "#使用一次{{Collectible422}}发光沙漏"..
            "#受致命伤时自动使用",
            MimicCharge = nil,
            IsRune = false,
            TarotCloth = nil
        },
        {
            Name = "Glowing Hourglass Shard",
            Desc = "#{{Heart}} Grant the ability to obtain heart containers and immediately receive two heart containers"..
            "#{{Warning}} The ability only lasts for one floor, after which all heart containers will get converted",
            MimicCharge = nil,
            IsRune = false,
            TarotCloth = nil
        }
    }
}

EIDInfo.Players = {
    [ModPlayerIDs.WARFARIN] = {
        {
            Name = "ff0",
            Desc = "#{{Heart}} 使用血液样本时额外恢复一颗红心"..
            "#{{ArrowUp}} 心上限数量增加到9个"
        },
        {
            Name = "ff0",
            Desc = "{{Heart}} Heals one red heart when using the Blood Sample"..
            "#{{ArrowUp}} The max amount of heart containers is raised to 9"
        }
    }
}

EIDInfo.Pills = {
    [ModPillEffectIDs.BAIT_AND_SWITCH] = {
        {
            Name = "偷天换日",
            Desc = "#传送角色至房间中某个随机位置，并获得2秒无敌",
            HorsePill = "传送角色至房间中某个随机位置，并获得4秒无敌",
            MimicCharge = 2,
            Class = "0"
        },
        {
            Name = "Bait and Switch",
            Desc = "#Teleport Isaac to a random position in the room, and grants shield for 2 second",
            HorsePill = "Teleport Isaac to a random position in the room, and grants shield for 4 second",
            MimicCharge = 2,
            Class = "0"
        }
    },
    [ModPillEffectIDs.BLEH] = {
        {
            Name = "口岁!",
            Desc = "#吐出1个非\"任务\"标签的被动道具或吞下的饰品",
            HorsePill = "#吐出2个非\"任务\"标签的被动道具或吞下的饰品",
            MimicCharge = 6,
            Class = "2"
        },
        {
            Name = "Bleh",
            Desc = "#Drops a passive item without \"quest\" tag or smelted trinket",
            HorsePill = "#Drops two passive items without \"quest\" tag or smelted trinkets",
            MimicCharge = 6,
            Class = "2"
        }
    },
    [ModPillEffectIDs.BLOOD_EXTRACTION] = {
        {
            Name = "血液提取",
            Desc = "#{{Heart}} 保留一颗红心，清除角色拥有的其它红心、永恒之心、腐心和金心并生成对应数量和种类的血团宝宝"..
            "#{{HalfHeart}} 每半个红心生成一个血团宝宝",
            HorsePill = "#{{Heart}}保留一颗红心，清除角色拥有的其它红心、永恒之心、腐心和金心并生成对应数量和种类的大血团宝宝"..
            "#{{HalfHeart}} 每半个红心生成一个大血团宝宝",
            MimicCharge = 6,
            Class = "2+"
        },
        {
            Name = "Blood Extraction",
            Desc = "#{{Heart}} Retains one red heart, drains Isaac's other red hearts, eternal hearts, rotten hearts, and golden hearts, and creates the corresponding number and types of blood clot familiars"..
            "#{{HalfHeart}} Creates a blood clot familiar for every half red heart",
            HorsePill = "#{{Heart}} Retains one red heart, drains Isaac's other red hearts, eternal hearts, rotten hearts, and golden hearts, and creates the corresponding number and types of larger blood clot familiars"..
            "#{{HalfHeart}} Creates a larger blood clot familiar for every half red heart",
            MimicCharge = 6,
            Class = "2+"
        }
    }
}

EIDInfo.Foods = {
    [ModFoodItemIDs.APPLE] = {
        {
            Name = "苹果",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Apple",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.BAKED_POTATO] = {
        {
            Name = "烤马铃薯",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Baked Potato",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.BEETROOT] = {
        {
            Name = "甜菜根",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Beetroot",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.BROWN_MUSHROOM] = {
        {
            Name = "棕色蘑菇",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Brown Mushroom",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.CARROT] = {
        {
            Name = "胡萝卜",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Carrot",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.CHORUS_FRUIT] = {
        {
            Name = "紫颂果",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Chorus Fruit",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.COCOA_BEANS] = {
        {
            Name = "可可豆",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Cocoa Beans",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.DRIED_KELP] = {
        {
            Name = "干海带",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Dried Kelp",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.GLOW_BERRIES] = {
        {
            Name = "发光浆果",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Glow Berries",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.GOLDEN_APPLE] = {
        {
            Name = "金苹果",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Golden Apple",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.GOLDEN_CARROT] = {
        {
            Name = "金胡萝卜",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Golden Carrot",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.MELON_SLICE] = {
        {
            Name = "西瓜片",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Melon Slice",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.POTATO] = {
        {
            Name = "马铃薯",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Potato",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.POTATO] = {
        {
            Name = "马铃薯",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Potato",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.RED_MUSHROOM] = {
        {
            Name = "红色蘑菇",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Red Mushroom",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.SWEET_BERRIES] = {
        {
            Name = "甜浆果",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Sweet Berries",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.WHEAT] = {
        {
            Name = "小麦",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Wheat",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.CABBAGE] = {
        {
            Name = "卷心菜",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Cabbage",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.ONION] = {
        {
            Name = "洋葱",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Onion",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.PUMPKIN_SLICE] = {
        {
            Name = "南瓜片",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Pumpkin Slice",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.TOMATO] = {
        {
            Name = "西红柿",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Tomato",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    },
    [ModFoodItemIDs.MONSTER_MEAT] = {
        {
            Name = "怪物肉",
            Desc = "#{{ArrowUp}} 烹饪后获得以下效果："
        },
        {
            Name = "Monster Meat",
            Desc = "#{{ArrowUp}} Grants the following effects after cooking:"
        }
    }
}

do
    local cardfronts = Sprite("gfx/eid/eid_cardfronts.anm2", true)
    local inclineIcons = Sprite("gfx/eid/eid_inline_icons.anm2", true)
    EIDInfo.Icons = {
        ["Player"..ModPlayerIDs.WARFARIN] = {
            AnimationName = "Players",
            AnimationFrame = 0,
            Width = 16,
            Height = 16,
            LeftOffset = 0,
            TopOffset = 0,
            SpriteObject = Sprite("gfx/eid/player_icons.anm2", true)
        },
        ["Water"] = {
            AnimationName = "Water",
            AnimationFrame = 0,
            Width = 10,
            Height = 10,
            LeftOffset = 0,
            TopOffset = 0,
            SpriteObject = inclineIcons
        },
        ["ItemPoolICU"] = {
            AnimationName = "ItemPoolICU",
            AnimationFrame = 0,
            Width = 10,
            Height = 10,
            LeftOffset = 0,
            TopOffset = 0,
            SpriteObject = inclineIcons
        },
        ["Card"..ModCardIDs.ENCHANTED_CARD] = {
            AnimationName = "Enchanted Card",
            AnimationFrame = 0,
            Width = 9,
            Height = 9,
            LeftOffset = 0.5,
            TopOffset = 1.5,
            SpriteObject = cardfronts
        },
        ["Card"..ModCardIDs.GLOWING_HOURGLASS_SHARD] = {
            AnimationName = "Glowing Hourglass Shard",
            AnimationFrame = 0,
            Width = 9,
            Height = 9,
            LeftOffset = 0.5,
            TopOffset = 1.5,
            SpriteObject = cardfronts
        }
    }
end

for ID, Info in pairs(EIDInfo.Collectibles) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addCollectible(ID, descTable.Desc, descTable.Name, EIDLanguage[i])
        if descTable.BookOfVirtues then
            EID.descriptions[EIDLanguage[i]].bookOfVirtuesWisps[ID] = descTable.BookOfVirtues
        end
        if descTable.BookOfBelial then
            EID.descriptions[EIDLanguage[i]].bookOfBelialBuffs[ID] = descTable.BookOfBelial
        end
        if descTable.BingeEater then
            EID.descriptions[EIDLanguage[i]].bingeEaterBuffs[ID] = descTable.BingeEater
        end
        if descTable.CarBattery then
            EID.descriptions[EIDLanguage[i]].carBattery[ID] = descTable.CarBattery
        end
    end
end

for ID, Info in pairs(EIDInfo.Cards) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addCard(ID, descTable.Desc, descTable.Name, EIDLanguage[i])
        EID:addCardMetadata(ID, descTable.MimicCharge, descTable.IsRune)
        EID.descriptions[EIDLanguage[i]].tarotClothBuffs[ID] = descTable.TarotCloth
    end
end

for ID, Info in pairs(EIDInfo.Pills) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addPill(ID, descTable.Desc, descTable.Name, EIDLanguage[i])
        EID:addPillMetadata(ID, descTable.MimicCharge, descTable.Class)
        EID:addHorsePill(ID, descTable.HorsePill, descTable.Name, EIDLanguage[i])
    end
end

for ID, Info in pairs(EIDInfo.Trinkets) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addTrinket(ID, descTable.Desc, descTable.Name, EIDLanguage[i])
        if descTable.GoldenInfo then
            EID.GoldenTrinketData[ID] = descTable.GoldenInfo
        end
        if descTable.GoldenEffect then
            EID.descriptions[EIDLanguage[i]].goldenTrinketEffects[ID] = descTable.GoldenEffect
        end
    end
end

for ID, Info in pairs(EIDInfo.Foods) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addEntity(ModEntityIDs.FOODS_FOOD_ITEM.Type, ModEntityIDs.FOODS_FOOD_ITEM.Variant, ID, descTable.Name, descTable.Desc, EIDLanguage[i])
    end
end

for ID, Info in pairs(EIDInfo.Players) do
    for i = 1, 2 do
        local descTable = Info[i]
        EID:addBirthright(ID, descTable.Desc, descTable.Name, EIDLanguage[i])
    end
end

for ShortCut, descTable in pairs(EIDInfo.Icons) do
    EID:addIcon(ShortCut, descTable.AnimationName, descTable.AnimationFrame, descTable.Width, descTable.Height, descTable.LeftOffset, descTable.TopOffset, descTable.SpriteObject)
end

if EID then
    EID.CharacterToHeartType[ModPlayerIDs.WARFARIN] = "Red"
    EID.ItemPoolTypeToMarkup[ModItemPoolIDs.ILLNESS] = "{{ItemPoolICU}}"
    EID.descriptions[EID:getLanguage()].itemPoolNames[ModItemPoolIDs.ILLNESS] = "ICU"
end

do
    local function EnchantmentsCondition(descObj)
        if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD and descObj.ObjSubType == ModCardIDs.ENCHANTED_CARD then
            return true
        end
    end
    local function EnchantmentsCallback(descObj)
        local enchantmentID = Enchantments.GetARandomEnchantment(descObj.Entity.InitSeed, true)
        local arrow = (ModEnchantmentInfos[enchantmentID][5] and "#{{ArrowDown}} ") or "#{{ArrowUp}} "
        local language = (EID:getLanguage() == "zh_cn" and 1) or 2
        EID:appendToDescription(descObj, arrow..ModEnchantmentInfos[enchantmentID][language].." I")
        return descObj
    end
    EID:addDescriptionModifier("EnchantmentsModifier", EnchantmentsCondition, EnchantmentsCallback)
end

do
    local function FoodsCondition(descObj)
        if descObj.ObjType == ModEntityIDs.FOODS_FOOD_ITEM.Type and descObj.ObjVariant == ModEntityIDs.FOODS_FOOD_ITEM.Variant then
            return true
        end
    end
    local function FoodsCallback(descObj)
        EID:appendToDescription(descObj, Foods.GetFoodResult(descObj.ObjSubType))
        return descObj
    end
    EID:addDescriptionModifier("FoodsModifier", FoodsCondition, FoodsCallback)
end

do
    local function SuspiciousStewCondition(descObj)
        if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == ModItemIDs.SUSPICIOUS_STEW then
            return true
        end
    end
    local function SuspiciousStewCallback(descObj)
        descObj.Quality = nil
        if descObj.Entity == nil then
            return descObj
        end
        local combined = descObj.Entity:ToPickup():GetVarData()
        EID:appendToDescription(descObj, Foods.GetSuspiciousStewResult(combined))
        return descObj
    end
    EID:addDescriptionModifier("SuspiciousStewModifier", SuspiciousStewCondition, SuspiciousStewCallback)
    EID.ItemReminderDescriptionModifier["5.100."..ModItemIDs.SUSPICIOUS_STEW] = {
        modifierFunction = function(descObj, player, inOverview)
            local slot = player:GetActiveItemSlot(ModItemIDs.SUSPICIOUS_STEW)
            local combined = player:GetActiveItemDesc(slot).VarData
            descObj.Quality = nil
            EID:ItemReminderAddResult(descObj, Foods.GetSuspiciousStewResult(combined))
            return true
        end
    }
end