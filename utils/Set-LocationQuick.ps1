#Requires -Version 5.1

function Set-LocationQuick {
  [CmdletBinding()]
  param (
    [string]$QuickPath = '..'
  )
  
  process {
    $Private:Target = Get-Location
    for ($i = 0; $i -lt $QuickPath.Length - 1; $i++) {
      $Private:Target = Split-Path $Private:Target
    }
    $Private:Target = Convert-Path $Private:Target
    Set-Location $Private:Target
  }
}