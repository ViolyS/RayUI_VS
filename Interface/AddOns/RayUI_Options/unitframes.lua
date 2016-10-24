local R, L, P, G = unpack(RayUI) --Import: Engine, Locales, ProfileDB, GlobalDB
local UF = R:GetModule("UnitFrames")

R.Options.args.UnitFrames = {
    type = "group",
    name = (UF.modName or UF:GetName()),
    order = 4,
    get = function(info)
        return R.db.UnitFrames[ info[#info] ]
    end,
    set = function(info, value)
        R.db.UnitFrames[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = UF.modName or UF:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = UF:Info() .. "\n\n",
            order = 2
        },
        settingsHeader = {
            type = "header",
            name = L["设置"],
            order = 4
        },
        colors = {
            order = 5,
            type = "group",
            name = L["颜色"],
            guiInline = true,
            args = {
                healthColorClass = {
                    order = 1,
                    name = L["生命条按职业着色"],
                    type = "toggle",
                },
                powerColorClass = {
                    order = 2,
                    name = L["法力条按职业着色"],
                    type = "toggle",
                },
                smooth = {
                    order = 3,
                    name = L["平滑变化"],
                    type = "toggle",
                },
                smoothColor = {
                    order = 4,
                    name = L["颜色随血量渐变"],
                    type = "toggle",
                },
            },
        },
        visible = {
            order = 6,
            type = "group",
            name = L["显示"],
            guiInline = true,
            args = {
                showBossFrames = {
                    order = 1,
                    name = L["显示BOSS"],
                    type = "toggle",
                },
                showArenaFrames = {
                    order = 2,
                    name = L["显示竞技场头像"],
                    type = "toggle",
                },
                showPortrait = {
                    order = 3,
                    name = L["启用3D头像"],
                    type = "toggle",
                },
                showHealthValue = {
                    order = 4,
                    name = L["默认显示血量数值"],
                    desc = L["鼠标悬浮时显示血量百分比"],
                    type = "toggle",
                },
                alwaysShowHealth = {
                    order = 5,
                    name = L["总是显示血量"],
                    type = "toggle",
                }
            },
        },
        others = {
            order = 7,
            type = "group",
            name = L["其他"],
            guiInline = true,
            args = {
                separateEnergy = {
                    order = 1,
                    name = L["独立能量条"],
                    type = "toggle",
                    disabled = function() return R.myclass ~= "ROGUE" end,
                },
                vengeance = {
                    order = 2,
                    name = L["坦克复仇条"],
                    type = "toggle",
                    disabled = function() return R:GetPlayerRole() ~= "TANK" end,
                },
            },
        },
    },
}
