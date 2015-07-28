RK = {}

function RK.OnLoad(event, addOnName)
  	if (addOnName ~= RK.SHORTNAME) then return end

  	EVENT_MANAGER:UnregisterForEvent("RK_Loaded", EVENT_ADD_ON_LOADED)	

	RK.LoadSavedSettings()
	RK.InitAddOnSettings()
	RK.SetKeybindingStrs()	
end

function RK.SetKeybindingStrs()
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

function RK.QSSelected(selectedId)
	local slotId = RK.QUICKSLOTMAPPING[selectedId]
	local item = RK_Item:New(slotId)
	local slotItemStr = item:BuildItemStr()

    SetCurrentQuickslot(slotId)
    RK.Write("QuickSlot "..selectedId..": "..slotItemStr, false)
end

function RK.Write(message, includeName)
	if (not RK.getSavedSetting("notifications")) then return end

	local preMessage = RK.COLORS.BLUE
	if (includeName == true) then
		preMessage = preMessage..RK.LONGNAME..": "
	end

	d(preMessage..RK.COLORS.GRAY..message.."|r")
end

function RK.SignOfLife()
	EVENT_MANAGER:UnregisterForEvent("RK_Player_Active", EVENT_PLAYER_ACTIVATED)
	RK.Write("Thanks for using "..RK.COLORS.WHITE..RK.LONGNAME..RK.COLORS.GRAY.."!!", true)
end

function RK.IsEmpty(str)
	return str == nil or str == ""
end

EVENT_MANAGER:RegisterForEvent("RK_Loaded", EVENT_ADD_ON_LOADED, RK.OnLoad)
EVENT_MANAGER:RegisterForEvent("RK_Player_Active", EVENT_PLAYER_ACTIVATED, RK.SignOfLife)