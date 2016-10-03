local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")

local function LoadArtifact()
	LoadAddOn("Blizzard_ArtifactUI")

	local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Artifact", 120)
	infobar:SetPoint("RIGHT", RayUI_InfoPanel_Currency, "LEFT", 0, 0)
	
	infobar:SetScript("OnUpdate", function(self)
		if HasArtifactEquipped() then
			local name, icon, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
			local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

			if totalXP > 1e6 then
				infobar.Text:SetText(ARTIFACT_POWER.."：|cffe5cc80"..(floor(totalXP / 1e5) / 10).."m|r")
			elseif  totalXP > 1e3 then
				infobar.Text:SetText(ARTIFACT_POWER.."：|cffe5cc80"..(floor(totalXP / 1e2) / 10).."k|r")
			else
				infobar.Text:SetText(ARTIFACT_POWER.."：|cffe5cc80"..totalXP.."|r")
			end
		else
			infobar.Text:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC.."|r")
		end
	end)

	infobar:HookScript("OnEnter", function(self)
		if HasArtifactEquipped() then
			local title,r,g,b = select(2, C_ArtifactUI.GetEquippedArtifactArtInfo())
			local name, icon, totalXP, pointsSpent = select(3, C_ArtifactUI.GetEquippedArtifactInfo())
			local points, xp, xpMax = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
			GameTooltip:AddLine(title,r,g,b,false)
			GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(ArtifactWatchBar.totalXP), BreakUpLargeNumbers(ArtifactWatchBar.xp), BreakUpLargeNumbers(ArtifactWatchBar.xpForNextPoint)), 1, 1, 1)
			if ArtifactWatchBar.numPointsAvailableToSpend > 0 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(ArtifactWatchBar.numPointsAvailableToSpend), 0, 1, 0, true)
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
