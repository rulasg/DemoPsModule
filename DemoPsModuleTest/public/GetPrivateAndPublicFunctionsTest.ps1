
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

