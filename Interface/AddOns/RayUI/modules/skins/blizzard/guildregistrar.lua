----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
    GuildRegistrarFrameTop:Hide()
    GuildRegistrarFrameBottom:Hide()
    GuildRegistrarFrameMiddle:Hide()
    GuildRegistrarFrameEditBox:StripTextures()
    GuildRegistrarGreetingFrame:StripTextures()

    GuildRegistrarFrameEditBox:SetHeight(20)

    S:ReskinPortraitFrame(GuildRegistrarFrame, true)
    S:CreateBD(GuildRegistrarFrameEditBox, .25)
    S:Reskin(GuildRegistrarFrameGoodbyeButton)
    S:Reskin(GuildRegistrarFramePurchaseButton)
    S:Reskin(GuildRegistrarFrameCancelButton)
end

S:AddCallback("GuildRegistrar", LoadSkin)
