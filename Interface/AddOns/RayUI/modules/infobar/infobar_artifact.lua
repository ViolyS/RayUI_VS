----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("InfoBar")


local IF = _InfoBar
local libAD = LibStub("LibArtifactData-1.0")

local function Artifact_OnUpdate(self)
    if HasArtifactEquipped() then
        local _, data = libAD:GetArtifactInfo()
            
        if data.numRanksPurchasable > 0 then
            self:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC..": "..R:ShortValue(data.unspentPower).."+|r")
        else
            self:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC..": "..R:ShortValue(data.unspentPower).." |r")
        end
    else
        self:SetText("|cffe5cc80"..ITEM_QUALITY6_DESC.."|r")
    end
end

local function Artifact_OnEnter(self)
    if HasArtifactEquipped() then
        local _, data = libAD:GetArtifactInfo()
        local knowledgeLevel, knowledgeMultiplier = libAD:GetArtifactKnowledge()
        local percentIncrease = math.floor(((knowledgeMultiplier - 1.0) * 100) + .5)

        
        GameTooltip:SetOwner(self, "ANCHOR_TOP",0,0)
        GameTooltip:AddLine(string.format("%s (%s %d)", data.name, LEVEL, data.numRanksPurchased))
        GameTooltip:SetPrevLineJustify("CENTER")
        GameTooltip:AddDivider()
        
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
end

local function Artifact_OnClick(self)
    if not ArtifactFrame or not ArtifactFrame:IsShown() then
        ShowUIPanel(SocketInventoryItem(16))
    elseif ArtifactFrame and ArtifactFrame:IsShown() then
        HideUIPanel(ArtifactFrame)
    end
end



do -- Initialize
    local info = {}

    info.title = ITEM_QUALITY6_DESC
    info.icon = "Interface\\Icons\\INV_Enchant_DustArcane"
    info.clickFunc = Artifact_OnClick
    info.onUpdate = Artifact_OnUpdate
    info.tooltipFunc = Artifact_OnEnter

    IF:RegisterInfoBarType("Artifact", info)
end
