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

# eza (ls/tree replacements)
function la { eza --icons --group-directories-first -la --header --git @args }
function ll { eza --icons --group-directories-first -l --header --git @args }
function ls { eza --icons --group-directories-first @args }
function lt { eza --icons --tree --level=2 --group-directories-first @args }
function lta { eza --icons --tree --level=2 -a --group-directories-first @args }
function tree { eza --icons --tree --group-directories-first @args }

# Consistent utility across OSes
function clipboard { Set-Clipboard $args }
function hash { Get-FileHash $args }
function open { explorer $args }
function touch { $args | ForEach-Object { New-Item -ItemType File -Path $_ -Force } }

# Add folder to PATH
# Add-Path -NewPath "C:\full\path\here"
# Add-Path -NewPath "C:\full\path\here" -Scope Machine
function Add-Path {
    param(
        [Parameter(Mandatory=$true)]
        [string]$NewPath,
        [System.EnvironmentVariableTarget]$Scope = [System.EnvironmentVariableTarget]::User
    )

    $current = [System.Environment]::GetEnvironmentVariable("Path", $Scope)
    $updatedParts = ($current -split ';' | Where-Object { $_ }) + $NewPath | Select-Object -Unique
    [System.Environment]::SetEnvironmentVariable("Path", ($updatedParts -join ';'), $Scope)
}

# Initialize Tools
(&mise activate pwsh) | Out-String | Invoke-Expression
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
atuin init powershell | Out-String | Invoke-Expression
