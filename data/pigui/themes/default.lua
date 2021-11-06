-- Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local theme = {}

-- theme.styleColors
-- This table provides a coherent theme palette that can be referenced by
-- component-specific semantic colors for consistent styling across the UI
--
-- The gray_*, primary_*, and accent_* colors define nine style breakpoints,
-- whereas the success_* (green), warning_* (orange) and danger_* (red)
-- colors define only five due to their more limited utility.
--
-- Ideally we'd like to drop a few of these breakpoints and consolidate the
-- main UI further, but the significant number of elements in need of color
-- makes that somewhat difficult.
local styleColors = {
	black			= Color "000000",
	transparent		= Color "00000000",
	white	 		= Color "FFFFFF",
	unknown			= Color "FF00FF",

	gray_100 		= Color "F4F4F5",
	gray_200 		= Color "DEDEE0",
	gray_300 		= Color "C8C8C8",
	gray_400 		= Color "969696",
	gray_500 		= Color "787878",
	gray_600 		= Color "5A5B5D",
	gray_700 		= Color "3C3E42",
	gray_800 		= Color "24242B",
	gray_900 		= Color "131315",

	primary_100		= Color "B5BCE3",
	primary_200		= Color "9CA0E2",
	primary_300		= Color "8A8FD6",
	primary_400		= Color "767CCB",
	primary_500		= Color "5F64B4",
	primary_600		= Color "4B4E95",
	primary_700		= Color "323267",
	primary_800		= Color "1B1B46",
	primary_900		= Color "0F0F2E",

	accent_100		= Color "9DBEE7",
	accent_200		= Color "6DA6EE",
	accent_300		= Color "3C8CF1",
	accent_400		= Color "2881F1",
	accent_500		= Color "1770EE",
	accent_600		= Color "0F4FC7",
	accent_700		= Color "06318E",
	accent_800		= Color "041853",
	accent_900		= Color "050E29",

	success_100		= Color "CAF8A8",
	success_300		= Color "77EE21",
	success_500		= Color "5ACC0A",
	success_700		= Color "317005",
	success_900		= Color "102502",

	warning_100		= Color "FFD391",
	warning_300		= Color "FFA431",
	warning_500		= Color "FF8000",
	warning_700		= Color "894400",
	warning_900		= Color "401F00",

	danger_100		= Color "EC6C6C",
	danger_300		= Color "FF2A2A",
	danger_500		= Color "C51010",
	danger_700		= Color "8C0606",
	danger_900		= Color "2C0505",
}

theme.styleColors = styleColors

theme.colors = {
	reticuleCircle			= styleColors.gray_300,
	reticuleCircleDark		= styleColors.gray_400,
	frame					= styleColors.gray_300,
	frameDark				= styleColors.gray_500,
	navTarget				= styleColors.warning_100,
	navTargetDark			= styleColors.warning_300,
	combatTarget			= styleColors.danger_300,
	combatTargetDark		= styleColors.danger_500,

	navigationalElements	= styleColors.gray_300,
	deltaVCurrent			= styleColors.gray_400,
	deltaVManeuver			= styleColors.primary_300,
	deltaVRemaining			= styleColors.gray_100,
	deltaVTotal				= styleColors.gray_600:opacity(0.75),
	brakeBackground			= styleColors.gray_600:opacity(0.75),
	brakePrimary			= styleColors.gray_300,
	brakeSecondary			= styleColors.gray_500,
	brakeNow				= styleColors.success_500,
	brakeOvershoot			= styleColors.danger_500,
	maneuver				= styleColors.accent_300,
	maneuverDark			= styleColors.accent_500,
	mouseMovementDirection	= styleColors.accent_100,
	-- FIXME: this color is primarily used to tint buttons by rendering over top of the frame color.
	-- This is atrocious for obvious reasons. Refactor button / frame rendering to draw an independent frame border.
	lightBlueBackground		= styleColors.primary_700:opacity(0.10),
	lightBlackBackground	= styleColors.black:opacity(0.40),
	blueBackground			= styleColors.primary_900,
	blueFrame				= styleColors.accent_100:shade(0.50),
	tableHighlight			= styleColors.primary_700,
	tableSelection			= styleColors.accent_300:shade(0.40),
	commsWindowBackground	= styleColors.primary_700:opacity(0.30),
	buttonBlue				= styleColors.primary_300,
	buttonInk				= styleColors.white,

	unknown					= styleColors.unknown, -- used as an invalid color
	transparent				= styleColors.transparent,
	font					= styleColors.white,
	white					= styleColors.white,
	lightGrey				= styleColors.gray_300,
	grey					= styleColors.gray_500,
	black					= styleColors.black,

	alertYellow				= styleColors.warning_300,
	alertRed				= styleColors.danger_500,
	hyperspaceInfo			= styleColors.success_300,

	econProfit				= styleColors.success_500,
	econLoss				= styleColors.danger_300,
	econMajorExport			= styleColors.success_300,
	econMinorExport			= styleColors.success_500,
	econMajorImport			= styleColors.accent_300,
	econMinorImport			= styleColors.accent_500,
	econIllegalCommodity	= styleColors.danger_300,

	gaugeBackground			= styleColors.gray_800:opacity(0.85),
	gaugePressure			= styleColors.primary_600,
	gaugeTemperature		= styleColors.danger_500,
	gaugeShield				= styleColors.primary_300,
	gaugeHull				= styleColors.gray_200,
	gaugeWeapon				= styleColors.warning_300,
	gaugeVelocityLight		= styleColors.gray_100,
	gaugeVelocityDark		= styleColors.gray_800,
	gaugeThrustLight		= styleColors.gray_500,
	gaugeThrustDark			= styleColors.gray_900,
	gaugeEquipmentMarket	= styleColors.primary_600,

	radarCargo				= styleColors.primary_200,
	radarCloud				= styleColors.primary_200,
	radarCombatTarget		= styleColors.danger_500,
	radarMissile			= styleColors.danger_300,
	radarPlayerMissile		= styleColors.accent_400,
	radarNavTarget			= styleColors.success_500,
	radarShip				= styleColors.warning_500,
	radarStation			= styleColors.accent_300,

	systemMapGrid			= styleColors.gray_800,
	systemMapGridLeg		= styleColors.gray_500,
	systemMapObject			= styleColors.gray_300,
	systemMapPlanner		= styleColors.primary_500,
	systemMapPlannerOrbit	= styleColors.primary_500,
	systemMapPlayer			= styleColors.accent_300,
	systemMapPlayerOrbit	= styleColors.accent_300,
	systemMapShip			= styleColors.gray_300,
	systemMapShipOrbit		= styleColors.accent_700,
	systemMapSelectedShipOrbit = styleColors.warning_500,
	systemMapSystemBody		= styleColors.primary_100:shade(0.5),
	systemMapSystemBodyIcon	= styleColors.gray_300,
	systemMapSystemBodyOrbit = styleColors.success_500,
	systemMapLagrangePoint	= styleColors.accent_200,

	sectorMapLabelHighlight = styleColors.white:opacity(0.5),
	sectorMapLabelShade = styleColors.primary_700:opacity(0.8)
}

-- ImGui global theming styles
theme.styles = {
	WindowBorderSize = 0.0,
}

theme.icons = {
	-- first row
	prograde = 0,
	retrograde = 1,
	radial_out = 2,
	radial_in = 3,
	antinormal = 4,
	normal = 5,
	frame = 6,
	maneuver = 7,
	forward = 8,
	backward = 9,
	down = 10,
	right = 11,
	up = 12,
	left = 13,
	bullseye = 14,
	square = 15,
	-- second row
	prograde_thin = 16,
	retrograde_thin = 17,
	radial_out_thin = 18,
	radial_in_thin = 19,
	antinormal_thin = 20,
	normal_thin = 21,
	frame_away = 22,
	direction = 24,
	direction_hollow = 25,
	direction_frame = 26,
	direction_frame_hollow = 27,
	direction_forward = 28,
	semi_major_axis = 31,
	-- third row
	heavy_fighter = 32,
	medium_fighter = 33,
	light_fighter = 34,
	sun = 35,
	asteroid_hollow = 36,
	current_height = 37,
	current_periapsis = 38,
	current_line = 39,
	current_apoapsis = 40,
	eta = 41,
	altitude = 42,
	gravity = 43,
	eccentricity = 44,
	inclination = 45,
	longitude = 46,
	latitude = 47,
	-- fourth row
	heavy_courier = 48,
	medium_courier = 49,
	light_courier = 50,
	rocky_planet = 51,
	ship = 52,
	landing_gear_up = 53,
	landing_gear_down = 54,
	ecm = 55,
	rotation_damping_on = 56,
	rotation_damping_off = 57,
	hyperspace = 58,
	hyperspace_off = 59,
	scanner = 60,
	message_bubble = 61,
	fuel = 63,
	-- fifth row
	heavy_passenger_shuttle = 64,
	medium_passenger_shuttle = 65,
	light_passenger_shuttle = 66,
	moon = 67,
	autopilot_set_speed = 68,
	autopilot_manual = 69,
	autopilot_fly_to = 70,
	autopilot_dock = 71,
	autopilot_hold = 72,
	autopilot_undock = 73,
	autopilot_undock_illegal = 74,
	autopilot_blastoff = 75,
	autopilot_blastoff_illegal = 76,
	autopilot_low_orbit = 77,
	autopilot_medium_orbit = 78,
	autopilot_high_orbit = 79,
	-- sixth row
	heavy_passenger_transport = 80,
	medium_passenger_transport = 81,
	light_passenger_transport = 82,
	gas_giant = 83,
	time_accel_stop = 84,
	time_accel_paused = 85,
	time_accel_1x = 86,
	time_accel_10x = 87,
	time_accel_100x = 88,
	time_accel_1000x = 89,
	time_accel_10000x = 90,
	pressure = 91,
	shield = 92,
	hull = 93,
	temperature = 94,
	rotate_view = 95,
	-- seventh row
	heavy_cargo_shuttle = 96,
	medium_cargo_shuttle = 97,
	light_cargo_shuttle = 98,
	spacestation = 99,
	time_backward_100x = 100,
	time_backward_10x = 101,
	time_backward_1x = 102,
	time_center = 103,
	time_forward_1x = 104,
	time_forward_10x = 105,
	time_forward_100x = 106,
	filter_bodies = 107,
	filter_stations = 108,
	filter_ships = 109,
	lagrange_marker = 110,
	system_overview_vertical = 111,
	-- eighth row
	heavy_freighter = 112,
	medium_freighter = 113,
	light_freighter = 114,
	starport = 115,
	warning_1 = 116,
	warning_2 = 117,
	warning_3 = 118,
	-- moon = 119, -- smaller duplicate of 67
	combattarget = 120,
	navtarget = 121,
	alert1 = 122,
	alert2 = 123,
	ecm_advanced = 124,
	systems_management = 125,
	distance = 126,
	filter = 127,
	-- ninth row
	view_internal = 128,
	view_external = 129,
	view_sidereal = 130,
	comms = 131,
	market = 132,
	bbs = 133,
	equipment = 134,
	repairs = 135,
	info = 136,
	personal_info = 137,
	personal = 138,
	roster = 139,
	map = 140,
	sector_map = 141,
	system_map = 142,
	system_overview = 143,
	-- tenth row
	galaxy_map = 144,
	settings = 145,
	language = 146,
	controls = 147,
	sound = 148,
	new = 149,
	skull = 150,
	mute = 151,
	unmute = 152,
	music = 153,
	zoom_in = 154,
	zoom_out = 155,
	search_lens = 156,
	message = 157,
	message_open = 158,
	search_binoculars = 159,
	-- eleventh row
	planet_grid = 160,
	bookmarks = 161,
	unlocked = 162,
	locked = 163,
	-- EMPTY = 164,
	label = 165,
	broadcast = 166,
	shield_other = 167,
	hud = 168,
	factory = 169,
	star = 170,
	delta = 171,
	clock = 172,
	orbit_prograde = 173,
	orbit_normal = 174,
	orbit_radial = 175,
	-- twelfth row
	-- BBS replacement icons
	-- TODO: mission display needs to be converted to use these instead of loading individual icons from disk
	-- mission_default = 176,
	alert_generic = 177,
	-- fuel_radioactive = 178,
	-- assassination = 179,
	money = 180,
	-- news = 181,
	-- crew = 182, -- duplicate of 138
	-- taxi = 183,
	-- taxi_urgent = 184,
	-- haul = 185,
	-- haul_urgent = 186,
	-- delivery = 187,
	-- delivery_urgent = 188,
	-- goodstrader = 189, -- duplicate of 132
	-- servicing_repair = 190,
	view_flyby = 191,
	-- thirteenth row
	cog = 192,
	gender = 193,
	nose = 194,
	mouth = 195,
	hair = 196,
	clothes = 197,
	accessories = 198,
	random = 199,
	periapsis = 200,
	apoapsis = 201,
	reset_view = 202,
	toggle_grid = 203,
	plus = 204,
	-- EMPTY = 205
	decrease = 206,
	increase = 207,
	-- fourteenth row, wide icons
	missile_unguided = 208,
	missile_guided = 210,
	missile_smart = 212,
	missile_naval = 214,
	find_person = 216,
	cargo_manifest = 217,
	trashcan = 218,
	bookmark = 219,
	pencil = 220,
	fountain_pen = 221,
	cocktail_glass = 222,
	beer_glass = 223,
	-- fifteenth row
	chart = 224,
	binder = 225,
	-- navtarget = 226,		-- duplicate of 121
	ships_no_orbits = 227,	-- duplicate of 52
	ships_with_orbits = 228,
	lagrange_no_text = 229,
	lagrange_with_text = 230,
	route = 231,
	route_destination = 232,
	route_dist = 233,
	impact_warning = 234,
	econ_major_import = 235,
	econ_minor_import = 236,
	econ_major_export = 237,
	econ_minor_export = 238,
	cargo_crate = 239,
	-- sixteenth row
	econ_profit = 240,
	econ_loss = 241,
	starport_surface = 242,
	outpost_tiny = 243,
	outpost_small = 244,
	outpost_medium = 245,
	outpost_large = 246,
	station_orbital_large = 247,
	station_orbital_small = 248,
	station_observatory = 249,
	cargo_crate_illegal = 255,

	-- TODO: manual / autopilot
	-- dummy, until actually defined correctly
	mouse_move_direction = 14,
}

return theme
