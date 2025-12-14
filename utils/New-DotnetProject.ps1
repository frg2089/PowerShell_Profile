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
    [string]
    $SdkVersion,
    [switch]
    $Sln,
    [switch]
    $NoMIT,
    [switch]
    $NoGitIgnore,
    [switch]
    $NoGitAttributes,
    [switch]
    $NoNugetConfig,
    [switch]
    $NoEditorConfig,
    [switch]
    $NoBuildProps,
    [switch]
    $NoBuildTargets,
    [switch]
    $NoCPM,
    [switch]
    $NoSln,
    [switch]
    $NoGit
  )
  
  process {
    New-Item -ItemType 'Directory' -Name 'src'
    if (-not $NoMIT) {
      Invoke-WebRequest -Uri https://frg2089.mit-license.org/license.txt -OutFile LICENSE
    }
    if (-not $NoGitIgnore) {
      dotnet new .gitignore
    }
    if (-not $NoGitAttributes) {
      dotnet new .gitattributes
    }
    if (-not $NoNugetConfig) {
      dotnet new nuget.config
    }
    if (-not $NoEditorConfig) {
      dotnet new .editorconfig
    }
    if (-not $NoBuildProps) {
      dotnet new buildprops
    }
    if (-not $NoBuildTargets) {
      dotnet new buildtargets
    }
    if (-not $NoCPM) {
      dotnet new packagesprops
    }
    if (-not $NoSln) {
      if ($Sln) {
        dotnet new sln
      }
      else {
        dotnet new sln --format slnx
      }
    }
    if (-not [string]::IsNullOrWhiteSpace($SdkVersion)) {
      dotnet new globaljson --roll-forward latestFeature --sdk-version $SdkVersion
    }
    if (-not $NoGit) {
      git init .
      git add .
    }
  }
}
