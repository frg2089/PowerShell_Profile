#Requires -Version 7.4
#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.PSResourceGet

$Private:Result = Test-InstalledPSResource -Name PSCompletions
if (!$Private:Result) {
  Install-PSResource -Name PSCompletions -Repository PSGallery -TrustRepository
}

Import-Module -Name PSCompletions
