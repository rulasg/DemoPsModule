
Write-Information -Message ("Loading {0} ..." -f ($PSCommandPath | Split-Path -LeafBase)) 

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

    $message ="Publishing {0} {1} {2} to PSGallery ..." -f $($psd1.RootModule), $($psd1.ModuleVersion), $($psd1.PrivateData.pSData.Prerelease)  
    $message | Write-Information -InformationAction Continue

    # Publish the module with ShouldProcess (-whatif, -confirm)
    if ($PSCmdlet.ShouldProcess($psdPath, "Publish-Module")) {
        # During testing we should never reach this point due to -WhatIf command on all tests.
        Publish-Module -WhatIf  -Name $psdPath -NuGetApiKey $NuGetApiKey -Force:$ForcePublish
    }
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$VersionTag
    )

    $version = $VersionTag.split('-')[0] 
    #remove all leters from $version
    $version = $version -replace '[a-zA-Z_]'
    $version
}

function Get-ModulePreRelease {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$VersionTag
    )

    $preRelease = $VersionTag.split('-')[1]
    # to clear the preRelease by Update-ModuleManifest 
    # preRelease must be a string with a space. 
    # $null or [string]::Empty leaves the value that has.
    $preRelease = $preRelease ?? " "
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
        # FunctionsToExport = '*'
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