-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local EquipType = require 'EquipType'.EquipType
local LaserType = require 'EquipType'.LaserType
local LaserType2 = require 'EquipType'.LaserType2

local misc = require 'EquipType'.misc
local laser = require 'EquipType'.laser

misc.missile_unguided = EquipType.New({
	l10n_key="MISSILE_UNGUIDED", slots="missile", price=30,
	missile_type="missile_unguided", tech_level=1,
	capabilities={mass=0.2}, purchasable=true,
	icon_name="equip_missile_unguided"
})
misc.missile_guided = EquipType.New({
	l10n_key="MISSILE_GUIDED", slots="missile", price=50,
	missile_type="missile_guided", tech_level=5,
	capabilities={mass=0.5}, purchasable=true,
	icon_name="equip_missile_guided"
})
misc.missile_smart = EquipType.New({
	l10n_key="MISSILE_SMART", slots="missile", price=95,
	missile_type="missile_smart", tech_level=10,
	capabilities={mass=1}, purchasable=true,
	icon_name="equip_missile_smart"
})
misc.missile_naval = EquipType.New({
	l10n_key="MISSILE_NAVAL", slots="missile", price=160,
	missile_type="missile_naval", tech_level="MILITARY",
	capabilities={mass=1.5}, purchasable=true,
	icon_name="equip_missile_naval"
})


laser.pulsecannon_1mw = LaserType2.New({
	l10n_key="PULSECANNON_1MW", price=600, capabilities={mass=1},
	slots = {"laser_front"}, gun_data = {
		projectile = {
			lifespan = 5, speed = 1600, damage = 1000,
			length = 15, width = 3, beam = false, mining = false, color = Color(255, 51, 51)
		},
		firingRPM = 800, firingHeat = 2500, coolingPerSecond = 7200, overheatThreshold = 280000,
		model = nil, numBarrels = 1
	}, purchasable = true, tech_level = 3
})

--[[
laser.pulsecannon_1mw = LaserType.New({
	l10n_key="PULSECANNON_1MW", price=600, capabilities={mass=1},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=1000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 255, rgba_g = 51, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=3,
	icon_name="equip_pulsecannon"
})
--]]
laser.pulsecannon_dual_1mw = LaserType.New({
	l10n_key="PULSECANNON_DUAL_1MW", price=1100, capabilities={mass=4},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=1000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=1, mining=0, rgba_r = 255, rgba_g = 51, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=4,
	icon_name="equip_dual_pulsecannon"
})
laser.pulsecannon_2mw = LaserType.New({
	l10n_key="PULSECANNON_2MW", price=1000, capabilities={mass=3},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=2000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 255, rgba_g = 127, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=5,
	icon_name="equip_pulsecannon"
})
laser.pulsecannon_rapid_2mw = LaserType.New({
	l10n_key="PULSECANNON_RAPID_2MW", price=1800, capabilities={mass=7},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=2000, rechargeTime=0.13, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 255, rgba_g = 127, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=5,
	icon_name="equip_pulsecannon_rapid"
})
laser.beamlaser_1mw = LaserType.New({
	l10n_key="BEAMLASER_1MW", price=2400, capabilities={mass=3},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=1500, rechargeTime=0.25, length=10000,
		width=1, beam=1, dual=0, mining=0, rgba_r = 255, rgba_g = 51, rgba_b = 127, rgba_a = 255,
		heatrate=0.02, coolrate=0.01
	}, purchasable=true, tech_level=4,
	icon_name="equip_beamlaser"
})
laser.beamlaser_dual_1mw = LaserType.New({
	l10n_key="BEAMLASER_DUAL_1MW", price=4800, capabilities={mass=6},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=1500, rechargeTime=0.5, length=10000,
		width=1, beam=1, dual=1, mining=0, rgba_r = 255, rgba_g = 51, rgba_b = 127, rgba_a = 255,
		heatrate=0.02, coolrate=0.01
	}, purchasable=true, tech_level=5,
	icon_name="equip_dual_beamlaser"
})
laser.beamlaser_2mw = LaserType.New({
	l10n_key="BEAMLASER_RAPID_2MW", price=5600, capabilities={mass=7},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=3000, rechargeTime=0.13, length=20000,
		width=1, beam=1, dual=0, mining=0, rgba_r = 255, rgba_g = 192, rgba_b = 192, rgba_a = 255,
		heatrate=0.02, coolrate=0.01
	}, purchasable=true, tech_level=6,
	icon_name="equip_beamlaser"
})
laser.pulsecannon_4mw = LaserType.New({
	l10n_key="PULSECANNON_4MW", price=2200, capabilities={mass=10},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=4000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 255, rgba_g = 255, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=6,
	icon_name="equip_pulsecannon"
})
laser.pulsecannon_10mw = LaserType.New({
	l10n_key="PULSECANNON_10MW", price=4900, capabilities={mass=30},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=10000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 51, rgba_g = 255, rgba_b = 51, rgba_a = 255
	}, purchasable=true, tech_level=7,
	icon_name="equip_pulsecannon"
})
laser.pulsecannon_20mw = LaserType.New({
	l10n_key="PULSECANNON_20MW", price=12000, capabilities={mass=65},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=20000, rechargeTime=0.25, length=30,
		width=5, beam=0, dual=0, mining=0, rgba_r = 0.1, rgba_g = 51, rgba_b = 255, rgba_a = 255
	}, purchasable=true, tech_level="MILITARY",
	icon_name="equip_pulsecannon"
})
laser.miningcannon_5mw = LaserType.New({
	l10n_key="MININGCANNON_5MW", price=3700, capabilities={mass=6},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=5000, rechargeTime=1.5, length=30,
		width=5, beam=0, dual=0, mining=1, rgba_r = 51, rgba_g = 127, rgba_b = 0, rgba_a = 255
	}, purchasable=true, tech_level=5,
	icon_name="equip_mining_laser"
})
laser.miningcannon_17mw = LaserType.New({
	l10n_key="MININGCANNON_17MW", price=10600, capabilities={mass=10},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=17000, rechargeTime=2, length=30,
		width=5, beam=0, dual=0, mining=1, rgba_r = 51, rgba_g = 127, rgba_b = 0, rgba_a = 255
	}, purchasable=true, tech_level=8,
	icon_name="equip_mining_laser"
})
laser.small_plasma_accelerator = LaserType.New({
	l10n_key="SMALL_PLASMA_ACCEL", price=120000, capabilities={mass=22},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=50000, rechargeTime=0.3, length=42,
		width=7, beam=0, dual=0, mining=0, rgba_r = 51, rgba_g = 255, rgba_b = 255, rgba_a = 255
	}, purchasable=true, tech_level=10,
	icon_name="equip_plasma_accelerator"
})
laser.large_plasma_accelerator = LaserType.New({
	l10n_key="LARGE_PLASMA_ACCEL", price=390000, capabilities={mass=50},
	slots = {"laser_front", "laser_rear"}, laser_stats = {
		lifespan=8, speed=1000, damage=100000, rechargeTime=0.3, length=42,
		width=7, beam=0, dual=0, mining=0, rgba_r = 127, rgba_g = 255, rgba_b = 255, rgba_a = 255
	}, purchasable=true, tech_level=12,
	icon_name="equip_plasma_accelerator"
})
