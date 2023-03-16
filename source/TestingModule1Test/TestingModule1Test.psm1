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

Write-Host "Loading TestingModule1Test ..." -ForegroundColor DarkCyan

function TestingModule1Test_Sample(){
    Assert-IsTrue -Condition $true
}

Export-ModuleMember -Function TestingModule1Test_*
