----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()

R.myclass            = select(2, UnitClass("player"))
R.myname             = UnitName("player")
R.myrealm            = GetRealmName()
R.version            = GetAddOnMetadata(_AddOnName, "Version")
_G.BINDING_HEADER_RAYUI = GetAddOnMetadata(_AddOnName, "Title")

RayUF.colors.power["MANA"] = { 0, 0.5, 1 }

RayUF["colors"].class = {
    ["DEATHKNIGHT"] = { 0.77, 0.12, 0.23}, -- #c41f3b
    ["DEMONHUNTER"] = { 0.64, 0.19, 0.79}, -- #a330c9
    ["DRUID"]       = { 1, 0.49, 0.04}, -- #ff7d0a
    ["HUNTER"]      = { 0.67, 0.83, 0.45}, -- #abd473
    ["MAGE"]        = { 0.25, 0.78, 0.92}, -- #3fc7eb
    ["MONK"]        = { 0, 1, 0.59}, -- #00ff96
    ["PALADIN"]     = { 0.96, 0.55, 0.73}, -- #f58cba
    ["PRIEST"]      = { 1, 1, 1}, -- #ffffff
    ["ROGUE"]       = { 1, 0.96, 0.41}, -- #fff569
    ["SHAMAN"]      = { 0, 0.44, 0.87}, -- #0070de
    ["WARLOCK"]     = { 0.53, 0.53, 0.93}, -- #8788ee
    ["WARRIOR"]     = { 0.78, 0.61, 0.43}, -- #c79c6e
}

RayUF["colors"].reaction = {
    [1] = { 1, 0.2, 0.2 }, -- Hated
    [2] = { 1, 0.2, 0.2 }, -- Hostile
    [3] = { 1, 0.6, 0.2 }, -- Unfriendly
    [4] = { 1, 1, 0.2 }, -- Neutral
    [5] = { 0.2, 1, 0.2 }, -- Friendly
    [6] = { 0.2, 1, 0.2 }, -- Honored
    [7] = { 0.2, 1, 0.2 }, -- Revered
    [8] = { 0.2, 1, 0.2 }, -- Exalted
}

RayUF["colors"].ComboPoints = {
    [1] = { 1, 0, 0 }, -- Red
    [2] = { 1, 1, 0 }, -- Yellow
    [3] = { 0, 1, 0 }, -- Green
}

R.colors = {
    class = {},
}

for class, color in pairs(RayUF.colors.class) do
    R.colors.class[class] = { r = color[1], g = color[2], b = color[3] }
end

for reaction, color in pairs(RayUF.colors.reaction) do
    FACTION_BAR_COLORS[reaction] = { r = color[1], g = color[2], b = color[3] }
end
