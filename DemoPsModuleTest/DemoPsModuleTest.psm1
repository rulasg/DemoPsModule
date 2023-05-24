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

function DemoPsModuleTest_Sample(){
    Assert-IsTrue -Condition $true
} Export-ModuleMember -Function DemoPsModuleTest_Sample

function DemoPsModuleTest_GetPrivateFunction(){

    # $module = Import-Module -Name $MODULE_PATH -PassThru -Force
    $module = Get-Module -Name DemoPsModule

    & $module {

        $result = Get-PrivateFunction -Text "Testing"
        Assert-AreEqual -Expected ("Private function [{0}]" -f "Testing") -Presented $result
    }
} Export-ModuleMember -Function DemoPsModuleTest_GetPrivateFunction

function DemoPsModuleTest_GetPublicFunction(){

    $result = Get-PublicFunction -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Testing") -Presented $result
} Export-ModuleMember -Function DemoPsModuleTest_GetPublicFunction

function DemoPsModuleTest_GetPublicFunctionWithPrivateCall(){

    $result = Get-PublicFunctinWithPrivateCall -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result
} Export-ModuleMember -Function DemoPsModuleTest_GetPublicFunctionWithPrivateCall

