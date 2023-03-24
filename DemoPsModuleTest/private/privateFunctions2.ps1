
function script:Get-PrivateFunction2{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    "Injected Private function2 [{0}]" -f $Text | Write-Output
    "Injected Private function2 [{0}] - Verbose" -f $Text | Write-Verbose
}