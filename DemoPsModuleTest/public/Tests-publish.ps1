

$publish_ps1 = $PSScriptRoot | split-path -Parent | split-path -Parent | Join-Path -ChildPath 'publish.ps1'

$ErrorParameters = @{
    ErrorAction = 'SilentlyContinue' 
    ErrorVar = 'errorVar'
}
$InfoParameters = @{
    InformationAction = 'SilentlyContinue' 
    InformationVar = 'infoVar'
}

function DemoPsModuleTest_Publish_NoTag_NoKey{

    # Fails due to lack of key as parameter of environment
    
    # Clear key env variable 
    $env:NUGETAPIKEY = $null

    & $publish_ps1 @ErrorParameters -whatif

    # Assert for error
    Assert-IsFalse $? -Comment "Publish command should fail with Exit <> 0" 
    Assert-AreEqual -Expected 1 -Presented $LASTEXITCODE
    Assert-Count -Expected 1 -Presented $errorVar
    Assert-IsTrue -Condition ($errorVar[0].exception.Message.Contains('$Env:NUGETAPIKEY is not set.') )
}

function DemoPsModuleTest_Publish_WithKey{

    & $publish_ps1 -NuGetApiKey "something" @InfoParameters -whatif

    Assert-IsTrue $? -Comment "Publish command should success with Exit = 0" 
    Assert-IsTrue -Condition ($infovar[0].MessageData.StartsWith('Publishing DemoPsModule.psm1') )
}

function DemoPsModuleTest_Publish_Key_InEnvironment{

    $Env:NUGETAPIKEY = "something"

    & $publish_ps1 -NuGetApiKey "something" @InfoParameters -whatif
    
    Assert-IsTrue $? -Comment "Publish command should success with Exit = 0" 
    Assert-IsTrue -Condition ($infovar[0].MessageData.StartsWith('Publishing DemoPsModule.psm1') )

}

function DemoPsModuleTest_Publish_With_VersionTag{

    # Confirm that we extract from the tag the paramers

    $Env:NUGETAPIKEY = "something"

    $versionTag = '1.0.0-alpha'

    & $publish_ps1 -VersionTag $versionTag @InfoParameters -whatif

    Assert-ManifestAndReset -Version "1.0.0" -Prerelease "alpha"
}


function Assert-ManifestAndReset{
    param(
        [Parameter(Mandatory=$true)][string]$Version,
        [Parameter(Mandatory=$true)][string]$Prerelease  
    )

    $manifestPath = $PSScriptRoot | Split-Path -Parent | Split-Parent | Join-Path -ChildPath 'DemoPsModule.psd1'
    $manifest = Import-PowerShellDataFile -Path $manifestPath

    Assert-AreEqual -Expected $version -Presented $manifest.ModuleVersion
    Assert-AreEqual -Expected $prerelease -Presented $manifest.PrivateData.PSData.Prerelease

    git restore $manifestPath

}
