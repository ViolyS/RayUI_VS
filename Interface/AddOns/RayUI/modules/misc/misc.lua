local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:NewModule("Misc", "AceEvent-3.0", "AceTimer-3.0")

M.modName = L["小玩意儿"]
local error=error
M.Modules = {}
M.OnLoadErrors = {}

function M:GetOptions()
	local options = {
		anouncegroup = {
			order = 5,
			type = "group",
			name = L["通报"],
			guiInline = true,
			args = {
				anounce = {
					order = 1,
					name = L["启用"],
					desc = L["打断通报，打断、驱散、进出战斗文字提示"],
					type = "toggle",
				},
			},
		},
		auctiongroup = {
			order = 6,
			type = "group",
			name = L["拍卖行"],
			guiInline = true,
			args = {
				auction = {
					order = 1,
					name = L["启用"],
					desc = L["Shift + 右键直接一口价，价格上限请在misc/auction.lua里设置"],
					type = "toggle",
				},
			},
		},
		autodezgroup = {
			order = 7,
			type = "group",
			name = L["自动贪婪"],
			guiInline = true,
			args = {
				autodez = {
					order = 1,
					name = L["启用"],
					desc = L["满级之后自动贪婪/分解绿装"],
					type = "toggle",
                    set = function(info, value)
                        R.db.Misc.autodez = value
                    end,
				},
			},
		},
		autoreleasegroup = {
			order = 8,
			type = "group",
			name = L["自动释放尸体"],
			guiInline = true,
			args = {
				autorelease = {
					order = 1,
					name = L["启用"],
					desc = L["战场中自动释放尸体"],
					type = "toggle",
                    set = function(info, value)
                        R.db.Misc.autorelease = value
                    end,
				},
			},
		},
		merchantgroup = {
			order = 9,
			type = "group",
			name = L["商人"],
			guiInline = true,
			args = {
				merchant = {
					order = 1,
					name = L["启用"],
					desc = L["自动修理、自动卖灰色物品"],
					type = "toggle",
				},
			},
		},
		questgroup = {
			order = 10,
			type = "group",
			name = L["任务"],
			guiInline = true,
			args = {
				quest = {
					order = 1,
					name = L["启用"],
					desc = L["任务等级，进/出副本自动收起/展开任务追踪，任务面板的展开/收起全部分类按钮"],
					type = "toggle",
				},
				automation = {
					order = 2,
					name = L["自动交接任务"],
					desc = L["自动交接任务，按shift点npc则不自动交接"],
					disabled = function() return not M.db.quest end,
					type = "toggle",
                    set = function(info, value)
                        R.db.Misc.automation = value
                    end,
				},
			},
		},
		remindergroup = {
			order = 11,
			type = "group",
			name = L["buff提醒"],
			guiInline = true,
			args = {
				reminder = {
					order = 1,
					name = L["启用"],
					desc = L["缺失重要buff时提醒"],
					type = "toggle",
				},
			},
		},
		raidbuffremindergroup = {
			order = 12,
			type = "group",
			name = L["团队buff提醒"],
			guiInline = true,
			args = {
				raidbuffreminder = {
					order = 1,
					name = L["启用"],
					type = "toggle",
				},
				raidbuffreminderparty = {
					order = 2,
					name = L["单人隐藏团队buff提醒"],
					type = "toggle",
					disabled = function() return not M.db.raidbuffreminder end,
				},
				raidbuffreminderduration = {
					order = 3,
					name = L["持续时间"],
					desc = L["图标上显示持续时间"],
					type = "toggle",
					disabled = function() return not M.db.raidbuffreminder end,
				},
				consolidate = {
					order = 4,
					name = L["整合buff"],
					desc = L["隐藏在团队buff提醒中显示的buff"],
					type = "toggle",
					disabled = function() return not M.db.raidbuffreminder end,
				},
			},
		},
		autoinvitegroup = {
			order = 13,
			type = "group",
			name = L["自动邀请"],
			guiInline = true,
			set = function(info, value)
				R.db.Misc[ info[#info] ] = value
			end,
			args = {
				autoAcceptInvite = {
					order = 1,
					name = L["自动接受邀请"],
					desc = L["自动接受公会成员、好友及实名好友的组队邀请"],
					type = "toggle",
				},
				autoInvite = {
					order = 2,
					name = L["自动邀请组队"],
					desc = L["当他人密语自动邀请关键字时会自动邀请他组队"],
					type = "toggle",
				},
				autoInviteKeywords = {
					order = 3,
					name = L["自动邀请关键字"],
					desc = L["设置自动邀请的关键字，多个关键字用空格分割"],
                    type = "input",
					disabled = function() return not M.db.autoInvite end,
				},
			},
		},
		raidcdgroup = {
			order = 14,
			type = "group",
			name = L["团队技能冷却"],
			guiInline = true,
			args = {
				raidcd = {
					order = 1,
					name = L["启用"],
					type = "toggle",
                    set = function(info, enable)
                        R.db.Misc[ info[#info] ] = enable
                        if enable then
                            M:EnableRaidCD()
                        else
                            M:DisableRaidCD()
                        end
                    end,
				},
				raidcdwidth = {
					order = 2,
					name = L["长度"],
					type = "range",
					min = 100, max = 300, step = 1,
                    set = function(info, value)
                        R.db.Misc[ info[#info] ] = value
                        RaidCDAnchor:SetWidth(value + 24)
                        RaidCDMover:SetWidth(value + 24)
                    end,
					disabled = function() return not M.db.raidcd end,
				},
				raidcdgrowth = {
					order = 3,
					name = L["增长方向"],
					type = "select",
					values = {
						["UP"] = L["上"],
						["DOWN"] = L["下"],
					},
                    set = function(info, value)
                        R.db.Misc[ info[#info] ] = value
                        M:UpdateRaidCDPositions()
                    end,
					disabled = function() return not M.db.raidcd end,
				},
			},
		},
		totembar = {
			order = 15,
			type = "group",
			name = L["图腾条"],
			guiInline = true,
			get = function(info) return R.db.Misc.totembar[ info[#info] ] end,
			set = function(info, value) R.db.Misc.totembar[ info[#info] ] = value; R:GetModule("Misc"):PositionAndSizeTotem() end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["启用"],
					set = function(info, value) R.db.Misc.totembar[ info[#info] ] = value; R:GetModule("Misc"):ToggleTotemEnable() end,
				},					
				size = {
					order = 2,
					type = "range",
					name = L["按键大小"],
					min = 24, max = 60, step = 1,
				},
				spacing = {
					order = 3,
					type = "range",
					name = L["按键间距"],
					min = 1, max = 10, step = 1,			
				},
				sortDirection = {
					order = 4,
					type = "select",
					name = L["排序方向"],
					values = {
						["ASCENDING"] = L["正向"],
						["DESCENDING"] = L["逆向"],
					},
				},
				growthDirection = {
					order = 5,
					type = "select",
					name = L["排列方向"],
					values = {
						["VERTICAL"] = L["垂直"],
						["HORIZONTAL"] = L["水平"],
					},
				},
			},
		},
	}
	return options
end

function M:RegisterMiscModule(name, func)
	self.Modules[name] = func
end

function M:Initialize()
	for module, func in pairs(self.Modules) do
		local _, catch = pcall(func)
		if catch then
			tinsert(self.OnLoadErrors, catch)
		end
	end
end

function M:Info()
	return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r的各种实用便利小功能."]
end

R:RegisterModule(M:GetName())