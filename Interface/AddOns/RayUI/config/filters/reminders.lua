﻿----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Reminder")


_ReminderList = {
    ROGUE = {
        ["伤害性毒药"] = {
            ["spellGroup"] = {
                [200802] = true, -- 苦痛毒藥
                [8679] = true, -- 致傷毒藥
                [2823] = true, -- 致命毒藥
                ["defaultIcon"] = 76803
            },
            ["enable"] = true,
            ["strictFilter"] = true,
            ["tree"] = 1,
        }
    },
    PALADIN = {
        ["灰烬使者的祝福"] = {
            ["spellGroup"] = {
                [242981] = true,
                ["defaultIcon"] = 242981
            },
            ["enable"] = true,
            ["strictFilter"] = false,
            ["tree"] = 3,
        }
    },
    MAGE = {
        ["奥术魔宠"] = {
            ["spellGroup"] = {
                [210126] = true,
                ["defaultIcon"] = 210126
            },
            ["enable"] = true,
            ["strictFilter"] = true,
            ["tree"] = 1,
        }
    },
}
