local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local M = R:GetModule("Misc")
local mod = M:NewModule("ObjectiveTracker", "AceEvent-3.0")

function mod:Initialize()
	local screenheight = GetScreenHeight()
	local ObjectiveTrackerFrameHolder = CreateFrame("Frame", "ObjectiveTrackerFrameHolder", UIParent)
	ObjectiveTrackerFrameHolder:SetWidth(260)
	ObjectiveTrackerFrameHolder:SetHeight(22)
	ObjectiveTrackerFrameHolder:SetPoint("RIGHT", UIParent, "RIGHT", -80, 290)

	R:CreateMover(ObjectiveTrackerFrameHolder, "WatchFrameMover", L["任务追踪锚点"], true)
	ObjectiveTrackerFrameHolder:SetAllPoints(WatchFrameMover)

	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:SetPoint("TOPRIGHT", ObjectiveTrackerFrameHolder, "TOPRIGHT")
	ObjectiveTrackerFrame:Height(screenheight / 2)

	hooksecurefunc(ObjectiveTrackerFrame,"SetPoint",function(_,_,parent)
		if parent ~= ObjectiveTrackerFrameHolder then
			ObjectiveTrackerFrame:ClearAllPoints()
			ObjectiveTrackerFrame:SetPoint("TOPRIGHT", ObjectiveTrackerFrameHolder, "TOPRIGHT")
		end
	end)
end

M:RegisterMiscModule(mod:GetName())
