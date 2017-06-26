----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Misc")


local M = _Misc
local mod = M:NewModule("Announce", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")


local iconsize = 24

function mod:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    if (eventType=="SPELL_DISPEL" or eventType=="SPELL_STOLEN" or eventType=="SPELL_INTERRUPT" or eventType=="SPELL_DISPEL_FAILED") and (sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet")) then
        local _, _, _, id, effect, _, etype = ...
        local msg = _G["ACTION_" .. eventType]
        local color
        local icon =GetSpellTexture(id)

        if eventType=="SPELL_INTERRUPT" then
            if IsInRaid() then
                SendChatMessage(msg..": "..destName.." \124cff71d5ff\124Hspell:"..id..":0\124h["..effect.."]\124h\124r!", (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
            elseif IsInGroup() then
                SendChatMessage(msg..": "..destName.." \124cff71d5ff\124Hspell:"..id..":0\124h["..effect.."]\124h\124r!", (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
            end
        end
    end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event, ...)
    if not GetZonePVPInfo() == "arena" then return end

    local unit, spellName, spellrank, spelline, spellID = ...
    if UnitIsEnemy("player", unit) and (spellID == 80167 or spellID == 94468 or spellID == 43183 or spellID == 57073 or spellName == "Drinking") then
        if GetNumGroupMembers() > 0 then
            local isInstance, instanceType = IsInInstance()
            -- 在一个副本中 并且是JJC或者ZC或者查找组队地城中(随机本 随机团 场景战役)
            if isInstance and (instanceType=="arena" or instanceType=="pvp" or IsInLFGDungeon()) then
                SendChatMessage(UnitName(unit)..L["正在吃喝."], "INSTANCE_CHAT")
            elseif IsInRaid() then
                SendChatMessage(UnitName(unit)..L["正在吃喝."], "RAID")
            else
                SendChatMessage(UnitName(unit)..L["正在吃喝."], "PARTY")
            end
        else
            SendChatMessage(UnitName(unit)..L["正在吃喝."], "SAY")
        end
    end
end

function mod:PLAYER_REGEN_ENABLED()
    if (UnitIsDead("player")) then return end
    self:AlertRun(LEAVING_COMBAT.." !",0.1,1,0.1)
end

function mod:PLAYER_REGEN_DISABLED()
    if (UnitIsDead("player")) then return end
    self:AlertRun(ENTERING_COMBAT.." !",1,0.1,0.1)
end

function mod:CHAT_MSG_SKILL(event, message)
    UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
end

-------------------------------------------------------------------------------------
-- Credit Alleykat
-- Entering combat and alertrun function (can be used in anther ways)
------------------------------------------------------------------------------------
local speed = .057799924 -- how fast the text appears
local font = LSM:Fetch("font", "RayUI Font") -- HOOG0555.ttf
local fontflag = "OUTLINE" -- for pixelfont stick to this else OUTLINE or THINOUTLINE
local fontsize = 24 -- font size

local GetNextChar = function(word,num)
    local c = word:byte(num)
    local shift
    if not c then return "",num end
    if (c > 0 and c <= 127) then
        shift = 1
    elseif (c >= 192 and c <= 223) then
        shift = 2
    elseif (c >= 224 and c <= 239) then
        shift = 3
    elseif (c >= 240 and c <= 247) then
        shift = 4
    end
    return word:sub(num,num+shift-1),(num+shift)
end

local updaterun = CreateFrame("Frame")

local flowingframe = CreateFrame("Frame",nil,R.UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER",R.UIParent,0, 140) -- where we want the textframe
flowingframe:SetHeight(64)

local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
flowingtext:SetFont(font,fontsize, fontflag)
flowingtext:SetShadowOffset(1.5,-1.5)

local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
rightchar:SetFont(font,60, fontflag)
rightchar:SetShadowOffset(1.5,-1.5)
rightchar:SetJustifyH("LEFT") -- left or right

local count,len,step,word,stringE,a,backstep

local nextstep = function()
    a,step = GetNextChar (word,step)
    flowingtext:SetText(stringE)
    stringE = stringE..a
    a = string.upper(a)
    rightchar:SetText(a)
end

local backrun = CreateFrame("Frame")
backrun:Hide()

local updatestring = function(self,t)
    count = count - t
    if count < 0 then
        count = speed
        if step > len then
            self:Hide()
            flowingtext:SetText(stringE)
            rightchar:SetText()
            flowingtext:ClearAllPoints()
            flowingtext:SetPoint("RIGHT")
            flowingtext:SetJustifyH("RIGHT")
            rightchar:ClearAllPoints()
            rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
            rightchar:SetJustifyH("RIGHT")
            self:Hide()
            count = 1.456789
            backrun:Show()
        else
            nextstep()
        end
    end
end

updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()

local backstepf = function()
    local a = backstep
    local firstchar
    local texttemp = ""
    local flagon = true
    while a <= len do
        local u
        u,a = GetNextChar(word,a)
        if flagon == true then
            backstep = a
            flagon = false
            firstchar = u
        else
            texttemp = texttemp..u
        end
    end
    flowingtext:SetText(texttemp)
    firstchar = string.upper(firstchar)
    rightchar:SetText(firstchar)
end

local rollback = function(self,t)
    count = count - t
    if count < 0 then
        count = speed
        if backstep > len then
            self:Hide()
            flowingtext:SetText()
            rightchar:SetText()
        else
            backstepf()
        end
    end
end

backrun:SetScript("OnUpdate",rollback)

function mod:AlertRun(f,r,g,b)
    flowingframe:Hide()
    updaterun:Hide()
    backrun:Hide()

    flowingtext:SetText(f)
    local l = flowingtext:GetWidth()

    local color1 = r or 1
    local color2 = g or 1
    local color3 = b or 1

    flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95) -- color in RGB(red green blue)(alpha)
    rightchar:SetTextColor(color1,color2,color3)

    word = f
    len = f:len()
    step,backstep = 1,1
    count = speed
    stringE = ""
    a = ""

    flowingtext:SetText("")
    flowingframe:SetWidth(l)
    flowingtext:ClearAllPoints()
    flowingtext:SetPoint("LEFT")
    flowingtext:SetJustifyH("LEFT")
    rightchar:ClearAllPoints()
    rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
    rightchar:SetJustifyH("LEFT")

    rightchar:SetText("")
    updaterun:Show()
    flowingframe:Show()
end

function mod:Initialize()
    if not M.db.anounce then return end

    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("CHAT_MSG_SKILL")

    CombatText:UnregisterEvent("PLAYER_REGEN_ENABLED")
    CombatText:UnregisterEvent("PLAYER_REGEN_DISABLED")
    SetCVar("floatingCombatTextCombatState", "1")
end

M:RegisterMiscModule(mod:GetName())
