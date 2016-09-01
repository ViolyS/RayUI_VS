local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	--[[OrderHall CommandBar]]--
	OrderHallCommandBar:StripTextures()
	OrderHallCommandBar:SetTemplate("Transparent")
	OrderHallCommandBar:ClearAllPoints()
	OrderHallCommandBar:SetPoint("TOP", UIParent, 0, 0)
	OrderHallCommandBar:SetWidth(480)
	OrderHallCommandBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	OrderHallCommandBar.ClassIcon:SetSize(46, 20)
	OrderHallCommandBar.CurrencyIcon:SetAtlas("legionmission-icon-currency", false)
	OrderHallCommandBar.AreaName:ClearAllPoints()
	OrderHallCommandBar.AreaName:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 10, 0)
	OrderHallCommandBar.WorldMapButton:Hide()
	
	--[[MissionFrame]]--
	S:SetBD(OrderHallMissionFrame)
	OrderHallMissionFrame:StripTextures()
	
	for i = 1, 3 do
		S:CreateTab(_G["OrderHallMissionFrameTab"..i])
	end

	OrderHallMissionFrame.GarrCorners:Hide()
	OrderHallMissionFrame.ClassHallIcon:Hide()

	OrderHallMissionFrameMissions:StripTextures()
	OrderHallMissionFrameMissions.CombatAllyUI:StripTextures()
	OrderHallMissionFrame.MissionTab:StripTextures()
	S:CreateBD(OrderHallMissionFrameMissions.CombatAllyUI, .25)

	S:ReskinScroll(OrderHallMissionFrameMissionsListScrollFrameScrollBar)

	for i = 1, 2 do
		local tab = _G["OrderHallMissionFrameMissionsTab" .. i]
		tab:StripTextures()
		S:CreateTab(tab)
	end
	
	S:ReskinClose(OrderHallMissionFrame.CloseButton)

	local ZoneSupportMissionPage = OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	S:ReskinClose(ZoneSupportMissionPage.CloseButton, "TOPRIGHT", ZoneSupportMissionPage.CombatAllyLabel, "TOPRIGHT", 14, -4)

	--[[MissionTab]]--
	local Follower = OrderHallMissionFrameFollowers
	Follower:StripTextures()
	Follower.SearchBox:SkinEditBox()
	S:CreateBD(Follower.MaterialFrame)
	OrderHallMissionFrame.MissionTab.MissionPage.StartMissionButton:SkinButton()
	
	--[[FollowerTab]]--
	local FollowerList = OrderHallMissionFrame.FollowerTab
	FollowerList:StripTextures()
	FollowerList.ModelCluster:StripTextures()
	FollowerList.Class:SetSize(50, 43)
	FollowerList.XPBar:StripTextures()
	FollowerList.XPBar:SetStatusBarTexture(R["media"].blank)
	FollowerList.XPBar:CreateBackdrop()
	
	--[[MissionStage]]--

	--[[TalentFrame]]--
end

S:RegisterSkin("Blizzard_OrderHallUI", LoadSkin)
