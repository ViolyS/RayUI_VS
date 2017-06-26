--AlertSystem from ls: Toasts
----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
_LoadRayUIEnv_()


local S = R:GetModule("Skins")

local function LoadSkin()
    TELLMEWHEN_ICONSPACING = R.Border

    TMW.Classes.Icon:PostHookMethod("OnNewInstance", function(self, icon)
        self:CreateShadow("Background")
    end)

    TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self, icon)
        self.texture:SetTexCoord(.08, .92, .08, .92)
    end)
end

S:AddCallbackForAddon("TellMeWhen", "TellMeWhen", LoadSkin)
