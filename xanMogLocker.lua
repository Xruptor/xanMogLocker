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
	model:SetPoint('CENTER')
	model:SetSize(300,400)
	model:ClearModel()
	model:SetUnit('player')
	model:RefreshUnit()
	--model:SetModelScale(1)
	model:SetPosition(0,0,0)
	model:SetLight(true, false, 0, 0.8, -1, 1, 1, 1, 1, 0.3, 1, 1, 1)
	addon.model = model
	
	local modelbg = addon:CreateTexture(nil,"BACKGROUND");
	modelbg:SetAllPoints(model);
	modelbg:SetColorTexture(0.3, 0.3, 0.3, 0.2)

	addon:Show()
end

function addon:DoTestPreview()
	for i = 0, 19 do
		local itemID = GetInventoryItemID("player", i)
		if itemID then
			local itemMatrix = getItemMatrix(itemID)
			if itemMatrix then
				--addon.model:TryOn(itemID, i)
				--Debug(i, returnLocalizedSlot(i), itemMatrix.name, itemMatrix.equipSlot, itemMatrix.icon, returnLocalizedSlot(itemMatrix.equipSlot))
				itemSlotIcon(returnLocalizedSlot(itemMatrix.equipSlot), itemMatrix.icon)
			end
		end
	end
	
	--C_TransmogCollection.GetInspectSources()
end

function addon:PLAYER_LOGIN()

	addon:DoMogFrame()
	
	addon:DoTestPreview()

	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded", ADDON_NAME, ver or "1.0"))
end

addon:RegisterEvent("PLAYER_LOGIN")
