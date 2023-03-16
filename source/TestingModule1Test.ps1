[CmdletBinding()]
param ()

$ModuleName = "TestingModule1"

Import-Module -Name TestingHelper -Force

Import-Module -Name ./source/TestingModule1.psd1 -Force

Test-Module -Name $ModuleName 
