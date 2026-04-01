local wezterm = require("wezterm")
local config = wezterm.config_builder()

---- OS Detection
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_macos = wezterm.target_triple:find("darwin") ~= nil

if is_linux then
  -- Use zsh
  config.default_prog = { "zsh" }
end

if is_macos then
  -- Hide window decorations on Linux and macOS
  config.window_decorations = "RESIZE"
end

if is_windows then
  -- Use PowerShell 7+
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

---- Appearance & Behavior
config.font = wezterm.font_with_fallback {
  "Monaspace Argon NF",
  "JetBrains Mono",
}
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
config.scrollback_lines = 10000

-- Tab Bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

-- Cursor
config.default_cursor_style = "SteadyBlock"

---- Keyboard Shortcuts
local act = wezterm.action

-- Define the Leader key (CTRL + Space)
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Split panes
  { key = "d", mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Navigate panes
  { key = "LeftArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },

  -- Tabs
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },

  -- QuickSelect (Extracts URLs, IP addresses, paths, etc.)
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },

  -- Font size
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },

  -- Fullscreen
  { key = "Enter", mods = "CTRL|SHIFT", action = act.ToggleFullScreen },

  -- Copy / Paste
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- Search
  { key = "f", mods = "CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },

  -- Reload config
  { key = "r", mods = "CTRL|SHIFT|ALT", action = act.ReloadConfiguration },
}

config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
