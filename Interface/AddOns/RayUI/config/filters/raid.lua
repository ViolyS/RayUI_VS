local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

--Cache global variables
--Lua functions
local unpack = unpack

--WoW API / Variables
local GetSpellInfo = GetSpellInfo

local function ClassBuff(id, point, color, anyUnit, onlyShowMissing)
	local r, g, b = unpack(color)
	return {["enabled"] = true, ["id"] = id, ["point"] = point, ["color"] = {["r"] = r, ["g"] = g, ["b"] = b}, ["anyUnit"] = anyUnit, ["onlyShowMissing"] = onlyShowMissing}
end

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		R:Print("SpellID is not valid in raid aura list: "..id..".")
		return "Unknown"
	else
		return name
	end
end

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0}
end

G.Raid.AuraWatch = {
	PRIEST = {
		[194384] = ClassBuff(194384, "TOPRIGHT", {1, 0, 0.75}, true),        -- Atonement
		[41635] = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),          -- Prayer of Mending
		[139] = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),               -- Renew
		[17] = ClassBuff(17, "TOPLEFT", {0.81, 0.85, 0.1}, true),            -- Power Word: Shield
		[47788] = ClassBuff(47788, "LEFT", {221/255, 117/255, 0}, true),     -- Guardian Spirit
		[33206] = ClassBuff(33206, "LEFT", {227/255, 23/255, 13/255}, true), -- Pain Suppression
	},
	DRUID = {
		[774] = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),      -- Rejuvenation
		[155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}),   -- Germination
		[8936] = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),  -- Regrowth
		[33763] = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),   -- Lifebloom
		[188550] = ClassBuff(188550, "TOPLEFT", {0.4, 0.8, 0.2}), -- Lifebloom T18 4pc
		[48438] = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}), -- Wild Growth
		[207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}),     -- Spring Blossoms
		[102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}),    -- Cenarion Ward
		[200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}),      -- Cultivation
	},
	PALADIN = {
		[53563] = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Light
		[156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}),       -- Beacon of Faith
		[1022] = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),    -- Hand of Protection
		[1044] = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),  -- Hand of Freedom
		[6940] = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[114163] = ClassBuff(114163, 'BOTTOMLEFT', {0.87, 0.7, 0.03}),   -- Eternal Flame
	},
	SHAMAN = {
		[61295] = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Riptide
	},
	MONK = {
		[119611] = ClassBuff(119611, "TOPLEFT", {0.8, 0.4, 0.8}),    --Renewing Mist
		[116849] = ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}),   -- Life Cocoon
		[124682] = ClassBuff(124682, "BOTTOMLEFT", {0.4, 0.8, 0.2}), -- Enveloping Mist
		[124081] = ClassBuff(124081, "BOTTOMRIGHT", {0.7, 0.4, 0}),  -- Zen Sphere
	},
	ROGUE = {
		[57934] = ClassBuff(57934, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}),          -- Vigilance
		[3411] = ClassBuff(3411, "TOPRIGHT", {227/255, 23/255, 13/255}), -- Intervene
	},
	PET = {
		[19615] = ClassBuff(19615, 'TOPLEFT', {227/255, 23/255, 13/255}, true), -- Frenzy
		[136] = ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true) --Mend Pet
	},
	HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	DEMONHUNTER = {},
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},
}

G.ReverseTimer = {

}

G.Raid.RaidDebuffs = {
	-- Ascending aura timer
	-- Add spells to this list to have the aura time count up from 0
	-- NOTE: This does not show the aura, it needs to be in one of the other list too.
	ascending = {
		[SpellName(89435)] = Defaults(5),
		[SpellName(89421)] = Defaults(5),
	},

	-- Any Zone
	debuffs = {
		[SpellName(15007)] = Defaults(16), -- Resurrection Sickness
		[SpellName(39171)] = Defaults(9), -- Mortal Strike
		[SpellName(76622)] = Defaults(9), -- Sunder Armor
	},

	buffs = {
		--[SpellName(871)] = Defaults(15), -- Shield Wall
	},

	-- Raid Debuffs
	instances = {
		[1094] = {
			-- The Emerald Nightmare 翡翠夢境

			-- Nythendra 奈珊卓拉
			[SpellName(204504)] = Defaults(2), -- 寄生 任何瘟疫都疊，10層心控
			[SpellName(203045)] = Defaults(5), -- 感染之地 踩到屎
			[SpellName(203096)] = Defaults(1), -- 腐爛 點名角落放屎
			[SpellName(204463)] = Defaults(3), -- 烈性腐爛 坦克5層換	
			[SpellName(203646)] = Defaults(8), -- 腐化爆裂 被炸易傷
			[SpellName(202978)] = Defaults(3), -- 感染之息 正在被噴
			[SpellName(205043)] = Defaults(1), -- 心智寄生 M

			-- Il'gynoth, Heart of the Corruption 腐化之心伊蓋諾斯
			[SpellName(210099)] = Defaults(2), -- 鎖定  軟泥盯你
			[SpellName(209469)] = Defaults(2), -- 腐化之觸  魔法 軟泥咬你，驅散
			[SpellName(210984)] = Defaults(3), -- 命運之眼  坦克2層換
			[SpellName(208929)] = Defaults(4), -- 噴吐腐化  去外面放水
			[SpellName(208697)] = Defaults(6), -- 精神鞭笞 眼梗瞪你，打斷
			[SpellName(212886)] = Defaults(6), -- 夢魘腐化 踩到紅水
			[SpellName(215128)] = Defaults(4), -- 詛咒之血 點名11碼分散
			[SpellName(215836)] = Defaults(4), -- 死亡綻放 不踩爆炸
			[SpellName(215845)] = Defaults(6), -- 散化孢子 爆炸dot
			[SpellName(209471)] = Defaults(6), -- 夢魘爆炸 軟泥爆炸dot

			-- Elerethe Renferal 艾樂瑞斯雷弗拉爾
			[SpellName(210228)] = Defaults(6), -- 滴毒尖牙 小怪 咬人疊dot
			[SpellName(215300)] = Defaults(4), -- 痛苦蛛網 坦克連線
			[SpellName(215307)] = Defaults(4), -- 痛苦蛛網 坦克連線
			[SpellName(213124)] = Defaults(6), -- 毒液之池 踩到綠水
			[SpellName(215489)] = Defaults(6), -- 毒液之池 踩到綠水
			[SpellName(215460)] = Defaults(4), -- 亡域毒液 角落放水
			[SpellName(215582)] = Defaults(4), -- 掃擊之爪 坦克
			[SpellName(210850)] = Defaults(5), -- 扭曲暗影 角落放風或消水
			[SpellName(218124)] = Defaults(6), -- 猛烈強風 擊飛M
			[SpellName(218144)] = Defaults(6), -- 猛烈強風 擊飛M
			[SpellName(218519)] = Defaults(6), -- 風之灼傷 強風易傷

			-- Ursoc 厄索克
			[SpellName(197943)] = Defaults(3), -- 全面壓制 坦克易傷
			[SpellName(204859)] = Defaults(3), -- 撕裂血肉 坦克dot
			[SpellName(198006)] = Defaults(1), -- 專注凝視 點名衝鋒
			[SpellName(198108)] = Defaults(2), -- 衝力 分攤易傷
			[SpellName(198392)] = Defaults(4), -- 不諧回音 咆哮轟鳴增傷
			[SpellName(205611)] = Defaults(6), -- 瘴氣 踩水
			[SpellName(197980)] = Defaults(6), -- 惡夢絕叫 分身恐懼

			-- Dragons of Nightmare 夢魘之龍
			[SpellName(207681)] = Defaults(3), -- 夢魘之花 踩花
			[SpellName(204731)] = Defaults(6), -- 恐懼破壞力 減傷光環
			[SpellName(204044)] = Defaults(6), -- 暗影衝擊 10%減速
			[SpellName(205341)] = Defaults(3), -- 迷霧蔓延 魔法 沉睡
			[SpellName(203110)] = Defaults(8), -- 夢魘沉睡 昏迷
			[SpellName(203770)] = Defaults(4), -- 褻瀆藤蔓 魔法 定身
			[SpellName(203787)] = Defaults(1), -- 快速傳染 10碼aoe
			[SpellName(204078)] = Defaults(5), -- 低沉咆哮 恐懼3秒
			[SpellName(214543)] = Defaults(8), -- 崩塌夢魘 內場減傷

			-- Cenarius 塞納留斯
			[SpellName(210315)] = Defaults(1), -- 夢魘刺藤 魔法 跑 驅散 
			[SpellName(211612)] = Defaults(6), -- 治癒樹根 回魔 
			[SpellName(211989)] = Defaults(5), -- 解縛之觸 
			[SpellName(216516)] = Defaults(4), -- 先祖夢境 +30%治療量 
			[SpellName(210279)] = Defaults(8), -- 蔓延夢魘 常註光環DOT
			[SpellName(213162)] = Defaults(4), -- 夢魘衝擊 坦克

			-- Xavius 薩維斯
			[SpellName(206651)] = Defaults(2), -- 暗蝕靈魂 坦克魔法 p1驅散爆炸
			[SpellName(209158)] = Defaults(2), -- 黑蝕靈魂 坦克魔法 p2p3驅散爆炸
			[SpellName(210451)] = Defaults(2), -- 恐懼束縛 連線撞掉
			[SpellName(209034)] = Defaults(2), -- 恐懼束縛 連線撞掉
			[SpellName(208431)] = Defaults(6), -- 腐化：墜入瘋狂 準備心控
			[SpellName(207409)] = Defaults(6), -- 腐化：瘋狂 心控
			[SpellName(211802)] = Defaults(1), -- 夢魘之刃 飛刀出人群
			[SpellName(224508)] = Defaults(1), -- 腐化隕石 人群分擔
			[SpellName(205771)] = Defaults(2), -- 痛苦凝視 小怪追人
			[SpellName(211634)] = Defaults(6), -- 無限黑暗
		},
		[1088] = {
			-- The Nighthold 暗夜堡

			-- Skorpyron 斯寇派隆
			[SpellName(211659)] = Defaults(2), -- 秘法束鍊 坦克 10碼消除 
			[SpellName(204766)] = Defaults(8), -- 能量奔騰 
			[SpellName(204483)] = Defaults(3), -- 集中爆炸 被暈
			[SpellName(204744)] = Defaults(6), -- 有毒甲殼 小怪放水	 M		
			[SpellName(214718)] = Defaults(8), -- 酸液碎片 綠階段dot M 

			-- Chronomatic Anomaly 時光異象
			[SpellName(206607)] = Defaults(2), -- 時光粒子 疊10爆炸
			[SpellName(206617)] = Defaults(2), -- 定時炸彈 跑遠
			[SpellName(205707)] = Defaults(3), -- 時光球體 碰到小圈

			-- Trilliax 提里埃斯
			[SpellName(214573)] = Defaults(4), -- 塞滿滿  吃過毒蛋糕
			[SpellName(206488)] = Defaults(5), -- 秘法滲流 踩到
			[SpellName(206838)] = Defaults(2), -- 多汁盛宴 吃到好蛋糕有盾
			[SpellName(208910)] = Defaults(3), -- 毒液之池 踩到綠水 
			[SpellName(215489)] = Defaults(1), -- 弧光連結 靠近
			[SpellName(208915)] = Defaults(1), -- 弧光連結 靠近

			-- Spellblade Aluriel 法刃艾露莉亞
			[SpellName(212531)] = Defaults(3), -- 冰霜印記 P1 
			[SpellName(212587)] = Defaults(3), -- 冰霜印記 P1
			[SpellName(212647)] = Defaults(2), -- 冰霜咬噬 P1易傷 
			[SpellName(213148)] = Defaults(3), -- 灼燒烙印 P2 
			[SpellName(213181)] = Defaults(3), -- 灼燒烙印 P2 
			[SpellName(213166)] = Defaults(3), -- 灼燒烙印 P2
			[SpellName(213504)] = Defaults(3), -- 秘法魔霧 P3
			[SpellName(212736)] = Defaults(4), -- 冰霜之池 P1踩水 
			[SpellName(213278)] = Defaults(4), -- 燃燒大地 P2踩火

			-- Tichondrius 提克迪奧斯
			[SpellName(206480)] = Defaults(1), -- 腐屍瘟疫 
			[SpellName(208230)] = Defaults(2), -- 血肉盛宴 
			[SpellName(212794)] = Defaults(4), -- 阿古斯烙印 集合爆掉 
			[SpellName(215988)] = Defaults(3), -- 腐肉夢魘 p2被暈 
			[SpellName(206466)] = Defaults(2), -- 夜之精華 +30%傷害量和治療量並回魔 
			[SpellName(216024)] = Defaults(2), -- 易變之傷 坦克 
			[SpellName(216040)] = Defaults(4), -- 燃燒之魂 魔法 p1-3大怪抽魔
			[SpellName(216685)] = Defaults(5), -- 阿古斯之焰 炸圈出火

			-- Krosus 克羅索斯
			[SpellName(206677)] = Defaults(1), -- 灼燒烙印 坦克5層換 
			[SpellName(205344)] = Defaults(2), -- 毀滅之球 遠離人群 

			-- High Botanist Tel'arn 大植物學家泰亞恩
			[SpellName(218342)] = Defaults(2), -- 寄生專注 花追人
			[SpellName(218503)] = Defaults(2), -- 遞迴打擊 坦克7-10層換			
			[SpellName(218304)] = Defaults(2), -- 寄生束縛 魔法 定身驅散出花

			-- Star Augur Etraeus 星占師伊催斯
			[SpellName(206464)] = Defaults(2), -- 星環噴發 坦克P1
			[SpellName(206388)] = Defaults(2), -- 魔化爆發 坦克P2
			[SpellName(206965)] = Defaults(2), -- 虛無爆發 坦克P3
			[SpellName(214167)] = Defaults(3), -- 重力牽引 坦克P3/P2/P4
			[SpellName(205984)] = Defaults(3), -- 重力牽引 坦克P3/P2/P4
			[SpellName(214335)] = Defaults(3), -- 重力牽引 坦克P3/P2/P4
			[SpellName(206398)] = Defaults(6), -- 魔焰 踩火
			[SpellName(205649)] = Defaults(3), -- 魔化轟擊 角落放火
			[SpellName(206936)] = Defaults(4), -- 寒冰彈射 P1分散
			[SpellName(207720)] = Defaults(4), -- 見證虛無 P3被恐
			[SpellName(206585)] = Defaults(4), -- 絕對零度 P1砸圈
			[SpellName(206589)] = Defaults(3), -- 冰凍 P1冰塊
			[SpellName(207831)] = Defaults(6), -- 大三角 星座易傷 M
			[SpellName(205445)] = Defaults(6), -- 星座：貪狼 星座配對 M
			[SpellName(205429)] = Defaults(6), -- 星座：巨蟹 星座配對 M
			[SpellName(217046)] = Defaults(6), -- 遺骸吞噬中 P4 M
			[SpellName(216345)] = Defaults(6), -- 星座：獵戶 星座配對 M
			[SpellName(216344)] = Defaults(6), -- 星座：飛龍 星座配對 M

			-- Grand Magistrix Elisande 大博學者艾莉珊德
			[SpellName(209166)] = Defaults(5), -- 時光加快 30%加速
			[SpellName(209165)] = Defaults(5), -- 時光遲緩 30%減速
			[SpellName(208659)] = Defaults(3), -- 秘法之環 碰到圈
			[SpellName(211261)] = Defaults(4), -- 恆增折磨 P3
			[SpellName(209244)] = Defaults(3), -- 滅時光束 p2 箭頭別穿人
			[SpellName(209598)] = Defaults(3), -- 交映爆發 p3 爆炸			
			[SpellName(209615)] = Defaults(2), -- 燒蝕 坦克 p1 2-5層換
			[SpellName(209973)] = Defaults(2), -- 燒蝕爆炸 坦克 P2
			[SpellName(211885)] = Defaults(2), -- 燒蝕 p3 易傷(打斷就沒)

			-- Gul'dan 古爾丹
			[210339] = Defaults(), -- Time Dilation
			[180079] = Defaults(), -- Felfire Munitions
			[206875] = Defaults(), -- Fel Obelisk (Tank)
			[206840] = Defaults(), -- Gaze of Vethriz
			[206896] = Defaults(), -- Torn Soul
			[206221] = Defaults(), -- Empowered Bonds of Fel
			[208802] = Defaults(), -- Soul Corrosion
			[212686] = Defaults(), -- Flames of Sargeras
		},
		[1026] = { 
			-- Hellfire Citadel 地獄火堡壘

			-- #1 Hellfire Assault 地獄火突襲戰/奇袭地狱火

			[SpellName(186016)] = Defaults(4), -- 魔焰彈藥/邪火弹药 拿彈藥的dot 
			[SpellName(184379)] = Defaults(1), -- 哀嚎之斧/啸风战斧 點名出人群三角站位 
			[SpellName(184238)] = Defaults(3), -- 畏縮！/颤抖！ 減速 
			[SpellName(184243)] = Defaults(2), -- 猛擊/猛击 坦克 易傷 
			[SpellName(185806)] = Defaults(1), -- 傳導震波衝擊/导电冲击脉冲 魔法 擊暈 
			[SpellName(180022)] = Defaults(1), -- 鑽洞/钻孔 你要被車碾了 
			[SpellName(185157)] = Defaults(4), -- 燃燒/灼烧 正面錐形aoe dot 
			[SpellName(187655)] = Defaults(4), -- 腐化虹吸/腐化虹吸 M 

			-- #2 Iron Reaver 鋼鐵劫奪者/钢铁掠夺者 
			[SpellName(182074)] = Defaults(4), -- 焚燒/献祭 踩到火 
			[SpellName(182001)] = Defaults(3), -- 不穩定的球體/不稳定的宝珠 8碼分散 
			[SpellName(182280)] = Defaults(1), -- 砲擊/炮击 離boss越遠傷害越低，p1只點坦，p2點全部 
			[SpellName(182003)] = Defaults(4), -- 燃料污漬/燃料尾痕 踩到水減速 
			[SpellName(179897)] = Defaults(4), -- 閃擊/迅猛突袭 被夾住啦 
			[SpellName(185242)] = Defaults(4), -- 閃擊/迅猛突袭 被夾住啦 
			[SpellName(185978)] = Defaults(2), -- 火焰彈易傷/易爆火焰炸弹 M 火焰炸彈爆炸易傷 
			[SpellName(182373)] = Defaults(2), -- 火焰易傷/易爆火焰炸弹 M 火焰彈對附近的易傷 

			-- #3 Kormrok 寇姆洛克/考莫克 
			[SpellName(181345)] = Defaults(2), -- 邪惡碎擊/攫取之手 坦克 被手抓 
			[SpellName(181321)] = Defaults(2), -- 魔化之觸/邪能之触 坦克 擊飛+50%法易傷 
			[SpellName(181306)] = Defaults(2), -- 炸裂爆發/爆裂冲击 坦克 定身，10秒爆炸，40碼aoe 
			[SpellName(187819)] = Defaults(3), -- 粉碎/邪污碾压 被手抓 
			[SpellName(180270)] = Defaults(4), -- 暗影團塊/暗影血球 強化紫色暗影波 
			[SpellName(185519)] = Defaults(4), -- 熾熱團塊/炽热血球 強化黃色暗影波 
			[SpellName(185521)] = Defaults(4), -- 邪惡團塊/邪污血球 強化綠色暗影波 
			[SpellName(181082)] = Defaults(6), -- 暗影池/暗影之池 掉進水池 
			[SpellName(186559)] = Defaults(6), -- 熾焰火池/火焰之池 掉進水池 
			[SpellName(186560)] = Defaults(6), -- 邪惡池塘/邪污之池 掉進水池 
			[SpellName(181208)] = Defaults(1), -- 暗影殘渣/暗影残渣 M 接水dot 
			[SpellName(185686)] = Defaults(1), -- 熾熱殘渣/爆炸残渣 M 接水dot 
			[SpellName(185687)] = Defaults(1), -- 腐惡殘渣/邪恶残渣 M 接水dot 

			-- #4 Hellfire High Council 地獄火高階議會/地狱火高阶议会 
			[SpellName(184449)] = Defaults(1), -- 死靈法師印記/死灵印记 魔法 
			[SpellName(184450)] = Defaults(1), -- 死靈法師印記/死灵印记 魔法 
			[SpellName(184676)] = Defaults(1), -- 死靈法師印記/死灵印记 魔法 
			[SpellName(185065)] = Defaults(1), -- 死靈法師印記/死灵印记 魔法 
			[SpellName(185066)] = Defaults(1), -- 死靈法師印記/死灵印记 魔法 
			[SpellName(184360)] = Defaults(2), -- 惡魔之怒/堕落狂怒 血沸點名 
			[SpellName(184847)] = Defaults(2), -- 強酸創傷/酸性创伤 坦克 破甲 
			[SpellName(184652)] = Defaults(3), -- 收割/暗影收割 踩圈 
			[SpellName(184355)] = Defaults(5), -- 血液沸騰/血液沸腾 M 血沸對最遠的5人上流血dot 

			-- #5 Kilrogg Deadeye 基爾羅格·亡眼/基尔罗格·死眼 
			[SpellName(188929)] = Defaults(1), -- 追心飛刀/剖心飞刀 點名飛刀 
			[SpellName(180389)] = Defaults(3), -- 追心飛刀/剖心飞刀 流血DOT 
			[SpellName(182159)] = Defaults(4), -- 惡魔腐化/邪能腐蚀 特殊能量 
			[SpellName(184396)] = Defaults(3), -- 惡魔腐化/邪能腐蚀 疊滿被心控 
			[SpellName(180313)] = Defaults(4), -- 惡魔附身/恶魔附身 被心控 
			[SpellName(180718)] = Defaults(3), -- 不朽決心/永痕的决心 玩家 增傷，可疊20層 
			[SpellName(181488)] = Defaults(6), -- 死亡幻象/死亡幻象 
			[SpellName(185563)] = Defaults(3), -- 不死救贖/永恒的救赎 玩家debuff 一個光圈，站進去清腐化 
			[SpellName(180200)] = Defaults(2), -- 撕碎護甲/碎甲 坦克 不該中；身上有主動減傷就不會中(同萊登) 
			[SpellName(180575)] = Defaults(6), -- 魔化烈焰/邪能烈焰 
			[SpellName(183917)] = Defaults(5), -- 撕裂嚎叫/撕裂嚎叫 玩家 流血dot 
			[SpellName(188852)] = Defaults(6), -- 濺血/溅血 踩水 
			[SpellName(184067)] = Defaults(6), -- 魔化之沼/邪能腐液  踩水 

			-- #6 Gorefiend 血魔/血魔 
			[SpellName(180093)] = Defaults(4), -- 靈魂箭雨/灵魂箭雨 緩速 
			[SpellName(179864)] = Defaults(1), -- 死亡之影/死亡之影 點名進場 
			[SpellName(179867)] = Defaults(6), -- 血魔的腐化/血魔的腐化 進過場，不能再次進場 
			[SpellName(181295)] = Defaults(2), -- 消化/消化 內場，debuff結束秒殺，剩3秒出場 
			[SpellName(180148)] = Defaults(1), -- 嗜命/生命渴望 玩家 傀儡(小怪)盯人，追上10碼爆炸 
			[SpellName(179977)] = Defaults(1), -- 末日之觸/毁灭之触 去角落放圈 
			[SpellName(179995)] = Defaults(6), -- 末日之井/末日井 踩到圈 
			[SpellName(185190)] = Defaults(6), -- 魔化烈焰/邪能烈焰 大怪buff 
			[SpellName(185189)] = Defaults(4), -- 魔化之怒/邪能之怒 大怪dot 
			[SpellName(179908)] = Defaults(3), -- 命運共享/命运相连 找被定身的集合消連線，能動 
			[SpellName(179909)] = Defaults(3), -- 命運共享/命运相连 找被定身的集合消連線，定身 
			[SpellName(186770)] = Defaults(6), -- 碰到血魔的洗澡水 

			-- #7 Shadow-Lord Iskar 暗影領主伊斯卡/暗影领主伊斯卡 
			[SpellName(185239)] = Defaults(1), -- 安祖烈光/安苏之光 拿球疊dot 
			[SpellName(182325)] = Defaults(4), -- dot，hp90%以上消失或拿球消 
			[SpellName(182600)] = Defaults(6), -- 魔化火焰/邪能焚化 踩火 
			[SpellName(181957)] = Defaults(5), -- 吹下去，拿球消 
			[SpellName(182200)] = Defaults(1), -- 魔化戰輪/邪能飞轮 出人群 
			[SpellName(182178)] = Defaults(1), -- 魔化戰輪/邪能飞轮 出人群 
			[SpellName(179219)] = Defaults(6), -- 幻魅魔化炸彈/幻影邪能炸弹 魔法 別驅 
			[SpellName(181753)] = Defaults(1), -- 魔化炸彈/邪能炸弹 魔法 拿球驅散 
			[SpellName(181824)] = Defaults(2), -- 幻魅腐化/幻影腐蚀 坦克 10秒後爆炸，拿球清 
			[SpellName(187344)] = Defaults(3), -- 幻魅火葬/幻影焚化 近戰 幻魅腐化給附近的人的易傷 
			[SpellName(185456)] = Defaults(2), -- 絕望之鍊/绝望之链 M 配對(無誤) 
			[SpellName(185510)] = Defaults(2), -- 黑暗束縛/暗影之缚 M 把鍊子綁在一起，沒有鍊子的人靠近會引爆 

			-- #8 Soulbound Construct (Socrethar) 永恆者索奎薩爾/永恒者索克雷萨 
			[SpellName(182038)] = Defaults(2), -- 粉碎防禦/粉碎防御 迴盪之擊易傷，分攤，坦克2次換 
			[SpellName(189627)] = Defaults(1), -- 烈性魔珠/易爆的邪能宝珠 點名球追人，追到爆炸 
			[SpellName(182218)] = Defaults(4), -- 魔炎殘渣/邪炽冲锋 衝鋒留下綠火，75%減速 
			[SpellName(180415)] = Defaults(4), -- 魔化牢籠/邪能牢笼 水晶暈人 
			[SpellName(189540)] = Defaults(5), -- 極限威能/压倒能量 傀儡隨便電人，6秒dot 
			[SpellName(184124)] = Defaults(1), -- 曼那瑞之賜/堕落者之赐 綠圈aoe，別靠近別人 
			[SpellName(182769)] = Defaults(2), -- 恐怖凝視/魅影重重 p2被小怪追 
			[SpellName(184239)] = Defaults(3), -- 暗言術：痛苦/暗言术：恶 魔法 喚影師施放，驅散 
			[SpellName(182900)] = Defaults(4), -- 惡性糾纏/恶毒鬼魅 小怪恐懼 
			[SpellName(188666)] = Defaults(2), -- 永世饑渴/无尽饥渴 M 玩家 潛獵者追人，正面秒殺 
			[SpellName(190776)] = Defaults(4), -- 索奎薩爾的應變之計/索克雷萨之咒 M 潛獵者傀儡易傷 

			-- #9 Tyrant Velhari 女暴君維哈里/暴君维哈里 
			[SpellName(180000)] = Defaults(2), -- 凋零徽印/凋零契印 坦克   2-4層換坦 
			[SpellName(179987)] = Defaults(6), -- 蔑視光環/蔑视光环 
			[SpellName(181683)] = Defaults(6), -- 壓迫光環/抑制光环 
			[SpellName(179993)] = Defaults(6), -- 惡意光環/怨恨光环 
			[SpellName(180526)] = Defaults(1), -- 腐化洗禮/腐蚀序列 P2 aoe標記，被標記的人會5碼aoe 
			[SpellName(180166)] = Defaults(3), -- 魔法 吸收治療量，驅散跳到別人身上 
			[SpellName(180164)] = Defaults(3), -- 魔法 吸收治療量，驅散跳到別人身上 
			[SpellName(182459)] = Defaults(2), -- 定罪赦令/谴责法令 分攤 
			[SpellName(180604)] = Defaults(4), -- 剝奪之地/亵渎之地 P3地板紫圈 

			-- #10 Fel Lord Zakuun 惡魔領主札昆/邪能领主扎昆 
			[SpellName(189260)] = Defaults(3), -- 裂魂/破碎之魂 進場的暗影易傷 
			[SpellName(179407)] = Defaults(4), -- 虛體/魂不附体 進場debuff 
			[SpellName(182008)] = Defaults(4), -- 潛在能量/潜伏能量 撞到波爆炸 
			[SpellName(189032)] = Defaults(4), -- 被污染/玷污 吸收盾，分別是綠/黃/紅燈，刷滿6碼爆炸 
			[SpellName(189031)] = Defaults(3), -- 被污染/玷污 吸收盾，分別是綠/黃/紅燈，刷滿6碼爆炸 
			[SpellName(189030)] = Defaults(2), -- 被污染/玷污 吸收盾，分別是綠/黃/紅燈，刷滿6碼爆炸 
			[SpellName(179428)] = Defaults(3), -- 轟隆裂隙/轰鸣的裂隙 站在漩渦上，一個漩渦只要一個人踩 
			[SpellName(181508)] = Defaults(1), -- 毀滅種子/毁灭之种 出人群 
			[SpellName(181515)] = Defaults(1), -- 毀滅種子/毁灭之种 出人群 
			[SpellName(181653)] = Defaults(4), -- 惡魔水晶/邪能水晶 
			[SpellName(188998)] = Defaults(2), -- 耗竭靈魂/枯竭灵魂 M 不能再次進場 

			-- #11 Xhul'horac 祖霍拉克/祖霍拉克 
			[SpellName(186134)] = Defaults(3), -- 魔化之觸/邪蚀 受到火焰傷害的標記，持續15秒，碰到暗影傷害會爆炸 
			[SpellName(186135)] = Defaults(3), -- 魔化之觸/邪蚀 受到火焰傷害的標記，持續15秒，碰到暗影傷害會爆炸 
			[SpellName(185656)] = Defaults(3), -- 影魔殲滅/邪影屠戮 
			[SpellName(186073)] = Defaults(6), -- 魔化焦灼/邪能炙烤 踩到綠火 
			[SpellName(186063)] = Defaults(6), -- 破滅虛空/虚空消耗 踩到紫水 
			[SpellName(186407)] = Defaults(1), -- 惡魔奔騰/魔能喷涌 點名，5秒後腳下出綠火 
			[SpellName(186333)] = Defaults(1), -- 虛無怒濤/灵能涌动 點名，5秒後腳下出紫水 
			[SpellName(186448)] = Defaults(6), -- 魔炎亂舞/邪焰乱舞 
			[SpellName(186453)] = Defaults(6), -- 魔炎亂舞/邪焰乱舞 
			[SpellName(186785)] = Defaults(6), -- 枯萎凝視/凋零凝视 
			[SpellName(186783)] = Defaults(6), -- 枯萎凝視/凋零凝视 
			[SpellName(188208)] = Defaults(5), -- 著火/点燃 小鬼火球砸中的dot 
			[SpellName(186547)] = Defaults(6), -- 黑洞/黑洞 全團aoe直到踩掉為止 
			[SpellName(186500)] = Defaults(4), -- 魔化鎖鍊/邪能锁链 跑遠拉斷 
			[SpellName(189775)] = Defaults(4), -- 強化魔化鎖鍊 跑遠拉斷

			-- #12 Mannoroth 瑪諾洛斯/玛诺洛斯 
			[SpellName(181275)] = Defaults(4), -- 軍團的詛咒/军团诅咒 詛咒 驅散召喚領主 
			[SpellName(181099)] = Defaults(1), -- 毀滅印記/末日印记 玩家 受到傷害移除並爆炸，20碼AOE 
			[SpellName(181119)] = Defaults(2), -- 末日尖刺/末日之刺 坦克 層數越高，結束時的傷害越高 
			[SpellName(189717)] = Defaults(2), -- 末日尖刺/末日之刺 坦克層數越高，結束時的傷害越高 
			[SpellName(182171)] = Defaults(6), -- 瑪諾洛斯之血/玛洛诺斯之血 踩到P1綠水 
			[SpellName(184252)] = Defaults(2), -- 刺傷/穿刺之伤 坦克 (p2p3/p4)不該中；旋刃戳刺時身上有主動減傷就不會中(同萊登) 
			[SpellName(191231)] = Defaults(2), -- 刺傷/穿刺之伤 坦克 (p2p3/p4)不該中；旋刃戳刺時身上有主動減傷就不會中(同萊登) 
			[SpellName(181359)] = Defaults(2), -- 巨力衝擊/巨力冲击 坦克 擊飛 
			[SpellName(181597)] = Defaults(4), -- 瑪諾洛斯的凝視/玛诺洛斯凝视 恐懼，分攤傷害 
			[SpellName(181841)] = Defaults(4), -- 暗影之力/暗影之力 推人(小心加速) 
			[SpellName(182006)] = Defaults(4), -- 瑪諾洛斯的強力凝視/强化玛诺洛斯凝视 恐懼，分攤傷害產生白水 
			[SpellName(182088)] = Defaults(4), -- 強化暗影之力/强化暗影之力 p4推人 
			[SpellName(182031)] = Defaults(6), -- 凝視之影/凝视暗影 踩到白色 
			[SpellName(190482)] = Defaults(3), -- 擁抱暗影/束缚暗影 M 

			-- #13 Archimonde 阿克蒙德/阿克蒙德 
			[SpellName(183634)] = Defaults(4), -- 影魔衝擊/暗影冲击 擊飛，分攤落地傷害 
			[SpellName(187742)] = Defaults(2), -- 暗影爆破/暗影冲击 玩家/坦克   大怪易傷，坦克2層換 
			[SpellName(183864)] = Defaults(2), -- 暗影爆破/暗影冲击 玩家/坦克   大怪易傷，坦克2層換 
			[SpellName(183828)] = Defaults(5), -- 死亡烙印/死亡烙印 坦克 dot 大怪死才消失 
			[SpellName(183586)] = Defaults(5), -- 毀滅之火/魔火 踩火dot 
			[SpellName(182879)] = Defaults(2), -- 毀滅之火鎖定/魔火锁定 追人 
			[SpellName(183963)] = Defaults(3), -- 那魯之光/纳鲁之光 伊芮爾的小球，免疫暗影傷害 
			[SpellName(185014)] = Defaults(4), -- 聚集混沌/聚焦混乱 即將被傳遞塑形混沌 
			[SpellName(186123)] = Defaults(3), -- 塑型混沌/精炼混乱 正面直線aoe，傳遞給箭頭指向的人 
			[SpellName(184964)] = Defaults(4), -- 束縛折磨/枷锁酷刑 遠離靈魂30碼消除 
			[SpellName(186952)] = Defaults(2), -- 虛空放逐/虚空放逐 坦克 進場 
			[SpellName(186961)] = Defaults(2), -- 虛空放逐/虚空放逐 坦克 進場 
			[SpellName(187047)] = Defaults(4), -- 吞噬生命/吞噬声明 內場，降低受到的治療量 
			[SpellName(189891)] = Defaults(6), -- 虛空裂隙/虚空撕裂 傳送門在外場變成的水池 
			[SpellName(190049)] = Defaults(3), -- 虛空腐化/虚空腐化 內場易傷 
			[SpellName(188796)] = Defaults(6), -- 惡魔腐化/邪能腐蚀 場邊綠水 
			[SpellName(190400)] = Defaults(6), -- 軍團之觸 分攤印記獲得易傷
			[SpellName(187050)] = Defaults(6), -- 燃燒軍團印記 分別有11/9/7/5秒4種，需分攤，結束時擊飛，人越少飛越高
		 },
		[988] = { 
			-- 黑石铸造厂 
			--格鲁尔 
			
			[SpellName(155080)] = Defaults(4), -- 煉獄切割 分担组DOT 
			[SpellName(155078)] = Defaults(3), -- 压迫打击 普攻坦克易伤 
			[SpellName(162322)] = Defaults(5), -- 炼狱打击 吃刀坦克易伤 
			[SpellName(155506)] = Defaults(2), -- 石化 

			--奥尔高格 
			
			[SpellName(156203)] = Defaults(5), -- 呕吐黑石 远程躲 
			[SpellName(156374)] = Defaults(5), -- 爆炸裂片 近战躲 
			[SpellName(156297)] = Defaults(3), -- 酸液洪流 副坦克易伤 
			[SpellName(173471)] = Defaults(4), -- 酸液巨口 主坦克DOT 
			[SpellName(155900)] = Defaults(2), -- 翻滚之怒 击倒 

			--爆裂熔炉 
			
			[SpellName(156932)] = Defaults(5), -- 崩裂 
			[SpellName(178279)] = Defaults(4), -- 炸弹 
			[SpellName(155192)] = Defaults(4), -- 炸弹 
			[SpellName(176121)] = Defaults(6), -- 不稳定的火焰 点名八码爆炸 
			[SpellName(155196)] = Defaults(2), -- 锁定 
			[SpellName(155743)] = Defaults(5), -- 熔渣池 
			[SpellName(155240)] = Defaults(3), -- 淬火 坦克易伤 
			[SpellName(155242)] = Defaults(3), -- 高热 三层换坦 
			[SpellName(155225)] = Defaults(5), -- 熔化 点名 
			[SpellName(155223)] = Defaults(5), -- 熔化 

			--汉斯加尔与弗兰佐克 
			
			[SpellName(157139)] = Defaults(3), -- 折脊碎椎 跳跃易伤 
			[SpellName(160838)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160845)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160847)] = Defaults(2), -- 干扰怒吼 
			[SpellName(160848)] = Defaults(2), -- 干扰怒吼 
			[SpellName(155818)] = Defaults(4), -- 灼热燃烧 场地边缘的火 

			--缚火者卡格拉兹 
			
			[SpellName(154952)] = Defaults(3), -- 锁定 
			[SpellName(155074)] = Defaults(1), -- 焦灼吐息 坦克易伤 
			[SpellName(155049)] = Defaults(2), -- 火焰链接 
			[SpellName(154932)] = Defaults(4), -- 熔岩激流 点名分摊 
			[SpellName(155277)] = Defaults(5), -- 炽热光辉 点名AOE 
			[SpellName(155314)] = Defaults(1), -- 岩浆猛击 冲锋火线 
			[SpellName(163284)] = Defaults(2), -- 升腾烈焰 坦克DOT 

			--克罗莫格 
			
			[SpellName(156766)] = Defaults(1), -- 扭曲护甲 坦克易伤 
			[SpellName(157059)] = Defaults(2), -- 纠缠之地符文 
			[SpellName(161839)] = Defaults(3), -- 破碎大地符文 
			[SpellName(161923)] = Defaults(3), -- 破碎大地符文 

			--兽王达玛克
			
			[SpellName(154960)] = Defaults(4), -- 长矛钉刺 
			[SpellName(155061)] = Defaults(1), -- 狂乱撕扯 狼阶段流血 
			[SpellName(162283)] = Defaults(1), -- 狂乱撕扯 BOSS继承的流血 
			[SpellName(154989)] = Defaults(3), -- 炼狱吐息 
			[SpellName(154981)] = Defaults(5), -- 爆燃 秒驱 
			[SpellName(155030)] = Defaults(2), -- 炽燃利齿 龙阶段坦克易伤 
			[SpellName(155236)] = Defaults(2), -- 碾碎护甲 象阶段坦克易伤 
			[SpellName(155499)] = Defaults(3), -- 高热弹片 
			[SpellName(155657)] = Defaults(4), -- 烈焰灌注 
			[SpellName(159044)] = Defaults(1), -- 强震 
			[SpellName(162277)] = Defaults(1), -- 强震 

			--主管索戈尔 
			
			[SpellName(155921)] = Defaults(2), -- 点燃 坦克易伤 
			[SpellName(165195)] = Defaults(4), -- 实验型脉冲手雷 
			[SpellName(156310)] = Defaults(3), -- 熔岩震击 
			[SpellName(159481)] = Defaults(3), -- 延时攻城炸弹 
			[SpellName(164380)] = Defaults(2), -- 燃烧 
			[SpellName(164280)] = Defaults(2), -- 热能冲击 

			--钢铁女武神 
			
			[SpellName(156631)] = Defaults(2), -- 急速射击 
			[SpellName(164271)] = Defaults(3), -- 穿透射击 
			[SpellName(158601)] = Defaults(1), -- 主炮轰击 
			[SpellName(156214)] = Defaults(4), -- 震颤暗影 
			[SpellName(158315)] = Defaults(2), -- 暗影猎杀 
			[SpellName(159724)] = Defaults(3), -- 鲜血仪式 
			[SpellName(158010)] = Defaults(2), -- 浸血觅心者 
			[SpellName(158692)] = Defaults(1), -- 致命投掷 
			[SpellName(158702)] = Defaults(2), -- 锁定 
			[SpellName(158683)] = Defaults(3), -- 堕落之血 

			--Blackhand
			[SpellName(156096)] = Defaults(5), --MARKEDFORDEATH
			[SpellName(156107)] = Defaults(4), --IMPALED
			[SpellName(156047)] = Defaults(2), --SLAGGED
			[SpellName(156401)] = Defaults(4), --MOLTENSLAG
			[SpellName(156404)] = Defaults(3), --BURNED
			[SpellName(158054)] = Defaults(4), --SHATTERINGSMASH 158054 155992 159142
			[SpellName(156888)] = Defaults(5), --OVERHEATED
			[SpellName(157000)] = Defaults(2), --ATTACHSLAGBOMBS
		},
		[994] = { 
			--悬槌堡

			-- 1 卡加斯
			[SpellName(158986)] = Defaults(2), -- 冲锋 
			[SpellName(159178)] = Defaults(5), -- 迸裂创伤         
			[SpellName(162497)] = Defaults(3), -- 搜寻猎物       
			[SpellName(163130)] = Defaults(3), -- 着火 
   
			-- 2 屠夫 
			[SpellName(156151)] = Defaults(3), -- 捶肉槌 
			[SpellName(156147)] = Defaults(5), -- 切肉刀           
			[SpellName(156152)] = Defaults(3), -- 龟裂创伤         
			[SpellName(163046)] = Defaults(4), -- 白鬼硫酸 
   
			-- 3 泰克图斯 
			[SpellName(162346)] = Defaults(4),  -- 晶化弹幕  点名 
			[SpellName(162370)] = Defaults(3), -- 晶化弹幕   踩到 
   
			-- 4  布兰肯斯波
			[SpellName(163242)] = Defaults(5), -- 感染孢子 
			[SpellName(159426)] = Defaults(5), -- 回春孢子 
			[SpellName(163241)] = Defaults(4), -- 溃烂 
			[SpellName(159220)] = Defaults(2),  -- 死疽吐息   
			[SpellName(160179)] = Defaults(2),  -- 蚀脑真菌 
			[SpellName(165223)] = Defaults(6), -- 爆裂灌注 
			[SpellName(163666)] = Defaults(3), -- 脉冲高热 
   
			-- 5  独眼魔双子
			[SpellName(155569)] = Defaults(3), -- 受伤 
			[SpellName(158241)] = Defaults(4), -- 烈焰   
			[SpellName(163372)] = Defaults(4), -- 奥能动荡 
			[SpellName(167200)] = Defaults(3), -- 奥术致伤 
			[SpellName(163297)] = Defaults(3), -- 扭曲奥能 

   
			-- 6 克拉戈
			[SpellName(172813)] = Defaults(5), -- 魔能散射：冰霜 
			[SpellName(162185)] = Defaults(5), -- 魔能散射：火焰 
			[SpellName(162184)] = Defaults(3), -- 魔能散射：暗影 
			[SpellName(162186)] = Defaults(2), -- 魔能散射：奥术 
			[SpellName(161345)] = Defaults(2), -- 压制力场 
			[SpellName(161242)] = Defaults(3), -- 废灵标记 
			[SpellName(172886)] = Defaults(4), -- 废灵璧垒 
			[SpellName(172895)] = Defaults(4), -- 魔能散射：邪能  点名 
			[SpellName(172917)] = Defaults(4), -- 魔能散射：邪能  踩到 
			[SpellName(163472)] = Defaults(2), -- 统御之力 
   
			-- 7 元首
			[SpellName(157763)] = Defaults(3),  -- 锁定         
			[SpellName(159515)] = Defaults(4), -- 狂莽突击         
			[SpellName(156225)] = Defaults(4), -- 烙印       
			[SpellName(164004)] = Defaults(4), -- 烙印：偏移         
			[SpellName(164006)] = Defaults(4), -- 烙印：强固         
			[SpellName(164005)] = Defaults(4), -- 烙印：复制         
			[SpellName(158605)] = Defaults(2), -- 混沌标记         
			[SpellName(164176)] = Defaults(2), -- 混沌标记：偏移           
			[SpellName(164178)] = Defaults(2), -- 混沌标记：强固         
			[SpellName(164191)] = Defaults(2), -- 混沌标记：复制 
   
        }, 
		[953] = {
			--Siege of Orgrimmar

			--Immerseus
			[SpellName(143297)] = Defaults(5), --Sha Splash
			[SpellName(143459)] = Defaults(4), --Sha Residue
			[SpellName(143524)] = Defaults(4), --Purified Residue
			[SpellName(143286)] = Defaults(4), --Seeping Sha
			[SpellName(143413)] = Defaults(3), --Swirl
			[SpellName(143411)] = Defaults(3), --Swirl
			[SpellName(143436)] = Defaults(2), --Corrosive Blast (tanks)
			[SpellName(143579)] = Defaults(3), --Sha Corruption (Heroic Only)

			--Fallen Protectors
			[SpellName(143239)] = Defaults(4), --Noxious Poison
			[SpellName(144176)] = Defaults(2), --Lingering Anguish
			[SpellName(143023)] = Defaults(3), --Corrupted Brew
			[SpellName(143301)] = Defaults(2), --Gouge
			[SpellName(143564)] = Defaults(3), --Meditative Field
			[SpellName(143010)] = Defaults(3), --Corruptive Kick
			[SpellName(143434)] = Defaults(6), --Shadow Word:Bane (Dispell)
			[SpellName(143840)] = Defaults(6), --Mark of Anguish
			[SpellName(143959)] = Defaults(4), --Defiled Ground
			[SpellName(143423)] = Defaults(6), --Sha Sear
			[SpellName(143292)] = Defaults(5), --Fixate
			[SpellName(144176)] = Defaults(5), --Shadow Weakness
			[SpellName(147383)] = Defaults(4), --Debilitation (Heroic Only)

			--Norushen
			[SpellName(146124)] = Defaults(2), --Self Doubt (tanks)
			[SpellName(146324)] = Defaults(4), --Jealousy
			[SpellName(144639)] = Defaults(6), --Corruption
			[SpellName(144850)] = Defaults(5), --Test of Reliance
			[SpellName(145861)] = Defaults(6), --Self-Absorbed (Dispell)
			[SpellName(144851)] = Defaults(2), --Test of Confiidence (tanks)
			[SpellName(146703)] = Defaults(3), --Bottomless Pit
			[SpellName(144514)] = Defaults(6), --Lingering Corruption
			[SpellName(144849)] = Defaults(4), --Test of Serenity

			--Sha of Pride
			[SpellName(144358)] = Defaults(2), --Wounded Pride (tanks)
			[SpellName(144843)] = Defaults(3), --Overcome
			[SpellName(146594)] = Defaults(4), --Gift of the Titans
			[SpellName(144351)] = Defaults(6), --Mark of Arrogance
			[SpellName(144364)] = Defaults(4), --Power of the Titans
			[SpellName(146822)] = Defaults(6), --Projection
			[SpellName(146817)] = Defaults(5), --Aura of Pride
			[SpellName(144774)] = Defaults(2), --Reaching Attacks (tanks)
			[SpellName(144636)] = Defaults(5), --Corrupted Prison
			[SpellName(144574)] = Defaults(6), --Corrupted Prison
			[SpellName(145215)] = Defaults(4), --Banishment (Heroic)
			[SpellName(147207)] = Defaults(4), --Weakened Resolve (Heroic)
			[SpellName(144574)] = Defaults(6), --Corrupted Prison
			[SpellName(144574)] = Defaults(6), --Corrupted Prison

			--Galakras
			[SpellName(146765)] = Defaults(5), --Flame Arrows
			[SpellName(147705)] = Defaults(5), --Poison Cloud
			[SpellName(146902)] = Defaults(2), --Poison Tipped blades

			--Iron Juggernaut
			[SpellName(144467)] = Defaults(2), --Ignite Armor
			[SpellName(144459)] = Defaults(5), --Laser Burn
			[SpellName(144498)] = Defaults(5), --Napalm Oil
			[SpellName(144918)] = Defaults(5), --Cutter Laser
			[SpellName(146325)] = Defaults(6), --Cutter Laser Target

			--Kor'kron Dark Shaman
			[SpellName(144089)] = Defaults(6), --Toxic Mist
			[SpellName(144215)] = Defaults(2), --Froststorm Strike (Tank only)
			[SpellName(143990)] = Defaults(2), --Foul Geyser (Tank only)
			[SpellName(144304)] = Defaults(2), --Rend
			[SpellName(144330)] = Defaults(6), --Iron Prison (Heroic)

			--General Nazgrim
			[SpellName(143638)] = Defaults(6), --Bonecracker
			[SpellName(143480)] = Defaults(5), --Assassin's Mark
			[SpellName(143431)] = Defaults(6), --Magistrike (Dispell)
			[SpellName(143494)] = Defaults(2), --Sundering Blow (Tanks)
			[SpellName(143882)] = Defaults(5), --Hunter's Mark

			--Malkorok
			[SpellName(142990)] = Defaults(2), --Fatal Strike (Tank debuff)
			[SpellName(142913)] = Defaults(6), --Displaced Energy (Dispell)
			[SpellName(142863)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(142864)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(142865)] = Defaults(1), --Strong Ancient Barrier
			[SpellName(143919)] = Defaults(5), --Languish (Heroic)

			--Spoils of Pandaria
			[SpellName(145685)] = Defaults(2), --Unstable Defensive System
			[SpellName(144853)] = Defaults(3), --Carnivorous Bite
			[SpellName(145987)] = Defaults(5), --Set to Blow
			[SpellName(145218)] = Defaults(4), --Harden Flesh
			[SpellName(145230)] = Defaults(1), --Forbidden Magic
			[SpellName(146217)] = Defaults(4), --Keg Toss
			[SpellName(146235)] = Defaults(4), --Breath of Fire
			[SpellName(145523)] = Defaults(4), --Animated Strike
			[SpellName(142983)] = Defaults(6), --Torment (the new Wrack)
			[SpellName(145715)] = Defaults(3), --Blazing Charge
			[SpellName(145747)] = Defaults(5), --Bubbling Amber
			[SpellName(146289)] = Defaults(4), --Mass Paralysis

			--Thok the Bloodthirsty
			[SpellName(143766)] = Defaults(2), --Panic (tanks)
			[SpellName(143773)] = Defaults(2), --Freezing Breath (tanks)
			[SpellName(143452)] = Defaults(1), --Bloodied
			[SpellName(146589)] = Defaults(5), --Skeleton Key (tanks)
			[SpellName(143445)] = Defaults(6), --Fixate
			[SpellName(143791)] = Defaults(5), --Corrosive Blood
			[SpellName(143777)] = Defaults(3), --Frozen Solid (tanks)
			[SpellName(143780)] = Defaults(4), --Acid Breath
			[SpellName(143800)] = Defaults(5), --Icy Blood
			[SpellName(143428)] = Defaults(4), --Tail Lash

			--Siegecrafter Blackfuse
			[SpellName(144236)] = Defaults(4), --Pattern Recognition
			[SpellName(144466)] = Defaults(5), --Magnetic Crush
			[SpellName(143385)] = Defaults(2), --Electrostatic Charge (tank)
			[SpellName(143856)] = Defaults(6), --Superheated

			--Paragons of the Klaxxi
			[SpellName(143617)] = Defaults(5), --Blue Bomb
			[SpellName(143701)] = Defaults(5), --Whirling (stun)
			[SpellName(143702)] = Defaults(5), --Whirling
			[SpellName(142808)] = Defaults(6), --Fiery Edge
			[SpellName(143609)] = Defaults(5), --Yellow Sword
			[SpellName(143610)] = Defaults(5), --Red Drum
			[SpellName(142931)] = Defaults(2), --Exposed Veins
			[SpellName(143619)] = Defaults(5), --Yellow Bomb
			[SpellName(143735)] = Defaults(6), --Caustic Amber
			[SpellName(146452)] = Defaults(5), --Resonating Amber
			[SpellName(142929)] = Defaults(2), --Tenderizing Strikes
			[SpellName(142797)] = Defaults(5), --Noxious Vapors
			[SpellName(143939)] = Defaults(5), --Gouge
			[SpellName(143275)] = Defaults(2), --Hewn
			[SpellName(143768)] = Defaults(2), --Sonic Projection
			[SpellName(142532)] = Defaults(6), --Toxin: Blue
			[SpellName(142534)] = Defaults(6), --Toxin: Yellow
			[SpellName(143279)] = Defaults(2), --Genetic Alteration
			[SpellName(143339)] = Defaults(6), --Injection
			[SpellName(142649)] = Defaults(4), --Devour
			[SpellName(146556)] = Defaults(6), --Pierce
			[SpellName(142671)] = Defaults(6), --Mesmerize
			[SpellName(143979)] = Defaults(2), --Vicious Assault
			[SpellName(143607)] = Defaults(5), --Blue Sword
			[SpellName(143614)] = Defaults(5), --Yellow Drum
			[SpellName(143612)] = Defaults(5), --Blue Drum
			[SpellName(142533)] = Defaults(6), --Toxin: Red
			[SpellName(143615)] = Defaults(5), --Red Bomb
			[SpellName(143974)] = Defaults(2), --Shield Bash (tanks)

			--Garrosh Hellscream
			[SpellName(144582)] = Defaults(4), --Hamstring
			[SpellName(144954)] = Defaults(4), --Realm of Y'Shaarj
			[SpellName(145183)] = Defaults(2), --Gripping Despair (tanks)
			[SpellName(144762)] = Defaults(4), --Desecrated
			[SpellName(145071)] = Defaults(5), --Touch of Y'Sharrj
			[SpellName(148718)] = Defaults(4), --Fire Pit
		},
		[930] = {
			-- Throne of Thunder

			--Trash
			[SpellName(138349)] = Defaults(7), -- Static Wound
			[SpellName(137371)] = Defaults(7), -- Thundering Throw

			--Horridon
			[SpellName(136767)] = Defaults(7), --Triple Puncture

			--Council of Elders
			[SpellName(136922)] = Defaults(9), --霜寒刺骨
			[SpellName(137650)] = Defaults(8), --幽暗之魂
			[SpellName(137641)] = Defaults(7), --Soul Fragment
			[SpellName(137359)] = Defaults(7), --Shadowed Loa Spirit Fixate
			[SpellName(137972)] = Defaults(7), --Twisted Fate

			--Tortos
			[SpellName(136753)] = Defaults(7), --Slashing Talons
			[SpellName(137633)] = Defaults(7), --Crystal Shell

			--Megaera
			[SpellName(137731)] = Defaults(7), --Ignite Flesh

			--Ji-Kun
			[SpellName(138309)] = Defaults(7), --Slimed

			--Durumu the Forgotten
			[SpellName(133767)] = Defaults(7), --Serious Wound
			[SpellName(133768)] = Defaults(7), --Arterial Cut

			--Primordius
			[SpellName(136050)] = Defaults(7), --Malformed Blood

			--Dark Animus
			[SpellName(138569)] = Defaults(7), --Explosive Slam

			--Iron Qon
			[SpellName(134691)] = Defaults(7), --Impale
			[SpellName(134647)] = Defaults(7), --Scorched

			--Twin Consorts
			[SpellName(137440)] = Defaults(7), --Icy Shadows
			[SpellName(137408)] = Defaults(7), --Fan of Flames
			[SpellName(137360)] = Defaults(7), --Corrupted Healing
			[SpellName(137341)] = Defaults(8), --Corrupted Healing

			--Lei Shen
			[SpellName(135000)] = Defaults(7), --Decapitate
			[SpellName(139011)] = Defaults(8), --Decapitate

			--Ra-den

		},
		[897] = {
			-- Heart of Fear
			-- Imperial Vizier Zor'lok
			[SpellName(122761)] = Defaults(7), -- Exhale
			[SpellName(122760)] = Defaults(7), -- Exhale			
			[SpellName(123812)] = Defaults(7), --Pheromones of Zeal
			[SpellName(122740)] = Defaults(7), --Convert (MC)
			[SpellName(122706)] = Defaults(7), --Noise Cancelling (AMZ)
			-- Blade Lord Ta'yak
			[SpellName(123180)] = Defaults(7), -- Wind Step			
			[SpellName(123474)] = Defaults(7), --Overwhelming Assault
			[SpellName(122949)] = Defaults(7), --Unseen Strike
			[SpellName(124783)] = Defaults(7), --Storm Unleashed
			-- Garalon
			[SpellName(123081)] = Defaults(8), --Pungency
			[SpellName(122774)] = Defaults(7), --Crush
			-- [SpellName(123423)] = Defaults(8), --Weak Points
			-- Wind Lord Mel'jarak			
			[SpellName(121881)] = Defaults(8), --Amber Prison
			[SpellName(122055)] = Defaults(7), --Residue
			[SpellName(122064)] = Defaults(7), --Corrosive Resin
			--Amber-Shaper Un'sok
			[SpellName(121949)] = Defaults(7), --Parasitic Growth
			[SpellName(122784)] = Defaults(7), --Reshape Life
			--Grand Empress Shek'zeer
			[SpellName(123707)] = Defaults(7), --Eyes of the Empress
			[SpellName(125390)] = Defaults(7), --Fixate
			[SpellName(123788)] = Defaults(8), --Cry of Terror
			[SpellName(124097)] = Defaults(7), --Sticky Resin
			[SpellName(123184)] = Defaults(8), --Dissonance Field
			[SpellName(124777)] = Defaults(7), --Poison Bomb
			[SpellName(124821)] = Defaults(7), --Poison-Drenched Armor
			[SpellName(124827)] = Defaults(7), --Poison Fumes
			[SpellName(124849)] = Defaults(7), --Consuming Terror
			[SpellName(124863)] = Defaults(7), --Visions of Demise
			[SpellName(124862)] = Defaults(7), --Visions of Demise: Target
			[SpellName(123845)] = Defaults(7), --Heart of Fear: Chosen
			[SpellName(123846)] = Defaults(7), --Heart of Fear: Lure
			[SpellName(125283)] = Defaults(7), --Sha Corruption
		},
		[896] = {
			-- Mogu'shan Vaults
			-- The Stone Guard
			[SpellName(116281)] = Defaults(7), --Cobalt Mine Blast
			-- Feng the Accursed
			[SpellName(116784)] = Defaults(9), --Wildfire Spark
			[SpellName(116374)] = Defaults(7), --Lightning Charge
			[SpellName(116417)] = Defaults(8), --Arcane Resonance
			-- Gara'jal the Spiritbinder
			[SpellName(122151)] = Defaults(8), --Voodoo Doll
			[SpellName(116161)] = Defaults(7), --Crossed Over
			[SpellName(116278)] = Defaults(7), --Soul Sever
			-- The Spirit Kings			
			--Meng the Demented
			[SpellName(117708)] = Defaults(7), --Maddening Shout
			--Subetai the Swift
			[SpellName(118048)] = Defaults(7), --Pillaged
			[SpellName(118047)] = Defaults(7), --Pillage: Target
			[SpellName(118135)] = Defaults(7), --Pinned Down
			[SpellName(118163)] = Defaults(7), --Robbed Blind
			--Zian of the Endless Shadow
			[SpellName(118303)] = Defaults(7), --Undying Shadow: Fixate
			-- Elegon
			[SpellName(117949)] = Defaults(7), --Closed Circuit
			[SpellName(132222)] = Defaults(8), --Destabilizing Energies
			-- Will of the Emperor
			--Jan-xi and Qin-xi
			[SpellName(116835)] = Defaults(7), --Devastating Arc
			[SpellName(132425)] = Defaults(7), --Stomp
			-- Rage
			[SpellName(116525)] = Defaults(7), --Focused Assault (Rage fixate)
			-- Courage
			[SpellName(116778)] = Defaults(7), --Focused Defense (fixate)
			[SpellName(117485)] = Defaults(7), --Impeding Thrust (slow debuff)
			-- Strength
			[SpellName(116550)] = Defaults(7), --Energizing Smash (knock down)
			-- Titan Spark (Heroic)
			[SpellName(116829)] = Defaults(7), --Focused Energy (fixate)
		},
		[886] = {
			-- Terrace of Endless Spring
			-- Protectors of the Endless
			[SpellName(118091)] = Defaults(6), --Defiled Ground
			[SpellName(117519)] = Defaults(6), --Touch of Sha
			[SpellName(111850)] = Defaults(6), --Lightning Prison: Targeted
			[SpellName(117436)] = Defaults(7), --Lightning Prison: Stunned
			[SpellName(118191)] = Defaults(6), --Corrupted Essence
			[SpellName(117986)] = Defaults(7), --Defiled Ground: Stacks
			-- Tsulong
			[SpellName(122768)] = Defaults(7), --Dread Shadows
			[SpellName(122777)] = Defaults(7), --Nightmares (dispellable)
			[SpellName(122752)] = Defaults(7), --Shadow Breath
			[SpellName(122789)] = Defaults(7), --Sunbeam
			[SpellName(123012)] = Defaults(7), --Terrorize: 5% (dispellable)
			[SpellName(123011)] = Defaults(7), --Terrorize: 10% (dispellable)
			[SpellName(123036)] = Defaults(7), --Fright (dispellable)
			[SpellName(122858)] = Defaults(6), --Bathed in Light
			-- Lei Shi
			[SpellName(123121)] = Defaults(7), --Spray
			[SpellName(123705)] = Defaults(7), --Scary Fog
			-- Sha of Fear
			[SpellName(119414)] = Defaults(7), --Breath of Fear
			[SpellName(129147)] = Defaults(7), --Onimous Cackle
			[SpellName(119983)] = Defaults(7), --Dread Spray
			[SpellName(120669)] = Defaults(7), --Naked and Afraid
			[SpellName(75683)] = Defaults(7), --Waterspout

			[SpellName(120629)] = Defaults(7), --Huddle in Terror
			[SpellName(120394)] = Defaults(7), --Eternal Darkness
			[SpellName(129189)] = Defaults(7), --Sha Globe
			[SpellName(119086)] = Defaults(7), --Penetrating Bolt
			[SpellName(119775)] = Defaults(7), --Reaching Attack
		},
		[824] = {
			-- Dragon Soul
			-- Morchok
			[SpellName(103687)] = Defaults(7),  -- RA.dbush Armor(擊碎護甲)

			-- Zon'ozz
			[SpellName(103434)] = Defaults(7), -- Disrupting Shadows(崩解之影)

			-- Yor'sahj
			[105171] = Defaults(8), -- Deep Corruption(深度腐化)
			[109389] = Defaults(8), -- Deep Corruption(深度腐化)
			[SpellName(105171)] = Defaults(7), -- Deep Corruption(深度腐化)
			[SpellName(104849)] = Defaults(9),  -- Void Bolt(虛無箭)

			-- Hagara
			[SpellName(104451)] = Defaults(7),  --寒冰之墓

			-- Ultraxion
			[SpellName(109075)] = Defaults(7), --凋零之光

			-- Blackhorn
			[SpellName(107567)] = Defaults(7),  --蠻橫打擊
			[SpellName(108043)] = Defaults(8),  --破甲攻擊
			[SpellName(107558)] = Defaults(9),  --衰亡

			-- Spine
			[SpellName(105479)] = Defaults(7), --燃燒血漿
			[SpellName(105490)] = Defaults(8),  --熾熱之握
			[SpellName(106200)] = Defaults(9),  --血液腐化:大地
			[SpellName(106199)] = Defaults(10),  --血液腐化:死亡

			-- Madness
			[SpellName(105841)] = Defaults(7),  --退化咬擊
			[SpellName(105445)] = Defaults(8),  --極熾高熱
			[SpellName(106444)] = Defaults(9),  --刺穿
		},
		[800] = {
			-- Firelands
			-- Rageface
			[SpellName(99947)] = Defaults(6), -- Face Rage

			--Baleroc
			[SpellName(99256)] = Defaults(5), -- 折磨
			[SpellName(99257)] = Defaults(6), -- 受到折磨
			[SpellName(99516)] = Defaults(7), -- Countdown

			--Majordomo Staghelm
			[SpellName(98535)] = Defaults(5), -- Leaping Flames

			--Burning Orbs
			[SpellName(98451)] = Defaults(6), -- Burning Orb
		},
		[752] = {
			-- Baradin Hold
			[SpellName(88954)] = Defaults(6), -- Consuming Darkness
		},
	},
}
