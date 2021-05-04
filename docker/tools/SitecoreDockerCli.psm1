using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

function Get-EnvValueByKey {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $Key,        
        [ValidateNotNullOrEmpty()]
        [string] 
        $FilePath = ".env.local",
        [ValidateNotNullOrEmpty()]
        [string] 
        $DockerRoot = ".\docker"
    )
    if (!(Test-Path $FilePath)) {
        $FilePath = Join-Path $DockerRoot $FilePath
    }
    if (!(Test-Path $FilePath)) {
        return ""
    }
    select-string -Path $FilePath -Pattern "^$Key=(.+)$" | % { $_.Matches.Groups[1].Value }
}
function  Test-IsEnvInitialized {
    $name = Get-EnvValueByKey "REPORTING_API_KEY"
    return ($null -ne $name -and $name -ne "")
}

function Remove-EnvHostsEntry {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $Key,
        [Switch]
        $Build        
    )
    $hostName = Get-EnvValueByKey $Key
    if ($null -ne $hostName -and $hostName -ne "") {
        Remove-HostsEntry $hostName
    }
}

function Start-Docker {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $Url,
        [ValidateNotNullOrEmpty()]
        [string] 
        $DockerRoot = ".\docker",
        [Switch]
        $Build
    )

    if ($Build) {
        docker-compose build
    }
    docker-compose --env-file ".env.local" up -d

    Write-Host "`nif something failed along the way, press [ctrl-c] to stop the dance and try again." -ForegroundColor Gray
    Write-Host "`ndon't forget to ""Populate Solr Managed Schema"" from the Control Panel`n`n`n" -ForegroundColor Yellow  

    Start-Sleep -Seconds 60

    Write-Host "`n`n`nopening https://$($url)`n`n" -ForegroundColor DarkGray
    Write-Host "`nIf the request fails with a 404 on the first attempt - just wait a few minutes and hit refresh..`n`n" -ForegroundColor DarkGray
    Start-Process "https://$url"
}

function Stop-Docker {
    param(
        [ValidateNotNullOrEmpty()]
        [string] 
        $DockerRoot = ".\docker",
        [Switch]$TakeDown,
        [Switch]$PruneSystem
    )

    if (Test-Path ".\docker-compose.yml") {
        if ($TakeDown) {
            docker-compose down
        }
        else {
            docker-compose stop
        }
        if ($PruneSystem) {
            docker system prune -f
        }
    }
}

function Install-SitecoreDockerTools {
    Import-Module PowerShellGet
    $SitecoreGallery = Get-PSRepository | Where-Object { $_.SourceLocation -eq "https://sitecore.myget.org/F/sc-powershell/api/v2" }
    if (-not $SitecoreGallery) {
        Write-Host "Adding Sitecore PowerShell Gallery..." -ForegroundColor Green 
        Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2 -InstallationPolicy Trusted
        $SitecoreGallery = Get-PSRepository -Name SitecoreGallery
    }
    
    $dockerToolsVersion = "10.1.4"
    Remove-Module SitecoreDockerTools -ErrorAction SilentlyContinue
    if (-not (Get-InstalledModule -Name SitecoreDockerTools -RequiredVersion $dockerToolsVersion -ErrorAction SilentlyContinue)) {
        Write-Host "Installing SitecoreDockerTools..." -ForegroundColor Green
        Install-Module SitecoreDockerTools -RequiredVersion $dockerToolsVersion -Scope CurrentUser -Repository $SitecoreGallery.Name
    }
    Write-Host "Importing SitecoreDockerTools..." -ForegroundColor Green
    Import-Module SitecoreDockerTools -RequiredVersion $dockerToolsVersion
}

function Initialize-HostNames {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $HostDomain
    )
    Write-Host "Adding hosts file entries..." -ForegroundColor Green

    Add-HostsEntry "cm.$($HostDomain)"
    Add-HostsEntry "cd.$($HostDomain)"
    Add-HostsEntry "id.$($HostDomain)"
    Add-HostsEntry "www.$($HostDomain)"
    
    if (!(Test-Path ".\docker\traefik\certs\cert.pem")) {
        & ".\\docker\\tools\\mkcert.ps1" -FullHostName $hostDomain
    }
}

function Show-Logo {
    
    $logo = @"
8888888                  d8b                             8888888b.                                  
  888                    Y8P                             888  "Y88b                                 
  888                                                    888    888                                 
  888   .d88b.  88888b.  888 888  888 88888b.d88b.       888    888  .d88b.  88888b.d88b.   .d88b.  
  888  d88P"88b 888 "88b 888 888  888 888 "888 "88b      888    888 d8P  Y8b 888 "888 "88b d88""88b 
  888  888  888 888  888 888 888  888 888  888  888      888    888 88888888 888  888  888 888  888 
  888  Y88b 888 888  888 888 Y88b 888 888  888  888      888  .d88P Y8b.     888  888  888 Y88..88P 
8888888 "Y88888 888  888 888  "Y88888 888  888  888      8888888P"   "Y8888  888  888  888  "Y88P"  
            888                                                                                     
       Y8b d88P                                                                                     
        "Y88P"       
                                                                                        Version 1.0                                                                           
"@

    Clear-Host
    #Write-Host $clock -ForegroundColor Cyan
    Write-Host $logo -ForegroundColor Red
    #Write-Host $experience -ForegroundColor Magenta
}

Export-ModuleMember -Function *