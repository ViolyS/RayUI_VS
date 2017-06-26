----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function SkinClique()
	local tab = _G["CliqueSpellTab"]
    tab:GetRegions():Kill()
    tab.pushed = true
    tab:CreateShadow("Background")
    tab:StyleButton(true)
	tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	CliqueConfig:StripTextures()
	CliqueConfigInset:StripTextures()
	S:SetBD(CliqueConfig)
	CliqueConfigPage1Column1:DisableDrawLayer("BACKGROUND")
	CliqueConfigPage1Column2:DisableDrawLayer("BACKGROUND")
	S:ReskinClose(CliqueConfigCloseButton)
	S:Reskin(CliqueConfigPage1ButtonSpell)
	CliqueConfigPage1ButtonSpell_RightSeparator:Kill()
	S:Reskin(CliqueConfigPage1ButtonOther)
	CliqueConfigPage1ButtonOther_RightSeparator:Kill()
	S:Reskin(CliqueConfigPage1ButtonOptions)
	CliqueConfigPage1ButtonOptions_LeftSeparator:Kill()
end

S:AddCallbackForAddon("Clique", "Clique", SkinClique)
