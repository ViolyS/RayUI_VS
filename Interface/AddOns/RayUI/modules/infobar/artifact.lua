local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

local function LoadArtifact()
	LoadAddOn("Blizzard_ArtifactUI")

	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Artifact", 120)
	infobar:SetPoint("RIGHT", RayUI_InfoPanel_Currency, "LEFT", 0, 0)
	
	infobar:SetScript("OnUpdate", function(self)
		if HasArtifactEquipped() then
			local _, _, totalXP = select(3, C_ArtifactUI.GetEquippedArtifactInfo())

			infobar.Text:SetText(ARTIFACT_POWER.."：|cffe5cc80"..R:ShortValue(totalXP).."|r")
		else
			infobar.Text:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC.."|r")
		end
	end)

	infobar:HookScript("OnEnter", function(self)
		if HasArtifactEquipped() then
			local name, _, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
			local numPointsAvailableToSpend, xp, xpMax = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
			GameTooltip:AddLine(name)
			GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(totalXP), BreakUpLargeNumbers(xp), BreakUpLargeNumbers(xpMax)), 1, 1, 1)

			local power = 0
			for i = 0, (select(6, C_ArtifactUI.GetEquippedArtifactInfo()) - 1) do
				power = power + C_ArtifactUI.GetCostForPointAtRank(i)
			end
			power = power + select(5, C_ArtifactUI.GetEquippedArtifactInfo())
			GameTooltip:AddDoubleLine("|cffffffff已注入：|r","|cffffffff"..BreakUpLargeNumbers(power).."点|r")

			if numPointsAvailableToSpend > 0 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(numPointsAvailableToSpend), 0, 1, 0, true)
			end

			GameTooltip:Show()
		end
	end)
	infobar:HookScript("OnLeave", GameTooltip_Hide)

	infobar:SetScript("OnMouseDown", function()
		if HasArtifactEquipped() then
			local frame = ArtifactFrame
			local activeID = C_ArtifactUI.GetArtifactInfo()
			local equippedID = C_ArtifactUI.GetEquippedArtifactInfo()
		
			if frame:IsShown() and activeID == equippedID then
				HideUIPanel(frame)
			else
				SocketInventoryItem(16)
			end
		end
	end)
end

IF:RegisterInfoText("Artifact", LoadArtifact)
