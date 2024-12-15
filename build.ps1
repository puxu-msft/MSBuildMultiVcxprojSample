<#
.SYNOPSIS
Invoke MSBuild to build

.NOTES
241214

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)]
    [string]$Project,

    [string]$Target,
    [switch]$ReBuild,
    [switch]$Clean,

    [switch]$ReleaseBuild,
    [switch]$Retail,

    [switch]$AnyCPU,

    [switch]$V,
    [switch]$VV,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining
)

trap {
    Write-Host -ForegroundColor Red "$($_.Exception.ToString())`n  $([string]::Join("`n  ", $_.ScriptStackTrace.Split("`n")))"
    return
}

function main {
    if ('' -eq [string]$Target) {
        $Target = "Build"
    }
    $Targets = $Target.Split(',')
    if ($ReBuild) {
        $Targets = @("Clean") + $Targets
    }
    elseif ($Clean) {
        $Targets = @("Clean")
    }

    $Targets = [string]::Join(',', $Targets)

    $exeArgs = @(
        "-t:$Targets"
    )

    if ($VV) {
        $exeArgs += @("-verbosity:diag")
    }
    elseif ($V) {
        $exeArgs += @("-verbosity:detailed")
    }
    else {
        $exeArgs += @("-MaxCpuCount:4")
    }

    $fwdArgs = @{
        Project = $Project;
        ReleaseBuild = $ReleaseBuild;
        Retail = $Retail;
        AnyCPU = $AnyCPU;
        Remaining = $exeArgs + $Remaining;
    }

    & "$PSScriptRoot\msbuild.ps1" @fwdArgs
}

main
