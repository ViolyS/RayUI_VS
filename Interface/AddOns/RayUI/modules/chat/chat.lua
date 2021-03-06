﻿----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Chat")


local CH = R:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0")

CH.modName = L["聊天栏"]
_Chat = CH


local ChatHistoryEvent = CreateFrame("Frame")
local tokennum, matchTable = 1, {}
local currentLink
local lines = {}
local frame = nil
local editBox = nil
local isf = nil
local sizes = {
    ":14:14",
    ":16:16",
    ":12:20",
    ":14",
}
local linkHoverShow = {
    achievement = true,
    enchant = true,
    glyph = true,
    item = true,
    quest = true,
    spell = true,
    talent = true,
    unit = true,
}

local function GetTimeForSavedMessage()
    local randomTime = select(2, ("."):split(GetTime() or "0."..math.random(1, 999), 2)) or 0
    return time().."."..randomTime
end

local function GetColor(className, isLocal)
    if isLocal then
        local found
        for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            if v == className then className = k found = true break end
        end
        if not found then
            for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
                if v == className then className = k break end
            end
        end
    end
    local tbl = R.colors.class[className]
    local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
    return color
end

local changeBNetName = function(misc, id, moreMisc, fakeName, tag, colon)
    local gameAccount = select(6, BNGetFriendInfoByID(id))
    if gameAccount then
        local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
        if englishClass and englishClass ~= "" then
            fakeName = "[|cFF"..GetColor(englishClass, true)..fakeName.."|r]"
        end
    end
    return misc..id..moreMisc..fakeName..tag..(colon == ":" and ":" or colon)
end

function CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
    local chatType = strsub(event, 10)
    if ( strsub(chatType, 1, 7) == "WHISPER" ) then
        chatType = "WHISPER"
    end
    if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
        chatType = "CHANNEL"..arg8
    end
    local info = ChatTypeInfo[chatType]

    --ambiguate guild chat names
    if (chatType == "GUILD") then
        arg2 = Ambiguate(arg2, "guild")
    else
        arg2 = Ambiguate(arg2, "none")
    end

    if ( info and info.colorNameByClass and arg12 ) then
        local localizedClass, englishClass, localizedRace, englishRace, sex = GetPlayerInfoByGUID(arg12)

        if ( englishClass ) then
            local classColorTable = R.colors.class[englishClass]
            if ( not classColorTable ) then
                return arg2
            end
            return string.format("\124cff%.2x%.2x%.2x", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255)..arg2.."\124r"
        end
    end

    return arg2
end

local function CreatCopyFrame()
    local S = R.Skins
    frame = CreateFrame("Frame", "CopyChatFrame", R.UIParent)
    table.insert(UISpecialFrames, frame:GetName())
    S:SetBD(frame)
    frame:SetScale(1)
    frame:SetPoint("CENTER", R.UIParent, "CENTER", 0, 0)
    frame:Size(400,400)
    frame:Hide()
    frame:EnableMouse(true)
    frame:SetFrameStrata("DIALOG")

    local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
    scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
    scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

    S:ReskinScroll(CopyScrollScrollBar)

    editBox = CreateFrame("EditBox", "CopyBox", frame)
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(99999)
    editBox:EnableMouse(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(scrollArea:GetWidth())
    editBox:Height(200)
    editBox:SetScript("OnEscapePressed", function()
            frame:Hide()
        end)

    --EXTREME HACK..
    editBox:SetScript("OnTextSet", function(self)
            local text = self:GetText()

            for _, size in pairs(sizes) do
                if string.find(text, size) then
                    self:SetText(string.gsub(text, size, ":12:12"))
                end
            end
        end)

    scrollArea:SetScrollChild(editBox)

    local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
    close:EnableMouse(true)
    close:SetScript("OnMouseUp", function()
            frame:Hide()
        end)

    S:ReskinClose(close)
    close:ClearAllPoints()
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -5)
end

local function GetLines(...)
    --[[ Grab all those lines ]]--
    local ct = 1
    for i = select("#", ...), 1, -1 do
        local region = select(i, ...)
        if region:GetObjectType() == "FontString" then
            lines[ct] = tostring(region:GetText())
            ct = ct + 1
        end
    end
    return ct - 1
end

function CH:CopyChat(cf)
    local _, size = cf:GetFont()
    FCF_SetChatWindowFontSize(cf, cf, 0.01)
    local lineCt = GetLines(cf.FontStringContainer:GetRegions())
    local text = table.concat(lines, "\n", 1, lineCt)
    FCF_SetChatWindowFontSize(cf, cf, size)
    if frame:IsShown() then frame:Hide() return end
    frame:Show()
    editBox:SetText(text)
end

local function ChatCopyButtons(id)
    local cf = _G[format("ChatFrame%d", id)]
    local tab = _G[format("ChatFrame%dTab", id)]
    local name = FCF_GetChatWindowInfo(id)
    local point = GetChatWindowSavedPosition(id)
    local _, fontSize = FCF_GetChatWindowInfo(id)
    local button = _G[format("ButtonCF%d", id)]

    if not button then
        local button = CreateFrame("Button", format("ButtonCF%d", id), cf)
        button:Height(22)
        button:Width(20)
        button:SetAlpha(0)
        button:SetPoint("TOPRIGHT", 0, 0)
        button:SetTemplate("Default", true)

        local buttontex = button:CreateTexture(nil, "OVERLAY")
        buttontex:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
        buttontex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        buttontex:SetTexture([[Interface\AddOns\RayUI\media\copy.tga]])

        if id == 1 then
            button:SetScript("OnMouseUp", function(self, btn)
                    if btn == "RightButton" then
                        ToggleFrame(ChatMenu)
                    else
                        CH:CopyChat(cf)
                    end
                end)
        else
            button:SetScript("OnMouseUp", function(self, btn)
                    CH:CopyChat(cf)
                end)
        end

        button:SetScript("OnEnter", function()
                button:SetAlpha(1)
            end)
        button:SetScript("OnLeave", function() button:SetAlpha(0) end)
    end

end

function CH:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r聊天模块."]
end

function CH:EditBox_MouseOn()
    for i =1, #CHAT_FRAMES do
        local eb = _G["ChatFrame"..i.."EditBox"]
        local tab = _G["ChatFrame"..i.."Tab"]
        eb:EnableMouse(true)
        tab:EnableMouse(false)
    end
end

function CH:EditBox_MouseOff()
    for i =1, #CHAT_FRAMES do
        local eb = _G["ChatFrame"..i.."EditBox"]
        local tab = _G["ChatFrame"..i.."Tab"]
        eb:EnableMouse(false)
        tab:EnableMouse(true)
    end
end

local function RegisterMatch(text)
    local token = "\255\254\253"..tokennum.."\253\254\255"
    matchTable[token] = string.gsub(text, "%%", "%%%%")
    tokennum = tokennum + 1
    return token
end

local function Link(link, ...)
    if link == nil then
        return ""
    end
    return RegisterMatch(string.format("|cff8A9DDE|Hurl:%s|h[%s]|h|r", link, link))
end

local patterns = {
    -- X://Y url
    { pattern = "^(%a[%w%.+-]+://%S+)", matchfunc=Link},
    { pattern = "%f[%S](%a[%w%.+-]+://%S+)", matchfunc=Link},
    -- www.X.Y url
    { pattern = "^(www%.[-%w_%%]+%.%S+)", matchfunc=Link},
    { pattern = "%f[%S](www%.[-%w_%%]+%.%S+)", matchfunc=Link},
    -- XXX.YYY.ZZZ.WWW:VVVV/UUUUU IPv4 address with port and path
    { pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link},
    { pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc=Link},
    -- XXX.YYY.ZZZ.WWW:VVVV IPv4 address with port (IP of ts server for example)
    { pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link},
    { pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc=Link},
    -- XXX.YYY.ZZZ.WWW/VVVVV IPv4 address with path
    { pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc=Link},
    { pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc=Link},
    -- XXX.YYY.ZZZ.WWW IPv4 address
    { pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc=Link},
    { pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc=Link},
}

local function filterFunc(frame, event, msg, ...)
    if not msg then return false, msg, ... end
    for i, v in ipairs(patterns) do
        msg = string.gsub(msg, v.pattern, v.matchfunc)
    end
    for k,v in pairs(matchTable) do
        msg = string.gsub(msg, k, v)
        matchTable[k] = nil
    end
    return false, msg, ...
end

local hyperLinkEntered
function CH:OnHyperlinkEnter(frame, linkData, link)
    if InCombatLockdown() then return; end
    local t = linkData:match("^(.-):")
    if linkHoverShow[t] then
        ShowUIPanel(GameTooltip)
        GameTooltip:SetOwner(RayUIChatBG, "ANCHOR_RIGHT", 6, 0)
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
        hyperLinkEntered = frame
    end
end

function CH:OnHyperlinkLeave(frame, linkData, link)
    if hyperLinkEntered then
        HideUIPanel(GameTooltip)
        hyperLinkEntered = nil
    end
end

function CH:ScrollToBottom(frame)
    frame:ScrollToBottom()

    self:CancelTimer(frame.ScrollTimer, true)

    _G[frame:GetName().."ButtonFrameBottomButton"]:Hide()
end

function CH:OnMouseScroll(frame, dir)
    local bb = _G[frame:GetName().."ButtonFrameBottomButton"]
    if dir > 0 then
        if IsShiftKeyDown() then
            frame:ScrollToTop()
        elseif IsControlKeyDown() then
            --only need to scroll twice because of blizzards scroll
            frame:ScrollUp()
            frame:ScrollUp()
        end

        if frame.ScrollTimer then
            CH:CancelTimer(frame.ScrollTimer, true)
        end
        frame.ScrollTimer = CH:ScheduleTimer("ScrollToBottom", 15, frame)
    elseif dir < 0 then
        if IsShiftKeyDown() then
            frame:ScrollToBottom()
        elseif IsControlKeyDown() then
            --only need to scroll twice because of blizzards scroll
            frame:ScrollDown()
            frame:ScrollDown()
        end
    end
    if frame:AtBottom() then
        bb:Hide()
    else
        bb:Show()
    end
end

function CH:LinkHoverOnLoad()
    for i = 1, #CHAT_FRAMES do
        local cf = _G["ChatFrame"..i]
        self:HookScript(cf, "OnHyperlinkEnter", "OnHyperlinkEnter")
        self:HookScript(cf, "OnHyperlinkLeave", "OnHyperlinkLeave")
    end
end

local function nocase(s)
    s = string.gsub(s, "%a", function (c)
            return string.format("[%s%s]", string.lower(c),
                string.upper(c))
        end)
    return s
end

local function changeName(msgHeader, name, msgCnt, chatGroup, displayName, msgBody)
    if name ~= R.myname then
        msgBody = msgBody:gsub("("..nocase(R.myname)..")" , "|cffffff00>>|r|cffff0000%1|r|cffffff00<<|r")
    end
    return ("|Hplayer:%s%s%s|h[%s]|h%s"):format(name, msgCnt, chatGroup, displayName, msgBody)
end

function CH:AddMessage(text, ...)
    if text:find(INTERFACE_ACTION_BLOCKED) then return end
    local isDebug = select(7,...)

    if string.find(text, "EUI:.*") then return end
    if not text:find("BN_CONVERSATION") then
        text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
        -- text = text:gsub("%[(%d0?)%. .-%]", "[%1]") --custom channels
        -- text = text:gsub("CHANNEL:", "")
    end
    if text and type(text) == "string" then
        text = text:gsub("(|Hplayer:([^:]+)([:%d+]*)([:%w+]*)|h%[(.-)%]|h)(.-)$", changeName)
    end
    if CHAT_TIMESTAMP_FORMAT then
        local timeStamp = BetterDate(CHAT_TIMESTAMP_FORMAT, time()):gsub("%[([^]]*)%]","%%[%1%%]")
        text = text:gsub(timeStamp, "")
    end
    if CH.timeOverride then
        if CHAT_TIMESTAMP_FORMAT then
            text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate(CHAT_TIMESTAMP_FORMAT:gsub("64C2F5", "7F7F7F"), CH.timeOverride), text)
        else
            text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate("|cff7F7F7F[%H:%M]|r ", CH.timeOverride), text)
        end
        CH.timeOverride = nil
    elseif not isDebug then
        text = ("|cffffffff|HTimeCopy|h|r%s|h%s"):format(BetterDate(CHAT_TIMESTAMP_FORMAT or "|cff64C2F5[%H:%M]|r ", time()), text)
    end
    text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
    text = string.gsub(text, "(%[|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(%]:?)", changeBNetName)
    text = string.gsub(text, "EUI", "ElvUI")
    if CH.db.autoshow and CH.OnEvent then
        CH:OnEvent("CHAT_MSG_SAY")
    end
    return self.OldAddMessage(self, text, ...)
end

function CH:SetChatPosition(override)
    if ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
    for i = 1, #CHAT_FRAMES do
        local chat = _G[format("ChatFrame%d", i)]
        local tab = _G[format("ChatFrame%sTab", i)]
        if i == 2 then
            chat:ClearAllPoints()
            chat:SetPoint("TOPLEFT", RayUIChatBG, "TOPLEFT", 0, 0)
            chat:SetPoint("BOTTOMRIGHT", RayUIChatBG, "BOTTOMRIGHT", 0, 0)
        else
            chat:ClearAllPoints()
            chat:SetPoint("TOPLEFT", RayUIChatBG, "TOPLEFT", 2, -2)
            chat:SetPoint("BOTTOMRIGHT", RayUIChatBG, "BOTTOMRIGHT", -2, 4)
        end
        FCF_SavePositionAndDimensions(chat, true)
        tab:SetParent(RayUIChatBG)
        chat:SetParent(RayUIChatBG)
        local _, _, _, _, _, _, shown, _, docked, _ = GetChatWindowInfo(i)
        if shown and not docked then
            FCF_DockFrame(chat)
        end
    end
    self.initialMove = true
end

local function updateFS(self, inc, flags, ...)
    local fstring = self:GetFontString()
    if (inc or self.ffl) then
        fstring:SetFont(R["media"].font, R["media"].fontsize+2, R["media"].fontflag)
    else
        fstring:SetFont(R["media"].font, R["media"].fontsize, R["media"].fontflag)
    end

    fstring:SetShadowOffset(1,-1)

    if(...) then
        fstring:SetTextColor(...)
    end

    if (inc or self.ffl) then
        fstring:SetTextColor(1,0,0)
    end

    local x = fstring:GetText()
    if x then
        fstring:SetText(x:upper())
    end
end

function CH:FaneifyTab(frame, sel)
    local i = frame:GetID()
    if(i == _G.SELECTED_CHAT_FRAME:GetID()) then
        updateFS(frame,nil, nil, .5, 1, 1)
    else
        updateFS(frame,nil, nil, 1, 1, 1)
    end
end

function CH:FCF_StartAlertFlash(frame)
    local ID = frame:GetID()
    local tab = _G["ChatFrame" .. ID .. "Tab"]
    tab.ffl = true
    updateFS(tab, true, nil, 1,0,0)
end

function CH:FCF_StopAlertFlash(frame)
    _G["ChatFrame" .. frame:GetID() .. "Tab"].ffl = nil
end

function CH:FCF_Tab_OnClick(tab)
    local id = tab:GetID()
    local chatFrame = _G["ChatFrame"..id]
    local bb = _G["ChatFrame"..id.."ButtonFrameBottomButton"]

    if chatFrame:AtBottom() then
        bb:Hide()
    else
        bb:Show()
    end
end

function CH:ChatEdit_AddHistory(editBox, line)
    if line:find("/rl") then return; end

    if ( strlen(line) > 0 ) then
        for i, text in pairs(RayUICharacterData.ChatEditHistory) do
            if text == line then
                return
            end
        end

        table.insert(RayUICharacterData.ChatEditHistory, #RayUICharacterData.ChatEditHistory + 1, line)
        if #RayUICharacterData.ChatEditHistory > 15 then
            table.remove(RayUICharacterData.ChatEditHistory, 1)
        end
    end
end

function CH:SaveChatHistory(event, ...)
    local temp = {}
    for i = 1, select('#', ...) do
        temp[i] = select(i, ...) or false
    end
    if #temp > 0 then
        temp[20] = event
        local timeForMessage = GetTimeForSavedMessage()
        RayUICharacterData.ChatHistory[timeForMessage] = temp

        local c, k = 0
        for id, data in pairs(RayUICharacterData.ChatHistory) do
            c = c + 1
            if (not k) or k > id then
                k = id
            end
        end

        if c > 128 then
            RayUICharacterData.ChatHistory[k] = nil
        end
    end
end

function CH:DisplayChatHistory()
    local temp, data = {}
    for id, _ in pairs(RayUICharacterData.ChatHistory) do
        table.insert(temp, tonumber(id))
    end

    table.sort(temp, function(a, b)
            return a < b
        end)

    for i = 1, #temp do
        data = RayUICharacterData.ChatHistory[tostring(temp[i])]
        if (time() - temp[i]) > 21600 then
            RayUICharacterData.ChatHistory[tostring(temp[i])] = nil
        else
            if type(data) == "table" and data[20] ~= nil then
                local event = data[20]

                if event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
                    --Sender info is stored as |Kf#|k0000000000|k, which is a unique identifier for the current session only
                    --We need to update it in case the WoW client has been closed between the time the message was saved and now
                    local bnetIDAccount = data[13] --Unique identifier which persists between sessions (integer)
                    local _, presenceName = BNGetFriendInfoByID(bnetIDAccount)
                    if presenceName then
                        data[2] = presenceName --Update sender with correct name
                    end
                end

                CH.timeOverride = temp[i]
                ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, event, unpack(data))
            end
        end
    end
end

local function OnArrowPressed(self, key)
    if #self.historyLines == 0 then
        return
    end

    if key == "UP" then
        self.historyIndex = self.historyIndex - 1

        if self.historyIndex < 1 then
            self.historyIndex = #self.historyLines
        end
    elseif key == "DOWN" then
        self.historyIndex = self.historyIndex + 1

        if self.historyIndex > #self.historyLines then
            self.historyIndex = 1
        end
    else
        return
    end
    self:SetText(self.historyLines[self.historyIndex])
end

function CH:ApplyStyle(event, ...)
    for _, frameName in pairs(CHAT_FRAMES) do
        local cf = _G[frameName]
        if not cf.styled then
            local tab = _G[frameName.."Tab"]
            local eb = _G[frameName.."EditBox"]
            local i = cf:GetID()

            cf:SetParent(RayUIChatBG)
            tab:SetParent(RayUIChatBG)
            local ebParts = {"Left", "Mid", "Right", "Middle"}
            for j = 1, #CHAT_FRAME_TEXTURES do
                _G[frameName..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
            end
            for _, ebPart in ipairs(ebParts) do
                if _G[frameName.."EditBoxFocus"..ebPart] then
                    _G[frameName.."EditBoxFocus"..ebPart]:SetHeight(18)
                    _G[frameName.."EditBoxFocus"..ebPart]:SetTexture(nil)
                    _G[frameName.."EditBoxFocus"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."EditBox"..ebPart] then
                    _G[frameName.."EditBox"..ebPart]:SetTexture(nil)
                    _G[frameName.."EditBox"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."TabHighlight"..ebPart] then
                    _G[frameName.."TabHighlight"..ebPart]:SetTexture(nil)
                    _G[frameName.."TabHighlight"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."TabSelected"..ebPart] then
                    _G[frameName.."TabSelected"..ebPart]:SetTexture(nil)
                    _G[frameName.."TabSelected"..ebPart].SetTexture = function() return end
                end
                if _G[frameName.."Tab"..ebPart] then
                    _G[frameName.."Tab"..ebPart]:SetTexture(nil)
                    _G[frameName.."Tab"..ebPart].SetTexture = function() return end
                end
            end
            if not _G[frameName.."EditBoxBG"] then
                local chatebbg = CreateFrame("Frame", frameName.."EditBoxBG" , _G[frameName.."EditBox"])
                chatebbg:SetPoint("TOPLEFT", -2, -5)
                chatebbg:SetPoint("BOTTOMRIGHT", 2, 4)
                _G[frameName.."EditBoxLanguage"]:Kill()
            end
            ChatCopyButtons(i)
            if i ~= 2 then
                cf.OldAddMessage = cf.AddMessage
                cf.AddMessage = CH.AddMessage
            end

            _G[frameName.."ButtonFrame"]:Kill()
            tab:SetAlpha(0)
            tab.noMouseAlpha = 0
            cf:SetFading(false)
            cf:SetMinResize(0,0)
            cf:SetMaxResize(0,0)
            cf:SetClampedToScreen(false)
            cf:SetClampRectInsets(0,0,0,0)
            _G[frameName.."TabText"]:SetFont(R["media"].font, 13)
            local editbox = CreateFrame("Frame", nil, R.UIParent)
            editbox:Height(22)
            editbox:SetWidth(RayUIChatBG:GetWidth())
            editbox:SetPoint("BOTTOMLEFT", cf, "TOPLEFT", -2, 6)
            editbox:CreateShadow("Background")
            editbox.shadow:SetFrameLevel(0)
            editbox:Hide()
            eb:SetAltArrowKeyMode(false)
            eb:ClearAllPoints()
            eb:Point("TOPLEFT", editbox, 2, 6)
            eb:Point("BOTTOMRIGHT", editbox, -2, -3)
            eb:SetParent(R.UIParent)
            eb:Hide()
            eb:HookScript("OnShow", function(self)
                    editbox.wpos = 100
                    editbox.wspeed = 600
                    editbox.wlimit = RayUIChatBG:GetWidth()
                    editbox.wmod = 1
                    editbox:SetScript("OnUpdate", R.simple_width)
                    UIFrameFadeIn(editbox, .3, 0, 1)
                end)
            eb:HookScript("OnHide", function(self)
                    editbox:Hide()
                end)

            eb.historyLines = RayUICharacterData.ChatEditHistory
            eb.historyIndex = 0
            eb:HookScript("OnArrowPressed", OnArrowPressed)

            hooksecurefunc("ChatEdit_UpdateHeader", function()
                    local type = eb:GetAttribute("chatType")
                    if ( type == "CHANNEL" ) then
                        local id = eb:GetAttribute("channelTarget")
                        if id == 0 then
                            editbox.border:SetBackdropBorderColor(unpack(R["media"].bordercolor))
                        else
                            editbox.border:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
                        end
                    else
                        editbox.border:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
                    end
                end)
            local function BottomButtonClick(self)
                self:GetParent():ScrollToBottom()
                self:Hide()
            end
            local bb = _G[frameName.."ButtonFrameBottomButton"]
            local flash = _G[frameName.."ButtonFrameBottomButtonFlash"]
            R.Skins:ReskinArrow(bb, "down")
            bb:SetParent(cf)
            bb:ClearAllPoints()
            bb:SetPoint("TOPRIGHT", cf, "TOPRIGHT", 0, -20)
            bb.SetPoint = R.dummy
            --flash:ClearAllPoints()
            --flash:Point("TOPLEFT", -3, 3)
            --flash:Point("BOTTOMRIGHT", 3, -3)
            bb:Hide()
            flash:Kill()
            bb:SetScript("OnClick", BottomButtonClick)
            bb:SetScript("OnShow", function(self) CH:OnMouseScroll(cf, 1) end)
            local font, path = cf:GetFont()
            cf:SetFont(font, path, R["media"].fontflag)
            cf:SetShadowColor(0, 0, 0, 0)

            self:SecureHook(eb, "AddHistoryLine", "ChatEdit_AddHistory")
            for i, text in pairs(RayUICharacterData.ChatEditHistory) do
                eb:AddHistoryLine(text)
            end

            cf.styled = true
        end
    end
    CH:SetChatPosition(true)
end

function CH:SetChat()
    local whisperFound
    for i = 1, #CHAT_FRAMES do
        local chatName, _, _, _, _, _, shown = FCF_GetChatWindowInfo(_G["ChatFrame"..i]:GetID())
        if chatName == WHISPER then
            if shown then
                whisperFound = true
            elseif not shown and not whisperFound then
                _G["ChatFrame"..i]:Show()
                whisperFound = true
            end
        end
    end
    if not whisperFound then
        FCF_OpenNewWindow(WHISPER)
    end
    for i = 1, #CHAT_FRAMES do
        local frame = _G["ChatFrame"..i]
        FCF_SetChatWindowFontSize(nil, frame, 15)
        FCF_SetWindowAlpha(frame , 0)
        local chatName = FCF_GetChatWindowInfo(frame:GetID())
        if chatName == WHISPER then
            ChatFrame_RemoveAllMessageGroups(frame)
            ChatFrame_AddMessageGroup(frame, "WHISPER")
            ChatFrame_AddMessageGroup(frame, "BN_WHISPER")
        end
    end
    ChatFrame1:SetFrameLevel(8)
    FCF_SavePositionAndDimensions(ChatFrame1)
    FCF_SetLocked(ChatFrame1, 1)
    ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
    ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
    ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)
    ToggleChatColorNamesByClassGroup(true, "SAY")
    ToggleChatColorNamesByClassGroup(true, "EMOTE")
    ToggleChatColorNamesByClassGroup(true, "YELL")
    ToggleChatColorNamesByClassGroup(true, "GUILD")
    ToggleChatColorNamesByClassGroup(true, "OFFICER")
    ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
    ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
    ToggleChatColorNamesByClassGroup(true, "WHISPER")
    ToggleChatColorNamesByClassGroup(true, "PARTY")
    ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
    ToggleChatColorNamesByClassGroup(true, "RAID")
    ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
    ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
    ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
    ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
    ToggleChatColorNamesByClassGroup(true, "CHANNEL11")

    FCFDock_SelectWindow(GENERAL_CHAT_DOCK, ChatFrame1)
end

function CH:SetItemRef(link, text, button, chatFrame)
    local linkType, id = strsplit(":", link)
    if linkType == "TimeCopy" then
        frame = GetMouseFocus():GetParent()
        local text
        for i = 1, select("#", frame:GetRegions()) do
            local obj = select(i, frame:GetRegions())
            if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
                text = obj:GetText()
            end
        end
        text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
        text = text:gsub("|H.-|h(.-)|h", "%1")
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
        if (not ChatFrameEditBox:IsShown()) then
            ChatEdit_ActivateChat(ChatFrameEditBox)
        end
        ChatFrameEditBox:SetText(text)
        ChatFrameEditBox:HighlightText()
    elseif linkType == "url" then
        currentLink = string.sub(link, 5)
        StaticPopup_Show("UrlCopyDialog")
    elseif linkType == "RayUIDamegeMeters" then
        local meterID = tonumber(id)
        ShowUIPanel(ItemRefTooltip)
        if not ItemRefTooltip:IsShown() then
            ItemRefTooltip:SetOwner(R.UIParent, "ANCHOR_PRESERVE")
        end
        ItemRefTooltip:ClearLines()
        ItemRefTooltip:AddLine(_DamageMeters[meterID].title)
        ItemRefTooltip:AddLine(string.format(L["发布者"]..": %s", _DamageMeters[meterID].source))
        for k, v in ipairs(_DamageMeters[meterID].data) do
            local left, right = v:match("^(.*) (.*)$")
            if left and right then
                ItemRefTooltip:AddDoubleLine(left, right, 1, 1, 1, 1, 1, 1)
            else
                ItemRefTooltip:AddLine(v, 1, 1, 1)
            end
        end
        ItemRefTooltip:Show()
    else
        return self.hooks.SetItemRef(link, text, button)
    end
end

function CH:PET_BATTLE_CLOSE()
    for _, frameName in pairs(CHAT_FRAMES) do
        local frame = _G[frameName]
        if frame and _G[frameName.."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG) then
            FCF_Close(frame)
        end
    end
end

function CH:ON_FCF_SavePositionAndDimensions(_, noLoop)
    if not noLoop then
        CH:SetChatPosition()
    end
end

function CH:Initialize()
    if not self.db.enable then return end

    if not RayUICharacterData.ChatEditHistory then
        RayUICharacterData.ChatEditHistory = {}
    end

    if not RayUICharacterData.ChatHistory then
        RayUICharacterData.ChatHistory = {}
    end

    ChatFrameMenuButton:Kill()
    QuickJoinToastButton:Kill()

    CreatCopyFrame()
    CopyChatFrame:Hide()
    if not RayUIChatBG then
        local RayUIChatBG = CreateFrame("Frame", "RayUIChatBG", R.UIParent, "SecureHandlerStateTemplate")
        RayUIChatBG:CreatePanel("Default", self.db.width, self.db.height, "BOTTOMLEFT",R.UIParent,"BOTTOMLEFT",15,30)
        RegisterStateDriver(RayUIChatBG, "visibility", "[combat]show")
        GeneralDockManager:SetParent(RayUIChatBG)
    end

    _G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE|h".."[I]".."|h %s:\32"
    _G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE|h".."[IL]".."|h %s:\32"
    _G.CHAT_BN_WHISPER_GET = "%s:\32"
    _G.CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32"
    _G.CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32"
    _G.CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32"
    _G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[PL]".."|h %s:\32"
    _G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[PL]".."|h %s:\32"
    _G.CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
    _G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[RL]".."|h %s:\32"
    _G.CHAT_RAID_WARNING_GET = "[RW]".." %s:\32"
    _G.CHAT_SAY_GET = "%s:\32"
    _G.CHAT_WHISPER_GET = "%s:\32"
    _G.CHAT_YELL_GET = "%s:\32"
    _G.ERR_FRIEND_ONLINE_SS = _G.ERR_FRIEND_ONLINE_SS:gsub("%]%|h", "]|h|cff00ffff")
    _G.ERR_FRIEND_OFFLINE_S = _G.ERR_FRIEND_OFFLINE_S:gsub("%%s", "%%s|cffff0000")

    _G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
    _G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

    ChatTypeInfo.EMOTE.sticky = 0
    ChatTypeInfo.YELL.sticky = 0
    ChatTypeInfo.RAID_WARNING.sticky = 1
    ChatTypeInfo.WHISPER.sticky = 0
    ChatTypeInfo.BN_WHISPER.sticky = 0

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

    self:SecureHook("ChatFrame_OpenChat", "EditBox_MouseOn")
    self:SecureHook("ChatEdit_OnShow", "EditBox_MouseOn")
    self:SecureHook("ChatEdit_SendText", "EditBox_MouseOff")
    self:SecureHook("ChatEdit_OnHide", "EditBox_MouseOff")
    self:SecureHook("FloatingChatFrame_OnMouseScroll", "OnMouseScroll")
    self:SecureHook("FCFTab_UpdateColors", "FaneifyTab")
    self:SecureHook("FCF_StartAlertFlash")
    self:SecureHook("FCF_StopAlertFlash")
    self:SecureHook("FCF_Tab_OnClick")
    self:SecureHook("FCF_SavePositionAndDimensions", "ON_FCF_SavePositionAndDimensions")

    local events = {
        "CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER",
        "CHAT_MSG_CHANNEL", "CHAT_MSG_EMOTE",
        "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
        "CHAT_MSG_PARTY", "CHAT_MSG_RAID",
        "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_PARTY_LEADER",
        "CHAT_MSG_SAY", "CHAT_MSG_WHISPER","CHAT_MSG_BN_WHISPER",
        "CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_YELL", "CHAT_MSG_BN_WHISPER_INFORM","CHAT_MSG_BN_CONVERSATION"
    }
    for _,event in ipairs(events) do
        ChatFrame_AddMessageEventFilter(event, filterFunc)
    end

    self:RegisterEvent("UPDATE_CHAT_WINDOWS", "ApplyStyle")
    self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "ApplyStyle")
    self:SecureHook("FCF_OpenTemporaryWindow", "ApplyStyle")
    self:RegisterEvent("PET_BATTLE_CLOSE")
    self:ApplyStyle()

    self:LinkHoverOnLoad()
    self:AutoHide()
    self:SpamFilter()
    self:DamageMeterFilter()
    self:EasyChannel()
    self:EnableDumpTool()
    self:RawHook("SetItemRef", true)
    self:RawHook("GetColoredName", true)

    ChatHistoryEvent:RegisterEvent("CHAT_MSG_BATTLEGROUND")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_BN_WHISPER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_CHANNEL")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_EMOTE")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_GUILD")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_OFFICER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_PARTY")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID_LEADER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_RAID_WARNING")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_SAY")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_WHISPER")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    ChatHistoryEvent:RegisterEvent("CHAT_MSG_YELL")
    ChatHistoryEvent:SetScript("OnEvent", function(self, event, ...)
            CH:SaveChatHistory(event, ...)
        end)
    CH:DisplayChatHistory()

    InterfaceOptionsSocialPanelTimestamps:SetScale(0.0001)
    InterfaceOptionsSocialPanelChatStyle:SetScale(0.0001)
    InterfaceOptionsSocialPanelProfanityFilter:SetScale(0.0001)
    InterfaceOptionsSocialPanelTimestamps:SetAlpha(0)
    InterfaceOptionsSocialPanelChatStyle:SetAlpha(0)
    InterfaceOptionsSocialPanelProfanityFilter:SetAlpha(0)
    SetCVar("profanityFilter", 0)
    SetCVar("chatStyle", "classic")
    SetCVar("showTimestamps", "none")

    self:RegisterChatCommand("setchat", "SetChat")
end

StaticPopupDialogs["UrlCopyDialog"] = {
    text = L["URL Ctrl+C复制"],
    button2 = CLOSE,
    hasEditBox = 1,
    editBoxWidth = 400,
    OnShow = function(frame)
        local editBox = _G[frame:GetName().."EditBox"]
        if editBox then
            editBox:SetText(currentLink)
            editBox:SetFocus()
            editBox:HighlightText(0)
        end
        local button = _G[frame:GetName().."Button2"]
        if button then
            button:ClearAllPoints()
            button:SetWidth(200)
            button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
        end
    end,
    EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    maxLetters=1024, -- this otherwise gets cached from other dialogs which caps it at 10..20..30...
}

R:RegisterModule(CH:GetName())
