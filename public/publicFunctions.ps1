

function Get-PublicFunction{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text
    )


    "Public function [{0}]" -f $Text | Write-Output
    "Public function [{0}] - Verbose" -f $Text | Write-Verbose
} Export-ModuleMember -Function Get-PublicFunction

function Get-PublicFunctinWithPrivateCall{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    $private = Get-PrivateFunction -Text $Text

    "Public function [{0}]" -f $private | Write-Output

} Export-ModuleMember -Function Get-PublicFunctinWithPrivateCall