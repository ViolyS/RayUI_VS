local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local libAD = LibStub("LibArtifactData-1.0")

local function MetaPowerTooltipHelper(...)
	local hasAddedAny = false;
	for i = 1, select("#", ...), 3 do
		local spellID, cost, currentRank = select(i, ...);
		local metaPowerDescription = GetSpellDescription(spellID);
		if metaPowerDescription then
			if hasAddedAny then
				GameTooltip:AddLine(" ");
			end
			GameTooltip:AddLine(metaPowerDescription, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
			hasAddedAny = true;
		end
	end

	return hasAddedAny;
end

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
            local _, data = libAD:GetArtifactInfo()
            local knowledgeLevel, knowledgeMultiplier = libAD:GetArtifactKnowledge()
            local percentIncrease = math.floor(((knowledgeMultiplier - 1.0) * 100) + .5)

            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("BOTTOMRIGHT", infobar, "TOPRIGHT", 0, 0)
            GameTooltip:AddLine(string.format("%s (%s %d)", data.name, LEVEL, data.numRanksPurchased))
            GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(BreakUpLargeNumbers(data.unspentPower), BreakUpLargeNumbers(data.power), BreakUpLargeNumbers(data.maxPower)), 1, 1, 1)
            GameTooltip:AddDoubleLine("|cffffffff已注入：|r","|cffffffff"..BreakUpLargeNumbers(libAD:GetAcquiredArtifactPower(_, artifactID)).."点|r")

            if knowledgeLevel > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(ARTIFACTS_KNOWLEDGE_TOOLTIP_LEVEL:format(knowledgeLevel), 1, 1, 1)
                GameTooltip:AddLine(ARTIFACTS_KNOWLEDGE_TOOLTIP_DESC:format(BreakUpLargeNumbers(percentIncrease)), 1, 1, 1)
            end

            if data.numRanksPurchasable > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(data.numRanksPurchasable), 0, 1, 0, true)
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
