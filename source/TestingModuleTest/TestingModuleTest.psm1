<#
.Synopsis
TestingModuleTest

.Description
Testing module for TestingModule

.Notes
NAME  : TestingModuleTest.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Information "Loading TestingModuleTest ..."

# function for dependency injection

function ImportTestingPrivateFunctions{

    $module = Get-Module -Name TestingModule

    & $module {
        $path = Join-Path -Path $PSScriptRoot -ChildPath "Private"
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
} Export-ModuleMember -Function Import-PrivateFunctions

function TestingModuleTest_Sample(){
    Assert-IsTrue -Condition $true
}

function TestingModuleTest_GetPrivateFunction(){

    # $module = Import-Module -Name $MODULE_PATH -PassThru -Force
    $module = Get-Module -Name TestingModule

    & $module {

        $result = Get-PrivateFunction -Text "Testing"
        Assert-AreEqual -Expected ("Private function [{0}]" -f "Testing") -Presented $result
    }
}

function TestingModuleTest_GetPublicFunction(){

    $result = Get-PublicFunction -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Testing") -Presented $result
}

function TestingModuleTest_GetPublicFunctionWithPrivateCall(){

    $result = Get-PublicFunctinWithPrivateCall -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result
}

function TestingModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

    $result_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result_Pub1
    
    ImportTestingPrivateFunctions
    
    $result_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result_Pub2
}

Export-ModuleMember -Function TestingModuleTest_*
