using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

function Install-DockerStarterKit {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $Name,
        [ValidateNotNullOrEmpty()]
        [string] 
        $StarterKitRoot = ".\_StarterKit",
        [ValidateNotNullOrEmpty()]
        [string] 
        $DestinationFolder = ".\docker\",
        [bool]$IncludeSolutionFiles
    )

    $foldersRoot = Join-Path $StarterKitRoot "\docker"
    $solutionFiles = Join-Path $StarterKitRoot "\solution\*"

    if (Test-Path $DestinationFolder) {
        Remove-Item $DestinationFolder -Force
    }
    New-Item $DestinationFolder -ItemType directory
    
    if ((Test-Path $solutionFiles) -and $IncludeSolutionFiles) {
        Write-Host "Copying solution and msbuild files for local docker setup.." -ForegroundColor Green
        Copy-Item $solutionFiles ".\" -Recurse -Force
    }
    
    Write-Host "Merging $($name) docker folder.." -ForegroundColor Green
    $folder = ""
    $Name.Split("-") | ForEach-Object{ 
        $folder = "$($folder)$($_)"; 
        if (Test-Path (Join-Path $foldersRoot $folder))
        {
            $path = "$((Join-Path $foldersRoot $folder))\*"
            Write-Host "Copying $($path) to $DestinationFolder" -ForegroundColor Magenta
            Copy-Item $path $DestinationFolder -Recurse -Force
        }
        $folder = "$($folder)-"
    }
    Move-Item (Join-Path $DestinationFolder "Dockerfile") ".\" -Force
}

function Get-EnvValueByKey {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $Key,        
        [ValidateNotNullOrEmpty()]
        [string] 
        $FilePath = ".env",
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
    docker-compose up -d

    Write-Host "`n`n..now the last thing left to do is a little dance for about 15 seconds to make sure Traefik is ready..`n`n`n" -ForegroundColor DarkYellow
    Write-Host "`nif something failed along the way, press [ctrl-c] to stop the dance and try again." -ForegroundColor Gray
    Write-Host "`ndon't forget to ""Populate Solr Managed Schema"" from the Control Panel`n`n`n" -ForegroundColor Yellow  
    Write-Host "`n`n`ndance done.. opening https://$($url)`n`n" -ForegroundColor DarkGray
    Write-Host "`nIf the request fails with a 404 on the first attempt then the dance wasn't long enough - just hit refresh..`n`n" -ForegroundColor DarkGray
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
        & ".\_StarterKit\tools\\mkcert.ps1" -FullHostName $hostDomain
    }
}

function Show-Logo {
    

    Clear-Host
    #Write-Host $clock -ForegroundColor Cyan
    #Write-Host $logo -ForegroundColor Red
    #Write-Host $experience -ForegroundColor Magenta
}

Export-ModuleMember -Function *