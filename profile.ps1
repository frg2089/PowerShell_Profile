#Requires -Version 7.4
#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.PSResourceGet

# Import Utils
$Private:UtilsPath = Join-Path $PSScriptRoot 'utils'
if (Test-Path -LiteralPath $Private:UtilsPath) {
  Get-ChildItem $Private:UtilsPath `
  | Where-Object Extension -EQ '.ps1' `
  | ForEach-Object { . $PSItem }
}

# Predictors
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Install-PSResourceAndImport -Name CompletionPredictor

# Import Configurations
$Private:ConfigurationsPath = Join-Path $PSScriptRoot 'configs'
if (Test-Path -LiteralPath $Private:ConfigurationsPath) {
  Get-ChildItem $Private:ConfigurationsPath `
  | Where-Object Extension -EQ '.ps1' `
  | ForEach-Object { . $PSItem }
}