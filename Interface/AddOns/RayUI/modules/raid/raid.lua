----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Raid")


local RA = R:NewModule("Raid", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

local _, ns = ...
local oUF = RayUF or oUF


RA.modName = L["团队"]
_Raid = RA

_ColorCache = {}
_DebuffColor = {}
_GroupConfig = {}
_HeadersToLoad = {}
_MapIDs = {
    [30] = 40, -- Alterac Valley
    [489] = 10, -- Warsong Gulch
    [529] = 15, -- Arathi Basin
    [566] = 15, -- Eye of the Storm
    [607] = 15, -- Strand of the Ancients
    [628] = 40, -- Isle of Conquest
    [726] = 10, -- Twin Peaks
    [727] = 10, -- Silvershard mines
    [761] = 10, -- The Battle for Gilneas
    [968] = 10, -- Rated Eye of the Storm
    [998] = 10, -- Temple of Kotmogu
    [1105] = 15, -- Deepwind Gourge
    [1280] = 40, -- Southshore vs. Tarren Mill
}

function RA:RegisterDebuffs()
    SetMapToCurrentZone()
    local _, instanceType = IsInInstance()
    local zone = GetCurrentMapAreaID()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD:ResetDebuffData()

        if instanceType == "party" or instanceType == "raid" then
            if _RaidDebuffsList.instances[zone] then
                ORD:RegisterDebuffs(_RaidDebuffsList.instances[zone])
            end
        end
    end
end

local function HideCompactRaid()
    if InCombatLockdown() then return end
    CompactRaidFrameManager:Kill()
    local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
    if compact_raid and compact_raid ~= "0" then
        CompactRaidFrameManager_SetSetting("IsShown", "0")
    end
end

function RA:HideBlizzard()
    hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideCompactRaid)
    CompactRaidFrameManager:HookScript("OnShow", HideCompactRaid)
    CompactRaidFrameContainer:UnregisterAllEvents()

    HideCompactRaid()
    hooksecurefunc("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
end

local function CreateLabel(frame)
    local label = CreateFrame("Frame", nil, frame)
    label:SetFrameStrata("BACKGROUND")
    label:SetFrameLevel(0)
    label:SetTemplate("Transparent")
    label.text = label:CreateFontString(nil, "OVERLAY")
    label.text:FontTemplate(R["media"].pxfont, 10 * R.mult, "OUTLINE, MONOCHROME")
    label.text:SetTextColor(0.7, 0.7, 0.7)

    if RA.db.horizontal then
        label:Point("TOPRIGHT", frame, "TOPLEFT", 0, 1)
        label:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, -1)
        label.text:Point("CENTER", 2, 0)
        label:Width(12)
    else
        label:Point("BOTTOMLEFT", frame, "TOPLEFT", -1, 0)
        label:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 1, 0)
        label.text:Point("CENTER", 0, 1)
        label:Height(12)
    end

    label:Hide()
    return label
end

function RA:CreateHeader(parent, name, groupFilter, template, layout)
    local point, growth, xoff, yoff
    if RA.db.horizontal then
        point = "LEFT"
        xoff = RA.db.spacing
        yoff = 0
        if RA.db.growth == "UP" then
            growth = "BOTTOM"
        else
            growth = "TOP"
        end
    else
        point = "TOP"
        xoff = 0
        yoff = -RA.db.spacing
        if RA.db.growth == "RIGHT" then
            growth = "LEFT"
        else
            growth = "RIGHT"
        end
    end

    local header = RayUF:SpawnHeader(name, nil, nil,
        "oUF-initialConfigFunction", ([[self:SetWidth(%d); self:SetHeight(%d);]]):format(R:Scale(_GroupConfig[layout].width), R:Scale(_GroupConfig[layout].height)),
        "xOffset", xoff,
        "yOffset", yoff,
        "point", point,
        "showPlayer", true,
        "showRaid", true,
        "showParty", true,
        "sortMethod", "INDEX",
        "groupFilter", groupFilter,
        "groupingOrder", "1,2,3,4,5,6,7,8",
        "groupBy", "GROUP",
        "maxColumns", 1,
        "unitsPerColumn", 5,
        "columnSpacing", RA.db.spacing,
        "columnAnchorPoint", growth,
        template and "template", template)

    header:SetParent(parent)
    header:Show()
    return header
end

function RA:CreateHeaderGroup(layout, groupFilter, template)
    local stringTitle = R:StringTitle(layout)
    RayUF:RegisterStyle("RayUF_"..stringTitle, RA["Construct_"..stringTitle.."Frames"])
    RayUF:SetActiveStyle("RayUF_"..stringTitle)

    local numGroups = _GroupConfig[layout].numGroups
    if numGroups then
        self[layout] = CreateFrame("Frame", "RayUF_"..stringTitle, R.UIParent, "SecureHandlerStateTemplate")
        self[layout].groups = {}
        self[layout]:Point(unpack(_GroupConfig[layout].defaultPosition))

        if RA.db.horizontal then
            self[layout]:Size(_GroupConfig[layout].width*5 + RA.db.spacing*4, _GroupConfig[layout].height*numGroups + RA.db.spacing*(numGroups-1))
        else
            self[layout]:Size(_GroupConfig[layout].width*numGroups + RA.db.spacing*(numGroups-1), _GroupConfig[layout].height*5 + RA.db.spacing*4)
        end
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", L[stringTitle.." Mover"], nil, nil, "ALL,RAID", true)

        for i= 1, numGroups do
            local group = self:CreateHeader(self[layout], "RayUF_"..stringTitle.."Group"..i, i, template, layout)
            if RA.db.showlabel then
                group.label = CreateLabel(group)
                group.label.text:SetText(_GroupConfig[layout].label or i)
            end

            if i == 1 then
                if RA.db.horizontal then
                    if RA.db.growth == "UP" then
                        group:Point("BOTTOMLEFT", self[layout], "BOTTOMLEFT", 0, 0)
                    else
                        group:Point("TOPLEFT", self[layout], "TOPLEFT", 0, 0)
                    end
                else
                    if RA.db.growth == "RIGHT" then
                        group:Point("TOPLEFT", self[layout], "TOPLEFT", 0, 0)
                    else
                        group:Point("TOPRIGHT", self[layout], "TOPRIGHT", 0, 0)
                    end
                end
            else
                if RA.db.horizontal then
                    if RA.db.growth == "UP" then
                        group:Point("BOTTOMLEFT", self[layout].groups[i-1], "TOPLEFT", 0, RA.db.spacing)
                    else
                        group:Point("TOPLEFT", self[layout].groups[i-1], "BOTTOMLEFT", 0, -RA.db.spacing)
                    end
                else
                    if RA.db.growth == "RIGHT" then
                        group:Point("TOPLEFT", self[layout].groups[i-1], "TOPRIGHT", RA.db.spacing, 0)
                    else
                        group:Point("TOPRIGHT", self[layout].groups[i-1], "TOPLEFT", -RA.db.spacing, 0)
                    end
                end
            end
            self[layout].groups[i] = group
            group:Show()
        end
    else
        self[layout] = self:CreateHeader(R.UIParent, "RayUF_"..stringTitle, groupFilter, template, layout)
        self[layout]:Point(unpack(_GroupConfig[layout].defaultPosition))
        if RA.db.showlabel and _GroupConfig[layout].label then
            self[layout].label = CreateLabel(self[layout])
            self[layout].label.text:SetText(_GroupConfig[layout].label)
        end
        if RA.db.horizontal then
            self[layout]:Size(_GroupConfig[layout].width*5 + RA.db.spacing*4, _GroupConfig[layout].height)
        else
            self[layout]:Size(_GroupConfig[layout].width, _GroupConfig[layout].height*5 + RA.db.spacing*4)
        end
        R:CreateMover(self[layout], "RayUF_"..stringTitle.."Mover", L[stringTitle.." Mover"], nil, nil, "ALL,RAID", true)
    end

    self[layout].visibility = _GroupConfig[layout].visibility
    if RA[stringTitle.."SmartVisibility"] then
        self[layout]:SetScript("OnEvent", RA[stringTitle.."SmartVisibility"])
        RA[stringTitle.."SmartVisibility"](self[layout])
    end
end

function RA:Initialize()
    if not self.db.enable then return end

    for class, color in next, RayUF.colors.class do
        _ColorCache[class] = RA:Hex(color)
    end

    for dtype, color in next, DebuffTypeColor do
        _DebuffColor[dtype] = RA:Hex(color)
    end

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame"..i]
        frame:UnregisterAllEvents()
        frame:Kill()

        local health = frame.healthbar
        if(health) then
            health:UnregisterAllEvents()
        end

        local power = frame.manabar
        if(power) then
            power:UnregisterAllEvents()
        end

        local spell = frame.spellbar
        if(spell) then
            spell:UnregisterAllEvents()
        end

        local altpowerbar = frame.powerBarAlt
        if(altpowerbar) then
            altpowerbar:UnregisterAllEvents()
        end
    end
    self:HideBlizzard()
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "HideBlizzard")
    UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

    for layout, config in pairs(_HeadersToLoad) do
        local stringTitle = R:StringTitle(layout)
        local groupFilter, template = unpack(config)
        self["Fetch"..stringTitle.."Settings"](self)
        if _GroupConfig[layout].enable then
            self:CreateHeaderGroup(layout, groupFilter, template)
        end
    end
    _HeadersToLoad = nil

    self:RegisterDebuffs()
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
    if ORD then
        ORD.MatchBySpellName = false
    end

    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RegisterDebuffs")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "RegisterDebuffs")
end

function RA:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r团队模块."]
end

R:RegisterModule(RA:GetName())
