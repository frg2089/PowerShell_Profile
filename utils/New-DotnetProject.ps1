#Requires -Version 7.4

function New-DotnetProject {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]
    $SdkVersion
  )
  
  process {
    New-Item -ItemType 'Directory' -Name 'src'
    Invoke-WebRequest -Uri https://frg2089.mit-license.org/license.txt -OutFile LICENSE
    dotnet new nugetconfig
    dotnet new gitignore
    dotnet new editorconfig
    dotnet new buildprops
    dotnet new buildtargets
    dotnet new packagesprops
    dotnet new sln
    dotnet new globaljson --roll-forward major --sdk-version $SdkVersion
    git init .
    git add .
    git commit -m ':tada: Initialize'
  }
}
