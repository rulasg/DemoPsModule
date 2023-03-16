<#
.Synopsis
TestingModule1Test

.Description
Testing module for TestingModule1

.Notes
NAME  : TestingModule1Test.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Information "Loading TestingModule1Test ..."

$MODULE_PATH = (Get-Module TestingModule1).Path

function TestingModule1Test_Sample(){
    Assert-IsTrue -Condition $true
}

function TestingModule1Test_GetPrivateFunction(){

    $module = Import-Module -Name $MODULE_PATH -PassThru -Force

    & $module {

        $result = Get-PrivateFunction -Text "Testing"
        Assert-AreEqual -Expected ("Private function [{0}]" -f "Testing") -Presented $result
    }
}

function TestingModule1Test_GetPublicFunction(){

    $result = Get-PublicFunction -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Testing") -Presented $result
}

function TestingModule1Test_GetPublicFunctionWithPrivateCall(){

    $result = Get-PublicFunctinWithPrivateCall -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result
}

Export-ModuleMember -Function TestingModule1Test_*
