Util = require("modules/util")


State = {}
State.__index = State




function State.new()
    local self = setmetatable({}, State)

    self.items = {}
    self.wasTransmog = false
    self.wasInCombat = false
    self.wasWeaponDrawn = false
    self.wasInHostileZone = false
    self.wasEquipped = false
    self.lastOutfit = nil
    self.lastItems = {}

    return self
end


function State:update()
	self.wasTransmog = Util.isTransmog()
	self.lastOutfit = Util.getLastOutfit()
	self.lastItems = Util.getLastItems()
end


function State:reset()
    self.wasTransmog = false
    self.wasInCombat = false
    self.wasWeaponDrawn = false
    self.wasInHostileZone = false
    self.wasEquipped = false
    self.lastOutfit = nil
    self.lastItems = {}
end




return State
