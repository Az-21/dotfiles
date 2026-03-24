local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Use PowerShell 7+ instead of CMD
local is_windows = wezterm.target_triple:find("windows") ~= nil
if is_windows then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Appearance
config.color_scheme = "Monokai Remastered"
config.font = wezterm.font "MonaspiceAr Nerd Font"
config.font_size = 16
config.initial_cols = 120
config.initial_rows = 30


config.window_padding = {
  left = 12,
  right = 12,
  top = 8,
  bottom = 8,
}

config.hide_mouse_cursor_when_typing = true

-- Keyboard
local act = wezterm.action

config.keys = {
  -- Split panes
  { key = "d", mods = "SUPER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Navigate panes
  { key = "LeftArrow",  mods = "SUPER|OPT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "SUPER|OPT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "SUPER|OPT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow",  mods = "SUPER|OPT", action = act.ActivatePaneDirection("Down") },

  -- New tab
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },

  -- Close tab / pane
  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Cycle tabs
  { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(1) },

  -- Font size
  { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
  { key = "0", mods = "SUPER", action = act.ResetFontSize },

  -- Fullscreen
  { key = "Enter", mods = "SUPER", action = act.ToggleFullScreen },

  -- Copy / Paste
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

  -- Search
  { key = "f", mods = "SUPER", action = act.Search({ CaseInSensitiveString = "" }) },

  -- Reload config
  { key = "r", mods = "SUPER|SHIFT", action = act.ReloadConfiguration },
}

config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
