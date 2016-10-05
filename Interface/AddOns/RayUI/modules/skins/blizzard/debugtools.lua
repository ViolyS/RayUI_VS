local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function LoadSkin()
	ScriptErrorsFrame:SetParent(R.UIParent)
	ScriptErrorsFrame:DisableDrawLayer("OVERLAY")
	ScriptErrorsFrameTitleBG:Hide()
	ScriptErrorsFrameDialogBG:Hide()
	S:CreateBD(ScriptErrorsFrame)
	S:CreateSD(ScriptErrorsFrame)

	S:CreateBD(EventTraceFrame)
	S:CreateSD(EventTraceFrame)
	S:ReskinClose(EventTraceFrameCloseButton)
	select(1, EventTraceFrameScroll:GetRegions()):Hide()
	local bu = select(2, EventTraceFrameScroll:GetRegions())
	bu:SetAlpha(0)
	bu:Width(17)

	bu.bg = CreateFrame("Frame", nil, EventTraceFrame)
	bu.bg:Point("TOPLEFT", bu, 0, 0)
	bu.bg:Point("BOTTOMRIGHT", bu, 0, 0)
	S:CreateBD(bu.bg, 0)

	local tex = EventTraceFrame:CreateTexture(nil, "BACKGROUND")
	tex:Point("TOPLEFT", bu.bg)
	tex:Point("BOTTOMRIGHT", bu.bg)
	tex:SetTexture(R["media"].gloss)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	FrameStackTooltip:SetParent(R.UIParent)
	FrameStackTooltip:SetFrameStrata("TOOLTIP")
	FrameStackTooltip:SetBackdrop(nil)

	local bg = CreateFrame("Frame", nil, FrameStackTooltip)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(FrameStackTooltip:GetFrameLevel()-1)
	S:CreateBD(bg, .6)

	EventTraceTooltip:SetParent(R.UIParent)
	EventTraceTooltip:SetFrameStrata("TOOLTIP")
	EventTraceTooltip:SetBackdrop(nil)

	local bg = CreateFrame("Frame", nil, EventTraceTooltip)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(EventTraceTooltip:GetFrameLevel()-1)
	S:CreateBD(bg, .6)

	S:ReskinClose(ScriptErrorsFrameClose)
	S:Reskin(ScriptErrorsFrame.close)
	S:ReskinScroll(ScriptErrorsFrameScrollFrameScrollBar)
	S:Reskin(ScriptErrorsFrame.reload)
	S:ReskinArrow(ScriptErrorsFrame.previous, "left")
	S:ReskinArrow(ScriptErrorsFrame.next, "right")

	local texs = {
		"TopLeft",
		"TopRight",
		"Top",
		"BottomLeft",
		"BottomRight",
		"Bottom",
		"Left",
		"Right",
		"TitleBG",
		"DialogBG",
	}

	for i=1, #texs do
		_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
		_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
	end

	FrameStackTooltip:HookScript("OnShow", function(self)
		self:SetScale(1.2)
	end)
end

S:AddCallbackForAddon("Blizzard_DebugTools", "DebugTools", LoadSkin)
