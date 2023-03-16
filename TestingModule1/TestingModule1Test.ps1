[CmdletBinding()]
param ()

$ModuleName = "TestingModule1"

Import-Module -Name TestingHelper -Force

Test-Module -Name $ModuleName 
