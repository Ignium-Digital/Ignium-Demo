Import-Module -Name (Join-Path $PSScriptRoot "docker\\tools\\SitecoreDockerCli.psm1") -Force

Show-Logo

Stop-Docker -TakeDown -PruneSystem

Write-Host "Job's done.." -ForegroundColor Green