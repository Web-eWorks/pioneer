-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local Commodities = require 'Commodities'
local EquipType = require 'EquipType'.EquipType
local HyperdriveType = require 'EquipType'.HyperdriveType

local misc = require 'EquipType'.misc
local hyperspace = require 'EquipType'.hyperspace

misc.atmospheric_shielding = EquipType.New({
	l10n_key="ATMOSPHERIC_SHIELDING", slots="atmo_shield", price=200,
	capabilities={mass=1, atmo_shield=9},
	purchasable=true, tech_level=3,
	icon_name="equip_atmo_shield_generator"
})
misc.heavy_atmospheric_shielding = EquipType.New({
	l10n_key="ATMOSPHERIC_SHIELDING_HEAVY", slots="atmo_shield", price=900,
	capabilities={mass=2, atmo_shield=19},
	purchasable=true, tech_level=5,
	icon_name="equip_atmo_shield_generator"
})
misc.ecm_basic = EquipType.New({
	l10n_key="ECM_BASIC", slots="ecm", price=6000,
	capabilities={mass=2, ecm_power=2, ecm_recharge=5},
	purchasable=true, tech_level=9, ecm_type = 'ecm',
	hover_message="ECM_HOVER_MESSAGE"
})
misc.ecm_advanced = EquipType.New({
	l10n_key="ECM_ADVANCED", slots="ecm", price=15200,
	capabilities={mass=2, ecm_power=3, ecm_recharge=5},
	purchasable=true, tech_level="MILITARY", ecm_type = 'ecm_advanced',
	hover_message="ECM_HOVER_MESSAGE"
})
misc.cabin = EquipType.New({
	l10n_key="UNOCCUPIED_CABIN", slots="cabin", price=1350,
	capabilities={mass=1, cabin=1},
	purchasable=true,  tech_level=1,
	icon_name="equip_cabin_empty"
})
misc.cabin_occupied = EquipType.New({
	l10n_key="PASSENGER_CABIN", slots="cabin", price=0,
	capabilities={mass=1}, purchasable=false, tech_level=1,
	icon_name="equip_cabin_occupied"
})
misc.shield_generator = EquipType.New({
	l10n_key="SHIELD_GENERATOR", slots="shield", price=2500,
	capabilities={mass=4, shield=1}, purchasable=true, tech_level=8,
	icon_name="equip_shield_generator"
})
misc.laser_cooling_booster = EquipType.New({
	l10n_key="LASER_COOLING_BOOSTER", slots="laser_cooler", price=380,
	capabilities={mass=1, laser_cooler=2}, purchasable=true, tech_level=8
})
misc.cargo_life_support = EquipType.New({
	l10n_key="CARGO_LIFE_SUPPORT", slots="cargo_life_support", price=700,
	capabilities={mass=1, cargo_life_support=1}, purchasable=true, tech_level=2
})

misc.shield_energy_booster = EquipType.New({
	l10n_key="SHIELD_ENERGY_BOOSTER", slots="energy_booster", price=10000,
	capabilities={mass=8, shield_energy_booster=1}, purchasable=true, tech_level=11
})
misc.hull_autorepair = EquipType.New({
	l10n_key="HULL_AUTOREPAIR", slots="hull_autorepair", price=16000,
	capabilities={mass=40, hull_autorepair=1}, purchasable=true, tech_level="MILITARY",
	icon_name="repairs"
})
misc.thrusters_basic = EquipType.New({
	l10n_key="THRUSTERS_BASIC", slots="thruster", price=3000,
	tech_level=5,
	capabilities={mass=0, thruster_power=1}, purchasable=true,
	icon_name="equip_thrusters_basic"
})
misc.thrusters_medium = EquipType.New({
	l10n_key="THRUSTERS_MEDIUM", slots="thruster", price=6500,
	tech_level=8,
	capabilities={mass=0, thruster_power=2}, purchasable=true,
	icon_name="equip_thrusters_medium"
})
misc.thrusters_best = EquipType.New({
	l10n_key="THRUSTERS_BEST", slots="thruster", price=14000,
	tech_level="MILITARY",
	capabilities={mass=0, thruster_power=3}, purchasable=true,
	icon_name="equip_thrusters_best"
})


hyperspace.hyperdrive_1 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS1", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=700, capabilities={mass=2, hyperclass=1}, purchasable=true, tech_level=3,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_2 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS2", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=1300, capabilities={mass=6, hyperclass=2}, purchasable=true, tech_level=4,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_3 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS3", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=2500, capabilities={mass=11, hyperclass=3}, purchasable=true, tech_level=4,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_4 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS4", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=5000, capabilities={mass=25, hyperclass=4}, purchasable=true, tech_level=5,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_5 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS5", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=10000, capabilities={mass=60, hyperclass=5}, purchasable=true, tech_level=5,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_6 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS6", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=20000, capabilities={mass=130, hyperclass=6}, purchasable=true, tech_level=6,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_7 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS7", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=30000, capabilities={mass=245, hyperclass=7}, purchasable=true, tech_level=8,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_8 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS8", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=60000, capabilities={mass=360, hyperclass=8}, purchasable=true, tech_level=9,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_9 = HyperdriveType.New({
	l10n_key="DRIVE_CLASS9", fuel=Commodities.hydrogen, slots="hyperdrive",
	price=120000, capabilities={mass=540, hyperclass=9}, purchasable=true, tech_level=10,
	icon_name="equip_hyperdrive"
})
hyperspace.hyperdrive_mil1 = HyperdriveType.New({
	l10n_key="DRIVE_MIL1", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=23000, capabilities={mass=3, hyperclass=1}, purchasable=true, tech_level=10,
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil2 = HyperdriveType.New({
	l10n_key="DRIVE_MIL2", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=47000, capabilities={mass=7, hyperclass=2}, purchasable=true, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil3 = HyperdriveType.New({
	l10n_key="DRIVE_MIL3", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=85000, capabilities={mass=12, hyperclass=3}, purchasable=true, tech_level=11,
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil4 = HyperdriveType.New({
	l10n_key="DRIVE_MIL4", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=214000, capabilities={mass=28, hyperclass=4}, purchasable=true, tech_level=12,
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil5 = HyperdriveType.New({
	l10n_key="DRIVE_MIL5", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=540000, capabilities={mass=63, hyperclass=5}, purchasable=false, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil6 = HyperdriveType.New({
	l10n_key="DRIVE_MIL6", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=1350000, capabilities={mass=128, hyperclass=6}, purchasable=false, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil7 = HyperdriveType.New({
	l10n_key="DRIVE_MIL7", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=3500000, capabilities={mass=196, hyperclass=7}, purchasable=false, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil8 = HyperdriveType.New({
	l10n_key="DRIVE_MIL8", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=8500000, capabilities={mass=285, hyperclass=8}, purchasable=false, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
hyperspace.hyperdrive_mil9 = HyperdriveType.New({
	l10n_key="DRIVE_MIL9", fuel=Commodities.military_fuel, byproduct=Commodities.radioactives, slots="hyperdrive",
	price=22000000, capabilities={mass=400, hyperclass=9}, purchasable=false, tech_level="MILITARY",
	icon_name="equip_hyperdrive_mil"
})
