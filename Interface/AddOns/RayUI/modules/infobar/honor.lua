local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local IF = R:GetModule("InfoBar")

local function LoadHonor()
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Honor", 100)
	infobar:SetPoint("RIGHT", RayUI_InfoPanel_Talent, "LEFT", 0, 0)

	infobar:SetScript("OnMouseDown", function() PVEFrame_ToggleFrame("PVPUIFrame") end)
	
	if UnitLevel("player") < 110 then
		infobar.Text:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..L["锁定"])
	return end

	local current = UnitHonor("player");
	local max = UnitHonorMax("player");
	local level = UnitHonorLevel("player")
	local levelmax = GetMaxPlayerHonorLevel()
	local percent = current/max * 100

	infobar:SetScript("OnUpdate", function(self)
		infobar.Text:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..level)
	end)

	infobar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
		GameTooltip:AddLine(title,r,g,b,false)
		GameTooltip:AddLine(HONOR)
		if (CanPrestige()) then
			GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE);
		elseif (level == levelmax) then
			GameTooltip:AddLine(MAX_HONOR_LEVEL);
		else
			GameTooltip:AddDoubleLine(HONOR_BAR:gsub("%%d/%%d",""), format("%d / %d (%.2f%%)", current, max, percent), 1, 1, 1)
			GameTooltip:AddDoubleLine(L["剩余"], format("%d", max - current), 1, 1, 1)
		end
		GameTooltip:Show()
	end)

	infobar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

IF:RegisterInfoText("honor", LoadHonor)
