local R, L, P, G = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, GlobalDB
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
end)

local function addLine(self,id,isItem)
	for i = 1, self:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		if not line then break end
		local text = line:GetText()
		if text and (text:match("FFCA3C3C技能ID") or text:match("FFCA3C3C堆叠数") or text:match("FFCA3C3C已拥有") or text:match("FFCA3C3C物品ID")) then
			return
		end
	end
	self:AddLine(" ")
	if isItem then
		if select(8, GetItemInfo(id)) and select(8, GetItemInfo(id)) >1 then
			self:AddDoubleLine("|cFFCA3C3C堆叠数:|r","|cffffffff"..select(8, GetItemInfo(id)))
		end
		self:AddDoubleLine("|cFFCA3C3C物品ID:|r","|cffffffff"..id)
	else
		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
	end
	self:Show()
end

-- hooksecurefunc(GameTooltip, "SetUnitConsolidatedBuff", function(self, unit, index)
-- 	local name = GetRaidBuffTrayAuraInfo(index)
-- 	local _, _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, name)
-- 	if id then
-- 		self:AddLine(" ")
-- 		if caster then
-- 			self:AddLine(UnitName(caster))
-- 		end
-- 		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
-- 		self:Show()
-- 	end	
-- end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11, UnitAura(...))
	local caster = select (8, UnitAura(...))
	if id then
		self:AddLine(" ")
		if caster ~= nil then
			self:AddLine(UnitName(caster))
		end
		self:AddDoubleLine("|cFFCA3C3C技能ID:|r","|cffffffff"..id)
		self:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

-- Item Hooks -----------------------------------------------------------------
hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local itemId = tonumber(string.match(link, "item:(%d+):"))
	if (itemId == 0 and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible()) then
		local newItemId
		if ((GetMouseFocus():GetName()) == "TradeSkillSkillIcon") then
			newItemId = tonumber(GetTradeSkillItemLink(TradeSkillFrame.selectedSkill):match("item:(%d+):"))
		else
			for i = 1, 12 do
				if ((GetMouseFocus():GetName()) == "TradeSkillReagent"..i) then
					newItemId = tonumber(GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, i):match("item:(%d+):"))
					break
				end
			end
		end
		_, link = GetItemInfo(newItemId)
	end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d-):(%d-):(%d-):(%d-):(%d-):(%d-):(%-?%d-):(%-?%d-)"))
	if id then addLine(self,id,true) end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
