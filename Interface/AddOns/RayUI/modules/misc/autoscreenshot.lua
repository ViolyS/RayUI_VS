local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("AutoScreeshot", "AceEvent-3.0")

function mod:TakeScreenshot(event, ...)
	TakeScreenshot()
end

function mod:Initialize()
	if not M.db.autoscreenshot then return end
	self:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreenshot")
end

M:RegisterMiscModule(mod:GetName())
