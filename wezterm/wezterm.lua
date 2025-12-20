local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

local mux = wezterm.mux

-- Colorscheme
config.color_scheme = 'Catppuccin Frappe'

-- JetBrains Mono Nerd Font
config.font =
    wezterm.font('JetBrains Mono', { weight = 'Regular', italic = false })

-- Font size
config.font_size = 14.0

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.disable_default_key_bindings = true
config.keys = {
  { key = 'q', mods = 'CMD', action = act.QuitApplication },
  { key = 'r', mods = 'CMD', action = act.ReloadConfiguration },
  { key = 'd', mods = 'CMD', action = act.ShowDebugOverlay },

  { key = 'n', mods = 'CMD', action = act.SpawnTab "CurrentPaneDomain" },
  { key = 'x', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },

  { key = 'h', mods = 'CMD', action = act.MoveTabRelative(-1) },
  { key = 'l', mods = 'CMD', action = act.MoveTabRelative(1) },

  { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
}

return config
