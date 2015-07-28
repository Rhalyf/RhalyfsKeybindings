RK = {}
RK.name = "RhalyfsKeybindings"
RK.nameLong = "Rhalyf's Keybindings"
RK.blueColor = "|c4DB8FF"
RK.whiteColor = "|cE6F5FF"
RK.addOnVersion = 0.4
RK.author = "Rhalyf"
-- Maps my keybinds to their actual slot values.
RK.quickSlotMapping = {12, 11, 10, 9, 16, 15, 14, 13}

function RK.OnLoad(event, addOnName)
  	if (addOnName ~= RK.name) then return end

	RK:HandleSavedSettings()
	RK:InitAddOnSettings()
	RK:SetKeybindingStrs()

	zo_callLater(RK.SignOfLife, 1000)

	EVENT_MANAGER:UnregisterForEvent("RK_Loaded", EVENT_ADD_ON_LOADED)	
end

function RK:HandleSavedSettings()
	local defaultSettings = {
  		notifications = true,
  	}
  	-- Documentation: ZO_SavedVars:NewAccountWide(savedVariableName, settingsVersion, settingsNamespace, defaultSettings, settingsProfile)
  	RK.savedSettings = ZO_SavedVars:NewAccountWide("RK_SavedSettings", 1, "RK", RK.defaultSettings, "RK")
end

function RK:InitAddOnSettings()
	local LAM2 = LibStub("LibAddonMenu-2.0")

	local panelData = {
		type = "panel",
		name = RK.nameLong,
		displayName = RK.blueColor..RK.nameLong,
		author = RK.author,
		version = RK.addOnVersion,
	}

	LAM2:RegisterAddonPanel(RK.name.."Options", panelData)

	local optionsData = {
		[1] = {
			type = "description",
			text = "Please set the QuickSlot keybindings via ESO's built-in Keybindings controller by selecting 'CONTROLS' in the Settings List.",
		},
		[2] = {
			type = "description",
			text = "Note: Keybindings are not Account-wide but the below settings are.",
		},
        [3] = {
			type = "checkbox",
			name = "Display QuickSlot Swap Notifications",
			tooltip = "Recieve notification from "..RK.nameLong.." when QuickSlot is changed via Keybindings",
			getFunc = function() return RK:getSavedSetting("notifications") end,
			setFunc = function(state) RK:setSavedSetting("notifications", state) end,
        },
    }

	LAM2:RegisterOptionControls(RK.name.."Options", optionsData)
end

function RK:SetKeybindingStrs()
	-- keybinding strings
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_1", "QuickSlot 1 (top)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_2", "QuickSlot 2 (top right)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_3", "QuickSlot 3 (middle right)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_4", "QuickSlot 4 (bottom right)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_5", "QuickSlot 5 (bottom)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_6", "QuickSlot 6 (bottom left)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_7", "QuickSlot 7 (middle left)")
	ZO_CreateStringId("SI_BINDING_NAME_RK_QS_8", "QuickSlot 8 (top left)")
end

function RK:getSavedSetting(setting)
	return RK.savedSettings[setting]
end

function RK:setSavedSetting(setting, state)
	RK.savedSettings[setting] = state
end

function RK:BuildItemStr(slotId)
	local itemLink = GetSlotItemLink(slotId)
	local itemStack = GetItemLinkStacks(itemLink)
	local itemStr = "|cE6F5FF"

	if (not itemLink or itemLink == "") then
		itemStr = itemStr.."empty slot"
	else
		if (itemStack) then
			itemStr = itemStr.."x"..itemStack
		end
		if (itemIcon and itemIcon ~= "") then
			itemStr = itemStr..itemIcon
		end
		itemStr = itemStr.." ["..itemLink.."]"
	end
	return itemStr
end

function RK:QSSelected(selectedId)
	local slotId = RK.quickSlotMapping[selectedId]
	local slotItemStr = RK:BuildItemStr(slotId)

    SetCurrentQuickslot(slotId)
    RK:Write("QuickSlot "..selectedId..": "..slotItemStr, false)
end

function RK:Write(message, includeName)
	if (not RK:getSavedSetting("notifications")) then return end

	local preMessage = RK.blueColor
	if (includeName == true) then
		preMessage = preMessage..RK.nameLong..":"
	end

	d(preMessage..message.."|r")
end

function RK.SignOfLife()
	RK:Write(" "..RK.whiteColor.."Thanks for using "..RK.nameLong.."!", true)
end
 
EVENT_MANAGER:RegisterForEvent("RK_Loaded", EVENT_ADD_ON_LOADED, RK.OnLoad)