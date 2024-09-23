#Requires -Version 5.1

function New-File {
  [CmdletBinding()]
  param (
    # File Name
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]
    $Path
  )
  
  process {
    $Path | ForEach-Object { New-Item -Type File -Path $_ }
  }
}

if ($PSVersionTable.Platform -eq 'Win32NT') {
  Set-Alias -Name touch -Value New-File
}