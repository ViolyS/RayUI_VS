local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB, GlobalDB

P["Reminder"] = {}

P["Reminder"]["filters"] = {
	PALADIN = {
		["强效祝福"] = {
			["spellGroup"] = {
				[203528] = true, -- 强效力量祝福
				[203538] = true, -- 强效王者祝福
				[203539] = true, -- 强效智慧祝福
				["defaultIcon"] = 203528
			},
			["enable"] = true,
			["strictFilter"] = true,
			["tree"] = 3,
		}
	},
	ROGUE = {
		["伤害性毒药"] = {
			["spellGroup"] = {
				[200802] = true, -- 苦痛毒藥
				[8679] = true, -- 致傷毒藥
				[2823] = true, -- 致命毒藥
				["defaultIcon"] = 2823
			},
			["enable"] = true,
			["strictFilter"] = true,
			["tree"] = 1,
		}
	},
}
