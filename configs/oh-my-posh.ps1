#Requires -Version 7.4
#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.PSResourceGet

Get-Command oh-my-posh -ErrorAction Continue | Out-Null
if (-not $?) {
  return
}

$Private:ConfigPath = Join-Path $PSScriptRoot '..' '.shimakaze.omp.json'

# Use Oh-My-Posh
if (-not (Test-Path -LiteralPath $Private:ConfigPath)){
  return
} 

# Install-PSResourceAndImport -Name posh-git
# function Set-PoshGitStatus {
#   $global:GitStatus = Get-GitStatus
#   $env:POSH_GIT_STRING = Write-GitStatus -Status $global:GitStatus
# }
# New-Alias -Name 'Set-PoshContext' -Value 'Set-PoshGitStatus' -Scope Global -Force

oh-my-posh init pwsh --config=$Private:ConfigPath | Invoke-Expression