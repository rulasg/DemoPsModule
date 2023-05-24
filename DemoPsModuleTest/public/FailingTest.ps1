function DemoPsModuleTest_FailingTest{
    Assert-IsTrue -Condition $false
} Export-ModuleMember -Function DemoPsModuleTest_FailingTest
