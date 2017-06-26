----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()


local hooked = false

local function ShowFinish(text, subtext)
    local levelUpTexCoords = {
        gLine = { 0.00195313, 0.81835938, 0.00195313, 0.01562500 },
        tint = {1, 0.996, 0.745},
        gLineDelay = 0,
    }

    local script = LevelUpDisplay:GetScript("OnShow")
    LevelUpDisplay.type = LEVEL_UP_TYPE_SCENARIO
    LevelUpDisplay:SetScript("OnShow", nil)
    LevelUpDisplay:Show()

    LevelUpDisplay.scenarioFrame.level:SetText(text)
    LevelUpDisplay.scenarioFrame.name:SetText(subtext)
    LevelUpDisplay.scenarioFrame.description:SetText("")
    LevelUpDisplay:SetPoint("TOP", 0, -250)

    LevelUpDisplay.gLine:SetTexCoord(unpack(levelUpTexCoords.gLine))
    LevelUpDisplay.gLine2:SetTexCoord(unpack(levelUpTexCoords.gLine))
    LevelUpDisplay.gLine:SetVertexColor(unpack(levelUpTexCoords.tint))
    LevelUpDisplay.gLine2:SetVertexColor(unpack(levelUpTexCoords.tint))
    LevelUpDisplay.levelFrame.levelText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    LevelUpDisplay.gLine.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)
    LevelUpDisplay.gLine2.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)
    LevelUpDisplay.blackBg.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)

    LevelUpDisplay.scenarioFrame.newStage:Play()
    PlaySoundKitID(31749)

    LevelUpDisplay:SetScript("OnShow", script)
end

function R:SetLayout(layout)
	R.db.layout = layout
	if layout == "healer" then
		R:ResetMovers()
		R.db.movers = {}
		R.db.movers.RayUF_PlayerMover = "BOTTOMRIGHTRayUIParentBOTTOM-190390"
		R.db.movers.RayUF_TargetMover = "BOTTOMLEFTRayUIParentBOTTOM190390"
		R.db.movers.RayUF_petMover = "TOPLEFTRayUF_PlayerMoverBOTTOMLEFT0-60"
		R.db.movers.RayUF_RaidMover = "BOTTOMRayUIParentBOTTOM0180"
		R.db.movers.RayUF_Raid40Mover = "BOTTOMRayUIParentBOTTOM0180"
		R.db.movers.PlayerCastBarMover = "BOTTOMRayUIParentBOTTOM0130"
		R.db.movers.ActionBar1Mover = "BOTTOMRayUIParentBOTTOM"..(-3*R.db.ActionBar.buttonsize-3*R.db.ActionBar.buttonspacing).."50"
		R.db.movers.ActionBar5Mover = "TOPRIGHTActionBar4MoverTOPLEFT"..-R.db.ActionBar.buttonspacing.."0"
		R.db.movers.PetBarMover = "BOTTOMLEFTActionBar2MoverBOTTOMRIGHT"..R.db.ActionBar.buttonspacing.."0"
		R.db.movers.AltPowerBarMover = "BOTTOMRIGHTRayUIParentBOTTOMRIGHT-36085"
		R.db.Raid.horizontal = true
		R.db.Raid.growth = "UP"
        R.db.UnitFrames.transparent = true
        R.db.UnitFrames.showPortrait = false
        R.db.UnitFrames.healthColorClass = false
        R.db.UnitFrames.powerColorClass = true
		StaticPopup_Show("CFG_RELOAD")
	elseif layout == "dps" then
		R:ResetMovers()
		R.db.movers = {}
		R.db.movers.ArenaHeaderMover = "TOPLEFTRayUIParentBOTTOM450460"
		R.db.movers.BossHeaderMover = "TOPLEFTRayUIParentBOTTOM450460"
		R.db.movers.RayUF_FocusMover = "BOTTOMRIGHTRayUF_PlayerTOPLEFT-2050"
		R.db.movers.RayUF_RaidMover = "BOTTOMLEFTRayUIParentBOTTOMLEFT15235"
		R.db.movers.RayUF_Raid40Mover = "BOTTOMLEFTRayUIParentBOTTOMLEFT15235"
		R.db.movers.ActionBar4Mover = "RIGHTRayUIParentRIGHT-490"
		R.db.Raid.horizontal = true
		R.db.Raid.growth = "UP"
		StaticPopup_Show("CFG_RELOAD")
	elseif layout == "default" then
		R:ResetMovers()
		R.db.Raid.horizontal = true
		R.db.Raid.growth = "UP"
		StaticPopup_Show("CFG_RELOAD")
	end
	R:SetMoversPositions()
    for i = 1, 5 do
        R.ActionBar:UpdatePositionAndSize("bar"..i)
    end
end

function R:ChooseLayout()
	if not RayUILayoutChooser then
		local S = R.Skins
		local f = CreateFrame("Frame", "RayUILayoutChooser", R.UIParent)
		f:SetFrameStrata("TOOLTIP")
		f:Size(500, 250)
		f:Point("CENTER")
		S:SetBD(f)

		f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
		f.CloseButton:SetScript("OnClick", function()
			R.db.layoutchosen = true
			f:Hide()
		end)
		S:ReskinClose(f.CloseButton)

		f.Title = f:CreateFontString(nil, "OVERLAY")
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point("TOP", 0, -15)
		f.Title:SetText(L["RayUI布局选择"])

		f.Desc = f:CreateFontString(nil, "OVERLAY")
		f.Desc:FontTemplate()
		f.Desc:Point("TOPLEFT", 20, -80)
		f.Desc:Width(f:GetWidth() - 40)
		f.Desc:SetText(L["欢迎使用RayUI, 请选择一个布局开始使用."])

		f.Option1 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option1:Size(120, 30)
		f.Option1:Point("BOTTOM", 0, 30)
		f.Option1:SetText(L["默认"])
		f.Option1:SetScript("OnClick", function(self)
			R.db.layoutchosen = true
			R:SetLayout("default")
			ShowFinish(L["设置完成"], self:GetText())
			f:Hide()
		end)
		S:Reskin(f.Option1)

		f.Option2 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option2:StripTextures()
		f.Option2:Size(120, 30)
		f.Option2:Point("RIGHT", f.Option1, "LEFT", -30, 0)
		f.Option2:SetText(L["伤害输出"])
		f.Option2:SetScript("OnClick", function(self)
			R.db.layoutchosen = true
			R:SetLayout("dps")
			ShowFinish(L["设置完成"], self:GetText())
			f:Hide()
		end)
		S:Reskin(f.Option2)

		f.Option3 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.Option3:StripTextures()
		f.Option3:Size(120, 30)
		f.Option3:Point("LEFT", f.Option1, "RIGHT", 30, 0)
		f.Option3:SetText(L["治疗"])
		f.Option3:SetScript("OnClick", function(self)
			R.db.layoutchosen = true
			R:SetLayout("healer")
			ShowFinish(L["设置完成"], self:GetText())
			f:Hide()
		end)
		S:Reskin(f.Option3)
	end
	RayUILayoutChooser:Show()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents("PLAYER_ENTERING_WORLD")
	if R.db.movers and R.db.movers.ActionBar5Mover == "TOPRIGHTActionBar4MoverTOPLEFT"..-R.db.ActionBar.buttonspacing.."0" and not R.db.movers.ActionBar4Mover then
		R.db.movers.ActionBar5Mover = nil
		R.db.movers.ActionBar4Mover = "RIGHTRayUIParentRIGHT-490"
		R:SetMoversPositions()
	end
end)
