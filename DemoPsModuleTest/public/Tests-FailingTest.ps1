# This test is to tet the GitHub Pipe failure when enabled
function DemoPsModuleTest_FailingTest{
    # Assert-IsTrue -Condition $false
} Export-ModuleMember -Function DemoPsModuleTest_FailingTest
