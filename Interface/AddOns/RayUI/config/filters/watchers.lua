local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB

local positions = {
    player_buff_icon = { "BOTTOMRIGHT", "RayUF_Player", "TOPRIGHT", 0, 80 }, -- "玩家buff&debuff"
    target_buff_icon = { "BOTTOMLEFT", "RayUF_Target", "TOPLEFT", 0, 80 }, -- "目标buff&debuff"
    player_proc_icon = { "BOTTOMRIGHT", "RayUF_Player", "TOPRIGHT", 0, 33 }, -- "玩家重要buff&debuff"
    target_proc_icon = { "BOTTOMLEFT", "RayUF_Target", "TOPLEFT", 0, 33 }, -- "目标重要buff&debuff"
    focus_buff_icon = { "BOTTOMLEFT", "RayUF_Focus", "TOPLEFT", 0, 10 }, -- "焦点buff&debuff"
    cd_icon = function() return R:IsDeveloper() and { "TOPLEFT", "RayUIActionBar1", "BOTTOMLEFT", 0, -6 } or { "TOPLEFT", "RayUIActionBar3", "BOTTOMRIGHT", -28, -6 } end, -- "cd"
    player_special_icon = { "TOPRIGHT", "RayUF_Player", "BOTTOMRIGHT", 0, -9 }, -- "玩家特殊buff&debuff"
    pve_player_icon = { "BOTTOM", RayUIParent, "BOTTOM", -35, 350 }, -- "PVE/PVP玩家buff&debuff"
    pve_target_icon = { "BOTTOM", RayUIParent, "BOTTOM", 35, 350 }, -- "PVE/PVP目标buff&debuff"
}

R["Watcher"] = {
    ["filters"] = {
        ["DRUID"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 生命之花
                { spellID = 33763, unitId = "player", caster = "player", filter = "BUFF" },
                -- 回春術
                { spellID = 774, unitId = "player", caster = "player", filter = "BUFF" },
                -- 癒合
                { spellID = 8936, unitId = "player", caster = "player", filter = "BUFF" },
                -- 回春術(萌芽)
                { spellID = 155777, unitId = "player", caster = "player", filter = "BUFF" },
                -- 安希之賜
                { spellID = 202739, unitId = "player", caster = "player", filter = "BUFF" },
                -- 伊露恩的祝福
                { spellID = 202737, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 生命之花
                { spellID = 33763, unitId = "target", caster = "player", filter = "BUFF" },
                -- 回春術
                { spellID = 774, unitId = "target", caster = "player", filter = "BUFF" },
                -- 癒合
                { spellID = 8936, unitId = "target", caster = "player", filter = "BUFF" },
                -- 回春術(萌芽)
                { spellID = 155777, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 月光增效
                { spellID = 164547, unitId = "player", caster = "player", filter = "BUFF" },
                -- 日光增效
                { spellID = 164545, unitId = "player", caster = "player", filter = "BUFF" },
                -- 兇蠻咆哮
                { spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
                -- 求生本能
                { spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" },
                -- 節能施法（野性）
                { spellID = 135700, unitId = "player", caster = "player", filter = "BUFF" },
                -- 節能施法（恢復）
                { spellID = 16870, unitId = "player", caster = "player", filter = "BUFF" },
                -- 樹皮術
                { spellID = 22812, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴
                { spellID = 106951, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴恢復
                { spellID = 22842, unitId = "player", caster = "player", filter = "BUFF" },
                -- 猛獸迅捷
                { spellID = 69369, unitId = "player", caster = "player", filter = "BUFF" },
                -- 自然戒備
                { spellID = 124974, unitId = "player", caster = "player", filter = "BUFF" },
                -- 森林之魂
                { spellID = 114108, unitId = "player", caster = "player", filter = "BUFF" },
                -- 星穹大連線
                { spellID = 194223, unitId = "player", caster = "player", filter = "BUFF" },
                -- 猛虎之怒
                { spellID = 5217, unitId = "player", caster = "player", filter = "BUFF" },
                -- 血腥爪击
                { spellID = 145152, unitId = "player", caster = "player", filter = "BUFF" },
                -- 粉碎
                { spellID = 158792, unitId = "player", caster = "player", filter = "BUFF" },
                -- 鬃毛倒竖
                { spellID = 155835, unitId = "player", caster = "player", filter = "BUFF" },
                -- 塞纳里奥结界
                { spellID = 102351, unitId = "player", caster = "player", filter = "BUFF" },
                -- 塞纳里奥结界:触发
                { spellID = 102352, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴:熊形态
                { spellID = 50334, unitId = "player", caster = "player", filter = "BUFF" },
                -- 巨熊之力
                { spellID = 159233, unitId = "player", caster = "player", filter = "BUFF" },
                -- 伊露恩的守護者
                { spellID = 213680, unitId = "player", caster = "player", filter = "BUFF" },
                -- 鋼鐵毛皮
                { spellID = 192081, unitId = "player", caster = "player", filter = "BUFF" },
                -- 烏索爾的印記
                { spellID = 192083, unitId = "player", caster = "player", filter = "BUFF" },
                -- 伊露恩戰士
                { spellID = 202425, unitId = "player", caster = "player", filter = "BUFF" },
                -- 化身：叢林之王
                { spellID = 102543, unitId = "player", caster = "player", filter = "BUFF" },
                -- 化身：厄索克守護者
                { spellID = 102558, unitId = "player", caster = "player", filter = "BUFF" },
                -- 化身：伊露恩天選者
                { spellID = 102560, unitId = "player", caster = "player", filter = "BUFF" },
                -- 化身：生命之树
                { spellID = 117679, unitId = "player", caster = "player", filter = "BUFF" },
                -- 突進
                { spellID = 1850, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 糾纏根鬚
                { spellID = 339, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 颶風術
                { spellID = 33786, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 月火術
                { spellID = 164812, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 日炎術
                { spellID = 164815, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 掃擊
                { spellID = 1822, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 撕扯
                { spellID = 1079, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 割裂
                { spellID = 33745, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 傷殘術
                { spellID = 203123, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 斜掠
                { spellID = 155722, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 痛击
                { spellID = 77758, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 痛击（豹）
                { spellID = 106830, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 星光閃焰
                { spellID = 202347, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 鐵樹皮術
                { spellID = 102342, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 糾纏根鬚
                { spellID = 339, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 颶風術
                { spellID = 33786, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 狂暴
                { spellID = 50334, filter = "CD" },
                -- 星穹大連線
                { spellID = 194223, filter = "CD" },
                -- 狂暴恢復
                { spellID = 22842, filter = "CD" },
                -- 複生
                { spellID = 20484, filter = "CD" },
                -- 樹皮術
                { spellID = 22812, filter = "CD" },
                -- 鐵樹皮術
                { spellID = 102342, filter = "CD" },
                -- 寧靜
                { spellID = 740, filter = "CD" },
                -- 自然戒備
                { spellID = 124974, filter = "CD" },
                -- 野性位移
                { spellID = 102280, filter = "CD" },
                -- 狂暴
                { spellID = 106951, filter = "CD" },
                -- 化身：叢林之王
                { spellID = 102543, filter = "CD" },
                -- 化身：厄索克守護者
                -- { spellID = 102558, filter = "CD" },
                -- 化身：伊露恩天選者
                -- { spellID = 102560, filter = "CD" },
                -- 化身：生命之樹
                -- { spellID = 33891, filter = "CD" },
                -- 狂奔怒吼
                { spellID = 106898, filter = "CD" },
                -- 突進
                { spellID = 1850, filter = "CD" },
                -- 太陽光束
                { spellID = 78675, filter = "CD" },
                -- 猛虎之怒
                { spellID = 5217, filter = "CD" },
                -- 影遁
                { spellID = 58984, filter = "CD" },
            },
        },
        ["HUNTER"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 凶暴野獸
                { spellID = 120694, unitId = "player", caster = "player", filter = "BUFF" },
                -- 治療寵物
                { spellID = 136, unitId = "pet", caster = "player", filter = "BUFF" },
                -- 獸劈斬
                { spellID = 118455, unitId = "pet", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 誤導
                { spellID = 34477, unitId = "player", caster = "player", filter = "BUFF" },
                { spellID = 35079, unitId = "player", caster = "player", filter = "BUFF" },
                -- 快速射擊
                { spellID = 6150, unitId = "player", caster = "player", filter = "BUFF" },
                -- 快速射擊
                { spellID = 19574, unitId = "player", caster = "player", filter = "BUFF" },
                -- 戰術大師
                { spellID = 34837, unitId = "player", caster = "player", filter = "BUFF" },
                -- 急速射擊
                { spellID = 3045, unitId = "player", caster = "player", filter = "BUFF" },
                -- 連環火網
                { spellID = 82921, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂亂效果
                { spellID = 19615, unitId = "pet", caster = "pet", filter = "BUFF" },
                -- 稳固集中
                { spellID = 193534, unitId = "player", caster = "player", filter = "BUFF" },
                -- 荷枪实弹
                { spellID = 194594, unitId = "player", caster = "player", filter = "BUFF" },
                -- 野性守護
                { spellID = 193530, unitId = "player", caster = "player", filter = "BUFF" },
                -- 箭雨
                { spellID = 194386, unitId = "player", caster = "player", filter = "BUFF" },
                -- 獵豹守護
                { spellID = 186257, unitId = "player", caster = "player", filter = "BUFF" },
                -- 獵豹守護
                { spellID = 186258, unitId = "player", caster = "player", filter = "BUFF" },
                -- 標記目標
                { spellID = 223138, unitId = "player", caster = "player", filter = "BUFF" },
                -- 特技射擊
                { spellID = 227272, unitId = "player", caster = "player", filter = "BUFF" },
                -- 强擊
                { spellID = 193526, unitId = "player", caster = "player", filter = "BUFF" },
                -- 摩克納薩爾之道
                { spellID = 201081, unitId = "player", caster = "player", filter = "BUFF" },
                -- 貓鼬撕咬
                { spellID = 190931, unitId = "player", caster = "player", filter = "BUFF" },
                -- 野性呼喚
                { spellID = 185791, unitId = "player", caster = "player", filter = "BUFF" },
                -- 擊殺命令
                { spellID = 34026, filter = "CD" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 翼龍釘刺
                { spellID = 19386, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 毒蛇釘刺
                { spellID = 118253, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 黑鸦
                { spellID = 131894, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 獵人印記
                { spellID = 185365, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 割裂
                { spellID = 185855, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 易伤
                { spellID = 187131, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 翼龍釘刺
                { spellID = 19386, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 急速射擊
                { spellID = 3045, filter = "CD" },
                -- 狂野怒火
                { spellID = 19574, filter = "CD" },
                -- 狂野怒火
                { spellID = 193530, filter = "CD" },
                -- 奧術之流
                { spellID = 25046, filter = "CD" },
                -- 誤導
                { spellID = 34477, filter = "CD" },
                -- 偽裝
                { spellID = 51753, filter = "CD" },
                -- 爆炸陷阱
                { spellID = 13813, filter = "CD" },
                -- 冰凍陷阱
                { spellID = 1499, filter = "CD" },
                -- 毒蛇陷阱
                { spellID = 34600, filter = "CD" },
                -- 翼龍釘刺
                { spellID = 19386, filter = "CD" },
                -- 主人的召喚
                { spellID = 53271, filter = "CD" },
                -- 假死
                { spellID = 5384, filter = "CD" },
                -- 黑鴉獵殺
                { spellID = 131894, filter = "CD" },
                -- 山貓衝刺
                { spellID = 120697, filter = "CD" },
                -- 强擊
                { spellID = 193526, filter = "CD" },
            },
        },
        ["MAGE"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 冰霜之指
                { spellID = 44544, unitId = "player", caster = "player", filter = "BUFF" },
                -- 焦炎之痕
                { spellID = 48108, unitId = "player", caster = "player", filter = "BUFF" },
                -- 飛彈彈幕
                { spellID = 79683, unitId = "player", caster = "player", filter = "BUFF" },
                -- 秘法強化
                { spellID = 12042, unitId = "player", caster = "player", filter = "BUFF" },
                -- 秘法衝擊
                { spellID = 36032, unitId = "player", caster = "player", filter = "DEBUFF" },
                -- 寒冰護體
                { spellID = 11426, unitId = "player", caster = "player", filter = "BUFF" },
                -- 腦部凍結
                { spellID = 190446, unitId = "player", caster = "player", filter = "BUFF" },
                -- 升溫
                { spellID = 48107, unitId = "player", caster = "player", filter = "BUFF" },
                -- 咒法結界
                { spellID = 1463, unitId = "player", caster = "player", filter = "BUFF" },
                -- 力之符文
                { spellID = 116014, unitId = "player", caster = "player", filter = "BUFF" },
                -- 咒法轉移
                { spellID = 116267, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰寒脈動
                { spellID = 12472, unitId = "player", caster = "player", filter = "BUFF" },
                -- 氣定神閒
                { spellID = 12043, unitId = "player", caster = "player", filter = "BUFF" },
                -- 時光倒轉
                { spellID = 110909, unitId = "player", caster = "player", filter = "BUFF" },
                -- 時光護盾
                { spellID = 115610, unitId = "player", caster = "player", filter = "BUFF" },
                -- 燒灼
                { spellID = 87023, unitId = "player", caster = "player", filter = "DEBUFF" },
                -- 強效隱形
                { spellID = 113862, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰霜炸彈
                { spellID = 112948, filter = "CD" },
                -- 燃灼
                { spellID = 190319, unitId = "player", caster = "player", filter = "BUFF" },
                -- 浮冰
                { spellID = 108839, unitId = "player", caster = "player", filter = "BUFF" },
                -- 秘法加速
                { spellID = 198924, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰刺
                { spellID = 199844, unitId = "player", caster = "player", filter = "BUFF" },

            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 變形術
                { spellID = 118, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 龍之吐息
                { spellID = 31661, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 減速術
                { spellID = 31589, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 燃火
                { spellID = 83853, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 點燃
                { spellID = 12654, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 活體爆彈
                { spellID = 44457, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 炎爆術
                { spellID = 11366, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 極度冰凍
                { spellID = 44572, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 冰霜爆彈
                { spellID = 112948, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 虛空暴雨
                { spellID = 114923, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 變形術
                { spellID = 118, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 活體爆彈
                { spellID = 44457, unitId = "focus", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 镜像术
                { spellID = 55342, filter = "CD" },
                -- 隐形术
                { spellID = 66, filter = "CD" },
                -- 燃火
                { spellID = 11129, filter = "CD" },
                -- 唤醒
                { spellID = 12051, filter = "CD" },
                -- 秘法強化
                { spellID = 12042, filter = "CD" },
                -- 急速冷卻
                { spellID = 11958, filter = "CD" },
                -- 極度冰凍
                { spellID = 44572, filter = "CD" },
                -- 冰寒脈動
                { spellID = 12472, filter = "CD" },
                -- 寒冰屏障
                { spellID = 45438, filter = "CD" },
                -- 冰霜之球
                { spellID = 84714, filter = "CD" },
                -- 燃燒吧
                { spellID = 205029, filter = "CD" },
                -- 燃灼
                { spellID = 190319, filter = "CD" },
            },
        },
        ["WARRIOR"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 勝利
                { spellID = 32216, unitId = "player", caster = "player", filter = "BUFF" },
                -- 嗜血
                { spellID = 23881, filter = "CD" },
                -- 巨人打击
                { spellID = 86346, filter = "CD" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 不屈打擊
                { spellID = 169686, unitId = "player", caster = "player", filter = "BUFF" },
                -- 驟亡
                { spellID = 52437, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴之怒
                { spellID = 18499, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魯莽
                { spellID = 1719, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熱血沸騰
                { spellID = 46916, unitId = "player", caster = "player", filter = "BUFF" },
                -- 劍盾合璧
                { spellID = 50227, unitId = "player", caster = "player", filter = "BUFF" },
                -- 蓄血
                { spellID = 64568, unitId = "player", caster = "player", filter = "BUFF" },
                -- 法術反射
                { spellID = 23920, unitId = "player", caster = "player", filter = "BUFF" },
                -- 勝利衝擊
                { spellID = 34428, unitId = "player", caster = "player", filter = "BUFF" },
                -- 盾牌格擋
                { spellID = 132404, unitId = "player", caster = "player", filter = "BUFF" },
                -- 盾墻
                { spellID = 871, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂怒恢復
                { spellID = 55694, unitId = "player", caster = "player", filter = "BUFF" },
                -- 橫掃攻擊
                { spellID = 12328, unitId = "player", caster = "player", filter = "BUFF" },
                -- 绞肉机
                { spellID = 85739, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂怒之擊!
                { spellID = 131116, unitId = "player", caster = "player", filter = "BUFF" },
                -- 浴血
                { spellID = 12292, unitId = "player", caster = "player", filter = "BUFF" },
                -- 怒击！
                { spellID = 131116, unitId = "player", caster = "player", filter = "BUFF" },
                -- 剑刃风暴
                { spellID = 46924, unitId = "player", caster = "player", filter = "BUFF" },
                -- 激怒
                { spellID = 12880, unitId = "player", caster = "player", filter = "BUFF" },
                -- 死亡裁决
                { spellID = 144442, unitId = "player", caster = "player", filter = "BUFF" },
                -- 盾牌屏障
                { spellID = 112048, unitId = "player", caster = "player", filter = "BUFF" },
                -- 最后通牒
                { spellID = 122510, unitId = "player", caster = "player", filter = "BUFF" },
                -- 剑在人在
                { spellID = 118038, unitId = "player", caster = "player", filter = "BUFF" },
                -- 復仇
                { spellID = 202574, unitId = "player", caster = "player", filter = "BUFF" },
                -- 復仇
                { spellID = 202573, unitId = "player", caster = "player", filter = "BUFF" },
                -- 集中怒氣（防禦）
                { spellID = 204488, unitId = "player", caster = "player", filter = "BUFF" },
                -- 集中怒氣（武器）
                { spellID = 207982, unitId = "player", caster = "player", filter = "BUFF" },
                -- 破壞鐵球
                { spellID = 215570, unitId = "player", caster = "player", filter = "BUFF" },
                -- 激怒
                { spellID = 184362, unitId = "player", caster = "player", filter = "BUFF" },
                -- 壓制
                { spellID = 60503, unitId = "player", caster = "player", filter = "BUFF" },
                -- 天神下凡
                { spellID = 107574, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 撕裂
                { spellID = 772, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 震盪波
                { spellID = 46968, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 斷筋
                { spellID = 1715, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 挫志怒吼
                { spellID = 1160, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 破膽怒吼
                { spellID = 5246, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 巨人打击
                { spellID = 208086, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 感染之傷(德魯伊)
                { spellID = 48484, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 挫志咆哮(德魯伊)
                { spellID = 99, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 鲁莽
                { spellID = 1719, filter = "CD" },
                -- 浴血奋战
                { spellID = 12292, filter = "CD" },
                -- 盾墙
                { spellID = 871, filter = "CD" },
                -- 集结呐喊
                { spellID = 97462, filter = "CD" },
                -- 破胆怒吼
                { spellID = 5246, filter = "CD" },
                -- 天神下凡
                { spellID = 107574, filter = "CD" },
            },
        },
        ["SHAMAN"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 治疗之雨
                { spellID = 73920, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石拳（山崩省略）
                { spellID = 218825, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 冰霜震击
                { spellID = 196840, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 引雷针
                { spellID = 197209, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 陷地图腾(可能不好用)
                { spellID = 64695, unitId = "target", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 冰怒
                { spellID = 210714, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熔岩奔腾
                { spellID = 77762, unitId = "player", caster = "player", filter = "BUFF" },
                -- 治療之潮
                { spellID = 53390, unitId = "player", caster = "player", filter = "BUFF" },
                -- 卓越術
                { spellID = 114052, unitId = "player", caster = "player", filter = "BUFF" },
                -- 星界轉移
                { spellID = 108271, unitId = "player", caster = "player", filter = "BUFF" },
                -- 升腾
                { spellID = 114050, unitId = "player", caster = "player", filter = "BUFF" },
                -- 先祖指引
                { spellID = 108281, unitId = "player", caster = "player", filter = "BUFF" },
                -- 元素掌握
                { spellID = 16166, unitId = "player", caster = "player", filter = "BUFF" },
            -- 灵魂行者的恩赐
                { spellID = 79206, unitId = "player", caster = "player", filter = "BUFF" },
                -- 激流
                { spellID = 61295, unitId = "player", caster = "player", filter = "BUFF" },
                -- 火舌
                { spellID = 194084, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风歌
                { spellID = 201898, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风暴使者
                { spellID = 201846, unitId = "player", caster = "player", filter = "BUFF" },
                -- 毁灭之风
                { spellID = 204945, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰封
                { spellID = 196834, unitId = "player", caster = "player", filter = "BUFF" },
                -- 漩涡之力
                { spellID = 191877, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风暴守护者
                { spellID = 205495, unitId = "player", caster = "player", filter = "BUFF" },
                -- 女王的崛起
                { spellID = 207288, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 妖术
                { spellID = 51514, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 烈焰震击
                { spellID = 188389, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 烈焰震击（治疗）
                { spellID = 188838, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 激流
                { spellID = 61295, unitId = "target", caster = "player", filter = "BUFF" },
                -- 地震术
                { spellID = 182387, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- Hex / Verhexen
                { spellID = 51514, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 烈焰震击
                { spellID = 188389, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 烈焰震击（治疗）
                { spellID = 188838, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 火元素圖騰
                { spellID = 198067, filter = "CD" },
                -- 土元素圖騰
                { spellID = 198103, filter = "CD" },
                -- 升腾
                { spellID = 114050, filter = "CD" },
                -- 岩浆图腾
                { spellID = 192222, filter = "CD" },
                -- 野性狼魂
                { spellID = 51533, filter = "CD" },
                -- 毁灭之风
                { spellID = 204945, filter = "CD" },
                -- 女王的恩赐
                { spellID = 207778, filter = "CD" },
            },
        },
        ["PALADIN"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 聖光信標
                { spellID = 53563, unitId = "player", caster = "player", filter = "BUFF" },
                -- 永恆之火
                { spellID = 114163, unitId = "player", caster = "player", filter = "BUFF" },
                -- 無私治療者
                { spellID = 114250, unitId = "player", caster = "player", filter = "BUFF" },
                -- 虔信信標
                { spellID = 156910, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 聖光信標
                { spellID = 53563, unitId = "target", caster = "player", filter = "BUFF" },
                -- 永恒之火
                { spellID = 114163, unitId = "target", caster = "player", filter = "BUFF" },
                -- 虔信信標
                { spellID = 156910, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 復仇之怒（神聖）
                { spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神圣复仇者
                { spellID = 105809, unitId = "player", caster = "player", filter = "BUFF" },
                -- 聖光灌注
                { spellID = 54149, unitId = "player", caster = "player", filter = "BUFF" },
                -- 聖佑術
                { spellID = 498, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熾烈決心
                { spellID = 166831, unitId = "player", caster = "player", filter = "BUFF" },
                -- 復仇之怒
                { spellID = 31884, unitId = "player", caster = "player", filter = "BUFF" },
                -- 圣盾術
                { spellID = 642, unitId = "player", caster = "player", filter = "BUFF" },
                -- 忠誠防衛者
                { spellID = 31850, unitId = "player", caster = "player", filter = "BUFF" },
                -- 公正之盾
                { spellID = 132403, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大十字軍
                { spellID = 85416, unitId = "player", caster = "player", filter = "BUFF" },
                -- 遠古諸王守護者
                { spellID = 86659, unitId = "player", caster = "player", filter = "BUFF" },
                -- 秩序壁壘
                { spellID = 209388, unitId = "player", caster = "player", filter = "BUFF" },
                -- 十字軍
                { spellID = 231895, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神圣意圖（懲戒）
                { spellID = 223819, unitId = "player", caster = "player", filter = "BUFF" },
                -- 正義怒火
                { spellID = 209785, unitId = "player", caster = "player", filter = "BUFF" },
                -- 以眼還眼
                { spellID = 205191, unitId = "player", caster = "player", filter = "BUFF" },
                -- 復仇聖盾
                { spellID = 184662, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神圣意圖（神聖震擊）
                { spellID = 216411, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神圣意圖（黎明曙光）
                { spellID = 216413, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熾熱殉難者
                { spellID = 223316, unitId = "player", caster = "player", filter = "BUFF" },
                -- 賦予信念
                { spellID = 223306, unitId = "player", caster = "player", filter = "BUFF" },
                -- 依法而治
                { spellID = 214202, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 自律
                { spellID = 25771, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 封阻之手
                { spellID = 183218, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 審判
                { spellID = 197277, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 制裁之錘
                { spellID = 853, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 精通光環
                { spellID = 31821, filter = "CD" },
                -- 聖佑術
                { spellID = 498, filter = "CD" },
                -- 神聖憤怒
                { spellID = 210220, filter = "CD" },
                -- 聖盾術
                { spellID = 642, filter = "CD" },
                -- 復仇之怒
                { spellID = 31884, filter = "CD" },
                -- 復仇之怒（神聖）
                { spellID = 31842, filter = "CD" },
                -- 神圣复仇者
                { spellID = 105809, filter = "CD" },
                -- 遠古諸王守護者
                { spellID = 86659, filter = "CD" },
                -- 復仇聖盾
                { spellID = 184662, filter = "CD" },
                -- 提尔的拯救（神圣神器）
                { spellID = 200652, filter = "CD" },
                -- 提尔之眼（防护神器）
                { spellID = 209202, filter = "CD" },
                -- 灰烬觉醒（惩戒神器）
                { spellID = 205273, filter = "CD" },
            },
        },
        ["PRIEST"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 真言術：盾
                { spellID = 17, unitId = "player", caster = "all", filter = "BUFF" },
                -- 虚弱靈魂
                { spellID = 6788, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 恢复
                { spellID = 139, unitId = "player", caster = "player", filter = "BUFF" },
                -- 漸隱術
                { spellID = 586, unitId = "player", caster = "player", filter = "BUFF" },
                -- 防護恐懼結界
                { spellID = 6346, unitId = "player", caster = "all", filter = "BUFF" },
                -- 預支時間
                { spellID = 59889, unitId = "player", caster = "player", filter = "BUFF" },
                -- 身心合一
                { spellID = 65081, unitId = "player", caster = "all", filter = "BUFF" },
                -- 身心合一（神牧）
                { spellID = 214121, unitId = "player", caster = "all", filter = "BUFF" },
                -- 天使之羽
                { spellID = 121557, unitId = "player", caster = "all", filter = "BUFF" },
                -- 幻影術
                { spellID = 114239, unitId = "player", caster = "player", filter = "BUFF" },
                -- 愈合之语
                { spellID = 155362, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 真言术：盾
                { spellID = 17, unitId = "target", caster = "all", filter = "BUFF" },
                -- 虚弱灵魂
                { spellID = 6788, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 恢复
                { spellID = 139, unitId = "target", caster = "player", filter = "BUFF" },
                -- 防護恐懼結界
                { spellID = 6346, unitId = "target", caster = "all", filter = "BUFF" },
                -- 救贖
                { spellID = 194384, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,
              
                -- 影散
                { spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗影强化(4T16)
                { spellID = 145180, unitId = "player", caster = "player", filter = "BUFF" },
                -- 鬼魅幻影
                { spellID = 119032, unitId = "player", caster = "player", filter = "BUFF" },
                -- 天使之壁
                { spellID = 114214, unitId = "player", caster = "player", filter = "BUFF" },
                -- 光之澎湃
                { spellID = 114255, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗奔騰
                { spellID = 87160, unitId = "player", caster = "player", filter = "BUFF" },
                -- 命運無常
                { spellID = 123254, unitId = "player", caster = "player", filter = "BUFF" },
                -- 注入能量
                { spellID = 10060, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神聖洞察
                { spellID = 123267, unitId = "player", caster = "player", filter = "BUFF" },
                -- 幽暗洞察
                { spellID = 124430, unitId = "player", caster = "player", filter = "BUFF" },
                -- 精神護罩
                { spellID = 109964, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗言术：乱
                { spellID = 132573, unitId = "player", caster = "player", filter = "BUFF" },
                -- 愈合之语(十层)
                { spellID = 155363, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂喜
                { spellID = 47536, unitId = "player", caster = "player", filter = "BUFF" },
                -- 希望象徵
                { spellID = 64901, unitId = "player", caster = "player", filter = "BUFF" },
                -- 神化
                { spellID = 200183, unitId = "player", caster = "player", filter = "BUFF" },
                -- 聖潔
                { spellID = 197030, unitId = "player", caster = "player", filter = "BUFF" },
                -- 瘋狂殘念
                { spellID = 197937, unitId = "player", caster = "player", filter = "BUFF" },
                -- 虛空射綫
                { spellID = 205372, unitId = "player", caster = "player", filter = "BUFF" },    
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 束縛不死生物
                { spellID = 9484, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 心靈尖嘯
                { spellID = 8122, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 虛無觸鬚
                { spellID = 114404, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 支配心智
                { spellID = 605, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 暗言術:痛
                { spellID = 589, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 吸血之觸
                { spellID = 34914, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 噬靈瘟疫
                { spellID = 158831, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 心靈炸彈
                { spellID = 226943, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 心靈恐慌
                { spellID = 64044, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 沉默
                { spellID = 15487, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 守護聖靈
                { spellID = 47788, unitId = "target", caster = "all", filter = "BUFF" },
                -- 痛苦鎮壓
                { spellID = 33206, unitId = "target", caster = "all", filter = "BUFF" },
                -- 意志洞悉
                { spellID = 152118, unitId = "target", caster = "all", filter = "BUFF" },
                -- 虚空熵能
                { spellID = 155361, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 心灵尖刺
                { spellID = 217673, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 束縛不死生物
                { spellID = 9484, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 心靈尖嘯
                { spellID = 8122, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 虛無觸鬚
                { spellID = 114404, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 光束泉
                { spellID = 126135, filter = "CD" },
                -- 神聖禮頌
                { spellID = 64843, filter = "CD" },
                -- 守護聖靈
                { spellID = 47788, filter = "CD" },
                -- 真言術:壁
                { spellID = 62618, filter = "CD" },
                -- 痛苦鎮壓
                { spellID = 33206, filter = "CD" },
                -- 影散
                { spellID = 47585, filter = "CD" },
                -- 吸血鬼的擁抱
                { spellID = 15286, filter = "CD" },
                -- 暗影魔
                { spellID = 34433, filter = "CD" },
                -- 注入能量
                { spellID = 10060, filter = "CD" },
                -- 絕望禱言
                { spellID = 19236, filter = "CD" },
                -- 狂喜
                { spellID = 47536, filter = "CD" },
                -- 希望象徵
                { spellID = 64901, filter = "CD" },
                -- 神化
                { spellID = 200183, filter = "CD" },
            },
        },
        ["WARLOCK"]={
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 黑暗再生
                { spellID = 108359, unitId = "player", caster = "player", filter = "BUFF" },
                -- 灵魂榨取
                { spellID = 108366, unitId = "player", caster = "player", filter = "BUFF" },
                -- 牺牲契约
                { spellID = 108416, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗交易
                { spellID = 110913, unitId = "player", caster = "player", filter = "BUFF" },
                -- 猩红恐惧
                { spellID = 111397, unitId = "player", caster = "player", filter = "BUFF" },
                -- 爆燃冲刺
                { spellID = 111400, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魔性征召
                { spellID = 114925, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魔典：恶魔牺牲
                { spellID = 196099, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔法阵：召唤
                { spellID = 48018, unitId = "player", caster = "player", filter = "BUFF" },
                -- 灵魂石保存
                { spellID = 20707, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

            },
            {
                name = "玩家重要buff&debuff",
                setpoint = positions.player_proc_icon,
                direction = "LEFT",
                size = 38,

                -- 灵魂燃烧
                { spellID = 74434, unitId = "player", caster = "player", filter = "BUFF" },
                -- 灵魂交换
                { spellID = 86211, unitId = "player", caster = "player", filter = "BUFF" },
                -- 灵魂收割
                { spellID = 196098, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熔火之心
                { spellID = 140074, unitId = "player", caster = "player", filter = "BUFF" },
                -- 协同魔典
                { spellID = 171982, unitId = "player", caster = "all", filter = "BUFF" },
                -- 炽燃之怒(2T16)
                { spellID = 145085, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗灵魂：学识
                { spellID = 113861, unitId = "player", caster = "player", filter = "BUFF" },
                -- 爆燃
                { spellID = 117828, unitId = "player", caster = "player", filter = "BUFF" },
                -- 火焰之雨
                { spellID = 104232, unitId = "player", caster = "player", filter = "BUFF" },
                -- 硫磺烈火
                { spellID = 108683, unitId = "player", caster = "player", filter = "BUFF" },
                -- 浩劫
                { spellID = 80240, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗灵魂：易爆
                { spellID = 113858, unitId = "player", caster = "player", filter = "BUFF" },
                -- 基尔加丹的狡诈
                { spellID = 137587, unitId = "player", caster = "player", filter = "BUFF" },
                -- 玛诺洛斯的狂怒
                { spellID = 108508, unitId = "player", caster = "player", filter = "BUFF" },
                -- 不灭决心
                { spellID = 104773, unitId = "player", caster = "player", filter = "BUFF" },
                -- 燃魂
                { spellID = 157698, unitId = "player", caster = "player", filter = "BUFF" },
                -- 熔火之心
                { spellID = 140074, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔箭
                { spellID = 157695, unitId = "player", caster = "player", filter = "DEBUFF" },
                -- 法力分流
                { spellID = 196104, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗影启迪
                { spellID = 196606, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魔性征召
                { spellID = 205146, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                setpoint = positions.target_proc_icon,
                direction = "RIGHT",
                mode = "ICON",
                size = 38,

                -- 恐懼術
                { spellID = 118699, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 放逐術
                { spellID = 710, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 腐蝕術
                { spellID = 146739, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 痛苦災厄
                { spellID = 980, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 痛苦動盪
                { spellID = 30108, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 蝕魂術
                { spellID = 48181, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 腐蝕種子
                { spellID = 27243, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 古尔丹之手
                { spellID = 47960, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 末日降临
                { spellID = 603, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 獻祭
                { spellID = 157736, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 浩劫
                { spellID = 80240, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 恐懼嚎叫
                { spellID = 5484, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 死亡纏繞
                { spellID = 6789, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 暗影之怒
                { spellID = 30283, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 奴役惡魔
                { spellID = 1098, unitId = "pet", caster = "player", filter = "DEBUFF" },
                -- 生命虹吸
                { spellID = 63106, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 诡异魅影
                { spellID = 205179, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 暗影烈焰
                { spellID = 205181, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 暗影烈焰
                { spellID = 196414, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 恐懼術
                { spellID = 118699, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 放逐術
                { spellID = 710, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 恐懼嚎叫
                { spellID = 5484, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,
            },
        },
        ["ROGUE"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 消失
                { spellID = 11327, unitId = "player", caster = "player", filter = "BUFF" },
                -- 矯捷
                { spellID = 193538, unitId = "player", caster = "player", filter = "BUFF" },
                -- 無聲之刃
                { spellID = 145193, unitId = "player", caster = "player", filter = "BUFF" },
                -- 剑刃乱舞
                { spellID = 13877, unitId = "player", caster = "player", filter = "BUFF" },
                -- 死亡徵兆
                { spellID = 212283, unitId = "player", caster = "player", filter = "BUFF" },
                -- 鮮血體驗
                { spellID = 213738, unitId = "player", caster = "all", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 致命毒藥
                { spellID = 2818, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 致殘毒藥
                { spellID = 3409, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 痛苦毒藥
                { spellID = 200803, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 致傷毒藥
                { spellID = 197046, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 手槍射擊
                { spellID = 185763, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,
    
                -- 疾跑
                { spellID = 2983, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗影披風
                { spellID = 31224, unitId = "player", caster = "player", filter = "BUFF" },
                -- 能量刺激
                { spellID = 13750, unitId = "player", caster = "player", filter = "BUFF" },
                -- 閃避
                { spellID = 5277, unitId = "player", caster = "player", filter = "BUFF" },
                -- 還擊
                { spellID = 199754, unitId = "player", caster = "player", filter = "BUFF" },
                -- 戰鬥就緒
                { spellID = 74001, unitId = "player", caster = "player", filter = "BUFF" },
                -- 毒化
                { spellID = 32645, unitId = "player", caster = "player", filter = "BUFF" },
                -- 切割
                { spellID = 5171, unitId = "player", caster = "player", filter = "BUFF" },
                -- 袖劍
                { spellID = 202754, unitId = "player", caster = "player", filter = "BUFF" },
                -- 偷天換日
                { spellID = 57934, unitId = "player", caster = "player", filter = "BUFF" },
                -- 偷天換日(傷害之後)
                { spellID = 59628, unitId = "player", caster = "player", filter = "BUFF" },
                -- 佯攻
                { spellID = 1966, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗影之舞
                { spellID = 185422, unitId = "player", caster = "player", filter = "BUFF" },
                -- 敏銳大師
                { spellID = 31665, unitId = "player", caster = "player", filter = "BUFF" },
                -- 毀滅者之怒
                { spellID = 109949, unitId = "player", caster = "player", filter = "BUFF" },
                -- 精密計畫
                { spellID = 193641, unitId = "player", caster = "player", filter = "BUFF" },
                -- 欺敵
                { spellID = 115192, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大好機會
                { spellID = 195627, unitId = "player", caster = "player", filter = "BUFF" },
                -- 絕對方位
                { spellID = 193359, unitId = "player", caster = "player", filter = "BUFF" },
                -- 地底藏寶
                { spellID = 199600, unitId = "player", caster = "player", filter = "BUFF" },
                -- 側舷截擊
                { spellID = 193356, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑旗
                { spellID = 199603, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大亂鬥
                { spellID = 193358, unitId = "player", caster = "player", filter = "BUFF" },
                -- 兇鯊海域
                { spellID = 193357, unitId = "player", caster = "player", filter = "BUFF" },
                -- 赤紅藥瓶
                { spellID = 185311, unitId = "player", caster = "player", filter = "BUFF" },
                -- 暗影之刃
                { spellID = 121471, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恐惧之刃诅咒（狂徒神器）
                { spellID = 202665, unitId = "player", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 偷襲
                { spellID = 1833, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 腎擊
                { spellID = 408, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 正中眉心
                { spellID = 199804, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 鬼魅攻擊
                { spellID = 196937, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 致盲
                { spellID = 2094, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 悶棍
                { spellID = 6770, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 割裂
                { spellID = 1943, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 絞喉
                { spellID = 703, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 絞喉沉默
                { spellID = 1330, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 鑿擊
                { spellID = 1776, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 宿怨
                { spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 出血
                { spellID = 16511, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 君王之灾（刺杀神器）
                { spellID = 192759, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 遇刺者之血（刺杀神器）
                { spellID = 192925, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 找尋弱點
                { spellID = 91021, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 制裁之錘
                { spellID = 853, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 夜刃
                { spellID = 195452, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 致盲
                { spellID = 2094, unitId = "focus", caster = "all", filter = "DEBUFF" },
                -- 悶棍
                { spellID = 6770, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 死亡標記
                { spellID = 137619, filter = "CD" },
                -- 暗影閃現
                { spellID = 36554, filter = "CD" },
                -- 繩鉤
                { spellID = 195457, filter = "CD" },
                -- 疾跑
                { spellID = 2983, filter = "CD" },
                -- 斗篷
                { spellID = 31224, filter = "CD" },
                -- 闪避
                { spellID = 5277, filter = "CD" },
                -- 猩红血瓶
                { spellID = 185311, filter = "CD" },
                -- 致盲
                { spellID = 2094, filter = "CD" },
                -- 偷天換日
                { spellID = 57934, filter = "CD" },
                -- 战斗就绪
                { spellID = 74001, filter = "CD" },
                -- 烟雾弹
                { spellID = 76577, filter = "CD" },
                -- 消失
                { spellID = 1856, filter = "CD" },
                -- 宿怨
                { spellID = 79140, filter = "CD" },
                -- 狂舞杀戮
                { spellID = 51690, filter = "CD" },
                -- 能量刺激
                { spellID = 13750, filter = "CD" },
                -- 奧術之流
                { spellID = 25046, filter = "CD" },
                -- 君王之灾（刺杀神器）
                { spellID = 192759, filter = "CD" },
                -- 恐惧之刃诅咒（狂徒神器）
                { spellID = 202665, filter = "CD" },
                -- 恐惧之刃诅咒（敏锐神器）
                { spellID = 209782, filter = "CD" },
            },
        },
        ["DEATHKNIGHT"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 冰結之爪
                { spellID = 194879, unitId = "player", caster = "player", filter = "BUFF" },
                -- 寒冰之盾
                { spellID = 207203, unitId = "player", caster = "player", filter = "BUFF" },
                -- 枯萎凋零
                { spellID = 188290, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 冷酷寒冬
                { spellID = 211793, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 锋锐之霜
                { spellID = 51714, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 血魄護盾
                { spellID = 77535, unitId = "player", caster = "player", filter = "BUFF" },
                -- 血族之裔
                { spellID = 55233, unitId = "player", caster = "player", filter = "BUFF" },
                -- 穢邪力量
                { spellID = 53365, unitId = "player", caster = "player", filter = "BUFF" },
                -- 穢邪之力
                { spellID = 67117, unitId = "player", caster = "player", filter = "BUFF" },
                -- 符文武器幻舞
                { spellID = 81256, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰錮堅韌
                { spellID = 48792, unitId = "player", caster = "player", filter = "BUFF" },
                -- 反魔法護罩
                { spellID = 48707, unitId = "player", caster = "player", filter = "BUFF" },
                -- 殺戮酷刑
                { spellID = 51124, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰封之霧
                { spellID = 59052, unitId = "player", caster = "player", filter = "BUFF" },
                -- 骸骨之盾
                { spellID = 195181, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰霜之柱
                { spellID = 51271, unitId = "player", caster = "player", filter = "BUFF" },
                -- 血魄之鏡
                { spellID = 206977, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗救贖
                { spellID = 101568, unitId = "player", caster = "player", filter = "BUFF" },
                -- 寶寶能量
                { spellID = 91342, unitId = "pet", caster = "player", filter = "BUFF" },
                -- 黑暗變身
                { spellID = 63560, unitId = "pet", caster = "player", filter = "BUFF" },
                -- 鮮血氣息
                { spellID = 50421, unitId = "player", caster = "player", filter = "BUFF" },
                -- 幽魂步
                { spellID = 212552, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冷酷寒冬
                { spellID = 196770, unitId = "player", caster = "player", filter = "BUFF" },
                -- 滅體抹殺
                { spellID = 207256, unitId = "player", caster = "player", filter = "BUFF" },
                -- 靈魂收割者（加速）
                { spellID = 215711, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 絞殺
                { spellID = 47476, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 血魄瘟疫
                { spellID = 55078, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 膿瘡傷口
                { spellID = 194310, unitId = "target", caster = "player", filter = "DEBUFF" },
                --冰霜熱疫
                { spellID = 55095, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 召喚石像鬼
                { spellID = 49206, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 死亡凋零
                { spellID = 43265, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 溃烂之伤
                { spellID = 194310, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 惡性瘟疫
                { spellID = 191587, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 靈魂收割者
                { spellID = 130736, unitId = "target", caster = "player", filter = "DEBUFF" },
                { spellID = 114866, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 大軍
                { spellID = 42650, filter = "CD" },
                -- 黑暗仲裁者
                { spellID = 207349, filter = "CD" },
                -- 滅體抹殺
                { spellID = 207256, filter = "CD" },
                -- 符文武器
                { spellID = 47568, filter = "CD" },
            },
        },
        ["MONK"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 回生迷霧
                { spellID = 119611, unitId = "player", caster = "player", filter = "BUFF" },
                -- 迷霧繚繞
                { spellID = 132120, unitId = "player", caster = "player", filter = "BUFF" },
                -- 舒和之霧
                { spellID = 115175, unitId = "player", caster = "player", filter = "BUFF" },
                -- 酒仙小緩勁
                { spellID = 124275, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 酒仙中緩勁
                { spellID = 124274, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 酒仙大緩勁
                { spellID = 124273, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 聚氣打擊
                { spellID = 129914, unitId = "player", caster = "player", filter = "BUFF" },
                -- 猛虎之眼（治疗）
                { spellID = 196608, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 回生迷霧
                { spellID = 119611, unitId = "target", caster = "player", filter = "BUFF" },
                -- 迷霧繚繞
                { spellID = 132120, unitId = "target", caster = "player", filter = "BUFF" },
                -- 舒和之霧
                { spellID = 115175, unitId = "target", caster = "player", filter = "BUFF" },
                -- 猛虎之眼（伤害）
                { spellID = 196608, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 虎掌
                { spellID = 125359, unitId = "player", caster = "player", filter = "BUFF" },
                -- 禪心玉
                { spellID = 124081, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石形絕釀
                { spellID = 120954, unitId = "player", caster = "player", filter = "BUFF" },
                -- 醉拳
                { spellID = 115307, unitId = "player", caster = "player", filter = "BUFF" },
                -- 護身氣勁
                { spellID = 115295, unitId = "player", caster = "player", filter = "BUFF" },
                -- 乾坤挪移
                { spellID = 125174, unitId = "player", caster = "player", filter = "BUFF" },
                -- 禪院教誨
                { spellID = 202090, unitId = "player", caster = "player", filter = "BUFF" },
                -- 精活迷霧
                { spellID = 118674, unitId = "player", caster = "player", filter = "BUFF" },
                -- 連段破:滅寂腿
                { spellID = 116768, unitId = "player", caster = "player", filter = "BUFF" },
                -- 連段破:虎掌
                { spellID = 118864, unitId = "player", caster = "player", filter = "BUFF" },
                -- 连击
                { spellID = 196741, unitId = "player", caster = "player", filter = "BUFF" },
                -- 风火大地
                { spellID = 137639, unitId = "player", caster = "player", filter = "BUFF" },
                -- 冰心诀
                { spellID = 152173, unitId = "player", caster = "player", filter = "BUFF" },
                -- 聚雷茶
                { spellID = 116680, unitId = "player", caster = "player", filter = "BUFF" },
                -- 生生不息(迷霧繚繞)
                { spellID = 197919, unitId = "player", caster = "player", filter = "BUFF" },
                -- 生生不息(生氣勃勃)
                { spellID = 197916, unitId = "player", caster = "player", filter = "BUFF" },
                -- 法力茶
                { spellID = 197908, unitId = "player", caster = "player", filter = "BUFF" },
                -- 金鐘絕釀
                { spellID = 215479, unitId = "player", caster = "player", filter = "BUFF" },
                -- 散魔功
                { spellID = 122783, unitId = "player", caster = "player", filter = "BUFF" },
                -- 猛虎出閘
                { spellID = 116841, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 掃葉腿
                { spellID = 119381, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 微醺醉氣
                { spellID = 116330, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 幽冥掌
                { spellID = 115080, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 冥思禪功
                { spellID = 115176, filter = "CD" },
                -- 乾坤挪移
                { spellID = 122470, filter = "CD" },
                -- 召喚白虎雪怒
                { spellID = 123904, filter = "CD" },
                -- 凝神絕釀
                { spellID = 115288, filter = "CD" },
                -- 石形絕釀
                { spellID = 115203, filter = "CD" },
                -- 召喚玄牛雕像
                { spellID = 115315, filter = "CD" },
                -- 氣繭護體
                { spellID = 116849, filter = "CD" },
                -- 五氣歸元
                { spellID = 115310, filter = "CD" },
            },
        },
        ["DEMONHUNTER"] = {
            {
                name = "玩家buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_buff_icon,
                size = 28,

                -- 靈魂碎片
                { spellID = 203981, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_buff_icon,
                size = 28,

                -- 生命之花
                -- { spellID = 33763, unitId = "target", caster = "player", filter = "BUFF" },
            },
            {
                name = "玩家重要buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_proc_icon,
                size = 38,

                -- 惡魔化身（浩劫）
                { spellID = 162264, unitId = "player", caster = "player", filter = "BUFF" },
                -- 惡魔化身（复仇）
                { spellID = 187827, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔之魂
                { spellID = 163073, unitId = "player", caster = "player", filter = "BUFF" },
                -- 惡魔尖刺
                { spellID = 203819, unitId = "player", caster = "player", filter = "BUFF" },
                -- 強化結界
                { spellID = 218256, unitId = "player", caster = "player", filter = "BUFF" },
                -- 虹吸能量
                { spellID = 218561, unitId = "player", caster = "player", filter = "BUFF" },
                -- 獻祭光環
                { spellID = 178740, unitId = "player", caster = "player", filter = "BUFF" },
                -- 氣勢如虹
                { spellID = 208628, unitId = "player", caster = "player", filter = "BUFF" },
                -- 混沌之刃
                { spellID = 211048, unitId = "player", caster = "player", filter = "BUFF" },
            },
            {
                name = "目标重要buff&debuff",
                direction = "RIGHT",
                setpoint = positions.target_proc_icon,
                size = 38,

                -- 熾炎烙印
                { spellID = 207744, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 放血
                { spellID = 207690, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 死敵
                { spellID = 206491, unitId = "target", caster = "player", filter = "DEBUFF" },
            },
            {
                name = "焦点buff&debuff",
                direction = "UP",
                setpoint = positions.focus_buff_icon,
                size = 24,
                mode = "BAR",
                iconSide = "LEFT",
                barWidth = 170,

                -- 糾纏根鬚
                -- { spellID = 339, unitId = "focus", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "CD",
                iconSide = "LEFT",
                size = 28,
                barWidth = 170,
                direction = function() return R:IsDeveloper() and "RIGHT" or "DOWN" end,
                mode = function() return R:IsDeveloper() and "ICON" or "BAR" end,
                setpoint = positions.cd_icon,

                -- 惡魔化身（浩劫）
                { spellID = 191427, filter = "CD" },
                -- 惡魔化身（复仇）
                { spellID = 187827, filter = "CD" },
                -- 靈視
                { spellID = 188501, filter = "CD" },
                -- 熾炎烙印
                { spellID = 204021, filter = "CD" },
                -- 魔化破滅
                { spellID = 212084, filter = "CD" },
                -- 殘影
                { spellID = 198589, filter = "CD" },
                -- 混沌之刃
                { spellID = 211048, filter = "CD" },
                -- 伊利达雷之怒（浩劫神器）
                { spellID = 201467, filter = "CD" },
                -- 灵魂切削（复仇神器）
                { spellID = 207407, filter = "CD" },
            },
        },
        ["ALL"]={
            {
                name = "玩家特殊buff&debuff",
                direction = "LEFT",
                setpoint = positions.player_special_icon,
                size = 38,

                -- 專業技能
                -- 硝基推進器
                { spellID = 54861, unitId = "player", caster = "all", filter = "BUFF" },
                -- 降落傘
                { spellID = 55001, unitId = "player", caster = "all", filter = "BUFF" },
                -- 德萊尼煉金石
                { spellID = 60234, unitId = "player", caster = "all", filter = "BUFF" },

                -- 藥水
                -- Draenic Agility Potion
                { spellID = 156423, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Intellect Potion
                { spellID = 156426, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Strength Potion
                { spellID = 156428, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Armor Potion
                { spellID = 156430, unitId = "player", caster = "player", filter = "BUFF" },

                -- 特殊buff
                -- 偷天換日
                { spellID = 57933, unitId = "player", caster = "all", filter = "BUFF" },
                -- 嗜血術
                { spellID = 2825, unitId = "player", caster = "all", filter = "BUFF" },
                -- 英勇氣概
                { spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
                -- 時間扭曲
                { spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
                -- 上古狂亂
                { spellID = 90355, unitId = "player", caster = "all", filter = "BUFF" },
                -- 戒備守護
                { spellID = 114030, unitId = "player", caster = "all", filter = "BUFF" },
                -- 群體法術反射
                { spellID = 114028, unitId = "player", caster = "all", filter = "BUFF" },
                -- 命令之吼
                { spellID = 97463, unitId = "player", caster = "all", filter = "BUFF" },
                -- 反魔法力场
                { spellID = 145629, unitId = "player", caster = "all", filter = "BUFF" },
                -- 犧牲聖禦
                { spellID = 6940, unitId = "player", caster = "all", filter = "BUFF" },
                -- 保護聖禦
                { spellID = 1022, unitId = "player", caster = "all", filter = "BUFF" },
                -- 精通光環
                { spellID = 31821, unitId = "player", caster = "all", filter = "BUFF" },
                -- 希望象征
                { spellID = 64901, unitId = "player", caster = "all", filter = "BUFF" },
                -- 守護聖靈
                { spellID = 47788, unitId = "player", caster = "all", filter = "BUFF" },
                -- 痛苦鎮壓
                { spellID = 33206, unitId = "player", caster = "all", filter = "BUFF" },
                -- 真言術：壁
                { spellID = 81782, unitId = "player", caster = "all", filter = "BUFF" },
                -- 灵魂链接图腾
                { spellID = 98008, unitId = "player", caster = "all", filter = "BUFF" },
                -- 氣繭護體
                { spellID = 116849, unitId = "player", caster = "all", filter = "BUFF" },
                -- 鐵樹皮術
                { spellID = 102342, unitId = "player", caster = "all", filter = "BUFF" },
                -- 奔竄咆哮
                { spellID = 77761, unitId = "player", caster = "all", filter = "BUFF" },
                -- 風爆
                { spellID = 204477, unitId = "player", caster = "all", filter = "BUFF" },

                -- 橙色多彩
                -- 不屈之源钻 (耐力, 减伤)
                { spellID = 137593, unitId = "player", caster = "all", filter = "BUFF" },
                -- 阴险之源钻 (爆击, 急速)
                { spellID = 137590, unitId = "player", caster = "all", filter = "BUFF" },
                -- 英勇之源钻 (智力, 节能)
                { spellID = 137331, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137247, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137323, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137326, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 137288, unitId = "player", caster = "all", filter = "BUFF" },

                -- 橙色披风
                -- 赤精之魂 (治疗)
                { spellID = 146200, unitId = "player", caster = "all", filter = "BUFF" },
                -- 雪怒之捷 (物理)
                { spellID = 146194, unitId = "player", caster = "all", filter = "BUFF" },
                -- 玉珑之精 (法系)
                { spellID = 146198, unitId = "player", caster = "all", filter = "BUFF" },
                -- 砮皂之韧 (坦克)
                { spellID = 148010, unitId = "player", caster = "all", filter = "BUFF" },

                -- 種族天賦
                -- 血之烈怒
                { spellID = 20572, unitId = "player", caster = "player", filter = "BUFF" },
                -- 狂暴
                { spellID = 26297, unitId = "player", caster = "player", filter = "BUFF" },
                -- 石像形态
                { spellID =  65116, unitId = "player", caster = "player", filter = "BUFF" },
                -- 疾步夜行
                { spellID =  68992, unitId = "player", caster = "player", filter = "BUFF" },
                -- 影遁
                { spellID =  58984, unitId = "player", caster = "player", filter = "BUFF" },
                -- 纳鲁的赐福
                { spellID =  28880, unitId = "player", caster = "all", filter = "BUFF" },

                -- 法師T16, 冰凍意念
                { spellID = 146557, unitId = "player", caster = "all", filter = "BUFF" },
                { spellID = 145252, unitId = "player", caster = "all", filter = "BUFF" },

                -- 7.0 军团再临
                -- 安格博达的回忆（力量/敏捷）
                { spellID = 214802, unitId = "player", caster = "all", filter = "BUFF" }, -- 因格瓦尔的嚎叫（爆击，红脸）
                { spellID = 214803, unitId = "player", caster = "all", filter = "BUFF" }, -- 席瓦拉的哀号（急速，绿脸）
                { spellID = 214807, unitId = "player", caster = "all", filter = "BUFF" }, -- 安格博达的挽歌（精通，蓝脸）
                -- 賈辛的機敏
                { spellID = 224149, unitId = "player", caster = "all", filter = "BUFF" },
            },
            {
                name = "PVE/PVP玩家buff&debuff",
                direction = "UP",
                setpoint = positions.pve_player_icon,
                size = 51,

                -- 死亡騎士
                -- 啃食
                { spellID = 91800, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 暴猛痛擊
                { spellID = 91797, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 窒息術
                { spellID = 108194, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冷酷凜冬
                { spellID = 115001, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 絞殺
                { spellID = 47476, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 黑暗幻象
                { spellID = 77606, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰鍊術
                { spellID = 45524, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 凍瘡
                { spellID = 50435, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 德魯伊
                -- 颶風術
                { spellID = 33786, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 猛力重擊
                { spellID = 5211, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 傷殘術
                { spellID = 22570, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 掠魂咆哮
                { spellID = 99, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 太陽光束
                { spellID = 78675, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 精靈沉默
                { spellID = 114238, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 糾纏根鬚
                { spellID = 339, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 無法移動
                { spellID = 45334, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 感染之傷
                { spellID = 58180, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 颱風
                { spellID = 61391, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 獵人
                -- 脅迫
                { spellID = 24394, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 禁錮射擊
                { spellID = 117526, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰凍陷阱
                { spellID = 3355, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 翼龍釘刺
                { spellID = 19386, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 險裡逃生
                { spellID = 136634, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震盪射擊
                { spellID = 5116, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 凍痕
                { spellID = 61394, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜雷之息 (奇特奇美拉)
                { spellID = 54644, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 腳踝粉碎 (鱷魚)
                { spellID = 50433, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 時間扭曲 (扭曲巡者)
                { spellID = 35346, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 音波衝擊 (蝙蝠)
                { spellID = 50519, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 法師
                -- 極度冰凍
                { spellID = 44572, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 變形術
                { spellID = 118, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜之環
                { spellID = 82691, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 龍之吐息
                { spellID = 31661, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰凍術 (水元素)
                { spellID = 33395, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰霜新星
                { spellID = 122, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 寒冰結界
                { spellID = 111340, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰錐術
                { spellID = 120, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 減速術
                { spellID = 31589, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 寒冰箭
                { spellID = 116, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 霜火箭
                { spellID = 44614, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰凍
                { spellID = 7321, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 武僧
                -- 點穴
                { spellID = 115078, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 掃葉腿
                { spellID = 119381, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 狂拳連打
                { spellID = 120086, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 鐵牛衝鋒波
                { spellID = 119392, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 傷筋斷骨
                { spellID = 116706, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 聖騎士
                -- 制裁之錘
                { spellID = 853, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 懺悔
                { spellID = 20066, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 盲目之光
                { spellID = 105421, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 復仇之盾
                { spellID = 31935, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 暈眩 - 復仇之盾
                { spellID = 63529, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 封阻之手
                { spellID = 183218, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 牧師
                -- 支配心智
                { spellID = 605, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 心靈尖嘯
                { spellID = 8122, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 心靈恐慌
                { spellID = 64044, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 罪與罰
                { spellID = 87204, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 沉默
                { spellID = 15487, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 虛無觸鬚之握
                { spellID = 114404, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 精神鞭笞
                { spellID = 15407, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 盜賊
                -- 腎擊
                { spellID = 408, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 烟雾弹
                { spellID = 88611, unitId = "player", caster = "all", filter = "BUFF" },
                -- 偷襲
                { spellID = 1833, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 悶棍
                { spellID = 6770, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 致盲
                { spellID = 2094, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 鑿擊
                { spellID = 1776, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 絞喉 - 沉默
                { spellID = 1330, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 煙霧彈
                { spellID = 76577, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 擲殺
                { spellID = 26679, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 致殘毒藥
                { spellID = 3409, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 薩滿
                -- 妖術
                { spellID = 51514, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 靜電衝擊
                { spellID = 118905, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 粉碎
                { spellID = 118345, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 地震術
                { spellID = 77505, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 陷地
                { spellID = 64695, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 地縛術
                { spellID = 3600, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 冰霜震擊
                { spellID = 8056, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 雷霆風暴
                { spellID = 51490, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 術士
                -- 暗影之怒
                { spellID = 30283, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 投擲利斧 (惡魔守衛)
                { spellID = 89766, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 恐懼術
                { spellID = 118699, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 恐懼嚎叫
                { spellID = 5484, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 血性恐懼
                { spellID = 137143, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 死影纏繞
                { spellID = 6789, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 誘惑 (魅魔)
                { spellID = 6358, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 迷惑 (Shivarra)
                { spellID = 115268, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 痛苦動盪
                { spellID = 31117, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 焚燒
                { spellID = 17962, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 暗影之焰
                { spellID = 47960, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 戰士
                -- 暴風怒擲
                { spellID = 132169, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震懾波
                { spellID = 132168, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 戰爭使者
                { spellID = 105771, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震地怒吼
                { spellID = 107566, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 斷筋
                { spellID = 1715, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 刺耳怒吼
                { spellID = 12323, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 巨像碎擊
                { spellID = 86346, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 衝鋒昏迷
                { spellID = 7922, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 種族天賦
                -- 戰爭踐踏
                { spellID = 20549, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 震動掌
                { spellID = 107079, unitId = "player", caster = "all", filter = "DEBUFF" },
                -- 奧流之術
                { spellID = 28730, unitId = "player", caster = "all", filter = "DEBUFF" },

                -- 其他
                -- 火箭燃料漏油
                { spellID = 94794, unitId = "player", caster = "all", filter = "DEBUFF" },
            },
            {
                name = "PVE/PVP目标buff&debuff",
                direction = "UP",
                setpoint = positions.pve_target_icon,
                size = 51,

                -- 法術反射
                { spellID = 23920, unitId = "target", caster = "all", filter = "BUFF" },
                -- 精通光環
                { spellID = 31821, unitId = "target", caster = "all", filter = "BUFF" },
                -- 寒冰屏障
                { spellID = 45438, unitId = "target", caster = "all", filter = "BUFF" },
                -- 暗影披風
                { spellID = 31224, unitId = "target", caster = "all", filter = "BUFF" },
                -- 聖盾術
                { spellID = 642, unitId = "target", caster = "all", filter = "BUFF" },
                -- 威懾
                { spellID = 19263, unitId = "target", caster = "all", filter = "BUFF" },
                -- 反魔法護罩
                { spellID = 48707, unitId = "target", caster = "all", filter = "BUFF" },
                -- 巫妖之軀
                { spellID = 49039, unitId = "target", caster = "all", filter = "BUFF" },
                -- 自由祝福
                { spellID = 1044, unitId = "target", caster = "all", filter = "BUFF" },
                -- 犧牲祝福
                { spellID = 6940, unitId = "target", caster = "all", filter = "BUFF" },
                -- 保護祝福
                { spellID = 1022, unitId= "target", caster = "all", filter = "BUFF" },
                -- 根基圖騰效果
                { spellID = 8178, unitId = "target", caster = "all", filter = "BUFF" },
            },
        },
    }
}
