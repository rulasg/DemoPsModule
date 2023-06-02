[cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    # Update the module manifest with the version tag (Sample: v10.0.01-alpha)
    [Parameter(Mandatory=$false)] [string]$VersionTag
)

if ($PSCmdlet.ShouldProcess($VersionTag, "git tag creation")) {
    git tag -a $VersionTag -m "Release tag" -s ; git push --tags
}

if ($PSCmdlet.ShouldProcess($VersionTag, "gh release create")) {
    gh release create $VersionTag --prerelease --generate-notes --verify-tag --title "Release $VersionTag"  
}