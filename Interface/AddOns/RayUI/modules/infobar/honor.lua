local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

local function LoadHonor()
	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Honor", 100)
	infobar:SetPoint("RIGHT", RayUI_InfoPanel_Talent, "LEFT", 0, 0)

    infobar:RegisterEvent("PLAYER_ENTERING_WORLD")
    infobar:RegisterEvent("HONOR_XP_UPDATE")
    infobar:RegisterEvent("HONOR_PRESTIGE_UPDATE")
	
	infobar:SetScript("OnUpdate", function(self)
		if UnitLevel("player") < 110 then
			infobar.Text:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..L["锁定"])
		else
			infobar.Text:SetText(HONOR_LEVEL_LABEL:gsub("%%d","")..UnitHonorLevel("player"))
		end
	end)
	infobar:SetScript("OnEnter", function(self)
		if UnitLevel("player") < 110 then return end

		local ch = UnitHonor("player");
		local mh = UnitHonorMax("player");
		local level = UnitHonorLevel("player")
		local levelmax = GetMaxPlayerHonorLevel()
		local percent = ch / mh * 100

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
		GameTooltip:AddLine(title,r,g,b,false)
		GameTooltip:AddLine(HONOR)
		if (CanPrestige()) then
			GameTooltip:AddLine(PVP_HONOR_PRESTIGE_AVAILABLE);
		elseif (level == levelmax) then
			GameTooltip:AddLine(MAX_HONOR_LEVEL);
		else
			GameTooltip:AddDoubleLine(HONOR_BAR:gsub("%%d/%%d",""), format("%d / %d (%.2f%%)", ch, mh, percent), 1, 1, 1)
			GameTooltip:AddDoubleLine(L["剩余"], format("%d", mh - ch), 1, 1, 1)
		end
		GameTooltip:Show()
	end)
	infobar:SetScript("OnLeave", GameTooltip_Hide)

	infobar:SetScript("OnMouseDown", function() PVEFrame_ToggleFrame("PVPUIFrame") end)
end

IF:RegisterInfoText("honor", LoadHonor)
