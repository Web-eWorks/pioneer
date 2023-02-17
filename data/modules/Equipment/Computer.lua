-- Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local EquipType = require 'EquipType'.EquipType
local Equipment = package.core.Equipment

local misc = Equipment.misc

misc.autopilot = EquipType.New({
	l10n_key="AUTOPILOT", slots="autopilot", price=1400,
	capabilities={mass=1, set_speed=1, autopilot=1}, purchasable=true, tech_level=1,
	icon_name="equip_autopilot"
})
misc.target_scanner = EquipType.New({
	l10n_key="TARGET_SCANNER", slots="target_scanner", price=900,
	capabilities={mass=1, target_scanner_level=1}, purchasable=true, tech_level=9,
	icon_name="equip_scanner"
})
misc.advanced_target_scanner = EquipType.New({
	l10n_key="ADVANCED_TARGET_SCANNER", slots="target_scanner", price=1200,
	capabilities={mass=1, target_scanner_level=2}, purchasable=true, tech_level="MILITARY",
	icon_name="equip_scanner"
})
misc.trade_computer = EquipType.New({
	l10n_key="TRADE_COMPUTER", slots="trade_computer", price=400,
	capabilities={mass=0, trade_computer=1}, purchasable=true, tech_level=9,
	icon_name="equip_trade_computer"
})
misc.hypercloud_analyzer = EquipType.New({
	l10n_key="HYPERCLOUD_ANALYZER", slots="hypercloud", price=1500,
	capabilities={mass=1, hypercloud_analyzer=1}, purchasable=true, tech_level=10,
	icon_name="equip_scanner"
})
