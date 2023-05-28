[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ref
)

"Ref parameter value [$ref]" | Write-Verbose

$tag = $ref.Split('/')[2]

"Tag value [$tag]" | Write-Verbose

# clearn string from $version value

$version = $tag.split('-')[0] 

#remove all leters from $version
$version = $version -replace '[a-zA-Z]'


"Version value [$version]" | Write-Verbose

$preRelease = $tag.split('-')[1]

"PreRelease value [$preRelease]" | Write-Verbose

$manifestPath = Get-ChildItem -Path $PSScriptRoot -Filter *.psd1
$parameters = @{
    ModuleVersion = $version
    Path = $manifestPath.FullName
    Prerelease = $preRelease
}
Update-ModuleManifest  @parameters   

$manifestModified = Import-powerShellDataFile -Path $manifestPath.FullName

$manifestModified
$manifestModified.PrivateData.PSData