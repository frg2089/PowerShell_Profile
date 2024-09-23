#Requires -Version 5.1

# 注册 git
Import-Module posh-git

# 注册 Oh-My-Posh
if (Test-Path "$PSScriptRoot\.shimakaze.omp.json") {
  try {
    Get-Command oh-my-posh

    function Set-PoshGitStatus {
      $global:GitStatus = Get-GitStatus
      $env:POSH_GIT_STRING = Write-GitStatus -Status $global:GitStatus
    }
    New-Alias -Name 'Set-PoshContext' -Value 'Set-PoshGitStatus' -Scope Global -Force

    oh-my-posh init pwsh --config="$PSScriptRoot\.shimakaze.omp.json" | Invoke-Expression
  }
  catch {
    Write-Debug -Message 'Skip init oh-my-posh'
  }
}

# 注册自动补全
if (Test-Path -LiteralPath $PSScriptRoot\Completions) {
  Get-ChildItem $PSScriptRoot\Completions `
  | Where-Object Extension -EQ '.ps1' `
  | ForEach-Object { . $PSItem }
}

# 注册实用脚本
if (Test-Path -LiteralPath $PSScriptRoot\Utils) {
  Get-ChildItem $PSScriptRoot\Utils `
  | Where-Object Extension -EQ '.ps1' `
  | ForEach-Object { . $PSItem }
}