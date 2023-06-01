
[cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    # Update the module manifest with the version tag (Sample: v10.0.01-alpha)
    [Parameter(Mandatory=$false)] [string]$VersionTag,
    # PAT for the PSGallery
    [Parameter(Mandatory=$false)] [string]$NuGetApiKey
)

# Load helper 
. ($PSScriptRoot | Join-Path -ChildPath "publish-Helper.ps1")

# Process Tag
if($VersionTag){

    $parameters = @{
        ModuleVersion = Get-ModuleVersion -VersionTag $VersionTag
        Path = Get-ModuleManifestPath
        Prerelease = Get-ModulePreRelease -VersionTag $VersionTag
    }
    Update-ModuleManifest  @parameters 
}

# check that $NuggetApiKey is null or whitespace
# If it is use environment variable $env:NugetApiKey
if ( [string]::IsNullOrWhiteSpace($NuGetApiKey) ) {
    if ( [string]::IsNullOrWhiteSpace($env:NUGETAPIKEY) ) {
        Write-Error -Message '$Env:NUGETAPIKEY is not set. Try running `$Env:NUGETAPIKEY = (Find-DocsFile nugetapikey | rsk | Get-SecretData).Get()`'
        exit 1
    }
    $NuGetApiKey = $env:NUGETAPIKEY
}

# Publish module to PSGallery
Publish-ModuleToPSGallery -NuGetApiKey $NuGetApiKey -Force
