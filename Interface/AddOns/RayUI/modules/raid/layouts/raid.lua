local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local RA = R:GetModule("Raid")
local UF = R:GetModule("UnitFrames")

local _, ns = ...
local RayUF = ns.oUF

--Cache global variables
--Lua functions
local type, unpack, table = type, unpack, table

--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function RA:FetchRaidSettings()
    self.groupConfig.raid = {
        enable = true,
        width = self.db.width,
        height = self.db.height,
        visibility = "[nogroup:party,nogroup:raid] hide;show",
        numGroups = 8,
        defaultPosition = { "BOTTOMLEFT", R.UIParent, "BOTTOMLEFT", 15, 235 },
    }
end

function RA:Construct_RaidFrames()
    self.RaisedElementParent = CreateFrame("Frame", nil, self)
    self.RaisedElementParent:SetFrameLevel(self:GetFrameLevel() + 100)
    self.Health = RA:Construct_HealthBar(self)
    self.Power = RA:Construct_PowerBar(self)
    self.Name = RA:Construct_NameText(self)
    self.ThreatIndicator = RA:Construct_Threat(self)
    self.Healtext = RA:Construct_HealText(self)
    self.Highlight = RA:Construct_Highlight(self)
    self.RaidTargetIndicator = RA:Construct_RaidIcon(self)
    self.ResurrectIcon = RA:Construct_ResurectionIcon(self)
    self.ReadyCheck = RA:Construct_ReadyCheck(self)
    self.RaidDebuffs = RA:Construct_RaidDebuffs(self)
    self.AuraWatch = RA:Construct_AuraWatch(self)
    self.RaidRoleFramesAnchor = RA:Construct_RaidRoleFrames(self)
    if RA.db.roleicon then
        self.LFDRole = RA:Construct_RoleIcon(self)
    end
    self.AFKtext = RA:Construct_AFKText(self)
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = RA.db.outsideRange,
    }

    RA:ConfigureAuraWatch(self)
    UF:EnableHealPredictionAndAbsorb(self)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", RA.UnitFrame_OnEnter)
    self:SetScript("OnLeave", RA.UnitFrame_OnLeave)
    RA:SecureHook(self, "UpdateAllElements", RA.UnitFrame_OnShow)
    self:SetScript("OnHide", RA.UnitFrame_OnHide)

    self:RegisterEvent("PLAYER_TARGET_CHANGED", RA.UpdateTargetBorder)
    self:RegisterEvent("GROUP_ROSTER_UPDATE", RA.UpdateTargetBorder)
end

function RA:RaidSmartVisibility(event)
--[[    local inInstance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _, mapID, instanceGroupSize = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    if not InCombatLockdown() then
        if(inInstance and (instanceType == "raid" or instanceType == "pvp")) then
            if RA.mapIDs[mapID] then
                maxPlayers = RA.mapIDs[mapID]
            end
            UnregisterStateDriver(self, "visibility")
            if maxPlayers <= 25 then
                self:Show()
            else
                self:Hide()
            end
        else
            RegisterStateDriver(self, "visibility", RA.groupConfig.raid.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
    ]]
    RegisterStateDriver(self, "visibility", RA.groupConfig.raid.visibility)
end

RA["headerstoload"]["raid"] = { nil, nil }
