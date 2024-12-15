<#
.SYNOPSIS
Run MSBuild out of a Developer PowerShell

.NOTES
241214

.NOTES
Install-Module -Scope CurrentUser VSSetup

.NOTES
For .NET projects, see a modern way (but there're some different) from https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-msbuild

.NOTES
.\msbuild.ps1 .\play.hello\ "-getProperty:OutDir"
.\msbuild.ps1 .\play.hello\ "-getItem:ClCompile"
.\msbuild.ps1 .\play.hello\ "-getTargetResult:Build"

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)]
    [string]$Project,

    [switch]$ReleaseBuild,
    [switch]$Retail,

    [switch]$AnyCPU,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining
)

trap {
    Write-Host -ForegroundColor Red "$($_.Exception.ToString())`n  $([string]::Join("`n  ", $_.ScriptStackTrace.Split("`n")))"
    # $Error.Clear()
    return # one of break, continue, return, exit
}

$Project = Resolve-Path -LiteralPath $Project
if (Test-Path -PathType Container $Project) {
    $ProjectDir = $Project
    $ProjectName = "."
}
else {
    $ProjectDir = [IO.Path]::GetDirectoryName($Project)
    $ProjectName = [IO.Path]::GetFileName($Project)
}

function main {
    # not work by now
    # see https://github.com/dotnet/msbuild/issues/1596
    $env:DOTNET_CLI_UI_LANGUAGE = "en-US"
    $env:PreferredUILang = "en-US"
    $env:VSLANG = "1033"
    # chcp 65001

    # disable telemetry
    $env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"

    $vsInstance = Get-VSSetupInstance -All | ? { $_.State -eq [Microsoft.VisualStudio.Setup.Configuration.InstanceState]::Complete } | Select-Object -First 1
    if ($null -eq $vsInstance) {
        throw "Failed to Get-VSSetupInstance"
    }

    if ($Retail) {
        $ReleaseBuild = $true
    }

    $Configuration = if ($ReleaseBuild) {"Release"} else {"Debug"}
    $Platform = if ($AnyCPU) {"Any CPU"} else {"x64"}

    $exeArgs = @(
        $ProjectName,
        "-p:Configuration=$Configuration",
        "-p:Platform=$Platform",
        "-NoLogo"
    ) + $Remaining

    if ($env:PROCESSOR_ARCHITECTURE -ieq 'AMD64') {
        # Hostx64
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\amd64\MSBuild.exe" @exeArgs
    }
    elseif ($env:PROCESSOR_ARCHITECTURE -ieq 'x86') {
        # Hostx86
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\MSBuild.exe" @exeArgs
    }
    else {
        throw "Unsupported CPU arch: $($env:PROCESSOR_ARCHITECTURE)"
    }
    if (0 -ne $LASTEXITCODE) {
        throw "msbuild exited with code $LASTEXITCODE"
    }
}

Push-Location $ProjectDir
try {
    main
}
finally {
    Pop-Location
}
