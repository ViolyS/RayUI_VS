----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("ObjectiveTracker", "AceEvent-3.0")

function mod:Initialize()
    local screenheight = GetScreenHeight()
    local ObjectiveTrackerFrameHolder = CreateFrame("Frame", "ObjectiveTrackerFrameHolder", R.UIParent)
    ObjectiveTrackerFrameHolder:SetWidth(260)
    ObjectiveTrackerFrameHolder:SetHeight(22)
    ObjectiveTrackerFrameHolder:SetPoint("RIGHT", R.UIParent, "RIGHT", -80, 290)

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
