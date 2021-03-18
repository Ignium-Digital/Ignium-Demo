# escape=`

ARG BASE_IMAGE
ARG HEADLESS_SERVICES_IMAGE

FROM ${HEADLESS_SERVICES_IMAGE} as headless
FROM ${BASE_IMAGE}

COPY --from=headless c:\module\db c:\jss_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory c:\jss_data; `
    Remove-Item -Path C:\jss_Data -Recurse -Force;