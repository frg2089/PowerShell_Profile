#Requires -Version 7.4

function Add-DotnetProjects {
  [CmdletBinding()]
  param (
    [string]
    $Solution,
    [string]
    $ProjectsDirectory,
    [switch]
    $NoRoot
  )
  $Private:CommandArgs = '--in-root'
  if ($NoRoot) {
    $Private:CommandArgs = ''
  }

  function Find-Solution ([string]$Path) {
    $Solution = Get-ChildItem -Path $Path -Filter '*.slnx' | Select-Object -First 1
    if (!$Solution) {
      $Solution = Get-ChildItem -Path $Path -Filter '*.sln' | Select-Object -First 1
    }

    return $Solution
  }
  if (!$Solution) {
    $Solution = Find-Solution -Path (Get-Location)
    if (!$Solution) {
      $Solution = Find-Solution -Path (Split-Path -Path (Get-Location))
    }
  }

  $Private:SolutionDirectory = Split-Path -Path $Solution

  if (!$ProjectsDirectory) {
    $ProjectsDirectory = Get-ChildItem -Directory -Path $Private:SolutionDirectory | Where-Object Name -EQ 'src' | Select-Object -First 1
    if (!$ProjectsDirectory) {
      $ProjectsDirectory = $Private:SolutionDirectory
    }
  }

  Get-ChildItem -Path $ProjectsDirectory | ForEach-Object { 
    dotnet sln $Solution add $_.FullName $Private:CommandArgs
  }
}

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
