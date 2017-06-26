----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("Skins")


local S = _Skins

local function LoadSkin()
	local r, g, b = _r, _g, _b
	S:SetBD(AuctionFrame, 2, -10, 0, 10)
	S:CreateBD(AuctionProgressFrame)
	S:ReskinCheck(ExactMatchCheckButton)

	AuctionProgressBar:SetStatusBarTexture(R["media"].normal)
	R:SetStatusBarGradient(AuctionProgressBar, true)
	local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
	ABBD:Point("TOPLEFT", -1, 1)
	ABBD:Point("BOTTOMRIGHT", 1, -1)
	ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
	S:CreateBD(ABBD, .25)

	S:ReskinClose(AuctionProgressFrameCancelButton, "LEFT", AuctionProgressBar, "RIGHT", 4, 0)
	select(14, AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	AuctionFrame:DisableDrawLayer("ARTWORK")
	AuctionPortraitTexture:Hide()
	for i = 1, 4 do
		select(i, AuctionProgressFrame:GetRegions()):Hide()
	end
    AuctionFrame:StripTextures(true)
	BrowseFilterScrollFrame:StripTextures()
	BrowseScrollFrame:StripTextures()
	AuctionsScrollFrame:StripTextures()
	BidScrollFrame:StripTextures()

    local sorttabs = {
		"BrowseQualitySort",
		"BrowseLevelSort",
		"BrowseDurationSort",
		"BrowseHighBidderSort",
		"BrowseCurrentBidSort",
		"BidQualitySort",
		"BidLevelSort",
		"BidDurationSort",
		"BidBuyoutSort",
		"BidStatusSort",
		"BidBidSort",
		"AuctionsQualitySort",
		"AuctionsDurationSort",
		"AuctionsHighBidderSort",
		"AuctionsBidSort",
	}
	for _, sorttab in pairs(sorttabs) do
		_G[sorttab.."Left"]:Kill()
		_G[sorttab.."Middle"]:Kill()
		_G[sorttab.."Right"]:Kill()
	end

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	for i = 1, 3 do
		S:CreateTab(_G["AuctionFrameTab"..i])
	end

	local abuttons = {
		"BrowseBidButton",
		"BrowseBuyoutButton",
		"BrowseCloseButton",
		"BrowseSearchButton",
		"BrowseResetButton",
		"BidBidButton",
		"BidBuyoutButton",
		"BidCloseButton",
		"AuctionsCloseButton",
		"AuctionsCancelAuctionButton",
		"AuctionsCreateAuctionButton",
		"AuctionsNumStacksMaxButton",
		"AuctionsStackSizeMaxButton"
	}
	for i = 1, #abuttons do
		local reskinbutton = _G[abuttons[i]]
		if reskinbutton then
			S:Reskin(reskinbutton)
            select(6, reskinbutton:GetRegions()):Kill()
		end
	end

	BrowseCloseButton:ClearAllPoints()
	BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)
	BrowsePrevPageButton:ClearAllPoints()
	BrowsePrevPageButton:Point("TOPLEFT", BrowseSearchButton, "BOTTOMLEFT", 0, -5)
	BrowseNextPageButton:ClearAllPoints()
	BrowseNextPageButton:Point("TOPRIGHT", BrowseResetButton, "BOTTOMRIGHT", 0, -5)

	-- Blizz needs to be more consistent

	BrowseBidPriceSilver:Point("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:Point("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:Point("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:Point("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:Point("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:Point("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:Point("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:Point("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		local bu = _G["BrowseButton"..i]
		local it = _G["BrowseButton"..i.."Item"]
		local ic = _G["BrowseButton"..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			S:CreateBG(it)

			it.IconBorder:Kill()
			_G["BrowseButton"..i.."Left"]:Hide()
			select(5, _G["BrowseButton"..i]:GetRegions()):Hide()
			_G["BrowseButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:Point("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			S:CreateBD(bd, .25)

			bu:SetHighlightTexture(R["media"].normal)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:Point("TOPLEFT", 0, -1)
			hl:Point("BOTTOMRIGHT", -1, 6)

			it:StyleButton(true)
		end
	end

	for i = 1, NUM_BIDS_TO_DISPLAY do
		local bu = _G["BidButton"..i]
		local it = _G["BidButton"..i.."Item"]
		local ic = _G["BidButton"..i.."ItemIconTexture"]

		it:SetNormalTexture("")
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBG(it)

		_G["BidButton"..i.."Left"]:Hide()
		select(6, _G["BidButton"..i]:GetRegions()):Hide()
		_G["BidButton"..i.."Right"]:Hide()

		local bd = CreateFrame("Frame", nil, bu)
		bd:SetPoint("TOPLEFT")
		bd:Point("BOTTOMRIGHT", 0, 5)
		bd:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bd, .25)

		bu:SetHighlightTexture(R["media"].normal)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl:ClearAllPoints()
		hl:Point("TOPLEFT", 0, -1)
		hl:Point("BOTTOMRIGHT", -1, 6)

		it:StyleButton(true)
	end

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		local bu = _G["AuctionsButton"..i]
		local it = _G["AuctionsButton"..i.."Item"]
		local ic = _G["AuctionsButton"..i.."ItemIconTexture"]

		it:SetNormalTexture("")
		ic:SetTexCoord(.08, .92, .08, .92)

		S:CreateBG(it)

		_G["AuctionsButton"..i.."Left"]:Hide()
		select(4, _G["AuctionsButton"..i]:GetRegions()):Hide()
		_G["AuctionsButton"..i.."Right"]:Hide()

		local bd = CreateFrame("Frame", nil, bu)
		bd:SetPoint("TOPLEFT")
		bd:Point("BOTTOMRIGHT", 0, 5)
		bd:SetFrameLevel(bu:GetFrameLevel()-1)
		S:CreateBD(bd, .25)

		bu:SetHighlightTexture(R["media"].normal)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl:ClearAllPoints()
		hl:Point("TOPLEFT", 0, -1)
		hl:Point("BOTTOMRIGHT", -1, 6)

		it:StyleButton(true)
	end

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local _, _, _, _, _, _, _, _, _, _, _, _, _, AuctionsItemButtonIconTexture = AuctionsItemButton:GetRegions() -- blizzard, please name your textures
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButtonIconTexture:Point("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:Point("BOTTOMRIGHT", -1, 1)
		end
	end)

	S:CreateBD(AuctionsItemButton, .25)
	local _, AuctionsItemButtonNameFrame = AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()

	S:ReskinClose(AuctionFrameCloseButton, "TOPRIGHT", AuctionFrame, "TOPRIGHT", -4, -14)
	S:ReskinScroll(BrowseScrollFrameScrollBar)
	S:ReskinScroll(AuctionsScrollFrameScrollBar)
	S:ReskinScroll(BrowseFilterScrollFrameScrollBar)
	S:ReskinDropDown(PriceDropDown)
	S:ReskinDropDown(DurationDropDown)
	S:ReskinInput(BrowseName)
	S:ReskinArrow(BrowsePrevPageButton, "left")
	S:ReskinArrow(BrowseNextPageButton, "right")
	S:ReskinCheck(IsUsableCheckButton)
	S:ReskinCheck(ShowOnPlayerCheckButton)

	BrowsePrevPageButton:GetRegions():SetPoint("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

	-- seriously, consistency
	BrowseDropDownLeft:SetAlpha(0)
	BrowseDropDownMiddle:SetAlpha(0)
	BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
	BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	BrowseDropDownButton:SetSize(16, 16)
	S:Reskin(BrowseDropDownButton)

	local downtex = BrowseDropDownButton:CreateTexture(nil, "OVERLAY")
	downtex:SetTexture("Interface\\AddOns\\RayUI\\media\\arrow-down-active")
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, BrowseDropDown)
	bg:SetPoint("TOPLEFT", 16, -5)
	bg:SetPoint("BOTTOMRIGHT", 109, 11)
	bg:SetFrameLevel(BrowseDropDown:GetFrameLevel(-1))
	S:CreateBD(bg, 0)
	S:CreateBackdropTexture(bg)

	local inputs = {
		"BrowseMinLevel",
		"BrowseMaxLevel",
		"BrowseBidPriceGold",
		"BrowseBidPriceSilver",
		"BrowseBidPriceCopper",
		"BidBidPriceGold",
		"BidBidPriceSilver",
		"BidBidPriceCopper",
		"StartPriceGold",
		"StartPriceSilver",
		"StartPriceCopper",
		"BuyoutPriceGold",
		"BuyoutPriceSilver",
		"BuyoutPriceCopper",
		"AuctionsStackSizeEntry",
		"AuctionsNumStacksEntry"
	}
	for i = 1, #inputs do
		S:ReskinInput(_G[inputs[i]])
	end

	BrowseMinLevel:SetPoint("TOPLEFT", BrowseLevelText, "BOTTOMLEFT", -7, -1)
	BrowseDropDown:SetPoint("TOPLEFT", BrowseLevelText, "BOTTOMRIGHT", 2, 4)
	BrowseNameText:ClearAllPoints()
	BrowseNameText:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 75, -44)

	-- [[ WoW token ]]

	local BrowseWowTokenResults = BrowseWowTokenResults

	S:Reskin(BrowseWowTokenResults.Buyout)

	-- Tutorial

	local WowTokenGameTimeTutorial = WowTokenGameTimeTutorial

	S:ReskinPortraitFrame(WowTokenGameTimeTutorial, true)
	S:Reskin(StoreButton)

	WowTokenGameTimeTutorial.LeftDisplay.Label:SetVertexColor(1, 1, 1)
	WowTokenGameTimeTutorial.RightDisplay.Label:SetVertexColor(1, 1, 1)

	-- Token

	do
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		Token.ItemBorder:Hide()
		iconBorder:SetTexture(R["media"].normal)
		iconBorder:SetDrawLayer("BACKGROUND")
		iconBorder:Point("TOPLEFT", icon, -1, 1)
		iconBorder:Point("BOTTOMRIGHT", icon, 1, -1)
		icon:SetTexCoord(.08, .92, .08, .92)
	end
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "Auction", LoadSkin)
