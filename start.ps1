#Requires -RunAsAdministrator

param(
    [Switch]$Build = $false
)

Import-Module -Name (Join-Path $PSScriptRoot ".\docker\tools\SitecoreDockerCli.psm1") -Force

Show-Logo

if (Test-IsEnvInitialized -FilePath ".\.env.local" ) {
    Write-Host "Docker environment is present, starting docker.." -ForegroundColor Green

    if (!(Test-Path ".\docker\traefik\certs\cert.pem")) {
        Write-Host "TLS certificate for Traefik not found, generating and adding hosts file entries" -ForegroundColor Green
        Install-SitecoreDockerTools
        $hostDomain = Get-EnvValueByKey "HOST_DOMAIN"
        if ($hostDomain -eq "") {
            throw "Required variable 'HOST_DOMAIN' not set in .env file."
        }
        Initialize-HostNames $hostDomain

        if ($Build.IsPresent) {
            Start-Docker -Url "$($hostDomain)/sitecore" -Build
        } else {
            Start-Docker -Url "$($hostDomain)/sitecore"
        }
        exit 0
    }

    if ($Build.IsPresent) {
        Start-Docker -Url "$(Get-EnvValueByKey "CM_HOST")/sitecore" -Build
    } else {
        Start-Docker -Url "$(Get-EnvValueByKey "CM_HOST")/sitecore"
    }
    
    exit 0
}

Install-SitecoreDockerTools

Copy-Item -Path .env -Destination .env.local

$hostDomain = Get-EnvValueByKey "HOST_DOMAIN"

Initialize-HostNames $hostDomain

Set-EnvFileVariable "REPORTING_API_KEY" -Value (Get-SitecoreRandomString 128 -DisallowSpecial) -Path ".env.local"
Set-EnvFileVariable "TELERIK_ENCRYPTION_KEY" -Value (Get-SitecoreRandomString 128) -Path ".env.local"
Set-EnvFileVariable "MEDIA_REQUEST_PROTECTION_SHARED_SECRET" -Value (Get-SitecoreRandomString 64 -DisallowSpecial) -Path ".env.local"
Set-EnvFileVariable "SITECORE_IDSECRET" -Value (Get-SitecoreRandomString 64 -DisallowSpecial) -Path ".env.local"
$idCertPassword = Get-SitecoreRandomString 8 -DisallowSpecial
Set-EnvFileVariable "SITECORE_ID_CERTIFICATE" -Value (Get-SitecoreCertificateAsBase64String -DnsName "localhost" -Password (ConvertTo-SecureString -String $idCertPassword -Force -AsPlainText)) -Path ".env.local"
Set-EnvFileVariable "SITECORE_ID_CERTIFICATE_PASSWORD" -Value $idCertPassword -Path ".env.local"

$saPassword = Get-SitecoreRandomString 12 -DisallowSpecial
Set-EnvFileVariable "SQL_SA_PASSWORD" -Value $saPassword -Path ".env.local"

if ($Build.IsPresent) {
    Start-Docker -Url "cm.$($hostDomain)/sitecore" -Build
} else {
    Start-Docker -Url "cm.$($hostDomain)/sitecore"
}