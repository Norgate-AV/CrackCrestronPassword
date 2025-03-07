# CrackCrestronPassword

[![GitHub Release](https://img.shields.io/github/v/release/Norgate-AV/CrackCrestronPassword)](https://github.com/Norgate-AV/CrackCrestronPassword/releases)
[![CI](https://github.com/Norgate-AV/CrackCrestronPassword/actions/workflows/tests.yml/badge.svg)](https://github.com/Norgate-AV/CrackCrestronPassword/actions/workflows/tests.yml)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![GitHub contributors](https://img.shields.io/github/contributors/Norgate-AV/CrackCrestronPassword)](https://github.com/Norgate-AV/CrackCrestronPassword/graphs/contributors)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A PowerShell utility to detect and decrypt password protection in Crestron program files (`.umc`, `.usp`, `.smw`).

## Overview :mag:

Crestron programming files can be password-protected to prevent unauthorized access. This utility can detect whether a file has password protection and, if present, reveal the password by reverse-engineering the simple encryption scheme used.

## Features :star:

-   Detects password-protected Crestron files
-   Extracts encrypted password data
-   Decrypts passwords using Crestron's simple encryption scheme
-   Works with SMW, UMC, and USP file formats
-   Cross-platform support (Windows, macOS, Linux)

## Prerequisites :heavy_check_mark:

-   PowerShell 5.1 or newer (PowerShell Core/PowerShell 7+ supported)
-   Windows, macOS, or Linux with PowerShell installed

## Usage :rocket:

### Basic Usage

```powershell
# Run the script against a file
./CrackCrestronPassword.ps1 -Path "/path/to/your/crestron/file.smw"

# Use verbose output for more details
./CrackCrestronPassword.ps1 -Path "/path/to/your/crestron/file.smw" -Verbose
```

### Example

For password-protected files:

```powershell
# Absolute path
./CrackCrestronPassword.ps1 -Path "C:\Projects\CrestronPrograms\MyProgram.smw"

# Relative path
./CrackCrestronPassword.ps1 -Path "MyProgram.smw"

# -Path is optional
./CrackCrestronPassword.ps1 "MyProgram.smw"
```

The script will output information about the provided file:

```
=========== Crestron Password Analyzer ===========

File: C:\Projects\CrestronPrograms\MyProgram.smw
Status: Password Protection Found
Password: ?=FI

=================================================
```

## How It Works :gear:

Crestron uses a simple encryption scheme for password protection:

1. The script looks for the `FeSchVr` marker that indicates password protection
2. It locates the encrypted password between specific markers
3. The decryption is performed by dividing each byte value by 2

## Project Structure :open_file_folder:

```
/
├── CrackCrestronPassword.ps1    # Main script
├── CrackCrestronPassword.psd1   # Module manifest file
├── Update-Version.ps1           # Version update script (optional)
├── CHANGELOG.md                 # Changelog
├── LICENSE                      # License file
├── README.md                    # Project documentation
├── Run-Tests.ps1                # Test runner
├── .github/                     # GitHub configuration
│   ├── workflows/               # GitHub Actions workflows
│   │   ├── version-update.yml   # Version update workflow
│   │   └── tests.yml            # Test workflow
│   └── changelog-config.json    # Changelog generator config
└── tests/                       # Test directory
    ├── CrackCrestronPassword.Tests.ps1  # Test script
    └── samples/                 # Test sample files
        ├── protected/           # Password-protected sample files
        │   ├── sample1.smw      # Sample protected file
        │   └── sample2.umc      # Sample protected file
        └── unprotected/         # Non-protected sample files
            ├── sample1.smw      # Sample unprotected file
            └── sample2.usp      # Sample unprotected file
```

## Running Tests :test_tube:

The project includes comprehensive tests using Pester 5:

```powershell
.\Run-Tests.ps1
```

The test runner will automatically install Pester 5 if it's not already installed.

### Test Categories

-   File detection tests - Verify detection of password protection
-   Password decryption tests - Verify correct password decryption
-   Error handling tests - Verify proper handling of errors
-   Real sample file tests - Test against real-world examples

## Adding Test Files :heavy_plus_sign:

You can add your own test files:

-   Place password-protected files in `tests/samples/protected/`
-   Place non-protected files in `tests/samples/unprotected/`

The test framework will automatically discover and use these files.

## LICENSE :balance_scale:

[MIT](./LICENSE)
