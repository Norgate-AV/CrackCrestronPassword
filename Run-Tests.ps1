#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [switch]$CI
)

# Ensure Pester 5.x is available
$requiredPesterVersion = [Version]'5.0.0'
$pester = Get-Module -Name Pester -ListAvailable | Sort-Object -Property Version -Descending | Select-Object -First 1

if (-not $pester -or $pester.Version -lt $requiredPesterVersion) {
    Write-Host "Pester 5.0.0 or later is required but not installed or loaded. Installing from PowerShell Gallery..." -ForegroundColor Yellow
    Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck -Scope CurrentUser
    Import-Module -Name Pester -MinimumVersion 5.0.0 -Force
}
else {
    Import-Module -Name Pester -MinimumVersion 5.0.0
}

Write-Host "Running tests with Pester v$((Get-Module Pester).Version)"

$testScriptPath = Join-Path $PSScriptRoot 'tests' 'CrackCrestronPassword.Tests.ps1'
$testResultsPath = Join-Path $PSScriptRoot 'TestResults' 'testResults.xml'

# Ensure the TestResults directory exists
$testResultsDir = Split-Path -Parent $testResultsPath
if (-not (Test-Path -Path $testResultsDir -PathType Container)) {
    New-Item -Path $testResultsDir -ItemType Directory -Force | Out-Null
}

$pesterConfig = New-PesterConfiguration
$pesterConfig.Run.Path = $testScriptPath
$pesterConfig.Output.Verbosity = 'Detailed'
$pesterConfig.TestResult.Enabled = $true
$pesterConfig.TestResult.OutputPath = $testResultsPath
$pesterConfig.TestResult.OutputFormat = 'NUnitXml'

$testResults = Invoke-Pester -Configuration $pesterConfig

if ($CI -and $testResults.FailedCount -gt 0) {
    exit 1
}

exit 0
