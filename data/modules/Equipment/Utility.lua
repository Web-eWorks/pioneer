-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local EquipTypes = require 'EquipType'

local EquipType = EquipTypes.EquipType
local SensorType = EquipTypes.SensorType
local BodyScannerType = EquipTypes.BodyScannerType

--==============================================================================

local Equipment = package.core.Equipment

local misc = Equipment.misc

misc.fuel_scoop = EquipType.New({
	l10n_key="FUEL_SCOOP", slots="scoop", price=3500,
	capabilities={mass=6, fuel_scoop=3}, purchasable=true, tech_level=4,
	icon_name="equip_fuel_scoop"
})
misc.cargo_scoop = EquipType.New({
	l10n_key="CARGO_SCOOP", slots="scoop", price=3900,
	capabilities={mass=7, cargo_scoop=1}, purchasable=true, tech_level=5,
	icon_name="equip_cargo_scoop"
})
misc.multi_scoop = EquipType.New({
	l10n_key="MULTI_SCOOP", slots="scoop", price=12000,
	capabilities={mass=9, cargo_scoop=1, fuel_scoop=2}, purchasable=true, tech_level=9,
	icon_name="equip_multi_scoop"
})

misc.radar = EquipType.New({
	l10n_key="RADAR", slots="radar", price=680,
	capabilities={mass=1, radar=1},
	purchasable=true, tech_level=3,
	icon_name="equip_radar"
})

misc.planetscanner = BodyScannerType.New({
	l10n_key = 'SURFACE_SCANNER', slots="sensor", price=2950,
	capabilities={mass=1,sensor=1}, purchasable=true, tech_level=5,
	max_range=100000000, target_altitude=0, state="HALTED", progress=0,
	bodyscanner_stats={scan_speed=3, scan_tolerance=0.05},
	stats={ aperture = 50.0, minAltitude = 150, resolution = 768, orbital = false },
	icon_name="equip_planet_scanner"
})
misc.planetscanner_good = BodyScannerType.New({
	l10n_key = 'SURFACE_SCANNER_GOOD', slots="sensor", price=5000,
	capabilities={mass=2,sensor=1}, purchasable=true, tech_level=8,
	max_range=100000000, target_altitude=0, state="HALTED", progress=0,
	bodyscanner_stats={scan_speed=3, scan_tolerance=0.05},
	stats={ aperture = 65.0, minAltitude = 250, resolution = 1092, orbital = false },
	icon_name="equip_planet_scanner"
})
misc.orbitscanner = BodyScannerType.New({
	l10n_key = 'ORBIT_SCANNER', slots="sensor", price=7500,
	capabilities={mass=3,sensor=1}, purchasable=true, tech_level=3,
	max_range=100000000, target_altitude=0, state="HALTED", progress=0,
	bodyscanner_stats={scan_speed=3, scan_tolerance=0.05},
	stats={ aperture = 4.0, minAltitude = 650000, resolution = 6802, orbital = true },
	icon_name="equip_orbit_scanner"
})
misc.orbitscanner_good = BodyScannerType.New({
	l10n_key = 'ORBIT_SCANNER_GOOD', slots="sensor", price=11000,
	capabilities={mass=7,sensor=1}, purchasable=true, tech_level=8,
	max_range=100000000, target_altitude=0, state="HALTED", progress=0,
	bodyscanner_stats={scan_speed=3, scan_tolerance=0.05},
	stats={ aperture = 2.8, minAltitude = 1750000, resolution = 12375, orbital = true },
	icon_name="equip_orbit_scanner"
})
