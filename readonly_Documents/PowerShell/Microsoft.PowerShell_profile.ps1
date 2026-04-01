# Remove Conflicting Default PowerShell Aliases
$conflicting = @("cat", "cd", "ls", "tree")
foreach ($alias in $conflicting) {
    if (Test-Path "Alias:\$alias") {
        Remove-Item "Alias:\$alias" -Force
    }
}

# Modern Tooling
Set-Alias cat bat
Set-Alias cd zoxide
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

# fzf terminal history
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
    $buffer = ""
    $cursor = 0
    # Capture what is currently typed in the prompt
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursor)

    # Locate the global PowerShell history file
    $historyPath = (Get-PSReadLineOption).HistorySavePath

    if (Test-Path $historyPath) {
        $selected = Get-Content $historyPath | fzf --query="$buffer" --tac --tiebreak=index

        if (-not [string]::IsNullOrWhiteSpace($selected)) {
            # Replace the current line with the fzf selection
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $buffer.Length, $selected)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selected.Length)
        }
    }
}

# Time savers
Set-Alias hash Get-FileHash
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
fnm env --shell powershell | Out-String | Invoke-Expression
