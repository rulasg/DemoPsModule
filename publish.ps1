
[cmdletbinding()]
param(
    [Parameter(Mandatory=$false)] [string]$Tag,
    [Parameter(Mandatory=$false)] [string]$NuGetApiKey
)


## FUNCTIONS

<# .SYNOPSIS Publish the Module to PSGallery .DESCRIPTION This script will publish the module to the PSGallery .NOTES You will need to create a NuGet API Key for the PSGallery at https://www.powershellgallery.com/account/apikeys .LINK https://raw.githubusercontent.com/rulasg/DemoPsModule/main/publish.ps1
.EXAMPLE
    # Publish the module to the PSGallery without prompting

    > Publish.ps1 -Force -NuGetApiKey "<API Key>""
.EXAMPLE
    # Publish the module to the PSGallery using PAT on enviroment variable

    > $env:NUGETAPIKEY = <API Key>
    > ./publish.ps1
#>
function Publish-ModuleToPSGallery{
    [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact='High'
    )]
    param(
        # The NuGet API Key for the PSGallery
        [Parameter(Mandatory=$true)] [string]$NuGetApiKey,
        # Force the publish without prompting for confirmation
        [Parameter(Mandatory=$false)] [switch]$Force,
        # Force publishing package to the gallery. Equivalente to Import-Module -Force
        [Parameter(Mandatory=$false)] [switch]$ForcePublish
    )

    # look for psd1 file on the same folder as this script
    $moduleName  = $PSScriptRoot | Split-Path -leaf
    $psdPath = $PSScriptRoot | Join-Path -ChildPath "$moduleName.psd1"

    # check if $psd is set
    if ( -not (Test-Path -Path $psdPath)) {
        Write-Error -Message 'No psd1 file found'
        return
    }

    # Display Module Information
    $psd1 = Import-PowerShellDataFile -Path $psdPath
    $psd1
    $psd1.PrivateData.PSData

    # Confirm if not forced
    if ($Force -and -not $Confirm){
        $ConfirmPreference = 'None'
    }

    # Publish the module with ShouldProcess (-whatif, -confirm)
    if ($PSCmdlet.ShouldProcess($psdPath, "Publish-Module")) {
        $message ="Publishing {0} {1} {2} to PSGallery ..." -f $($psd1.RootModule), $($psd1.ModuleVersion), $($psd1.PrivateData.pSData.Prerelease)  
        # show an empty line
        Write-Information -InformationAction Continue -Message ""
        Write-Information -InformationAction Continue -Message $message 

        Publish-Module -WhatIf  -Name $psdPath -NuGetApiKey $NuGetApiKey -Force:$ForcePublish
    }
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tag
    )

    $version = $tag.split('-')[0] 
    #remove all leters from $version
    $version = $version -replace '[a-zA-Z_]'
    $version
}

function Get-ModulePreRelease {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tag
    )

    $preRelease = $tag.split('-')[1]
    $preRelease
}

function Update-MyModuleManifest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ModuleVersion,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Prerelease
    )

    $parameters = @{
        ModuleVersion = $ModuleVersion
        Path = $Path
        Prerelease = $Prerelease
    }
    Update-ModuleManifest  @parameters   
}

function Get-ModuleManifestPath {
    [CmdletBinding()]
    param()

    # look for psd1 file on the same folder as this script
    $moduleName  = $PSScriptRoot | Split-Path -leaf
    $psdPath = $PSScriptRoot | Join-Path -ChildPath "$moduleName.psd1"

    # check if $psd is set
    if ( -not (Test-Path -Path $psdPath)) {
        Write-Error -Message 'No psd1 file found'
        return
    } else {
        $psdPath
    }
}

##################

# Process Tag
if($Tag){

    $parameters = @{
        ModuleVersion = Get-ModuleVersion -Tag $Tag
        Path = Get-ModuleManifestPath
        Prerelease = Get-ModulePreRelease -Tag $Tag
    }
    Update-ModuleManifest  @parameters -WhatIf
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
