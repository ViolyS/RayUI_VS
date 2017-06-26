﻿----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local AB = R:GetModule("ActionBar")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
local CreateFrame = CreateFrame
local HasExtraActionBar = HasExtraActionBar

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ExtraActionBarFrame, ZoneAbilityFrame

function R:TestBossButton()
	if ExtraActionBarFrame:IsShown() then
		ExtraActionBarFrame.intro:Stop()
		ExtraActionBarFrame.outro:Play()
	else
		ExtraActionBarFrame.button:Show()
		ExtraActionBarFrame:Show()
		ExtraActionBarFrame.outro:Stop()
		ExtraActionBarFrame.intro:Play()
		ExtraActionBarFrame.button.style:SetTexture("Interface\\ExtraButton\\ChampionLight")
		ExtraActionBarFrame.button.style:Show()
		if not ExtraActionBarFrame.button.icon:GetTexture() then
			ExtraActionBarFrame.button.icon:SetTexture("Interface\\ICONS\\ABILITY_SEAL")
			ExtraActionBarFrame.button.icon:Show()
		end
	end
end

function AB:CreateExtraButton()
	local holder = CreateFrame("Frame", nil, R.UIParent)
	holder:Point("CENTER", R.UIParent, "BOTTOM", 500, 510)
	holder:Size(ExtraActionBarFrame:GetSize())

	local draenorholder = CreateFrame("Frame", nil, R.UIParent)
	draenorholder:Point("BOTTOM", ExtraActionBarFrame, "TOP", 0, 20)
	draenorholder:Size(ExtraActionBarFrame:GetSize())

	ExtraActionBarFrame:SetParent(holder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", holder, "CENTER")
	ZoneAbilityFrame:SetParent(draenorholder)
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame:SetPoint("CENTER", draenorholder, "CENTER")

	ExtraActionBarFrame.ignoreFramePositionManager  = true
	ZoneAbilityFrame.ignoreFramePositionManager = true

	for i=1, ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton"..i]
		if button then
			-- button.Hide = R.dummy
			-- button:Show()
			button.noResize = true
			button.pushed = true
			button.checked = true

			self:Style(button)
            button:StyleButton(true)
			local tex = button:CreateTexture(nil, 'OVERLAY')
			tex:SetColorTexture(0.9, 0.8, 0.1, 0.3)
			tex:SetAllPoints()
			button:SetCheckedTexture(tex)
			_G["ExtraActionButton"..i.."Icon"]:SetDrawLayer("ARTWORK")
			_G["ExtraActionButton"..i.."Cooldown"]:SetFrameLevel(button:GetFrameLevel()+2)
		end
	end

	do
		local button = ZoneAbilityFrame.SpellButton
		-- button.Hide = R.dummy
		-- button:Show()
		button.pushed = true
		button.checked = true

        button:StyleButton(true)
		button:CreateShadow("Background")
		button.Cooldown:SetFrameLevel(button:GetFrameLevel()+2)
		button.border:SetFrameLevel(button:GetFrameLevel())
		button.NormalTexture:SetDrawLayer("BACKGROUND")
		button.NormalTexture:Kill()
        button.Icon:SetDrawLayer("ARTWORK")
		button.Icon:SetTexCoord(.08, .92, .08, .92)
		button.Style:SetDrawLayer("BACKGROUND")
	end

	if HasExtraActionBar() then
		ExtraActionBarFrame:Show()
	end

	R:CreateMover(holder, "BossButtonMover", L["额外按钮"], true, nil, "ALL,ACTIONBARS,RAID")
	R:CreateMover(draenorholder, "DraenorButtonMover", L["要塞按钮"], true, nil, "ALL,ACTIONBARS,RAID")
end
