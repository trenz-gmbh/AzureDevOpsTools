[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $OrgName,

    [Parameter()]
    [switch]
    $Confirm
)

# Begin of main script
$repos = & "$PSScriptRoot\Get-AdoGitRepos.ps1" -OrgName $OrgName -ExcludePermissions
if ($null -eq $repos)
{
    Write-Error "No repositories found for org $OrgName"
    exit 1
}

foreach ($repo in $repos)
{
    Write-Host "Processing project: $($repo.ProjectName), repo: $($repo.Name)"
    $params = @{ OrgName = $OrgName; ProjectName = $repo.ProjectName; RepoName = $repo.Name }
    if ($Confirm.IsPresent)
    {
        $params.Confirm = $true
    }
    & "$PSScriptRoot\Remove-AdoGitRepoWritePermissions.ps1" @params
}
