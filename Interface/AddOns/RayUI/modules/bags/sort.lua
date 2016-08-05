local R, L, P = unpack(RayUI) --Import: Engine, Locales, ProfileDB
local B = R:GetModule("Bags")

local bankBags = {BANK_CONTAINER}
for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
	table.insert(bankBags, i)
end

local playerBags = {}
for i = 0, NUM_BAG_SLOTS do
	table.insert(playerBags, i)
end

local allBags = {}
for _,i in ipairs(playerBags) do
	table.insert(allBags, i)
end
for _,i in ipairs(bankBags) do
	table.insert(allBags, i)
end

local coreGroups = {
	bank = bankBags,
	bags = playerBags,
	all = allBags,
}

local bagCache = {}
local bagIDs = {}
local bagPetIDs = {}
local bagStacks = {}
local bagMaxStacks = {}
local bagGroups = {}
local initialOrder = {}
local bagSorted, bagLocked = {}, {}
local bagRole
local moves = {}
local targetItems = {}
local sourceUsed = {}
local targetSlots = {}
local specialtyBags = {}
local emptySlots = {}

local movesUnderway, lastItemID, lockStop
local moveTracker = {}

local inventorySlots = {
	INVTYPE_AMMO = 0,
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_BODY = 4,
	INVTYPE_CHEST = 5,
	INVTYPE_ROBE = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = 11,
	INVTYPE_TRINKET = 12,
	INVTYPE_CLOAK = 13,
	INVTYPE_WEAPON = 14,
	INVTYPE_SHIELD = 15,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPONMAINHAND = 18,
	INVTYPE_WEAPONOFFHAND = 19,
	INVTYPE_HOLDABLE = 20,
	INVTYPE_RANGED = 21,
	INVTYPE_THROWN = 22,
	INVTYPE_RANGEDRIGHT = 23,
	INVTYPE_RELIC = 24,
	INVTYPE_TABARD = 25,
}

local safe = {
	[BANK_CONTAINER] = true,
	[0] = true
}

local frame = CreateFrame("Frame")
local t, WAIT_TIME = 0, 0.05
frame:SetScript("OnUpdate", function(self, elapsed)
	t = t + (elapsed or 0.01)
	if t > WAIT_TIME then
		t = 0
		B:DoMoves()
	end
end)
frame:Hide()
B.SortUpdateTimer = frame

local function UpdateLocation(from, to)
	if (bagIDs[from] == bagIDs[to]) and (bagStacks[to] < bagMaxStacks[to]) then
		local stackSize = bagMaxStacks[to]
		if (bagStacks[to] + bagStacks[from]) > stackSize then
			bagStacks[from] = bagStacks[from] - (stackSize - bagStacks[to])
			bagStacks[to] = stackSize
		else
			bagStacks[to] = bagStacks[to] + bagStacks[from]
			bagStacks[from] = nil
			bagIDs[from] = nil
			bagMaxStacks[from] = nil
		end
	else
		bagIDs[from], bagIDs[to] = bagIDs[to], bagIDs[from]
		bagStacks[from], bagStacks[to] = bagStacks[to], bagStacks[from]
		bagMaxStacks[from], bagMaxStacks[to] = bagMaxStacks[to], bagMaxStacks[from]
	end
end

local function PrimarySort(a, b)
	local aName, _, _, aLvl, _, _, _, _, _, _, aPrice = GetItemInfo(bagIDs[a])
	local bName, _, _, bLvl, _, _, _, _, _, _, bPrice = GetItemInfo(bagIDs[b])
	
	if aLvl ~= bLvl then
		return aLvl > bLvl
	end
	if aPrice ~= bPrice then
		return aPrice > bPrice
	end
	return aName < bName
end

local function DefaultSort(a, b)
	local aID = bagIDs[a]
	local bID = bagIDs[b]

	if (not aID) or (not bID) then return aID end

	if bagPetIDs[a] and bagPetIDs[b] then
		local aName, _, aType = C_PetJournal.GetPetInfoBySpeciesID(aID);
		local bName, _, bType = C_PetJournal.GetPetInfoBySpeciesID(bID);

		if aType and bType and aType ~= bType then
			return aType > bType
		end

		if aName and bName and aName ~= bName then
			return aName < bName
		end
	end


	local aOrder, bOrder = initialOrder[a], initialOrder[b]

	if aID == bID then
		local aCount = bagStacks[a]
		local bCount = bagStacks[b]
		if aCount and bCount and aCount == bCount then
			return aOrder < bOrder
		elseif aCount and bCount then
			return aCount < bCount
		end
	end

	local _, _, aRarity, _, _, _, _, _, aEquipLoc, _, _, aItemClassId, aItemSubClassId = GetItemInfo(aID)
	local _, _, bRarity, _, _, _, _, _, bEquipLoc, _, _, bItemClassId, bItemSubClassId = GetItemInfo(bID)

	if bagPetIDs[a] then
		aRarity = 1
	end

	if bagPetIDs[b] then
		bRarity = 1
	end

	if aRarity ~= bRarity and aRarity and bRarity then
		return aRarity > bRarity
	end

	if aItemClassId ~= bItemClassId then
		return (aItemClassId or 99) < (bItemClassId or 99)
	end

	if aItemClassId == LE_ITEM_CLASS_ARMOR or aItemClassId == LE_ITEM_CLASS_WEAPON then
		local aEquipLoc = inventorySlots[aEquipLoc] or -1
		local bEquipLoc = inventorySlots[bEquipLoc] or -1
		if aEquipLoc == bEquipLoc then
			return PrimarySort(a, b)
		end

		if aEquipLoc and bEquipLoc then
			return aEquipLoc < bEquipLoc
		end
	end
	if (aItemClassId == bItemClassId) and (aItemSubClassId == bItemSubClassId) then
		return PrimarySort(a, b)
	end

	return (aItemSubClassId or 99) < (bItemSubClassId or 99)
end

local function ReverseSort(a, b)
	return DefaultSort(b, a)
end

local function UpdateSorted(source, destination)
	for i, bs in pairs(bagSorted) do
		if bs == source then
			bagSorted[i] = destination
		elseif bs == destination then
			bagSorted[i] = source
		end
	end
end

local function ShouldMove(source, destination)
	if destination == source then return end

	if not bagIDs[source] then return end
	if bagIDs[source] == bagIDs[destination] and bagStacks[source] == bagStacks[destination] then return end

	return true
end

local function IterateForwards(bagList, i)
	i = i + 1
	local step = 1
	for _,bag in ipairs(bagList) do
		local slots = GetContainerNumSlots(bag)
		if i > slots + step then
			step = step + slots
		else
			for slot = 1, slots do
				if step == i then
					return i, bag, slot
				end
				step = step + 1
			end
		end
	end
	bagRole = nil
end

local function IterateBackwards(bagList, i)
	i = i + 1
	local step = 1
	for ii = #bagList, 1, -1 do
		local bag = bagList[ii]
		local slots = GetContainerNumSlots(bag)
		if i > slots + step then
			step = step + slots
		else
			for slot=slots, 1, -1 do
				if step == i then
					return i, bag, slot
				end
				step = step + 1
			end
		end
	end
	bagRole = nil
end

function B.IterateBags(bagList, reverse, role)
	bagRole = role
	return (reverse and IterateBackwards or IterateForwards), bagList, 0
end

local function ConvertLinkToID(link) 
	if not link then return; end
	
	if tonumber(string.match(link, "item:(%d+)")) then
		return tonumber(string.match(link, "item:(%d+)"))
	else
		return tonumber(string.match(link, "battlepet:(%d+)")), true
	end
end 

local function DefaultCanMove()
	return true
end

function B:Encode_BagSlot(bag, slot) 
	return (bag*100) + slot 
end

function B:Decode_BagSlot(int) 
	return math.floor(int/100), int % 100 
end

function B:IsPartial(bag, slot)
	local bagSlot = B:Encode_BagSlot(bag, slot)
	return ((bagMaxStacks[bagSlot] or 0) - (bagStacks[bagSlot] or 0)) > 0
end

function B:EncodeMove(source, target)
	return (source * 10000) + target
end

function B:DecodeMove(move)
	local s = math.floor(move/10000)
	local t = move%10000
	s = (t>9000) and (s+1) or s
	t = (t>9000) and (t-10000) or t
	return s, t
end

function B:AddMove(source, destination)
	UpdateLocation(source, destination)
	table.insert(moves, 1, B:EncodeMove(source, destination))
end

function B:ScanBags()
	for _, bag, slot in B.IterateBags(allBags) do
		local bagSlot = B:Encode_BagSlot(bag, slot)
		local itemID, isBattlePet = ConvertLinkToID(GetContainerItemLink(bag, slot))
		if itemID then
			if isBattlePet then
				bagPetIDs[bagSlot] = itemID
				bagMaxStacks[bagSlot] = 1
			else
				bagMaxStacks[bagSlot] = select(8, GetItemInfo(itemID))
			end
			
			bagIDs[bagSlot] = itemID
			bagStacks[bagSlot] = select(2, GetContainerItemInfo(bag, slot))
		end
	end
end

function B:IsSpecialtyBag(bagID)
	if safe[bagID] then return false end
	
	local inventorySlot = ContainerIDToInventoryID(bagID)
	if not inventorySlot then return false end
	
	local bag = GetInventoryItemLink("player", inventorySlot)
	if not bag then return false end
	
	local family = GetItemFamily(bag)
	if family == 0 then return false end
	
	return family
end

function B:CanItemGoInBag(bag, slot, targetBag)
	local item = bagIDs[B:Encode_BagSlot(bag, slot)]
	local itemFamily = GetItemFamily(item)
	if itemFamily > 0 then
		local equipSlot = select(9, GetItemInfo(item))
		if equipSlot == "INVTYPE_BAG" then
			itemFamily = 1
		end
	end
	local bagFamily = select(2, GetContainerNumFreeSlots(targetBag))
	return bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0
end

function B.Compress(...)
	for i=1, select("#", ...) do
		local bags = select(i, ...)
		B.Stack(bags, bags, B.IsPartial)
	end
end

function B.Stack(sourceBags, targetBags, canMove)
	if not canMove then canMove = DefaultCanMove end
	for _, bag, slot in B.IterateBags(targetBags, nil, "deposit") do
		local bagSlot = B:Encode_BagSlot(bag, slot)
		local itemID = bagIDs[bagSlot]
		if itemID and (bagStacks[bagSlot] ~= bagMaxStacks[bagSlot]) then
			targetItems[itemID] = (targetItems[itemID] or 0) + 1
			table.insert(targetSlots, bagSlot)
		end
	end

	for _, bag, slot in B.IterateBags(sourceBags, true, "withdraw") do
		local sourceSlot = B:Encode_BagSlot(bag, slot)
		local itemID = bagIDs[sourceSlot]
		if itemID and targetItems[itemID] and canMove(itemID, bag, slot) then
			for i = #targetSlots, 1, -1 do
				local targetedSlot = targetSlots[i]
				if bagIDs[sourceSlot] and bagIDs[targetedSlot] == itemID and targetedSlot ~= sourceSlot and not (bagStacks[targetedSlot] == bagMaxStacks[targetedSlot]) and not sourceUsed[targetedSlot] then
					B:AddMove(sourceSlot, targetedSlot)
					sourceUsed[sourceSlot] = true
					
					if bagStacks[targetedSlot] == bagMaxStacks[targetedSlot] then
						targetItems[itemID] = (targetItems[itemID] > 1) and (targetItems[itemID] - 1) or nil
					end
					if bagStacks[sourceSlot] == 0 then
						targetItems[itemID] = (targetItems[itemID] > 1) and (targetItems[itemID] - 1) or nil
						break
					end
					if not targetItems[itemID] then break end
				end
			end
		end
	end

	wipe(targetItems)
	wipe(targetSlots)
	wipe(sourceUsed)
end

function B.Sort(bags, sorter, invertDirection)
	if not sorter then sorter = invertDirection and ReverseSort or DefaultSort end

	for i, bag, slot in B.IterateBags(bags, nil, "both") do
		local bagSlot = B:Encode_BagSlot(bag, slot)
		initialOrder[bagSlot] = i
		table.insert(bagSorted, bagSlot)
	end	
	
	table.sort(bagSorted, sorter)

	local passNeeded = true
	while passNeeded do
		passNeeded = false
		local i = 1
		for _, bag, slot in B.IterateBags(bags, nil, "both") do
			local destination = B:Encode_BagSlot(bag, slot)
			local source = bagSorted[i]

			if ShouldMove(source, destination) then
				if not (bagLocked[source] or bagLocked[destination]) then
					B:AddMove(source, destination)
					UpdateSorted(source, destination)
					bagLocked[source] = true
					bagLocked[destination] = true
				else
					passNeeded = true
				end
			end
			i = i + 1
		end
		wipe(bagLocked)
	end

	wipe(bagSorted)
	wipe(initialOrder)	
end

function B.FillBags(from, to)
	B.Stack(from, to)
	for _, bag in ipairs(to) do
		if B:IsSpecialtyBag(bag) then
			table.insert(specialtyBags, bag)
		end
	end
	if #specialtyBags > 0 then
		B:Fill(from, specialtyBags)
	end

	B.Fill(from, to)
	wipe(specialtyBags)	
end

function B.Fill(sourceBags, targetBags, reverse, canMove)
	if not canMove then canMove = DefaultCanMove end

	for _, bag, slot in B.IterateBags(targetBags, reverse, "deposit") do
		local bagSlot = B:Encode_BagSlot(bag, slot)
		if not bagIDs[bagSlot] then
			table.insert(emptySlots, bagSlot)
		end
	end

	for _, bag, slot in B.IterateBags(sourceBags, not reverse, "withdraw") do
		if #emptySlots == 0 then break end
		local bagSlot = B:Encode_BagSlot(bag, slot)
		local targetBag, targetSlot = B:Decode_BagSlot(emptySlots[1])
		if bagIDs[bagSlot] and B:CanItemGoInBag(bag, slot, targetBag) and canMove(bagIDs[bagSlot], bag, slot) then
			B:AddMove(bagSlot, table.remove(emptySlots, 1))
		end
	end
	wipe(emptySlots)
end

function B.SortBags(...)
	for i=1, select("#", ...) do
		local bags = select(i, ...)
		for _, slotNum in ipairs(bags) do
			local bagType = B:IsSpecialtyBag(slotNum)
			if bagType == false then bagType = "Normal" end
			if not bagCache[bagType] then bagCache[bagType] = {} end
			table.insert(bagCache[bagType], slotNum)
		end	

		for bagType, sortedBags in pairs(bagCache) do
			if bagType ~= "Normal" then
				B.Stack(sortedBags, sortedBags, B.IsPartial)
				B.Stack(bagCache["Normal"], sortedBags)
				B.Fill(bagCache["Normal"], sortedBags, B.db.sortInverted)
				B.Sort(sortedBags, nil, B.db.sortInverted)
				wipe(sortedBags)
			end
		end
		
		if bagCache["Normal"] then
			B.Stack(bagCache["Normal"], bagCache["Normal"], B.IsPartial)
			B.Sort(bagCache["Normal"], nil, B.db.sortInverted)
			wipe(bagCache["Normal"])
		end
		wipe(bagCache)
		wipe(bagGroups)
	end
end

function B:StartStacking()
	wipe(bagMaxStacks)
	wipe(bagStacks)
	wipe(bagIDs)
	wipe(moveTracker)

	if #moves > 0 then
		self.SortUpdateTimer:Show()
	else
		B:StopStacking()
	end
end

function B:StopStacking(message)
	wipe(moves)
	wipe(moveTracker)
	lastItemID, lockStop = nil, nil
	self.SortUpdateTimer:Hide()
	if message then
		R:Print(message)
	end
end

function B:DoMove(move)
	if CursorHasItem() then
		return false, "cursorhasitem"
	end
	
	local source, target = B:DecodeMove(move)
	local sourceBag, sourceSlot = B:Decode_BagSlot(source)
	local targetBag, targetSlot = B:Decode_BagSlot(target)
	local _, sourceCount, sourceLocked = GetContainerItemInfo(sourceBag, sourceSlot)
	local _, targetCount, targetLocked = GetContainerItemInfo(targetBag, targetSlot)
	
	if sourceLocked or targetLocked then
		return false, "source/target_locked"
	end

	local sourceLink = GetContainerItemLink(sourceBag, sourceSlot)
	local sourceItemID = ConvertLinkToID(sourceLink)
	local targetItemID = ConvertLinkToID(GetContainerItemLink(targetBag, targetSlot))
	if not sourceItemID then
		if moveTracker[source] then
			return false, "move incomplete"
		else
			return B:StopStacking(L["出了点问题, 请重试!"])
		end
	end
	
	local stackSize = select(8, GetItemInfo(sourceItemID))	
	if (sourceItemID == targetItemID) and (targetCount ~= stackSize) and ((targetCount + sourceCount) > stackSize) then
		SplitContainerItem(sourceBag, sourceSlot, stackSize - targetCount)
	else
		PickupContainerItem(sourceBag, sourceSlot)
	end
	
	if CursorHasItem() then
		PickupContainerItem(targetBag, targetSlot)
	end	

	return true, sourceItemID, source, targetItemID, target
end

function B:DoMoves()
	if InCombatLockdown() then
		return B:StopStacking(L["出了点问题, 请重试!"])
	end
	
	if CursorHasItem() then
		local itemID = ConvertLinkToID(select(3, GetCursorInfo()))
		if lastItemID ~= itemID then
			return B:StopStacking(L["出了点问题, 请重试!"])
		end
	end
	
	if lockStop then
		for slot, itemID in pairs(moveTracker) do
			if ConvertLinkToID(GetContainerItemLink(B:Decode_BagSlot(slot))) ~= itemID then
				WAIT_TIME = 0.1
				return --give processing time to happen
			end
			moveTracker[slot] = nil
		end
	end
	
	lastItemID, lockStop = nil, nil
	wipe(moveTracker)

	local start, success, moveID, targetID, moveSource, moveTarget
	start = GetTime()
	if #moves > 0 then 
		for i = #moves, 1, -1 do
			success, moveID, moveSource, targetID, moveTarget = B:DoMove(moves[i])
			if not success then
				WAIT_TIME = 0.1
				lockStop = true
				return
			end
			moveTracker[moveSource] = targetID
			moveTracker[moveTarget] = moveID
			lastItemID = moveID
			table.remove(moves, i)
			if moves[i-1] then
				if (GetTime() - start) > 0.5 then
					WAIT_TIME  = 0
					return
				end
			end
		end 
	end
	B:StopStacking()
end

function B:GetGroup(id)
	if string.match(id, "^[-%d,]+$") then
		local bags = {}
		for b in string.gmatch(id, "-?%d+") do
			table.insert(bags, tonumber(b))
		end
		return bags
	end
	return coreGroups[id]
end

function B:CommandDecorator(func, groupsDefaults)
	local bagGroups = {}
	return function(groups)
		if self.SortUpdateTimer:IsShown() then
			R:Print(L["已在运行!"])
			B:StopStacking()
			return
		end

		wipe(bagGroups)
		if not groups or #groups == 0 then
			groups = groupsDefaults
		end
		for bags in (groups or ""):gmatch("[^%s]+") do
			bags = B:GetGroup(bags)
			if bags then
				table.insert(bagGroups, bags)
			end
		end

		B:ScanBags()
		if func(unpack(bagGroups)) == false then
			return
		end
		wipe(bagGroups)
		B:StartStacking()
	end
end