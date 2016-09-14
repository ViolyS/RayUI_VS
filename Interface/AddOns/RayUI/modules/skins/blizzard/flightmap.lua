local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local S = R:GetModule("Skins")

local function LoadSkin()
	FlightMapFrame.BorderFrame:StripTextures()
	FlightMapFramePortraitFrame:Kill()
	FlightMapFramePortrait:Kill()
	FlightMapFrameTitleText:Kill()

	local flightmap = FlightMapFrame.ScrollContainer
	S:SetBD(flightmap, -1, 1, 1, -1)
	S:ReskinClose(FlightMapFrameCloseButton, "TOPRIGHT", flightmap, "TOPRIGHT", -4, -4)
end

S:RegisterSkin('Blizzard_FlightMap', LoadSkin)
