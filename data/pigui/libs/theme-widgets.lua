-- Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local ui = require 'pigui.baseui'
local theme = ui.theme

local _defaultIconSize = ui.rescaleUI(Vector2(24, 24), Vector2(1600, 900))
local _defaultFramePadding = 1
local _largeIconSize = ui.rescaleUI(Vector2(32, 32), Vector2(1600, 900))
local _largeFramePadding = 1

theme.sizes = {
	iconButton = _defaultIconSize,
	iconButtonL = _largeIconSize
}

local function setAlpha(c, a) return Color(c.r, c.g, c.b, a) end

function theme.iconButton(icon, tooltip, size)
	size = size or _defaultIconSize
	return ui.coloredSelectedIconButton(icon, size, false, _defaultFramePadding, theme.colors.buttonBlue, theme.colors.font, tooltip)
end

function theme.iconToggleButton(icon, enabled, tooltip, size)
	size = size or _defaultIconSize
	return ui.coloredSelectedIconButton(icon, size, enabled, _defaultFramePadding, theme.colors.buttonBlue, theme.colors.font, tooltip)
end

function theme.iconTristateButton(icon, state, enabled, tooltip, size)
	size = size or _defaultIconSize
	enabled = enabled == nil or enabled
	local col = enabled and theme.colors.buttonBlue or (state and theme.colors.buttonBlue:opacity(120) or theme.colors.buttonBlue:opacity(40))
	return ui.coloredSelectedIconButton(icon, size, state, _defaultFramePadding, col, theme.colors.font, tooltip)
end

function theme.iconButtonL(icon, tooltip, size)
	size = size or _largeIconSize
	return ui.coloredSelectedIconButton(icon, size, false, _largeFramePadding, theme.colors.buttonBlue, theme.colors.font, tooltip)
end

function theme.iconToggleButtonL(icon, enabled, tooltip, size)
	size = size or _largeIconSize
	return ui.coloredSelectedIconButton(icon, size, enabled, _largeFramePadding, theme.colors.buttonBlue, theme.colors.font, tooltip)
end

function theme.iconTristateButtonL(icon, state, enabled, tooltip, size)
	size = size or _largeIconSize
	enabled = enabled == nil or enabled
	local col = enabled and theme.colors.buttonBlue or (state and theme.colors.buttonBlue:opacity(120) or theme.colors.buttonBlue:opacity(40))
	return ui.coloredSelectedIconButton(icon, size, state, _largeFramePadding, col, theme.colors.font, tooltip)
end
