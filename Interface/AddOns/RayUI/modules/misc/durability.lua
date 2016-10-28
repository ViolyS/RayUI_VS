local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local M = R:GetModule("Misc")
local mod = M:NewModule("Durability", "AceEvent-3.0")

--Cache global variables
--Lua functions
local _G = _G
local pairs, math, string, rawget, select = pairs, math, string, rawget, select

--WoW API / Variables
local CreateFrame = CreateFrame
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LE_ITEM_QUALITY_ARTIFACT, INVSLOT_OFFHAND, INVSLOT_MAINHAND

local SLOTIDS, LEFT_SLOT = {}, {}
for _, slot in pairs({"Head","Neck","Shoulder","Shirt","Chest","Waist","Legs","Feet","Wrist","Hands","Finger0","Finger1","Trinket0","Trinket1","Back","MainHand","SecondaryHand","Tabard"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end
for _, slot in pairs({ 1, 2, 3, 4, 5, 9, 17, 19 }) do LEFT_SLOT[slot] = true end
local frame = CreateFrame("Frame", nil, CharacterFrame)

local function RYGColorGradient(perc)
    local relperc = perc*2 % 1
    if perc <= 0 then return 1, 0, 0
    elseif perc < 0.5 then return 1, relperc, 0
    elseif perc == 0.5 then return 1, 1, 0
    elseif perc < 1.0 then return 1 - relperc, 1, 0
    else return 0, 1, 0 end
end

local itemLevel = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Character"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].pxfont, 10*R.mult, "THINOUTLINE,MONOCHROME")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            text:Point("TOPRIGHT", gslot, "TOPRIGHT", -2, 0)
            t[i] = text
            return text
        end,
    })

local inspectItemLevel = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Inspect"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].pxfont, 10*R.mult, "THINOUTLINE,MONOCHROME")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            text:Point("TOPRIGHT", gslot, "TOPRIGHT", -2, 0)
            t[i] = text
            return text
        end,
    })

local durability = setmetatable({}, {
        __index = function(t,i)
            local gslot = _G["Character"..i.."Slot"]
            if not gslot then return nil end

            local text = gslot:CreateFontString(nil, "OVERLAY")
            text:SetFont(R["media"].pxfont, 10*R.mult, "THINOUTLINE,MONOCHROME")
            text:SetShadowColor(0, 0, 0)
            text:SetShadowOffset(R.mult, -R.mult)
            text:Point("CENTER", gslot, "BOTTOM", 1, 8)
            t[i] = text
            return text
        end,
    })

function mod:UpdateDurability()
    local min = 1
    for slot, id in pairs(SLOTIDS) do
        local v1, v2 = GetInventoryItemDurability(id)

        if v1 and v2 and v2 ~= 0 then
            min = math.min(v1/v2, min)
            local text = durability[slot]
            if not text then return end
            text:SetTextColor(RYGColorGradient(v1/v2))
            text:SetText(string.format("%d%%", v1/v2*100))
        else
            local text = rawget(durability, slot)
            if not text then return end
            if text then text:SetText(nil) end
        end
    end

    local r, g, b = RYGColorGradient(min)
end

function mod:UpdateItemlevel(event)
    local t = itemLevel
    local unit = "player"
    if event == "INSPECT_READY" then
        unit = "target"
        t = inspectItemLevel
    end
    for slot, id in pairs(SLOTIDS) do
        local text = t[slot]
        if not text then return end
        text:SetText("")
        local clink = GetInventoryItemLink(unit, id)
        if clink then
            local iLvl = GetDetailedItemLevelInfo(clink)
            local rarity = select(3, GetItemInfo(clink))
            if iLvl and rarity then
                if iLvl == 750 and rarity == LE_ITEM_QUALITY_ARTIFACT and id == INVSLOT_OFFHAND then
                    iLvl = GetDetailedItemLevelInfo(GetInventoryItemLink(unit, INVSLOT_MAINHAND))
                end
                local r, g, b = GetItemQualityColor(rarity)

                text:SetText(iLvl)
                text:SetTextColor(r, g, b)
            end
        end
    end
end

function mod:Initialize()
    self:RegisterEvent("ADDON_LOADED", "UpdateDurability")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdateDurability")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateItemlevel")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateItemlevel")
    self:RegisterEvent("INSPECT_READY", "UpdateItemlevel")
end

M:RegisterMiscModule(mod:GetName())
