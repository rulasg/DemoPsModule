

function Get-PrivateFunction{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    "Private function [{0}]" -f $Text | Write-Output
    "Private function [{0}] - Verbose" -f $Text | Write-Verbose
}