use std/util "path add"

# Core
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.config.buffer_editor = "nvim"
#
$env.config.auto_cd_implicit = true
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = false
$env.config.completions.persistent_menus = true
$env.config.filesize.unit = "binary"
$env.config.highlight_resolved_externals = true
$env.config.rm.always_trash = true
$env.config.table.index_mode = "auto"

# https://github.com/wezterm/wezterm/discussions/5859
if ($env.TERM_PROGRAM? == "WezTerm") {
    $env.config.shell_integration.osc133 = false
}

# Modern tooling
alias cat = bat
alias vi = nvim
alias vim = nvim

# Arch installs zed as `zeditor`; everywhere else it's `zed`
def --wrapped zed [...args] {
    let bin = if (which zeditor | is-not-empty) { "zeditor" } else { "zed" }
    run-external $bin ...$args
}

# Copy to clipboard
def clipboard []: any -> nothing {
    let text = $in | into string | str trim --right --char (char nl)
    match $nu.os-info.name {
        "macos" => { $text | ^pbcopy }
        "windows" => { $text | ^clip.exe }
        _ => { $text | ^wl-copy }
    }
}

# GitHub Desktop Plus
def --wrapped gitui [...args] {
    job spawn { ^desktop-plus-cli ...$args } | ignore
}

# Soruce
use ($nu.default-config-dir | path join "functions.nu") *
use ($nu.data-dir | path join "init" "mise.nu")
source ($nu.data-dir | path join "init" "atuin.nu")
source ($nu.data-dir | path join "init" "carapace.nu")
source ($nu.data-dir | path join "init" "starship.nu")
source ($nu.data-dir | path join "init" "tv.nu")
source ($nu.data-dir | path join "init" "zoxide.nu")

# Welcome
fastfetch --logo-type small --structure Title:OS:Kernel:Memory:CPU:GPU
$env.config.show_banner = "short"
