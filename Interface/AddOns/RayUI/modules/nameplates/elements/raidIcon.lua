----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("NamePlates")


local mod = _NamePlates

function mod:UpdateElement_RaidIcon(frame)
    local icon = frame.RaidTargetIndicator;
    local index = GetRaidTargetIndex(frame.unit);
    icon:ClearAllPoints()
    if(frame.HealthBar:IsShown()) then
        icon:SetPoint("RIGHT", frame.HealthBar, "LEFT", -6, 0)
    else
        icon:SetPoint("BOTTOM", frame.Name, "TOP", 0, 3)
    end

    if ( index ) then
        SetRaidTargetIconTexture(icon, index);
        icon:Show();
    else
        icon:Hide();
    end
end

function mod:ConstructElement_RaidIcon(frame)
    local texture = frame:CreateTexture(nil, "OVERLAY")
    texture:SetPoint("RIGHT", frame.HealthBar, "LEFT", -6, 0)
    texture:SetSize(40, 40)
    texture:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
    texture:Hide()

    return texture
end
