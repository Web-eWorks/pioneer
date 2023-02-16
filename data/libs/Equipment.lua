-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local Commodities = require 'Commodities'
local EquipTypes  = require 'EquipType'
local Serializer  = require 'Serializer'

-- Constants: EquipSlot
--
-- Equipment slots. Every equipment item has a corresponding
-- "slot" that it fits in to. Each slot has an independent capacity.
--
-- engine - hyperdrives and military drives
-- laser_front - front attachment point for lasers and plasma accelerators
-- laser_rear - rear attachment point for lasers and plasma accelerators
-- missile - missile
-- ecm - ecm system
-- radar - radar
-- target_scanner - target scanner
-- hypercloud - hyperspace cloud analyser
-- hull_autorepair - hull auto-repair system
-- energy_booster - shield energy booster unit
-- atmo_shield - atmospheric shielding
-- cabin - cabin
-- shield - shield
-- scoop - scoop used for scooping things (cargo, fuel/hydrogen)
-- laser_cooler - laser cooling booster
-- cargo_life_support - cargo bay life support
-- autopilot - autopilot
-- trade_computer - commodity trade analyzer computer module

require 'modules.Equipment' -- load all equipment items

local serialize = function()
	local ret = {}
	for _,k in ipairs{"laser", "hyperspace", "misc"} do
		local tmp = {}
		for kk, vv in pairs(EquipTypes[k]) do
			tmp[kk] = vv
		end
		ret[k] = tmp
	end
	return ret
end

local unserialize = function (data)
	for _,k in ipairs{"laser", "hyperspace", "misc"} do
		local tmp = EquipTypes[k]
		for kk, vv in pairs(data[k]) do
			tmp[kk] = vv
		end
	end
end

Serializer:Register("Equipment", serialize, unserialize)

return EquipTypes
