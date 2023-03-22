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

# check that $NuggetApiKey is set
if ( $null -eq $NuGetApiKey ) {
    Write-Error -Message 'NuGetApiKey is not set. Try running `$NuGetApiKey = fdf nuget | Get-SecretValue`'
    return
}

$psd = get-childitem -Path $PSScriptRoot -Filter *.psd1

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

publish-Module   -Name $psd -NuGetApiKey $NuGetApiKey