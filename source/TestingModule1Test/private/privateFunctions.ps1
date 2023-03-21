
function script:Get-PrivateFunction{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    "Injected Private function [{0}]" -f $Text | Write-Output
    "Injected Private function [{0}] - Verbose" -f $Text | Write-Verbose
}