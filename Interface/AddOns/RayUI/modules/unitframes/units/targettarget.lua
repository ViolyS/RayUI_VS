----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("UnitFrames")


local UF = _UnitFrames
local oUF = RayUF or oUF


function UF:Construct_TargetTargetFrame(frame, unit)
    frame.mouseovers = {}
    frame.UNIT_WIDTH = self.db.units[unit].width
    frame.UNIT_HEIGHT = self.db.units[unit].height
    frame.POWER_HEIGHT = ceil(frame.UNIT_HEIGHT * self.db.powerheight)

    frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)
    frame.Health = self:Construct_HealthBar(frame, true, true)
    frame.Power = self:Construct_PowerBar(frame, true, true)

    frame.Power:Point("BOTTOMLEFT", frame, "BOTTOMLEFT")
    frame.Power:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    frame.Power:Height(frame.POWER_HEIGHT)
    frame.Health:Point("TOPLEFT", frame, "TOPLEFT")
    frame.Health:Point("BOTTOMRIGHT", frame.Power, "TOPRIGHT", 0, 1)

    frame.Name = self:Construct_NameText(frame)
    frame.Mouseover = self:Construct_Highlight(frame)
    frame.PvPIndicator = self:Construct_PvPIndicator(frame)
    frame.QuestIndicator = self:Construct_QuestIcon(frame)
    frame.RaidTargetIndicator = self:Construct_RaidIcon(frame)
    frame.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.4
        }

    self:EnableHealPredictionAndAbsorb(frame)

    frame.Health.value:Point("TOPLEFT", frame.Health, "TOPLEFT", 5, - 5)
    frame.Power.value:Point("TOPRIGHT", frame.Health, "TOPRIGHT", - 5, - 5)

    frame.Name:ClearAllPoints()
    frame.Name:Point("BOTTOM", frame.Health, "BOTTOM", 0, 5)
    frame.Name:SetJustifyH("CENTER")
    if self.db.healthColorClass then
        frame:Tag(frame.Name, "[RayUF:name]")
    else
        frame:Tag(frame.Name, "[RayUF:color][RayUF:name]")
    end

    if self.db.showPortrait then
        frame.Portrait = self:Construct_Portrait(frame)
    end

    frame.Buffs = self:Construct_Buffs(frame)
    frame.Buffs["growth-x"] = "RIGHT"
    frame.Buffs["growth-y"] = "UP"
    frame.Buffs.initialAnchor = "BOTTOMLEFT"
    frame.Buffs.num = 5
    frame.Buffs.CustomFilter = function(_, unit) if UnitIsFriend(unit, "player") then return false end return true end
    frame.Buffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)

    frame.Debuffs = self:Construct_Debuffs(frame)
    frame.Debuffs["growth-x"] = "RIGHT"
    frame.Debuffs["growth-y"] = "UP"
    frame.Debuffs.initialAnchor = "BOTTOMLEFT"
    frame.Debuffs.num = 5
    frame.Debuffs.CustomFilter = function(_, unit) if UnitIsEnemy(unit, "player") then return false end return true end
    frame.Debuffs:Point("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)
end

tinsert(_UnitsToLoad, "targettarget")
