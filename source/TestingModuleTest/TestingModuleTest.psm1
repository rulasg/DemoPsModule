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

$MODULE_NAME = 'TestingModule'
$MODULE_PATH = ($MODULE_NAME | Get-Module ).Path


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


# function TestingModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

#     # Init module and change variable
#     Import-Module -Name $MODULE_PATH -Force
#     Update-GuidInstance -Value 99
#     Assert-AreEqual -Expected 99 -Presented (Get-GuidInstance)
    
#     # Testing if the Get-Module return the global or an instance of the module
#     $module = Import-Module -Name $MODULE_PATH -PassThru

#     # confirm we are still calling the global instance
#     Assert-AreEqual -Expected 99 -Presented (Get-GuidInstance)

#     & $module {
#         Assert-AreEqual -Expected 0 -Presented (Get-GuidInstance)
#     }

#     $module = Get-Module -Name $MODULE_PATH -Force

#     $module1 = Get-Module -Name TestingModule -PassThru
# }
# function TestingModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

#     # This functions proves that even if I update the functios onthe module they are not really updated
#     # Seems as if you are copying the module when you Get-Module making a copy
#     $module1 = Get-Module -Name TestingModule -PassThru

#     $PSScriptRoot_OUT = $PSScriptRoot
    
#     $giOut1 = Get-GuidInstance
#     $result_OUT_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    
#     & $module1 {
        
#         $giIN1 = $GuidInstance
#         $result_IN_Priv1 = Get-PrivateFunction -Text "Testing"
#         $result_IN_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
#         Assert-NotContains -Expected "Injected" -Presented $result_IN_Pub1
        
#         $privateModulePath = Join-Path -Path $PSScriptRoot -ChildPath "Private" -AdditionalChildPath "PrivateFunctions.ps1"
#         . $privateModulePath
        
#         $giIN2 = Update-guidInstance
#         $giIN3 = Get-GuidInstance
#         Assert-AreEqual -Expected $giIN2 -Presented $GuidInstance
#         $GuidInstance = 99
#         Assert-AreNotEqual -Expected 99 -Presented Get-GuidInstance

#         $result_IN_Priv2 = Get-PrivateFunction -Text "Testing"
#         $result_IN_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
#         Assert-Contains -Expected "Injected" -Presented $result_IN_Pub1
        
#         # Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result
#     }
    
#     $giOUT2 = Get-GuidInstance
#     Assert-AreEqual -Expected $giOut1 -Presented $giOUT2
#     $giOUT3 = Update-GuidInstance
#     Assert-arenotEqual -Expected $giOut1 -Presented $giOUT3

#     $result_OUT_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    
#     $module2 = Get-Module -Name TestingModule -PassThru
#     & $module2 {
#         $giIN2 = Get-GuidInstance
#         $result_IN_Priv2 = Get-PrivateFunction -Text "Testing"
#         $result_IN_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
#     }

#     Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result
# }

Export-ModuleMember -Function TestingModuleTest_*
