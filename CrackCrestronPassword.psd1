@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'CrackCrestronPassword.ps1'

    # Version number of this module.
    ModuleVersion     = '0.1.0'

    # ID used to uniquely identify this module
    GUID              = '6eef4e64-3926-4ac1-a86d-66e32e85c4a9'

    # Author of this module
    Author            = 'Norgate AV'

    # Company or vendor of this module
    CompanyName       = 'Norgate AV'

    # Copyright statement for this module
    Copyright         = '(c) 2025 Norgate AV. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Extract and decrypt passwords from Crestron SMW, UMC, and USP files'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry
    FunctionsToExport = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry
    AliasesToExport   = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData       = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Crestron', 'Security', 'Password')

            # Project URL
            ProjectUri   = 'https://github.com/norgate-av/crack-crestron-password'

            # License URI
            LicenseUri   = 'https://github.com/norgate-av/crack-crestron-password/blob/main/LICENSE'

            # Release notes for this version
            ReleaseNotes = 'Initial release with password decryption functionality for Crestron files'
        }
    }
}
