-- Inheritance LUA Doc: http://www.lua.org/pil/16.2.html 
RK_Item = {}

function RK_Item:New(slotIndex)
	obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj:Init(slotIndex)
	return obj
end

function RK_Item:Init(slotIndex)
	self.slot = slotIndex
	self.link = GetSlotItemLink(self.slot)
	self.name = GetItemLinkName(self.link)
	self.stack = GetItemLinkStacks(self.link)
end

function RK_Item:IsValid()
	return (self.slot > -1 and
			self.stack > -1 and
			not RK.IsEmpty(self.link) and
			not RK.IsEmpty(self.name))
end

function RK_Item:BuildItemStr()
	local itemStr = RK.COLORS.WHITE

	if (not self:IsValid()) then
		return itemStr.."empty slot"
	end

	if (self.stack) then
		itemStr = itemStr.."x"..self.stack
	end
	itemStr = itemStr.." "..self:FormatLink(LINK_STYLE_BRACKETS)
	return itemStr
end

function RK_Item:FormatLink(itemLinkStyle)
	local linkLength = self.link:len()
	local nameLength = self.name:len()
	local formattedName = self.formattedName or self:FormatName()
	if (itemLinkStyle == LINK_STYLE_BRACKETS) then
		formattedName = "["..formattedName.."]"
	end
	local finalLink = ""
	for i = 1, linkLength-2-nameLength do
		finalLink = finalLink..self.link:sub(i, i)
	end
	finalLink = finalLink..formattedName.."|h"
	return finalLink
end

function RK_Item:FormatName()
	local length = self.name:len()
	local final = ""
	for i = 1, length do
		local char = self.name:sub(i, i)
		if (i == 1 or self.name:sub(i-1, i-1) == " ") then
			final = final..char:upper()
		elseif (char == "^") then
			break
		else
			final = final..char
		end
	end
	self.formattedName = final
	return final
end

function RK_Item:Write() -- for debugging
	local str = ""
	for k, v in pairs(self) do
		str = str.."["..k.."]="..tostring(v)..",|r"
	end
	RK.Write(str.." IsValid: "..tostring(self:IsValid()))


end