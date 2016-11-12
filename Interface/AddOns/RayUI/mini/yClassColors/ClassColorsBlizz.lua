--[[--------------------------------------------------------------------
	!ClassColors
	Change class colors without breaking the Blizzard UI.
	Copyright (c) 2009-2016 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	https://mods.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if ns.alreadyLoaded then
	return
end

local strfind, format, gsub, strmatch, strsub = string.find, string.format, string.gsub, string.match, string.sub
local pairs, type = pairs, type

------------------------------------------------------------------------

local addonFuncs = {}

local blizzHexColors = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

------------------------------------------------------------------------
-- ChatConfigFrame.xml

do
	local function ColorLegend(self)
		for i = 1, #self.classStrings do
			local class = CLASS_SORT_ORDER[i]
			local color = CUSTOM_CLASS_COLORS[class]
			self.classStrings[i]:SetFormattedText("|c%s%s|r\n", color.colorStr, LOCALIZED_CLASS_NAMES_MALE[class])
		end
	end
	ChatConfigChatSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
	ChatConfigChannelSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
end

------------------------------------------------------------------------
-- ChatFrame.lua

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = strsub(event, 10)
	if strsub(chatType, 1, 7) == "WHISPER" then
		chatType = "WHISPER"
	elseif strsub(chatType, 1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..arg8
	end
	local info = ChatTypeInfo[chatType]

	if chatType == "GUILD" then
		arg2 = Ambiguate(arg2, "guild")
	else
		arg2 = Ambiguate(arg2, "none")
	end

	if info and info.colorNameByClass and arg12 and arg12 ~= "" and arg12 ~= 0 then
		local _, class = GetPlayerInfoByGUID(arg12)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				return format("|c%s%s|r", color.colorStr, arg2)
			end
		end
	end

	return arg2
end

do
	-- Lines 3220+
	-- Fix class colors in raid roster listing
	local AddMessage = {}

	local function FixClassColors(frame, message, ...)
		if type(message) == "string" and strfind(message, "|cff") then -- type check required for shitty addons that pass nil or non-string values
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = color and gsub(message, hex, color.colorStr) or message -- color check required for Warmup, maybe others
			end
		end
		return AddMessage[frame](frame, message, ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		AddMessage[frame] = frame.AddMessage
		frame.AddMessage = FixClassColors
	end
end

------------------------------------------------------------------------
--	CompactUnitFrame.lua

do
	local UnitClass, UnitIsConnected, UnitIsPlayer = UnitClass, UnitIsConnected, UnitIsPlayer

	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		if UnitIsConnected(frame.unit) and UnitIsPlayer(frame.unit) and frame.optionTable.useClassColors then
			local _, class = UnitClass(frame.unit)
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
				if frame.optionTable.colorHealthWithExtendedColors then
					frame.selectionHighlight:SetStatusBarColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	FriendsFrame.lua

hooksecurefunc("WhoList_Update", function()
	local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	for i = 1, WHOS_TO_DISPLAY do
		local who = i + offset
		local _, _, _, _, _, _, class = GetWhoInfo(who)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["WhoFrameButton"..i.."Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

------------------------------------------------------------------------
--	LevelUpDisplay.lua

hooksecurefunc("BossBanner_ConfigureLootFrame", function(lootFrame, data)
    local color = CUSTOM_CLASS_COLORS[data.className]
    lootFrame.PlayerName:SetTextColor(color.r, color.g, color.b)
end)

------------------------------------------------------------------------
--	LFDFrame.lua

hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
	for i = 1, GetNumSubgroupMembers() do
		local _, class = UnitClass("party"..i)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local name, server = UnitName("party"..i) -- skip call to GetUnitName wrapper func
				if server and server ~= "" then
					_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s-%s|r", color.colorStr, name, server)
				else
					_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s|r", color.colorStr, name)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
-- LFGFrame.lua

hooksecurefunc("LFGCooldownCover_Update", function(self)
	local nextIndex, numPlayers, prefix = 1
	if IsInRaid() then
		numPlayers = GetNumGroupMembers()
		prefix = "raid"
	else
		numPlayers = GetNumSubgroupMembers()
		prefix = "party"
	end
	for i = 1, numPlayers do
		if nextIndex > #self.Names then
			break
		end
		local unit = prefix..i
		if self.showAll or (self.showCooldown and UnitHasLFGRandomCooldown(unit)) or UnitHasLFGDeserter(unit) then
			local _, class = UnitName(unit)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local name, server = UnitName(unit) -- skip call to GetUnitName wrapper func
					if server and server ~= "" then
						self.Names[nextIndex]:SetFormattedText("|c%s%s-%s|r", color.colorStr, name, server)
					else
						self.Names[nextIndex]:SetFormattedText("|c%s%s|r", color.colorStr, name)
					end
				end
			end
			nextIndex = nextIndex + 1
		end
	end
end)

------------------------------------------------------------------------
-- LFGList.lua

hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", function(member, appID, memberIdx, status, pendingStatus)
	if not pendingStatus and (status == "failed" or status == "cancelled" or status == "declined" or status == "invitedeclined" or status == "timedout") then
		-- grayedOut
		return
	end
	local _, class = C_LFGList.GetApplicantMemberInfo(appID, memberIdx)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			member.Name:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

hooksecurefunc("LFGListApplicantMember_OnEnter", function(self)
	local applicantID = self:GetParent().applicantID
	local memberIdx = self.memberIdx
	local _, class = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

local LFG_LIST_TOOLTIP_MEMBERS_SIMPLE = gsub(LFG_LIST_TOOLTIP_MEMBERS_SIMPLE, "%%d", "%%d+")

hooksecurefunc("LFGListSearchEntry_OnEnter", function(self)
	local resultID = self.resultID
	local _, activityID, _, _, _, _, _, _, _, _, _, _, numMembers = C_LFGList.GetSearchResultInfo(resultID)
	local _, _, _, _, _, _, _, _, displayType = C_LFGList.GetActivityInfo(activityID)
	if displayType ~= LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then return end
	local start
	for i = 4, GameTooltip:NumLines() do
		if strfind(_G["GameTooltipTextLeft"..i]:GetText(), LFG_LIST_TOOLTIP_MEMBERS_SIMPLE) then
			start = i
			break
		end
	end
	if start then
		for i = 1, numMembers do
			local _, class = C_LFGList.GetSearchResultMemberInfo(resultID, i)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					_G["GameTooltipTextLeft"..(start+i)]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFRFrame.lua

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(index)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			button.class:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------
--	LootFrame.lua

hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
	-- TODO: Find a better way of doing this... Blizzard's way is frankly quite awful,
	--       creating multiple new local tables every time the function runs. :(
	for k, playerFrame in pairs(MasterLooterFrame) do
		if type(k) == "string" and strmatch(k, "^player%d+$") and type(playerFrame) == "table" and playerFrame.id and playerFrame.Name then
			local i = playerFrame.id
			local _, class
			if IsInRaid() then
				_, class = UnitClass("raid"..i)
			elseif i > 1 then
				_, class = UnitClass("party"..i)
			else
				_, class = UnitClass("player")
			end
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					playerFrame.Name:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LootHistory.lua

hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, itemFrame)
	local itemID = itemFrame.itemIdx
	local rollID, _, _, done, winnerID = C_LootHistory.GetItem(itemID)
	local expanded = self.expandedRolls[rollID]
	if done and winnerID and not expanded then
		local _, class = C_LootHistory.GetPlayerInfo(itemID, winnerID)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				itemFrame.WinnerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(self, playerFrame)
	if playerFrame.playerIdx then
		local name, class = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)
		if name then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				playerFrame.PlayerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

function LootHistoryDropDown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo()
	info.text = MASTER_LOOTER
	info.fontObject = GameFontNormalLeft
	info.isTitle = 1
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
	local color = CUSTOM_CLASS_COLORS[class]

	info = UIDropDownMenu_CreateInfo()
	info.text = format(MASTER_LOOTER_GIVE_TO, format("|c%s%s|r", color.colorStr, name))
	info.func = LootHistoryDropDown_OnClick
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)
end

------------------------------------------------------------------------
--	PaperDollFrame.lua

hooksecurefunc("PaperDollFrame_SetLevel", function()
	local className, class = UnitClass("player")
	local color = CUSTOM_CLASS_COLORS[class].colorStr
	local spec, specName, _ = GetSpecialization()
	if spec then
		_, specName = GetSpecializationInfo(spec)
	end
	if specName and specName ~= "" then
		CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), color, specName, className)
	else
		CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), color, className)
	end
end)

------------------------------------------------------------------------
--	RaidFinder.lua

hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", function()
	local prefix, members
	if IsInRaid() then
		prefix, members = "raid", GetNumGroupMembers()
	else
		prefix, members = "party", GetNumSubgroupMembers()
	end

	local cooldowns = 0
	for i = 1, members do
		local unit = prefix .. i
		if UnitHasLFGDeserter(unit) and not UnitIsUnit(unit, "player") then
			cooldowns = cooldowns + 1
			if cooldowns <= MAX_RAID_FINDER_COOLDOWN_NAMES then
				local _, class = UnitClass(unit)
				if class then
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName(unit))
					end
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidWarning.lua

do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...)
		if strfind(message, "|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

------------------------------------------------------------------------
--	Blizzard_Calendar.lua

addonFuncs["Blizzard_Calendar"] = function()
	local _G = _G
	local CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame = CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame
	local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
	local CalendarEventGetNumInvites, CalendarEventGetInvite = CalendarEventGetNumInvites, CalendarEventGetInvite

	hooksecurefunc("CalendarViewEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("CalendarCreateEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_ChallengesUI.lua

addonFuncs["Blizzard_ChallengesUI"] = function()
	local function PostSetUp(self, leaderInfo)
		self.CharacterName:SetFormattedText(leaderInfo.isYou and CHALLENGE_MODE_GUILD_BEST_LINE_YOU or CHALLENGE_MODE_GUILD_BEST_LINE,
			CUSTOM_CLASS_COLORS[leaderInfo.class].colorStr,
			leaderInfo.name)
	end

	local function GuildChallengesGuildBestMixin_OnEnter(self)
		local leaderInfo = self.leaderInfo
		
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local name = C_ChallengeMode.GetMapInfo(leaderInfo.mapid)
		GameTooltip:SetText(name, 1, 1, 1)
		GameTooltip:AddLine(CHALLENGE_MODE_POWER_LEVEL:format(leaderInfo.level))
		for i = 1, #leaderInfo.members do
			local classColorStr = CUSTOM_CLASS_COLORS[leaderInfo.members[i].class].colorStr
			GameTooltip:AddLine(CHALLENGE_MODE_GUILD_BEST_LINE:format(classColorStr, leaderInfo.members[i].name))
		end
		GameTooltip:Show()
	end

	hooksecurefunc("ChallengesFrame_Update", function(self)
		if self.leadersAvailable then
			local leaders = C_ChallengeMode.GetGuildLeaders()
			if leaders and #leaders > 0 then
				for i = 1, #leaders do
					local frame = self.GuildBest.GuildBests[i]
					frame:SetScript("OnEnter", GuildChallengesGuildBestMixin_OnEnter)
					PostSetUp(frame, leaders[i])
				end
			end
		end
	end)

	hooksecurefunc(ChallengeModeCompleteBanner, "PlayBanner", function(self, data)
		local sortedUnitTokens = self:GetSortedPartyMembers()
		for i = 1, #sortedUnitTokens do
			local unitToken = sortedUnitTokens[i]
			local name = UnitName(unitToken)
			local _, classFileName = UnitClass(unitToken)
			local classColorStr = CUSTOM_CLASS_COLORS[classFileName].colorStr
			self.PartyMembers[i].Name:SetFormattedText("|c%s%s|r", classColorStr, name)
		end
	end)
end

------------------------------------------------------------------------
-- Blizzard_HeirloomCollection.lua

addonFuncs["Blizzard_Collections"] = function()
	local NO_CLASS_FILTER = 0
	local NO_SPEC_FILTER = 0

	function HeirloomsJournal:UpdateClassFilterDropDownText()
		local text;
		local classFilter, specFilter = C_Heirloom.GetClassAndSpecFilters()
		if classFilter == NO_CLASS_FILTER then
			text = ALL_CLASSES
		else
			local className, classTag = GetClassInfoByID(classFilter)
			local classColorStr = CUSTOM_CLASS_COLORS[classTag].colorStr
			if specFilter == NO_SPEC_FILTER then
				text = HEIRLOOMS_CLASS_FILTER_FORMAT:format(classColorStr, className)
			else
				local specName = GetSpecializationNameForSpecID(specFilter)
				text = HEIRLOOMS_CLASS_SPEC_FILTER_FORMAT:format(classColorStr, className, specName)
			end
		end
		UIDropDownMenu_SetText(self.classDropDown, text)
    end
end

------------------------------------------------------------------------
--	Blizzard_GuildRoster.lua

addonFuncs["Blizzard_GuildUI"] = function()
	hooksecurefunc("GuildRosterButton_SetStringText", function(buttonString, text, isOnline, class)
		if isOnline and class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				buttonString:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
--	InspectPaperDollFrame.lua

addonFuncs["Blizzard_InspectUI"] = function()
	local InspectFrame, InspectLevelText = InspectFrame, InspectLevelText
	local GetInspectSpecialization, GetSpecializationInfoByID, UnitClass, UnitLevel = GetInspectSpecialization, GetSpecializationInfoByID, UnitClass, UnitLevel

	hooksecurefunc("InspectPaperDollFrame_SetLevel", function()
		local unit = InspectFrame.unit
		if not unit then return end

		local className, class = UnitClass(unit)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local level = UnitLevel(unit)
				if level == -1 then
					level = "??"
				end
				local spec, specName = GetInspectSpecialization(unit)
				if spec then
					spec, specName = GetSpecializationInfoByID(spec)
				end
				if specName and specName ~= "" then
					InspectLevelText:SetFormattedText(PLAYER_LEVEL, level, color.colorStr, specName, className)
				else
					InspectLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, level, color.colorStr, className)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_RaidUI.lua

addonFuncs["Blizzard_RaidUI"] = function()
	local _G = _G
	local min = math.min
	local GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass = GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass
	local MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP = MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP

	hooksecurefunc("RaidGroupFrame_Update", function()
		local isRaid = IsInRaid()
		if not isRaid then return end
		for i = 1, min(GetNumGroupMembers(), MAX_RAID_MEMBERS) do
			local name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
			if class and online and not dead and _G["RaidGroup"..subgroup].nextIndex <= MEMBERS_PER_RAID_GROUP then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local button = _G["RaidGroupButton"..i]
					button.subframes.name:SetTextColor(color.r, color.g, color.b)
					button.subframes.class:SetTextColor(color.r, color.g, color.b)
					button.subframes.level:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("RaidGroupFrame_UpdateHealth", function(i)
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo(i)
		if class and online and not dead then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local r, g, b = color.r, color.g, color.b
				_G["RaidGroupButton"..i.."Name"]:SetTextColor(r, g, b)
				_G["RaidGroupButton"..i.."Class"]:SetTextColor(r, g, b)
				_G["RaidGroupButton"..i.."Level"]:SetTextColor(r, g, b)
			end
		end
	end)

	hooksecurefunc("RaidPullout_UpdateTarget", function(frame, button, unit, which)
		if UnitCanCooperate("player", unit) then
			if _G[frame]["show"..which] then
				local _, class = UnitClass(unit)
				if class then
					local color = class and CUSTOM_CLASS_COLORS[class]
					if color then
						_G[button..which.."Name"]:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end)

	local petowners = {}
	for i = 1, 40 do
		petowners["raidpet"..i] = "raid"..i
	end
	hooksecurefunc("RaidPulloutButton_UpdateDead", function(button, dead, class)
		if not dead then
			if class == "PETS" then
				local _
				_, class = UnitClass(petowners[button.unit])
			end
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					button.nameLabel:SetVertexColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_StoreUISecure.lua

-- RAID_CLASS_COLORS is referenced several times in here, but it is
-- forbidden to addons, so there's nothing we can do about it.

------------------------------------------------------------------------
--	Blizzard_TradeSkillUI.lua

addonFuncs["Blizzard_TradeSkillUI"] = function()
	hooksecurefunc(TradeSkillFrame.DetailsFrame.GuildFrame, "Refresh", function(self)
		if self.waitingOnData then return end

		local _, _, numMembers = GetGuildRecipeInfoPostQuery()
		local offset = FauxScrollFrame_GetOffset(self.Container.ScrollFrame)
		for i, craftersButton in ipairs(self.Container.ScrollFrame.buttons) do
			local dataIndex = offset + i
			if dataIndex > numMembers then
				break
			end

			local _, _, class, online = GetGuildRecipeMember(i + offset)
			if class and online then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					craftersButton.Text:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------

local numAddons = 0

for addon, func in pairs(addonFuncs) do
	if IsAddOnLoaded(addon) then
		addonFuncs[addon] = nil
		func()
	else
		numAddons = numAddons + 1
	end
end

if numAddons > 0 then
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		local func = addonFuncs[addon]
		if func then
			addonFuncs[addon] = nil
			numAddons = numAddons - 1
			func()
		end
		if numAddons == 0 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end
	end)
end
