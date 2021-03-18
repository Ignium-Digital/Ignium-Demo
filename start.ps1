#Requires -RunAsAdministrator

Import-Module -Name (Join-Path $PSScriptRoot ".\docker\tools\SitecoreDockerCli.psm1") -Force

Show-Logo

if (Test-IsEnvInitialized -FilePath ".\.env" ) {
    Write-Host "Docker environment is present, starting docker.." -ForegroundColor Green

    if (!(Test-Path ".\docker\traefik\certs\cert.pem")) {
        Write-Host "TLS certificate for Traefik not found, generating and adding hosts file entries" -ForegroundColor Green
        Install-SitecoreDockerTools
        $hostDomain = Get-EnvValueByKey "HOST_DOMAIN"
        if ($hostDomain -eq "") {
            throw "Required variable 'HOST_DOMAIN' not set in .env file."
        }
        Initialize-HostNames $hostDomain
        Start-Docker -Url "$($hostDomain)/sitecore" -Build
        exit 0
    }
    Start-Docker -Url "$(Get-EnvValueByKey "CM_HOST")/sitecore"
    exit 0
}

if ((Test-Path ".\*.sln")) {
    if (!(Confirm "A solution file already exist but no initialized docker environmnent was found.`n`nWould you like to install a Docker environment preset??")) {
        exit 0
    }
    if (Test-Path (Join-Path $PSScriptRoot "docker")) {
        Remove-Item (Join-Path $PSScriptRoot "docker") -Force -Recurse
    }
}





Write-Host "$($dockerPreset) selected.." -ForegroundColor Magenta

Install-DockerStarterKit -Name $dockerPreset -IncludeSolutionFiles (Confirm -Question "Would you like to include a basic solution msbuild setup?" -DefaultYes)



Install-SitecoreDockerTools

$hostDomain = "$($solutionName.ToLower()).localhost"
$hostDomain = Read-ValueFromHost -Question "Domain Hostname (press enter for $($hostDomain))" -DefaultValue $hostDomain -Required
Initialize-HostNames $hostDomain




Set-EnvFileVariable "REPORTING_API_KEY" -Value (Get-SitecoreRandomString 128 -DisallowSpecial)
Set-EnvFileVariable "TELERIK_ENCRYPTION_KEY" -Value (Get-SitecoreRandomString 128)
Set-EnvFileVariable "MEDIA_REQUEST_PROTECTION_SHARED_SECRET" -Value (Get-SitecoreRandomString 64 -DisallowSpecial)
Set-EnvFileVariable "SITECORE_IDSECRET" -Value (Get-SitecoreRandomString 64 -DisallowSpecial)
$idCertPassword = Get-SitecoreRandomString 8 -DisallowSpecial
Set-EnvFileVariable "SITECORE_ID_CERTIFICATE" -Value (Get-SitecoreCertificateAsBase64String -DnsName "localhost" -Password (ConvertTo-SecureString -String $idCertPassword -Force -AsPlainText))
Set-EnvFileVariable "SITECORE_ID_CERTIFICATE_PASSWORD" -Value $idCertPassword



Start-Docker -Url "cm.$($hostDomain)/sitecore" -Build

