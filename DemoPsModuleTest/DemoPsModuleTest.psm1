<#
.Synopsis
DemoPsModuleTest

.Description
Testing module for DemoPsModule

.Notes
NAME  : DemoPsModuleTest.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Information "Loading DemoPsModuleTest ..."

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

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

Export-ModuleMember -Function DemoPsModuleTest_*