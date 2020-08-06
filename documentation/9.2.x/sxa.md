# Sitecore 9.2.x SXA

In order to run images of 9.2.x you need to make sure your `.env` file looks similar to:

``` (.env)
REGISTRY=igniumdigital.azurecr.io/
ISOLATION=
SQL_SA_PASSWORD=8Tombs-Given-Clock#-arming-Alva-debut-Spine-monica-Normal-Ted-About1-chard-Easily-granddad-5Context!
TELERIK_ENCRYPTION_KEY=qspJhcSmT5VQSfbZadFfzhCK6Ud7uRoS42Qcm8UofvVLiXciUBcUeZELsTo8KD9o6KderQr9Z8uZ9CHisFJNRz46WTZ5qCRufRFt
WINDOWSSERVERCORE_VERSION=2004
NANOSERVER_VERSION=1809
SITECORE_VERSION=9.2.0
LICENSE_PATH=C:\license
```

Then in a windows terminal, run the following command:

``` (docker-compose)
c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" up -d
```