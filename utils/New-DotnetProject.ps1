#Requires -Version 7.4

if (!$SolutionExtensions) {
  New-Variable -Name 'SolutionExtensions' -Value @('.slnx', '.sln') -Scope Script
}

function Find-Solution {
  param (
    [Parameter()]
    [string]
    $Path
  )
  if (!$Path) {
    $Path = Get-Location
  }

  $Path = Resolve-Path -LiteralPath $Path
  
  $Private:List = Get-ChildItem -LiteralPath $Path -File | Where-Object Extension -In $Script:SolutionExtensions 
  if ($Private:List -is [System.IO.FileInfo]) {
    return $Private:List
  }
  elseif ($Private:List.Length -gt 1) {
    Write-Error -Message 'Multiple solutions found. see $Error[0].TargetObject' -TargetObject $Private:List
  }

  $Private:Parent = Split-Path -LiteralPath $Path
  if ($Private:Parent) {
    return Find-Solution -Path $Private:Parent
  }
}

<#
.DESCRIPTION
  Append Projects into Solution.
#>
function Add-DotnetProjects {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Solution,
    [Parameter()]
    [string]
    $ProjectsDirectory,
    [Parameter()]
    [string]
    $SolutionFolder,
    [Parameter()]
    [switch]
    $Workspace
  )
  if (!$Solution) {
    $Solution = Find-Solution
  }
  if (!$Solution) {
    throw 'Solution not found.'
  }

  $Private:SolutionDirectory = Split-Path -LiteralPath $Solution

  if ($Workspace) {
    if (!$ProjectsDirectory) {
      $ProjectsDirectory = Get-ChildItem -LiteralPath $Private:SolutionDirectory | Where-Object Name -EQ 'src' | Select-Object -First 1
    }
    if (!$ProjectsDirectory) {
      $ProjectsDirectory = $Private:SolutionDirectory
    }
  }
  if (!$ProjectsDirectory) {
    $ProjectsDirectory = Get-Location
  }

  $Private:CommandArgs = @()
  if ($SolutionFolder) {
    $Private:CommandArgs += '--solution-folder'
    $Private:CommandArgs += $SolutionFolder
  }
  else {
    $Private:CommandArgs += '--in-root'
  }

  Get-ChildItem -Path $ProjectsDirectory | ForEach-Object { 
    dotnet sln $Solution add $PSItem.FullName $Private:CommandArgs
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
    $Private:Slnp = Get-Command dotnet-slnp -ErrorAction SilentlyContinue

    if (-not $NoSln) {
      if ($Sln) {
        dotnet new sln
      }
      else {
        dotnet new sln --format slnx
      }
    }
    New-Item -ItemType 'Directory' -Name 'src'
    if (-not $NoMIT) {
      Invoke-WebRequest -Uri https://frg2089.mit-license.org/license.txt -OutFile LICENSE
      if ($Private:Slnp) {
        dotnet slnp add LICENSE
      }
    }
    if (-not $NoGitIgnore) {
      dotnet new .gitignore
      if ($Private:Slnp) {
        dotnet slnp add .gitignore
      }
    }
    if (-not $NoGitAttributes) {
      dotnet new .gitattributes
      if ($Private:Slnp) {
        dotnet slnp add .gitattributes
      }
    }
    if (-not $NoNugetConfig) {
      dotnet new nuget.config
      if ($Private:Slnp) {
        dotnet slnp add nuget.config
      }
    }
    if (-not $NoEditorConfig) {
      dotnet new .editorconfig
      if ($Private:Slnp) {
        dotnet slnp add .editorconfig
      }
    }
    if (-not $NoBuildProps) {
      dotnet new buildprops
      if ($Private:Slnp) {
        dotnet slnp add Directory.Build.props
      }
    }
    if (-not $NoBuildTargets) {
      dotnet new buildtargets
      if ($Private:Slnp) {
        dotnet slnp add Directory.Build.targets
      }
    }
    if (-not $NoCPM) {
      dotnet new packagesprops
      if ($Private:Slnp) {
        dotnet slnp add Directory.Packages.props
      }
    }
    if (-not [string]::IsNullOrWhiteSpace($SdkVersion)) {
      dotnet new global.json --roll-forward latestFeature --sdk-version $SdkVersion
      if ($Private:Slnp) {
        dotnet slnp add global.json
      }
    }
    if (-not $NoGit) {
      git init .
      git add .
    }
  }
}
