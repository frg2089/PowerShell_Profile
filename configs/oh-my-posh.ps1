#Requires -Version 7.4
#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.PSResourceGet

$Private:ConfigPath = Join-Path $PSScriptRoot '..' '.shimakaze.omp.json'

# Use Oh-My-Posh
if (Test-Path -LiteralPath $Private:ConfigPath) {
  if ($PSVersionTable.Platform -eq 'Win32NT') {
    where.exe /Q oh-my-posh
  }
  else {
    # TODO: 其他操作系统的检测方法
  }
  if ($LASTEXITCODE -eq 0) {
    Install-PSResourceAndImport -Name posh-git
    function Set-PoshGitStatus {
      $global:GitStatus = Get-GitStatus
      $env:POSH_GIT_STRING = Write-GitStatus -Status $global:GitStatus
    }
    New-Alias -Name 'Set-PoshContext' -Value 'Set-PoshGitStatus' -Scope Global -Force

    oh-my-posh init pwsh --config=$Private:ConfigPath | Invoke-Expression
  }
}