[CmdletBinding()]
param ()

function Import-TestingHelper{
    [CmdletBinding()]
    param (
        [Parameter()][string]$Version,
        [Parameter()][switch]$AllowPrerelease,
        [Parameter()][switch]$PassThru
    )

    
    if ($Version) {
        $V = $Version.Split('-')
        $semVer = $V[0]
        $AllowPrerelease = ($AllowPrerelease -or ($null -ne $V[1]))
    }
    
    $module = Import-Module TestingHelper -PassThru -ErrorAction SilentlyContinue -RequiredVersion:$semVer

    if ($null -eq $module) {
        $installed = Install-Module -Name TestingHelper -Force -AllowPrerelease:$AllowPrerelease -passThru -RequiredVersion:$Version
        $module = Import-Module -Name $installed.Name -RequiredVersion ($installed.Version.Split('-')[0]) -Force -PassThru
    }

    if ($PassThru) {
        $module
    }
}

# Import-TestingHelper -Version "2.1.1-alpha"
uninstall-Module -name TestingHelper -AllVersions ; rmo testinghelper*
Import-TestingHelper -AllowPrerelease # 2.1.1-alpha

Import-TestingHelper -Version 2.5 # 2.5

uninstall-Module -name TestingHelper -AllVersions ; rmo testinghelper*   
Import-TestingHelper -Version 1.3 # 1.3

uninstall-Module -name TestingHelper -AllVersions ; rmo testinghelper*   
Import-TestingHelper  # 2.0

uninstall-Module -name TestingHelper -AllVersions ; rmo testinghelper*   
Import-TestingHelper -Version "2.1.1-alpha" # 2.1.1-alpha
Import-TestingHelper  # 2.1.1-alpha

# Run test by PSD1 file
# Test-ModulelocalPSD1

# Run tests by module name
# We need to manage the import of the version we want to test
# If there are different versions of the module installed, we need to import the one we want to test
# $psd = get-childitem -Path $PSScriptRoot -Filter *.psd1
# Import-Module -Name $psd.FullName -Force
# Test-Module -Name $psd.BaseName