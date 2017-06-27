----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins


local PostalSkin = CreateFrame("Frame")
PostalSkin:RegisterEvent("MAIL_SHOW")

PostalSkin:SetScript("OnEvent", function(self, event)
    self:UnregisterEvent("MAIL_SHOW")
    S:Reskin(PostalSelectOpenButton)
    S:Reskin(PostalSelectReturnButton)
    OpenAllMail:Kill()
    S:Reskin(PostalOpenAllButton)

    S:ReskinCheck(PostalInboxCB1)
    S:ReskinCheck(PostalInboxCB2)
    S:ReskinCheck(PostalInboxCB3)
    S:ReskinCheck(PostalInboxCB4)
    S:ReskinCheck(PostalInboxCB5)
    S:ReskinCheck(PostalInboxCB6)
    S:ReskinCheck(PostalInboxCB7)

    S:Reskin(Postal_OpenAllMenuButton)
    Postal_OpenAllMenuButton:Size(PostalOpenAllButton:GetHeight())
    Postal_OpenAllMenuButton:ClearAllPoints()
    Postal_OpenAllMenuButton:Point("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
    local Postal_OpenAllMenuButtonDownTex = Postal_OpenAllMenuButton:CreateTexture(nil, "ARTWORK")
    Postal_OpenAllMenuButtonDownTex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
    Postal_OpenAllMenuButtonDownTex:Size(8, 8)
    Postal_OpenAllMenuButtonDownTex:SetPoint("CENTER")
    Postal_OpenAllMenuButtonDownTex:SetVertexColor(1, 1, 1)
    
    S:Reskin(Postal_ModuleMenuButton)
    Postal_ModuleMenuButton:Size(MailFrameCloseButton:GetHeight())
    Postal_ModuleMenuButton:ClearAllPoints()
    Postal_ModuleMenuButton:Point("RIGHT", MailFrameCloseButton, "LEFT", -2, 0)
    local Postal_ModuleMenuButtonDownTex = Postal_ModuleMenuButton:CreateTexture(nil, "ARTWORK")
    Postal_ModuleMenuButtonDownTex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
    Postal_ModuleMenuButtonDownTex:Size(8, 8)
    Postal_ModuleMenuButtonDownTex:SetPoint("CENTER")
    Postal_ModuleMenuButtonDownTex:SetVertexColor(1, 1, 1)

    S:Reskin(Postal_BlackBookButton)
    Postal_BlackBookButton:Size(SendMailNameEditBox:GetHeight())
    Postal_BlackBookButton:ClearAllPoints()
    Postal_BlackBookButton:Point("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
    local Postal_BlackBookButtonDownTex = Postal_BlackBookButton:CreateTexture(nil, "ARTWORK")
    Postal_BlackBookButtonDownTex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
    Postal_BlackBookButtonDownTex:Size(8, 8)
    Postal_BlackBookButtonDownTex:SetPoint("CENTER")
    Postal_BlackBookButtonDownTex:SetVertexColor(1, 1, 1)
end)