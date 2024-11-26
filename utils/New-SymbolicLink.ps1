#Requires -Version 5.1

function New-SymbolicLink {
  [CmdletBinding()]
  param (
    # Value
    [Parameter(Mandatory = $true)]
    [string]
    $Value,
    # Source
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [Parameter()]
    [Alias('j')]
    [switch]
    [bool]
    $Junction = $false,
    [Parameter()]
    [Alias('h')]
    [switch]
    [bool]
    $HardLink = $false
  )
  
  process {
    if ($J) {
      New-Item -Type Junction -Path $Path -Value $Value
    }
    elseif ($H) {
      New-Item -Type HardLink -Path $Path -Value $Value
    }
    else {
      New-Item -Type SymbolicLink -Path $Path -Value $Value
    }
  }
}

if ($PSVersionTable.Platform -eq 'Win32NT') {
  Set-Alias -Name ln -Value New-SymbolicLink
}
