# CrackCrestronPassword

A PowerShell utility to detect and decrypt password protection in Crestron program files (`.umc`, `.usp`, `.smw`).

## Overview :mag:

Crestron programming files can be password-protected to prevent unauthorized access. This utility can detect whether a file has password protection and, if present, reveal the password by reverse-engineering the simple encryption scheme used.

## Installation :inbox_tray:

No installation required. Simply download the script and run it with PowerShell.

### Prerequisites

-   PowerShell 5.1 or newer (PowerShell Core/PowerShell 7+ supported)
-   Windows, macOS, or Linux with PowerShell installed

## Usage :rocket:

```powershell
.\CrackCrestronPassword.ps1 -Path <path-to-file>
```

### Example

```powershell
# Absolute path
.\CrackCrestronPassword.ps1 -Path "C:\Projects\CrestronPrograms\MyProgram.smw"

# Relative path
.\CrackCrestronPassword.ps1 -Path "MyProgram.smw"

# -Path is optional
.\CrackCrestronPassword.ps1 "MyProgram.smw"
```

### Output

The script will output information about the provided file:

```
=========== Crestron Password Analyzer ===========

File: C:\Projects\CrestronPrograms\MyProgram.smw
Status: Password Protection Found
Encrypted: Hex: 0x78 0x7A 0x7E 0x8C 0x92
Mixed ASCII/Hex: xz~<0x8C><0x92>
Raw: xz~??
Decrypted: ?=FI

=================================================
```

## How It Works :gear:

Crestron uses a simple encryption scheme for password protection:

1. The script looks for the `FeSchVr` marker that indicates password protection
2. It locates the encrypted password between specific markers
3. The decryption is performed by dividing each byte value by 2

## Project Structure :open_file_folder:

```
crack-crestron-password/
├── CrackCrestronPassword.ps1    # Main script
├── Run-Tests.ps1                # Test runner
├── tests/
│   ├── CrackCrestronPassword.Tests.ps1  # Test script
│   └── samples/                 # Test sample files
│       ├── protected/           # Password-protected sample files
│       ├── unprotected/         # Non-protected sample files
│       └── TestSmw1.smw         # Test file
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
