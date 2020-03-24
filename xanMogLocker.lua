local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent)
end
addon = _G[ADDON_NAME]

local debugf = tekDebug and tekDebug:GetFrame(ADDON_NAME)
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
LibStub("AceEvent-3.0"):Embed(addon)

local IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

local transMogSlots = {
	"HeadSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
}

local localizedSlots = {
	INVTYPE_HEAD = "HeadSlot",
	INVTYPE_SHOULDER = "ShoulderSlot",
	INVTYPE_CLOAK = "BackSlot",
	INVTYPE_CHEST = "ChestSlot",
	INVTYPE_ROBE = "ChestSlot",
	INVTYPE_BODY = "ShirtSlot",
	INVTYPE_TABARD = "TabardSlot",
	INVTYPE_WRIST = "WristSlot",
	INVTYPE_HAND = "HandsSlot",
	INVTYPE_WAIST = "WaistSlot",
	INVTYPE_LEGS = "LegsSlot",
	INVTYPE_FEET = "FeetSlot",
	INVTYPE_2HWEAPON = "MainHandSlot",
	INVTYPE_WEAPON = "MainHandSlot",
	INVTYPE_WEAPONMAINHAND = "MainHandSlot",
	INVTYPE_WEAPONOFFHAND = "SecondaryHandSlot",
	INVTYPE_RANGED = "MainHandSlot",
	INVTYPE_RANGEDRIGHT = "MainHandSlot",
	INVTYPE_SHIELD = "SecondaryHandSlot",
	INVTYPE_HOLDABLE = "SecondaryHandSlot",
}

local localizedTransMogSlots = {
	[INVSLOT_HEAD] = "HeadSlot",
	[INVSLOT_SHOULDER] = "ShoulderSlot",
	[INVSLOT_BACK] = "BackSlot",
	[INVSLOT_CHEST] = "ChestSlot",
	[INVSLOT_BODY] = "ShirtSlot",
	[INVSLOT_TABARD] = "TabardSlot",
	[INVSLOT_WRIST] = "WristSlot",
	[INVSLOT_HAND] = "HandsSlot",
	[INVSLOT_WAIST] = "WaistSlot",
	[INVSLOT_LEGS] = "LegsSlot",
	[INVSLOT_FEET] = "FeetSlot",
	[INVSLOT_MAINHAND] = "MainHandSlot",
	[INVSLOT_OFFHAND] = "SecondaryHandSlot",
}

local slotToLocalized = {
	["HeadSlot"] = INVTYPE_HEAD,
	["ShoulderSlot"] = INVTYPE_SHOULDER,
	["BackSlot"] = INVTYPE_CLOAK,
	["ChestSlot"] = INVTYPE_CHEST,
	["ShirtSlot"] = INVTYPE_BODY,
	["TabardSlot"] = INVTYPE_TABARD,
	["WristSlot"] = INVTYPE_WRIST,
	["HandsSlot"] = INVTYPE_HAND,
	["WaistSlot"] = INVTYPE_WAIST,
	["LegsSlot"] = INVTYPE_LEGS,
	["FeetSlot"] = INVTYPE_FEET,
	["MainHandSlot"] = INVTYPE_WEAPONMAINHAND,
	["SecondaryHandSlot"] = INVTYPE_WEAPONOFFHAND,
}

local RaceIDs = {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Scourge = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Goblin = 9,
    BloodElf = 10,
    Draenei = 11,
    Worgen = 22,
    Pandaren = 24,
}

--update this from here Blizzard_Wardrobe.lua
local SET_MODEL_PAN_AND_ZOOM_LIMITS = {
	["Draenei2"] = { maxZoom = 2.2105259895325, panMaxLeft = -0.56983226537705, panMaxRight = 0.82581323385239, panMaxTop = -0.17342753708363, panMaxBottom = -2.6428601741791 },
	["Draenei3"] = { maxZoom = 3.0592098236084, panMaxLeft = -0.33429977297783, panMaxRight = 0.29183092713356, panMaxTop = -0.079871296882629, panMaxBottom = -2.4141833782196 },
	["Worgen2"] = { maxZoom = 1.9605259895325, panMaxLeft = -0.64045578241348, panMaxRight = 0.59410041570663, panMaxTop = -0.11050206422806, panMaxBottom = -2.2492413520813 },
	["Worgen3"] = { maxZoom = 2.9013152122498, panMaxLeft = -0.2526838183403, panMaxRight = 0.38198262453079, panMaxTop = -0.10407017171383, panMaxBottom = -2.4137926101685 },
	["Worgen3Alt"] = { maxZoom = 3.3618412017822, panMaxLeft = -0.19753229618072, panMaxRight = 0.26802557706833, panMaxTop = -0.073476828634739, panMaxBottom = -1.9255120754242 },
	["Worgen2Alt"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.33268970251083, panMaxRight = 0.36896070837975, panMaxTop = -0.14780110120773, panMaxBottom = -2.1662468910217 },
	["Scourge2"] = { maxZoom = 3.1710526943207, panMaxLeft = -0.3243542611599, panMaxRight = 0.5625838637352, panMaxTop = -0.054175414144993, panMaxBottom = -1.7261047363281 },
	["Scourge3"] = { maxZoom = 2.7105259895325, panMaxLeft = -0.35650563240051, panMaxRight = 0.41562974452972, panMaxTop = -0.07072202116251, panMaxBottom = -1.877711892128 },
	["Orc2"] = { maxZoom = 2.5526309013367, panMaxLeft = -0.64236557483673, panMaxRight = 0.77098786830902, panMaxTop = -0.075792260468006, panMaxBottom = -2.0818419456482 },
	["Orc3"] = { maxZoom = 3.2960524559021, panMaxLeft = -0.22763830423355, panMaxRight = 0.32022559642792, panMaxTop = -0.038521766662598, panMaxBottom = -2.0473554134369 },
	["Gnome3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.29900181293488, panMaxRight = 0.35779395699501, panMaxTop = -0.076380833983421, panMaxBottom = -0.99909907579422 },
	["Gnome2"] = { maxZoom = 2.8552639484406, panMaxLeft = -0.2777853012085, panMaxRight = 0.29651582241058, panMaxTop = -0.095201380550861, panMaxBottom = -1.0263166427612 },
	["Dwarf2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.50352156162262, panMaxRight = 0.4159924685955, panMaxTop = -0.07211934030056, panMaxBottom = -1.4946432113648 },
	["Dwarf3"] = { maxZoom = 2.8947370052338, panMaxLeft = -0.37057432532311, panMaxRight = 0.43383255600929, panMaxTop = -0.084960877895355, panMaxBottom = -1.7173190116882 },
	["BloodElf3"] = { maxZoom = 3.1644730567932, panMaxLeft = -0.2654082775116, panMaxRight = 0.28886350989342, panMaxTop = -0.049619361758232, panMaxBottom = -1.9943760633469 },
	["BloodElf2"] = { maxZoom = 3.1710524559021, panMaxLeft = -0.25901651382446, panMaxRight = 0.45525884628296, panMaxTop = -0.085230752825737, panMaxBottom = -2.0548067092895 },
	["Troll2"] = { maxZoom = 2.2697355747223, panMaxLeft = -0.58214980363846, panMaxRight = 0.5104039311409, panMaxTop = -0.05494449660182, panMaxBottom = -2.3443803787231 },
	["Troll3"] = { maxZoom = 3.1249995231628, panMaxLeft = -0.35141581296921, panMaxRight = 0.50875341892242, panMaxTop = -0.063820324838161, panMaxBottom = -2.4224486351013 },
	["Tauren2"] = { maxZoom = 2.1118416786194, panMaxLeft = -0.82946360111237, panMaxRight = 0.83975899219513, panMaxTop = -0.061676319688559, panMaxBottom = -2.035267829895 },
	["Tauren3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.37433895468712, panMaxRight = 0.40420442819595, panMaxTop = -0.1868137717247, panMaxBottom = -2.2116675376892 },
	["NightElf3"] = { maxZoom = 2.9539475440979, panMaxLeft = -0.27334463596344, panMaxRight = 0.27148312330246, panMaxTop = -0.094710879027844, panMaxBottom = -2.3087983131409 },
	["NightElf2"] = { maxZoom = 2.9144732952118, panMaxLeft = -0.45042458176613, panMaxRight = 0.47114592790604, panMaxTop = -0.10513981431723, panMaxBottom = -2.4612309932709 },
	["Human3"] = { maxZoom = 3.3618412017822, panMaxLeft = -0.19753229618072, panMaxRight = 0.26802557706833, panMaxTop = -0.073476828634739, panMaxBottom = -1.9255120754242 },
	["Human2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.33268970251083, panMaxRight = 0.36896070837975, panMaxTop = -0.14780110120773, panMaxBottom = -2.1662468910217 },
	["Pandaren3"] = { maxZoom = 2.5921046733856, panMaxLeft = -0.45187762379646, panMaxRight = 0.54132586717606, panMaxTop = -0.11439494043589, panMaxBottom = -2.2257535457611 },
	["Pandaren2"] = { maxZoom = 2.9342107772827, panMaxLeft = -0.36421552300453, panMaxRight = 0.50203305482864, panMaxTop = -0.11241528391838, panMaxBottom = -2.3707413673401 },
	["Goblin2"] = { maxZoom = 2.4605259895325, panMaxLeft = -0.31328883767128, panMaxRight = 0.39014467597008, panMaxTop = -0.089733943343162, panMaxBottom = -1.3402827978134 },
	["Goblin3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.26144406199455, panMaxRight = 0.30945864319801, panMaxTop = -0.07625275105238, panMaxBottom = -1.2928194999695 },
	["LightforgedDraenei2"] = { maxZoom = 2.2105259895325, panMaxLeft = -0.56983226537705, panMaxRight = 0.82581323385239, panMaxTop = -0.17342753708363, panMaxBottom = -2.6428601741791 },
	["LightforgedDraenei3"] = { maxZoom = 3.0592098236084, panMaxLeft = -0.33429977297783, panMaxRight = 0.29183092713356, panMaxTop = -0.079871296882629, panMaxBottom = -2.4141833782196 },
	["HighmountainTauren2"] = { maxZoom = 2.1118416786194, panMaxLeft = -0.82946360111237, panMaxRight = 0.83975899219513, panMaxTop = -0.061676319688559, panMaxBottom = -2.035267829895 },
	["HighmountainTauren3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.37433895468712, panMaxRight = 0.40420442819595, panMaxTop = -0.1868137717247, panMaxBottom = -2.2116675376892 },
	["Nightborne3"] = { maxZoom = 2.9539475440979, panMaxLeft = -0.27334463596344, panMaxRight = 0.27148312330246, panMaxTop = -0.094710879027844, panMaxBottom = -2.3087983131409 },
	["Nightborne2"] = { maxZoom = 2.9144732952118, panMaxLeft = -0.45042458176613, panMaxRight = 0.47114592790604, panMaxTop = -0.10513981431723, panMaxBottom = -2.4612309932709 },
	["VoidElf3"] = { maxZoom = 3.1644730567932, panMaxLeft = -0.2654082775116, panMaxRight = 0.28886350989342, panMaxTop = -0.049619361758232, panMaxBottom = -1.9943760633469 },
	["VoidElf2"] = { maxZoom = 3.1710524559021, panMaxLeft = -0.25901651382446, panMaxRight = 0.45525884628296, panMaxTop = -0.085230752825737, panMaxBottom = -2.0548067092895 },
	["MagharOrc2"] = { maxZoom = 2.5526309013367, panMaxLeft = -0.64236557483673, panMaxRight = 0.77098786830902, panMaxTop = -0.075792260468006, panMaxBottom = -2.0818419456482 },
	["MagharOrc3"] = { maxZoom = 3.2960524559021, panMaxLeft = -0.22763830423355, panMaxRight = 0.32022559642792, panMaxTop = -0.038521766662598, panMaxBottom = -2.0473554134369 },
	["DarkIronDwarf2"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.50352156162262, panMaxRight = 0.4159924685955, panMaxTop = -0.07211934030056, panMaxBottom = -1.4946432113648 },
	["DarkIronDwarf3"] = { maxZoom = 2.8947370052338, panMaxLeft = -0.37057432532311, panMaxRight = 0.43383255600929, panMaxTop = -0.084960877895355, panMaxBottom = -1.7173190116882 },
	["KulTiran2"] = { maxZoom =  1.71052598953247, panMaxLeft = -0.667941331863403, panMaxRight = 0.589463412761688, panMaxTop = -0.373320609331131, panMaxBottom = -2.7329957485199 },
	["KulTiran3"] = { maxZoom =  2.22368383407593, panMaxLeft = -0.43183308839798, panMaxRight = 0.445900857448578, panMaxTop = -0.303212702274323, panMaxBottom = -2.49550628662109 },
	["ZandalariTroll2"] = { maxZoom =  2.1710512638092, panMaxLeft = -0.487841755151749, panMaxRight = 0.561356604099274, panMaxTop = -0.385127544403076, panMaxBottom = -2.78562784194946 },
	["ZandalariTroll3"] = { maxZoom =  3.32894563674927, panMaxLeft = -0.376705944538116, panMaxRight = 0.488780438899994, panMaxTop = -0.20890490710735, panMaxBottom = -2.67064166069031 },
	["Mechagnome3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.29900181293488, panMaxRight = 0.35779395699501, panMaxTop = -0.076380833983421, panMaxBottom = -0.99909907579422 },
	["Mechagnome2"] = { maxZoom = 2.8552639484406, panMaxLeft = -0.2777853012085, panMaxRight = 0.29651582241058, panMaxTop = -0.095201380550861, panMaxBottom = -1.0263166427612 },
	["Vulpera2"] = { maxZoom = 2.4605259895325, panMaxLeft = -0.31328883767128, panMaxRight = 0.39014467597008, panMaxTop = -0.089733943343162, panMaxBottom = -1.3402827978134 },
	["Vulpera3"] = { maxZoom = 2.9605259895325, panMaxLeft = -0.26144406199455, panMaxRight = 0.30945864319801, panMaxTop = -0.07625275105238, panMaxBottom = -1.2928194999695 },
}

local function returnLocalizedSlot(slotID, slotToLocal)
	if slotToLocal then return slotToLocalized[slotID] end
	return transMogSlots[slotID] or localizedSlots[slotID]
end

local function getItemMatrix(itemID)
	local name, link, quality, itemLevel, reqLevel, class, subClass, maxStack, equipSlot, icon, sellPrice, classID, subClassID, bindType, expansion, itemSetID, isReagent = GetItemInfo(itemID)
	if name then
		return {
			name = name,
			link = link,
			quality = quality,
			itemLevel = itemLevel,
			reqLevel = reqLevel,
			class = class,
			subClass = subClass,
			maxStack = maxStack,
			equipSlot = equipSlot,
			icon = icon,
			sellPrice = sellPrice,
			classID = classID,
			subClassID = subClassID,
			bindType = bindType,
			expansion = expansion,
			itemSetID = itemSetID,
			isReagent = isReagent,
		}
	end
end

local function itemSlotIcon(slotIndex, texture)
	if not slotIndex or not addon.itemSlots[slotIndex] then return end
	--if the texture fails, then load our current character texture
	addon.itemSlots[slotIndex].icon:SetTexture(texture or select(2, GetInventorySlotInfo(slotIndex)))
end

function addon:DoMogFrame()

	addon:SetFrameStrata("DIALOG")
	addon:SetToplevel(true)
	addon:EnableMouse(true)
	addon:EnableMouseWheel(true)
	addon:SetMovable(true)
	addon:SetClampedToScreen(true)
	addon:SetWidth(450)
	addon:SetHeight(570)
	
	addon:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 32,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})

	addon:SetBackdropColor(0,0,0,0.6)
	addon:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	local closeButton = CreateFrame("Button", nil, addon, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", addon, -15, -8);

	local header = addon:CreateFontString("$parentHeaderText", "ARTWORK", "GameFontNormalSmall")
	header:SetJustifyH("LEFT")
	header:SetFontObject("GameFontNormal")
	header:SetPoint("CENTER", addon, "TOP", 0, -20)
	header:SetText(ADDON_NAME)

	local function onEnter(self)
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
		GameTooltip:SetText(returnLocalizedSlot(self.slot, true))
	end
		
	addon.itemSlots = {}
	for i, slotIndex in ipairs(transMogSlots) do
		local slot = CreateFrame("ItemButton", nil, addon)
		slot.slot = slotIndex
		if i == 1 then
			slot:SetPoint("TOPLEFT", addon, "TOPLEFT", 20, -85)
		elseif i == 8 then
			slot:SetPoint("TOPRIGHT", addon, "TOPRIGHT", -20, -85)
		elseif i >= 12 then
			if i == 12 then
				slot:SetPoint("CENTER", addon, "CENTER", -15, -235)
			else
				slot:SetPoint("RIGHT", addon.itemSlots[returnLocalizedSlot(i-1)], "RIGHT", 45, 0)
			end
		else
			slot:SetPoint("TOP", addon.itemSlots[returnLocalizedSlot(i-1)], "BOTTOM", 0, -8)
		end
		slot:RegisterForClicks("AnyUp")
		slot:SetScript("OnEnter", onEnter)
		slot:SetScript("OnLeave", GameTooltip_Hide)
		slot.OnEnter = onEnter
		addon.itemSlots[slotIndex] = slot
		itemSlotIcon(slotIndex)
	end
	
	local model = CreateFrame("DressUpModel", nil, addon)
	model:SetPoint("CENTER")
	model:SetSize(300,400)
	model:ClearModel()
	model:SetUnit("player")
	model:RefreshUnit()
	--model:SetModelScale(1)
	model:SetPosition(0,0,0)
	model.defaultPosX, model.defaultPosY, model.defaultPosZ, model.yaw = 0, 0, 0, 0
	model:SetLight(true, false, -1, 0, 0, .7, .7, .7, .7, .6, 1, 1, 1)
	addon.model = model
	
	--set the pan and zoom limits
	--https://github.com/Gethe/wow-ui-source/blob/f836c162afa2ccb5e42ef4a6c386a438608f4dd3/AddOns/Blizzard_Collections/Blizzard_Wardrobe.lua
	local _, race = UnitRace("player")
	local sex = UnitSex("player")
	model.panAndZoomModelType = race..sex
	
	model:SetScript("OnUpdate",function(self, elapsed) 
		if ( self.rotating ) then
			local x = GetCursorPosition()
			local diff = (x - self.rotateStartCursorX) * MODELFRAME_DRAG_ROTATION_CONSTANT
			self.rotateStartCursorX = GetCursorPosition()
			self.yaw = self.yaw + diff
			if ( self.yaw < 0 ) then
				self.yaw = self.yaw + (2 * PI)
			end
			if ( self.yaw > (2 * PI) ) then
				self.yaw = self.yaw - (2 * PI)
			end
			self:SetRotation(self.yaw, false)
		elseif ( self.panning ) then
			local cursorX, cursorY = GetCursorPosition()
			local modelX = self:GetPosition()
			local panSpeedModifier = 100 * sqrt(1 + modelX - self.defaultPosX)
			local modelY = self.panStartModelY + (cursorX - self.panStartCursorX) / panSpeedModifier
			local modelZ = self.panStartModelZ + (cursorY - self.panStartCursorY) / panSpeedModifier
			local limits = SET_MODEL_PAN_AND_ZOOM_LIMITS[self.panAndZoomModelType]
			if not limits then limits = SET_MODEL_PAN_AND_ZOOM_LIMITS["Human2"] end  --failsafe if addon gets outdated and new races are put in
			
			modelY = Clamp(modelY, limits.panMaxLeft, limits.panMaxRight)
			modelZ = Clamp(modelZ, limits.panMaxBottom, limits.panMaxTop)
			self:SetPosition(modelX, modelY, modelZ)
		end
	end)
	model:SetScript("OnMouseDown",function(self, button) 
		if ( button == "LeftButton" ) then
			self.rotating = true
			self.rotateStartCursorX = GetCursorPosition()
		elseif ( button == "RightButton" ) then
			self.panning = true
			self.panStartCursorX, self.panStartCursorY = GetCursorPosition()
			local modelX, modelY, modelZ = self:GetPosition()
			self.panStartModelY = modelY
			self.panStartModelZ = modelZ
		end
	end)
	model:SetScript("OnMouseUp",function(self, button) 
		if ( button == "LeftButton" ) then
			self.rotating = false
		elseif ( button == "RightButton" ) then
			self.panning = false
		end
	end)
	model:SetScript("OnMouseWheel",function(self, delta) 
		local posX, posY, posZ = self:GetPosition()
		posX = posX + delta * 0.5
		local limits = SET_MODEL_PAN_AND_ZOOM_LIMITS[self.panAndZoomModelType]
		if not limits then limits = SET_MODEL_PAN_AND_ZOOM_LIMITS["Human2"] end  --failsafe if addon gets outdated and new races are put in
		posX = Clamp(posX, self.defaultPosX, limits.maxZoom)
		self:SetPosition(posX, posY, posZ)
	end)
	
	local modelbg = addon:CreateTexture(nil,"BACKGROUND");
	modelbg:SetAllPoints(model);
	modelbg:SetColorTexture(0.3, 0.3, 0.3, 0.2)

	addon:Show()
end

function addon:PreviewItem(itemLink, slotIndex)
	if not itemLink then return end
	local itemMatrix = getItemMatrix(itemLink)
	if not itemMatrix then return end
	
	itemSlotIcon(returnLocalizedSlot(itemMatrix.equipSlot), itemMatrix.icon)
	addon.model:TryOn(itemLink, slotIndex)
	
	--https://github.com/Gethe/wow-ui-source/blob/356d028f9d245f6e75dc8a806deb3c38aa0aa77f/FrameXML/DressUpFrames.lua
	
	--playerActor:TryOn(appearanceSources[mainHandSlotID], "MAINHANDSLOT", mainHandEnchant);
	--playerActor:TryOn(appearanceSources[secondaryHandSlotID], "SECONDARYHANDSLOT", offHandEnchant);
	
	-- --https://github.com/Gethe/wow-ui-source/blob/f836c162afa2ccb5e42ef4a6c386a438608f4dd3/AddOns/Blizzard_Collections/Blizzard_Wardrobe.lua
	-- if ( event == "GET_ITEM_INFO_RECEIVED" ) then
		-- local itemID = ...;
		-- for itemFrame in self.DetailsFrame.itemFramesPool:EnumerateActive() do
			-- if ( itemFrame.itemID == itemID ) then
				-- self:SetItemFrameQuality(itemFrame);
				-- break;
			-- end
		-- end
		
end

function addon:LoadInspectedCharacter()

	--this is for player
	-- for i = 0, 19 do
		-- local itemID = GetInventoryItemID("player", i)
		-- if itemID then
			-- local itemMatrix = getItemMatrix(itemID)
			-- if itemMatrix then
				-- --addon.model:TryOn(itemID, i)
				-- --Debug(i, returnLocalizedSlot(i), itemMatrix.name, itemMatrix.equipSlot, itemMatrix.icon, returnLocalizedSlot(itemMatrix.equipSlot))
				-- itemSlotIcon(returnLocalizedSlot(itemMatrix.equipSlot), itemMatrix.icon)
			-- end
		-- end
	-- end
	
	--itemAppearanceModID
	--doModelUpdate
	
	local inspectSlots = C_TransmogCollection.GetInspectSources()
	if not inspectSlots then return end
	
	local mainHandSlotID = GetInventorySlotInfo("MAINHANDSLOT")
	local secondaryHandSlotID = GetInventorySlotInfo("SECONDARYHANDSLOT")
	
	for i, sourceIndex in pairs(inspectSlots) do
		if sourceIndex ~= NO_TRANSMOG_SOURCE_ID and i ~= mainHandSlotID and i ~= secondaryHandSlotID then
			local _, _, _, _, _, link = C_TransmogCollection.GetAppearanceSourceInfo(sourceIndex)
			if link then
				addon:PreviewItem(link, i)
			end
		end
	end

	local MainHandSlot = select(6, C_TransmogCollection.GetAppearanceSourceInfo(inspectSlots[mainHandSlotID]))
	addon:PreviewItem(MainHandSlot, mainHandSlotID)
	
	local SecondaryHandSlot = select(6, C_TransmogCollection.GetAppearanceSourceInfo(inspectSlots[secondaryHandSlotID]))
	addon:PreviewItem(SecondaryHandSlot, secondaryHandSlotID)
	
	--addon.model:RefreshUnit()

	addon:Show()
end

function addon:AddInspectButton()
	if addon.inspectButton then return end
	if not InspectFrame then return end
	addon.inspectButton = true
	
	local button = CreateFrame("Button", ADDON_NAME.."_InspectButton", InspectFrame, "UIPanelButtonTemplate")
	button:SetText("Load Player")
	button:SetHeight(30)
	button:SetWidth(button:GetTextWidth() + 30)
	button:SetPoint("TOPRIGHT", 110, 0)
	button:SetScript("OnClick", function()
		addon:LoadInspectedCharacter()
	end)
end

function addon:ADDON_LOADED(event, addonName)
	if not addon.inspectButton then
		if IsAddOnLoaded("Blizzard_InspectUI") then
			addon:AddInspectButton()
			self:UnregisterEvent("ADDON_LOADED")
		end
	else
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function addon:GET_ITEM_INFO_RECEIVED(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	--Debug(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end

function addon:PLAYER_LOGIN()

	addon:DoMogFrame()
	
	if InspectFrame and not addon.inspectButton then
		addon:AddInspectButton()
	end

	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded", ADDON_NAME, ver or "1.0"))
end

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("GET_ITEM_INFO_RECEIVED")