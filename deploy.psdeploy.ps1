# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

# folder structure of:
# - RepoFolder
#   - This PSDeploy file
#   - ModuleName
#     - ModuleName.psd1

# Nuget key in $ENV:NugetApiKey

# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# Publish to gallery with a few restrictions
if (
    $env:BHPSModulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "main" -and
    $env:BHCommitMessage -match '!deploy'
) {
    Deploy Module {
        By PSGalleryModule {
            FromSource $ENV:BHPSModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
} else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the main branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
    Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
# You can use this to test a build from AppVeyor before pushing to psgallery
# https://psdeploy.readthedocs.io/en/latest/Example-AppVeyorModule-Deployment/

if (
    $env:BHPSModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor'
) {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}
