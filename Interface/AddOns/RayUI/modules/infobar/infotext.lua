﻿--AlertSystem from ls: Toasts
----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local IF = R:GetModule("InfoBar")

IF.InfoTextModules = {}

function IF:RegisterInfoText(name, func)
	-- IF.InfoTextModules[name] = func
	tinsert(IF.InfoTextModules, func)
end

function IF:LoadInfoText()
	-- for name, func in pairs(self.InfoTextModules) do
		-- func()
	-- end
	for i = 1, #self.InfoTextModules do
		local _, catch = pcall(IF.InfoTextModules[i])
		if catch then
			error(catch, 2)
		end
	end
end