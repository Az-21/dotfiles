# Remove Conflicting Default PowerShell Aliases
$conflicting = @("cat", "cd", "ls", "tree")
foreach ($alias in $conflicting) {
    if (Test-Path "Alias:\$alias") {
        Remove-Item "Alias:\$alias" -Force
    }
}

# Modern Tooling
Set-Alias cat bat
Set-Alias cd z
Set-Alias find fd
Set-Alias grep rg
Set-Alias vi nvim
Set-Alias vim nvim
function pip { uv pip @args }
function venv { uv venv @args }

# eza (ls/tree replacements)
function la { eza --icons --group-directories-first -la --header --git @args }
function ll { eza --icons --group-directories-first -l --header --git @args }
function ls { eza --icons --group-directories-first @args }
function lt { eza --icons --tree --level=2 --group-directories-first @args }
function lta { eza --icons --tree --level=2 -a --group-directories-first @args }
function tree { eza --icons --tree --group-directories-first @args }

# yazi — open file manager in current dir, cd into last visited dir on exit
function y {
    # Generate a temporary file path
    $tmp = [System.IO.Path]::GetTempFileName()

    # Run yazi, passing all arguments
    yazi @args --cwd-file="$tmp"

    # Read the file and change directory if valid
    if (Test-Path $tmp) {
        $cwd = Get-Content -Path $tmp -Raw
        if (![string]::IsNullOrWhiteSpace($cwd) -and $cwd.Trim() -ne $PWD.Path) {
            z $cwd.Trim()
        }
        Remove-Item -Path $tmp -Force
    }
}

# Autocomplete
# Case-insensitive completion is the default in PowerShell.
# For advanced menu selection similar to Zsh, PSReadLine handles this natively.
Set-PSReadLineOption -PredictionSource History # (Optional: Enables ghost-text suggestions)

# Time savers
Set-Alias hash Get-FileHash
function touch { $args | ForEach-Object { New-Item -ItemType File -Path $_ -Force } }

# Initialize Tools
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# Invoke-Expression (&fnm env --use-on-cd --shell powershell)
atuin init powershell | Out-String | Invoke-Expression
