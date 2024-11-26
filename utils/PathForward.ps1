#Requires -Version 5.1

function Set-LocationToParent {
  $Private:ParentPath = Join-Path $PWD '..'
  $Private:ParentPath = Convert-Path $Private:ParentPath
  Set-Location $Private:ParentPath
}

Set-Alias -Name .. -Value Set-LocationToParent