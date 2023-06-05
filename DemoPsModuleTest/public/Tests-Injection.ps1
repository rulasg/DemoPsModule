
function DemoPsModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

    $result_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result_Pub1

    Import-TestingPrivateFunctionsForInjection

    $result_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result_Pub2
} Export-ModuleMember -Function DemoPsModuleTest_GetPublicFunctionWithPrivateCall_Injected

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