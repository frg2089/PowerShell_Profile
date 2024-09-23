#Requires -Version 5.1

function ConvertFrom-Base64 {
  [CmdletBinding()]
  param (
    # Data
    [Parameter(Mandatory)]
    [string]
    $Data,
    # Encoding
    [Parameter()]
    [System.Text.Encoding]
    $Encoding = [System.Text.Encoding]::UTF8
  )

  process {
    $Encoding.GetString([System.Convert]::FromBase64String($Data))
  }
}

function ConvertTo-Base64 {
  [CmdletBinding()]
  param (
    # Data
    [Parameter(Mandatory)]
    [string]
    $String,
    # Encoding
    [Parameter()]
    [System.Text.Encoding]
    $Encoding = [System.Text.Encoding]::UTF8
  )

  process {
    [System.Convert]::ToBase64String($Encoding.GetBytes($String))
  }
}