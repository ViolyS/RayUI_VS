----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")


local mod = _NamePlates

local function HighlightUpdate(self)
    if not UnitExists("mouseover") or not self.unit or not UnitIsUnit("mouseover", self.unit) then
        self.Name.NameOnlyGlow:Hide()
        self.Highlight:Hide()
        self:SetScript("OnUpdate",nil)
    end
end

function mod:UpdateElement_Highlight(frame)
    if not self.db.units[frame.UnitType].healthbar and not frame.isTarget then
        frame.Name.NameOnlyGlow:Show()
        frame.Highlight.handler:SetScript("OnUpdate", function() HighlightUpdate(frame) end)
    elseif UnitIsUnit("mouseover", frame.unit) and not frame.isTarget then
        frame.Highlight:ClearAllPoints()
        frame.Highlight:SetPoint("TOPLEFT", frame.HealthBar, "TOPLEFT")
        frame.Highlight:SetPoint("BOTTOMRIGHT", frame.HealthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        frame.Highlight:Show()
        frame.Highlight.handler:SetScript("OnUpdate", function() HighlightUpdate(frame) end)
    else
        frame.Highlight:Hide()
        frame.Highlight.handler:SetScript("OnUpdate", nil)
    end
end

function mod:ConstructElement_Highlight(frame)
    local f = frame.HealthBar:CreateTexture(nil, "ARTWORK", nil, 1)
    f.handler = CreateFrame("Frame")
    f:SetTexture(R["media"].normal)
    f:SetVertexColor(1, 1, 1, .3)
    f:Hide()
    return f
end
