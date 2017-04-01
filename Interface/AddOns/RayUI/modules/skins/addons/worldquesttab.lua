local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local S = R:GetModule("Skins")

local function SkinWorldQuestTab()
    local tabs = {"BWQ_TabNormal", "BWQ_TabWorld"}
    for i = 1, #tabs do
        local tab = _G[tabs[i]]

        tab:GetRegions():Hide()
        tab.Highlight:Kill()
        tab.Hider:Kill()
        S:Reskin(tab)
    end
    BWQ_TabWorld:SetPoint("LEFT", BWQ_TabNormal, "RIGHT", 2, 0)

    BWQ_WorldQuestFrame:GetRegions():Hide()

    -- BWQ_WorldQuestFrameSortButton
    local f = _G["BWQ_WorldQuestFrameSortButton"]
    local left = _G["BWQ_WorldQuestFrameSortButtonLeft"]
    local middle = _G["BWQ_WorldQuestFrameSortButtonMiddle"]
    local right = _G["BWQ_WorldQuestFrameSortButtonRight"]

    if left then left:SetAlpha(0) end
    if middle then middle:SetAlpha(0) end
    if right then right:SetAlpha(0) end

    local down = _G["BWQ_WorldQuestFrameSortButtonButton"]
    down:ClearAllPoints()
    down:Point("TOPRIGHT", -18, -4)
    down:Point("BOTTOMRIGHT", -18, 8)
    down:SetWidth(19)

    S:Reskin(down)

    down:SetDisabledTexture(R["media"].blank)
    local dis = down:GetDisabledTexture()
    dis:SetVertexColor(0, 0, 0, .3)
    dis:SetDrawLayer("OVERLAY")
    dis:SetAllPoints(down)

    local downtex = down:CreateTexture(nil, "ARTWORK")
    downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
    downtex:SetSize(8, 8)
    downtex:SetPoint("CENTER")
    downtex:SetVertexColor(1, 1, 1)

    local bg = CreateFrame("Frame", nil, f)
    bg:Point("TOPLEFT", 16, -4)
    bg:Point("BOTTOMRIGHT", -18, 8)
    S:CreateBD(bg, 0)

    local gradient = S:CreateGradient(f)
    gradient:Point("TOPLEFT", bg, 1, -1)
    gradient:Point("BOTTOMRIGHT", bg, -1, 1)

    -- BWQ_WorldQuestFrameFilterButton
    S:ReskinFilterButton(BWQ_WorldQuestFrameFilterButton)
    for i = 1, 2 do
        local ddm = _G["Lib_DropDownList"..i.."MenuBackdrop"]

        for j = 1, 9 do
            select(j, ddm:GetRegions()):Hide()
        end
        S:CreateBD(ddm)
    end
    S:CreateBD(Lib_DropDownList1Backdrop)

    S:ReskinScroll(BWQ_QuestScrollFrameScrollBar)
end

S:AddCallbackForAddon("WorldQuestTab", "WorldQuestTab", SkinWorldQuestTab)
