<#
.Synopsis
TestingModule1

.Description
Sample of module to learn

.Notes
NAME  : TestingModule1.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Host "Loading TestingModule1 ..." -ForegroundColor DarkCyan

$script:GuidInstance = 0

function Get-GuidInstance(){
    return $script:GuidInstance
} Export-ModuleMember -Function Get-GuidInstance
function Update-GuidInstance([int] $value ){
    $script:GuidInstance = $value
} Export-ModuleMember -Function Update-GuidInstance


#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

Export-ModuleMember -Function Get-PublicFunction
Export-ModuleMember -Function Get-PublicFunctinWithPrivateCall
