<#
.SYNOPSIS
    Publish the Module to PSGallery
.DESCRIPTION
    This script will publish the module to the PSGallery
.NOTES
    You will need to create a NuGet API Key for the PSGallery at https://www.powershellgallery.com/account/apikeys
# .LINK
    # Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    # Publish the module to the PSGallery without prompting

    > Publish.ps1 -Force -NuGetApiKey "<API Key>""
.EXAMPLE
    # Publish the module to the PSGallery using PAT on enviroment variable

    > $env:NUGETAPIKEY = <API Key>
    > Publish.ps1
#>

[CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact='High'
    )]
param(
    # The NuGet API Key for the PSGallery
    [Parameter(Mandatory=$false)] [string]$NuGetApiKey,
    # Force the publish without prompting for confirmation
    [Parameter(Mandatory=$false)] [switch]$Force
)

# check that $NuggetApiKey is null or whitespace
# If it is use environment variable $env:NugetApiKey
if ( [string]::IsNullOrWhiteSpace($NuGetApiKey) ) {
    
    if ( [string]::IsNullOrWhiteSpace($env:NUGETAPIKEY) ) {
        Write-Error -Message '$Env:NUGETAPIKEY is not set. Try running `$Env:NUGETAPIKEY = fdf nuget | Get-SecretValue`'
        return
    }
    
    $NuGetApiKey = $env:NUGETAPIKEY
}

# look for psd1 file on the same folder as this script
$psd = Get-ChildItem -Path $PSScriptRoot -Filter *.psd1

# check if $psd is set
if ( $null -eq $psd ) {
    Write-Error -Message 'No psd1 file found'
    return
}

# check if $psd is a single file
if ( $psd.Count -gt 1 ) {
    Write-Error -Message 'More than one psd1 file found'
    return
}

$psd1 = Import-PowerShellDataFile -Path $psd
$psd1
$psd1.PrivateData.PSData


if ($Force -and -not $Confirm){
    $ConfirmPreference = 'None'
}

if ($PSCmdlet.ShouldProcess($psd, "Publish-Module")) {
    publish-Module   -Name $psd -NuGetApiKey $NuGetApiKey
}