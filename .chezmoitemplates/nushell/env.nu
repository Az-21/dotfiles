let init_dir = ($nu.data-dir | path join "init")
mkdir $init_dir

let tools = {
    mise:     { mise activate nu }
    atuin:    { atuin init nu }
    starship: { starship init nu }
    zoxide:   { zoxide init nushell }
}

for t in ($tools | transpose name init) {
    let file = ($init_dir | path join $"($t.name).nu")
    let bin = (which $t.name | get path.0?)
    if $bin == null {
        if not ($file | path exists) { "" | save $file }
        continue
    }
    let stale = (not ($file | path exists)) or ((ls ($bin | path expand) | get modified.0) > (ls $file | get modified.0))
    if $stale {
        let out = (do $t.init)
        if ($out | is-not-empty) {
            $out | save -f $"($file).tmp"
            mv -f $"($file).tmp" $file
        }
    }
}
