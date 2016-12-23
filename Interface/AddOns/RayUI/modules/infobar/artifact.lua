local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local IF = R:GetModule("InfoBar")
local libAD = LibStub("LibArtifactData-1.0")

local function LoadArtifact()
    local infobar = IF:CreateInfoPanel("RayUI_InfoPanel_Artifact", 120)
    infobar:SetPoint("RIGHT", RayUI_InfoPanel_Currency, "LEFT", 0, 0)

    infobar:RegisterEvent("PLAYER_ENTERING_WORLD")
    infobar:RegisterEvent("ARTIFACT_ADDED")
    infobar:RegisterEvent("ARTIFACT_ACTIVE_CHANGED")
    infobar:RegisterEvent("ARTIFACT_POWER_CHANGED")
    infobar:RegisterEvent("ARTIFACT_EQUIPPED_CHANGED")
    infobar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    
    infobar:SetScript("OnUpdate", function(self)
        if HasArtifactEquipped() then
            local _, _, totalXP = select(3, C_ArtifactUI.GetEquippedArtifactInfo())

            infobar.Text:SetText(ARTIFACT_POWER.."：|cffe5cc80"..R:ShortValue(totalXP).."|r")
        else
            infobar.Text:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC.."|r")
        end
    end)

    infobar:SetScript("OnEnter", function(self)
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
        if not ArtifactFrame or not ArtifactFrame:IsShown() then
            ShowUIPanel(SocketInventoryItem(16))
        elseif ArtifactFrame and ArtifactFrame:IsShown() then
            HideUIPanel(ArtifactFrame)
        end
    end)
end

IF:RegisterInfoText("Artifact", LoadArtifact)
