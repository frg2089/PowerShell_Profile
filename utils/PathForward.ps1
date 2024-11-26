#Requires -Version 5.1

function Set-LocationToParent {
  Set-Location ..
}

Set-Alias -Name .. -Value Set-LocationToParent