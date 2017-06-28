----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("InfoBar")


local IF = _InfoBar

local function Honor_OnUpdate(self)
    if UnitLevel("player") < 110 then
        self:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..L["锁定"])
    else
        self:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..UnitHonorLevel("player"))
    end
end

local function Honor_OnEnter(self)
    if UnitLevel("player") < 110 then return end
    
    local ch = UnitHonor("player");
    local mh = UnitHonorMax("player");
    local level = UnitHonorLevel("player")
    local levelmax = GetMaxPlayerHonorLevel()
    local perc = ch / mh * 100

    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 0)
    GameTooltip:AddLine(HONOR, 1, 1, 1)
    GameTooltip:SetPrevLineJustify("CENTER")
    GameTooltip:AddDivider()
    
    if (CanPrestige()) then
        GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE);
    elseif (level == levelmax) then
        GameTooltip:AddLine(MAX_HONOR_LEVEL);
    else
        GameTooltip:AddDoubleLine(HONOR_BAR:gsub("%%d/%%d",""), format("%d / %d (%.1f%%)", ch, mh, perc), 1, 1, 1)
        GameTooltip:AddDoubleLine(L["剩余"], format("%d", mh - ch), 1, 1, 1)
    end
    
    GameTooltip:Show()
end

local function Honor_OnClick(self)
    PVEFrame_ToggleFrame("PVPUIFrame")
end



do -- Initialize
    local info = {}

    info.title = HONOR
    info.icon = "Interface\\Icons\\achievement_arena_2v2_1"
    info.clickFunc = Honor_OnClick
    info.onUpdate = Honor_OnUpdate
    info.tooltipFunc = Honor_OnEnter

    IF:RegisterInfoBarType("Honor", info)
end
