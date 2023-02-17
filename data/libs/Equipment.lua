-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local EquipType   = require 'EquipType'.EquipType
local Serializer  = require 'Serializer'

local utils = require 'utils'

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

-- ID-setting assignment operator to allow savefile modernization
local __by_id = {}

local __automagic = {
	__index = function(t, k)
		local namespace = k .. "."
		local nt = setmetatable({}, {
			-- assign the equipment prototype an id, and store it in the __by_id table
			__newindex = function(_t, key, v)
				rawset(_t, key, v)
				local id = namespace .. key
				rawset(__by_id, id, v)
				v.id = id
			end
		})
		rawset(t, k, nt)
		return nt
	end
}

---@type table<string, table>
local Equipment = setmetatable({}, __automagic)

package.core.Equipment = Equipment

require 'modules.Equipment.Computer'
require 'modules.Equipment.Internal'
require 'modules.Equipment.Utility'
require 'modules.Equipment.Weapons'

-- Forward-port the definition of equipment items to the most recent defined in code, if present
local un = EquipType.Unserialize
function EquipType.Unserialize(data)
	local obj = un(data)

	if EquipType.isProto(obj) then
		local ns, key = EquipType.SplitId(obj.id)
		obj = Equipment[ns][key] or obj
	end

	return obj
end

local serialize = function()
	return __by_id
end

local unserialize = function (data)
	for id, v in pairs(data) do
		-- don't overwrite an already-present equipment item
		if not __by_id[id] then
			local ns, k = EquipType.SplitId(id)
			Equipment[ns][k] = v -- this assignment will populate the __by_id table
		end
	end
end

Serializer:Register("Equipment", serialize, unserialize)

return Equipment
