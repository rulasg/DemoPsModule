<#
.SYNOPSIS
    Run tests
.DESCRIPTION
    Run the unit test of the actual module
.NOTES
    Using TestingHelper this script will search for a Test module and run the tests
    This script will be referenced from launch.json to run the tests on VSCode
.LINK
    https://raw.githubusercontent.com/rulasg/DemoPsModule/main/test.ps1
.EXAMPLE
    > ./test.ps1
#>

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

Import-TestingHelper -version 2.1.1-alpha #first version wiht Test-ModulelocalPsd1

# Run test by PSD1 file
Test-ModulelocalPSD1

# Run tests by module name
# We need to manage the import of the version we want to test
# If there are different versions of the module installed, we need to import the one we want to test
# $psd = get-childitem -Path $PSScriptRoot -Filter *.psd1
# Import-Module -Name $psd.FullName -Force
# Test-Module -Name $psd.BaseName