# $HOME/Documents/PowerShell/Profile.ps1

# Alias first party tools and commands
New-Alias e Explorer
New-Alias hash Get-FileHash
New-Alias touch New-Item

# Alias third party tools and commands
New-Alias vi nvim
New-Alias vim nvim

# Extensions
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias -Name cd -Value z -Option AllScope -Scope Global -Force
