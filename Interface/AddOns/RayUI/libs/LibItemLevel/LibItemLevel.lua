---------------------------------
-- 物品等級庫 Author: M
---------------------------------

local MAJOR, MINOR = "LibItemLevel-RayUI", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

--Cache global variables
--Lua functions
local _G = _G
local select, tonumber, string = select, tonumber, string
local max = math.max

--WoW API / Variables
local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local UnitExists = UnitExists

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UIParent

--物品等級匹配規則
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")

--Toolip
local tooltip = CreateFrame("GameTooltip", "LibItemLevelTooltip1", UIParent, "GameTooltipTemplate")
local unittip = CreateFrame("GameTooltip", "LibItemLevelTooltip2", UIParent, "GameTooltipTemplate")

--物品是否本地化
function lib:hasLocally(ItemID)
    if (not ItemID or ItemID == "" or ItemID == "0") then return true end
    return select(10, GetItemInfo(tonumber(ItemID)))
end

--物品是否本地化
function lib:itemLocally(ItemLink)
    local id, gem1, gem2, gem3 = string.match(ItemLink, "item:(%d+):[^:]*:(%d-):(%d-):(%d-):")
    return (self:hasLocally(id) and self:hasLocally(gem1) and self:hasLocally(gem2) and self:hasLocally(gem3))
end

--獲取物品實際等級信息
function lib:GetItemInfo(ItemLink)
    if (not ItemLink or ItemLink == "") then
        return 0, 0
    end
    if (not string.match(ItemLink, "item:%d+:")) then
        return -1, 0
    end
    if (not self:itemLocally(ItemLink)) then
        return 1, 0
    end
    local level, text
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetHyperlink(ItemLink)
    for i = 2, 5 do
        text = _G[tooltip:GetName().."TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
    end
    return 0, tonumber(level) or 0, GetItemInfo(ItemLink)
end

--獲取UNIT物品實際等級信息
function lib:GetUnitItemInfo(unit, index)
    if (not UnitExists(unit)) then return 1, 0 end
    unittip:SetOwner(UIParent, "ANCHOR_NONE")
    unittip:ClearLines()
    unittip:SetInventoryItem(unit, index)
    local ItemLink = select(2, unittip:GetItem())
    if (not ItemLink or ItemLink == "") then
        return 0, 0
    end
    if (not self:itemLocally(ItemLink)) then
        return 1, 0
    end
    local level, text
    for i = 2, 5 do
        text = _G[unittip:GetName().."TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
    end
    return 0, tonumber(level) or 0, GetItemInfo(ItemLink)
end

--獲取UNIT的裝備等級
function lib:GetUnitItemLevel(unit)
    local total, counts = 0, 0
    local _, count, level
    for i = 1, 15 do
        if (i ~= 4) then
            count, level = self:GetUnitItemInfo(unit, i)
            total = total + level
            counts = counts + count
        end
    end
    local mcount, mlevel, mquality, mslot, ocount, olevel, oquality, oslot
    mcount, mlevel, _, _, mquality, _, _, _, _, _, mslot = self:GetUnitItemInfo(unit, 16)
    ocount, olevel, _, _, oquality, _, _, _, _, _, oslot = self:GetUnitItemInfo(unit, 17)
    counts = counts + mcount + ocount
    --[神器]最高x2 [雙-雙 雙-X X-雙]最高x2
    if (mquality == 6 or oslot == "INVTYPE_2HWEAPON" or mslot == "INVTYPE_2HWEAPON" or mslot == "INVTYPE_RANGED" or mslot == "INVTYPE_RANGEDRIGHT") then
        total = total + max(mlevel, olevel) * 2
    else
        total = total + mlevel + olevel
    end
    return counts, total/(16-counts), total
end
