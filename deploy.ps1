[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ref
)

"Ref parameter value [$ref]" | Write-Host

$tag = $ref.Split('/')[2]
"Tag value [$tag]" | Write-Host

# Check the commit value
$tagCommit = git rev-list -n 1 $tag
$head = git rev-parse --verify HEAD

"Actual commit [{0}] " -f $commit | Write-Host
"ref    commit [{0}] " -f $tagref | write-host
$equal = ($commit -eq $tagref)

"Confirmed head commit [{0}]" -f $equal | Write-Host

if ($equal) {
    "Tag commit [{0}] is equal to head commit [{1}]" -f $tagCommit, $head | Write-Host
} else {
    "Tag commit [{0}] is not equal to head commit [{1}]" -f $tagCommit, $head | Write-Host
    exit 1
}

# clearn string from $version value
$version = $tag.split('-')[0] 
#remove all leters from $version
$version = $version -replace '[a-zA-Z]'
"Version value [$version]" | Write-Host

# prerelease value
$preRelease = $tag.split('-')[1]
"PreRelease value [$preRelease]" | Write-Host

# update module manifest
$manifestPath = Get-ChildItem -Path $PSScriptRoot -Filter *.psd1
$parameters = @{
    ModuleVersion = $version
    Path = $manifestPath.FullName
    Prerelease = $preRelease
}
Update-ModuleManifest  @parameters   

# Publish
 ./publish.ps1 -Force