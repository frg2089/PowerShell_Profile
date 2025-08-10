#Requires -Version 7.4

function New-DotnetProject {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $SdkVersion,
    [switch]
    $Slnx,
    [switch]
    $BuildTargets
  )
  
  process {
    New-Item -ItemType 'Directory' -Name 'src'
    Invoke-WebRequest -Uri https://frg2089.mit-license.org/license.txt -OutFile LICENSE
    dotnet new nugetconfig
    dotnet new gitignore
    dotnet new editorconfig
    dotnet new buildprops
    if ($BuildTargets) {
      dotnet new buildtargets
    }
    dotnet new packagesprops
    if ($Slnx) {
      dotnet new sln --format slnx
    }
    else {
      dotnet new sln
    }
    dotnet new globaljson --roll-forward latestMajor --sdk-version $SdkVersion
    git init .
    git add .
    git commit -m ':tada: Initialize'
  }
}
