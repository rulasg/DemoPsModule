<#
.SYNOPSIS
    Publish the Module to PSGallery
.DESCRIPTION
    This script will publish the module to the PSGallery
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    # Set the Environment variable $NugetApiKey to the API Key for the PSGallery
    Publish.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$false)] [string]$NuGetApiKey,
    [Parameter(Mandatory=$false)] [switch]$Force
)

# check that $NuggetApiKey is null or whitespace
# If it is use environment variable $env:NugetApiKey
if ( [string]::IsNullOrWhiteSpace($NuGetApiKey) ) {
    
    if ( [string]::IsNullOrWhiteSpace($env:NuGetApiKey) ) {
        Write-Error -Message 'NuGetApiKey is not set. Try running `$Env:NuGetApiKey = fdf nuget | Get-SecretValue`'
        return
    }
    
    $NuGetApiKey = $env:NuGetApiKey
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

Import-PowerShellDataFile -Path $psd

if (-not $Force) {
    
    Write-Host
    Write-Host -Message 'Publishing to PSGallery. Press any key to continue...' -ForegroundColor Yellow
    Read-Host
}

if ($PSCmdlet.ShouldProcess($psd, "Publish-Module")) {
    publish-Module   -Name $psd -NuGetApiKey $NuGetApiKey
}