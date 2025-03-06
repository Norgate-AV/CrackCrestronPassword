#!/usr/bin/env pwsh

<#
 _   _                       _          ___     __
| \ | | ___  _ __ __ _  __ _| |_ ___   / \ \   / /
|  \| |/ _ \| '__/ _` |/ _` | __/ _ \ / _ \ \ / /
| |\  | (_) | | | (_| | (_| | ||  __// ___ \ V /
|_| \_|\___/|_|  \__, |\__,_|\__\___/_/   \_\_/
                 |___/

MIT License

Copyright (c) 2025 Norgate AV

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

[CmdletBinding()]

param (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [ValidatePattern(".*\.(smw|umc|usp)$")]
    [string]$Path
)

function Write-Results {
    param (
        [string]$Path,
        [string]$Status,
        [string]$Encrypted = "",
        [string]$Decrypted = ""
    )

    Write-Host "`n=========== Crestron Password Analyzer ===========`n"
    Write-Host "File: $Path"
    Write-Host "Status: $Status"

    if ($Encrypted -ne "") {
        Write-Host "Encrypted: $Encrypted"
    }

    if ($Decrypted -ne "") {
        Write-Host "Decrypted: $Decrypted"
    }

    Write-Host "`n================================================="
}

# Read the file as bytes to avoid any text encoding issues
try {
    $fileBytes = [System.IO.File]::ReadAllBytes($Path)
}
catch {
    Write-Error "Failed to read file: $_"
    exit(1)
}

# Look for "FeSchVr" in the binary data
$feSchVrBytes = [System.Text.Encoding]::ASCII.GetBytes("FeSchVr")
$feSchVrIndex = -1

for ($i = 0; $i -lt ($fileBytes.Length - $feSchVrBytes.Length); $i++) {
    $match = $true
    for ($j = 0; $j -lt $feSchVrBytes.Length; $j++) {
        if ($fileBytes[$i + $j] -ne $feSchVrBytes[$j]) {
            $match = $false
            break
        }
    }
    if ($match) {
        $feSchVrIndex = $i
        break
    }
}

if ($feSchVrIndex -lt 0) {
    Write-Results -Path $Path -Status "No Password Protection"
    exit(0)
}

# Now look for the "TŠ" marker - T (0x54) followed by Š (0x8A)
$endMarkerIndex = -1
for ($i = $feSchVrIndex; $i -lt ($fileBytes.Length - 1); $i++) {
    if ($fileBytes[$i] -eq 0x54 -and $fileBytes[$i + 1] -eq 0x8A) {
        $endMarkerIndex = $i
        break
    }
}

if ($endMarkerIndex -lt 0) {
    Write-Results -Path $Path -Status "Password Protection Found, but no TŠ marker was detected"
    exit(1)
}

# Find the starting T marker by searching backward
$startMarkerIndex = -1
for ($i = 2; $i -lt 25; $i++) {
    if ($endMarkerIndex - $i -ge 0 -and $fileBytes[$endMarkerIndex - $i] -eq 0x54) {
        $startMarkerIndex = $endMarkerIndex - $i
        break
    }
}

if ($startMarkerIndex -lt 0) {
    Write-Results -Path $Path -Status "Password Protection Found, but couldn't locate start marker"
    exit(1)
}

# Extract encrypted bytes between the markers
$encryptedBytes = $fileBytes[($startMarkerIndex + 1)..($endMarkerIndex - 1)]

# Convert encrypted bytes to a string for display (original raw format)
$encryptedString = [System.Text.Encoding]::Default.GetString($encryptedBytes)

# Create a hex representation of the encrypted bytes for better readability
$encryptedHex = ($encryptedBytes | ForEach-Object { "0x{0:X2}" -f $_ }) -join " "

# Create a mixed ASCII/hex representation (printable ASCII as-is, non-printable as hex)
$encryptedMixed = ""
foreach ($byte in $encryptedBytes) {
    # If it's a printable ASCII character (32-126), show as-is
    if ($byte -ge 32 -and $byte -le 126) {
        $encryptedMixed += [char]$byte
    }
    # Otherwise show hex representation
    else {
        $encryptedMixed += "<0x{0:X2}>" -f $byte
    }
}

# Decrypt bytes by dividing each byte by 2
$decrypted = ""
foreach ($byte in $encryptedBytes) {
    $decryptedByte = [int]($byte / 2)
    if ($decryptedByte -lt 32 -or $decryptedByte -eq 127) {
        # Replace control characters with their hex value for display
        $decrypted += "<" + $decryptedByte + ">"
    }
    else {
        $decrypted += [char]$decryptedByte
    }
}

# Display results
Write-Results -Path $Path `
    -Status "Password Protection Found" `
    -Encrypted "Hex: $encryptedHex`nMixed ASCII/Hex: $encryptedMixed`nRaw: $encryptedString" `
    -Decrypted $decrypted

# Add byte value debug info
Write-Verbose "`nDebug Information:"
Write-Verbose "Start marker index: $startMarkerIndex, End marker index: $endMarkerIndex"
Write-Verbose "Encrypted string byte values: $($encryptedBytes -join ', ')"
Write-Verbose "Decrypted byte values: $(($encryptedBytes | ForEach-Object { [int]($_ / 2) }) -join ', ')"
