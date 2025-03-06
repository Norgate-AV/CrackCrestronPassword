#!/usr/bin/env pwsh

[CmdletBinding()]
param()

# Ensure Pester 5 is installed
$minimumVersion = "5.0.0"
$pesterInstalled = Get-Module -ListAvailable -Name Pester
$latestPester = $pesterInstalled | Sort-Object Version -Descending | Select-Object -First 1

if (-not $pesterInstalled -or $latestPester.Version -lt [Version]$minimumVersion) {
    # Install or update to Pester 5
    Write-Host "Installing/updating to Pester $minimumVersion..." -ForegroundColor Yellow
    Install-Module -Name Pester -Force -SkipPublisherCheck -MinimumVersion $minimumVersion
}

# Import Pester 5
Import-Module Pester -MinimumVersion $minimumVersion
$pesterVersion = (Get-Module -ListAvailable -Name Pester | Sort-Object Version -Descending | Select-Object -First 1).Version
Write-Host "Using Pester version: $pesterVersion" -ForegroundColor Cyan

# Run tests with Pester 5 - always use Detailed verbosity
$config = New-PesterConfiguration
$config.Run.Path = "$PSScriptRoot\tests\CrackCrestronPassword.Tests.ps1"
$config.Output.Verbosity = 'Detailed'
Invoke-Pester -Configuration $config
