#Requires -Version 7.4
#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.PSResourceGet

function Test-InstalledPSResource {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Name
  )

  begin {
    if ($Global:PSResources -isnot [object[]]) {
      $Global:PSResources = Get-InstalledPSResource
    }
  }

  process {
    $Private:Result = $Global:PSResources | Where-Object Name -EQ $Name

    return $null -ne $Private:Result   
  }
}
function Install-PSResourceAndImport {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Name
  )

  process {
    $Private:Result = Test-InstalledPSResource -Name $Name
    if (!$Private:Result) {
      Install-PSResource -Name $Name -Repository PSGallery -TrustRepository
    }

    Import-Module -Name $Name
  }
}