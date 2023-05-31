

$publishScript = $PSScriptRoot | split-path -Parent | split-path -Parent | Join-Path -ChildPath 'publish.ps1'

$ErrorParameters = @{
    ErrorAction = 'SilentlyContinue' 
    ErrorVar = 'errorVar'
}
$InfoParameters = @{
    InformationAction = 'SilentlyContinue' 
    InformationVar = 'infoVar'
}

function DemoPsModuleTest_Publish_NoTag_NoKey{

    & $publishScript @ErrorParameters

    Assert-IsFalse $? -Comment "Publish command should fail with Exit <> 0" 
    Assert-AreEqual -Expected 1 -Presented $LASTEXITCODE
    Assert-Count -Expected 1 -Presented $errorVar
    Assert-IsTrue -Condition ($errorVar[0].exception.Message.Contains('$Env:NUGETAPIKEY is not set.') )
}

function DemoPsModuleTest_Publish_WithKey{

    & $publishScript -NuGetApiKey "something" @InfoParameters

    Assert-Contains -Presented $infoVar -Expected "Publishing DemoPsModule.psm1 10.0.0 alpha to PSGallery ..."
}

function DemoPsModuleTest_Publish_Key_InEnvironment{

    $Env:NUGETAPIKEY = "something"

    & $publishScript -NuGetApiKey "something" @InfoParameters

    Assert-Contains -Presented $infoVar -Expected "Publishing DemoPsModule.psm1 10.0.0 alpha to PSGallery ..."
}