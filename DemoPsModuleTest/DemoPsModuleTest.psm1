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

# function for dependency injection
# Import testing module private 

function Import-TestingPrivateFunctionsForInjection{

    $module = Get-Module -Name DemoPsModule

    & $module {
        $path = Join-Path -Path $PSScriptRoot -ChildPath "FunctionsForDependencyInjection"
        $Private = @( Get-ChildItem -Path $path -ErrorAction SilentlyContinue )
        Foreach($import in $Private)
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

function DemoPsModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

    $result_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result_Pub1

    Import-TestingPrivateFunctionsForInjection

    $result_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result_Pub2
} Export-ModuleMember -Function DemoPsModuleTest_GetPublicFunctionWithPrivateCall_Injected

