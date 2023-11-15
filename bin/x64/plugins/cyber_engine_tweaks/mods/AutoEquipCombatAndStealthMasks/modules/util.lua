Util = {}


File = require("modules/file")


BASE_SLOTS = {
	["Face"] = true
}


EQUIPMENT_EX_SLOTS = {
	["OutfitSlots.Balaclava"] = true,
	["OutfitSlots.Mask"] = true
}




function Util.getPlayerData()
	return Game.GetScriptableSystemsContainer():Get("EquipmentSystem"):GetPlayerData(Game.GetPlayer())
end


function Util.getOutfitSystem()
	return Game.GetScriptableSystemsContainer():Get("EquipmentEx.OutfitSystem")
end


function Util.getItems()
	local items = {}
	local config = File.readJSON("config.json")

	if config then
		for i, item in ipairs(config) do
			items[i] = ItemID.FromTDBID(item)
		end
	end

	return items
end


function Util.isTransmog()
	return Util.getPlayerData():IsVisualSetActive()
end


function Util.isInVehicle()
	return Game.GetMountedVehicle(Game.GetPlayer()) ~= nil
end


function Util.isInCombat()
	local combatState = tonumber(EnumInt(Game.GetPlayer().GetCurrentCombatState(Game.GetPlayer())))
	return combatState == 1
end


function Util.isWeaponDrawn()
	return Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), "AttachmentSlots.WeaponRight") ~= nil
end


function Util.isInHostileZone()
	local zoneType = tonumber(EnumInt(Game.GetPlayer():GetCurrentSecurityZoneType(Game.GetPlayer())))
	return zoneType == 3 or zoneType == 4
end


function Util.getLastOutfit()
	local outfitSystem = Util.getOutfitSystem()
	local outfits = outfitSystem:GetOutfits()

	for _, outfit in pairs(outfits) do
		if outfitSystem:IsEquipped(outfit) then
			return outfit
		end
	end

	return nil
end


function Util.getLastItems()
	local items = {}
	local player, transactionSystem = Game.GetPlayer(), Game.GetTransactionSystem()

	for slot, _ in pairs(BASE_SLOTS) do
		local item = Util.getPlayerData():GetActiveItem(slot)

		if ItemID.IsValid(item) then
			items[slot] = item
		end
	end

	for slot, _ in pairs(EQUIPMENT_EX_SLOTS) do
		local item = transactionSystem:GetItemInSlot(player, slot)

		if item then
			items[slot] = item:GetItemID()
		end
	end

	return items
end


function Util.baseToEEX(base)
	if base == "Face" then
		return "AttachmentSlots.Eyes"
	elseif base == "Head" then
		return "AttachmentSlots.Head"
	end

	return nil
end


function Util.equipItems(items, wasTransmog)
	local outfitSystem = Util.getOutfitSystem()
	local transactionSystem = Game.GetTransactionSystem()

	for slot, item in pairs(items) do
		if BASE_SLOTS[slot] then
			if not wasTransmog then
				transactionSystem:AddItemToSlot(Game.GetPlayer(), Util.baseToEEX(slot), item, true)
			end
		else
			outfitSystem:EquipItem(item)
		end
	end
end


function Util.unequipItems(items)
	local outfitSystem = Util.getOutfitSystem()
	local transactionSystem = Game.GetTransactionSystem()

	for slot, item in pairs(items) do
		if BASE_SLOTS[slot] then
			transactionSystem:RemoveItemFromSlot(Game.GetPlayer(), Util.baseToEEX(slot))
		else
			outfitSystem:UnequipItem(item)

			if EQUIPMENT_EX_SLOTS[slot] then
				outfitSystem:DetachVisualFromSlot(item, slot)
			end
		end
	end
end




return Util
