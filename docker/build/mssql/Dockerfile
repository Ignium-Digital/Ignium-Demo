# escape=`

ARG BASE_IMAGE
ARG HEADLESS_SERVICES_IMAGE
ARG HRZ_IMAGE

FROM ${HEADLESS_SERVICES_IMAGE} as headless
FROM ${HRZ_IMAGE} as horizon
FROM ${BASE_IMAGE}

COPY --from=headless c:\module\db c:\jss_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory c:\jss_data; `
    Remove-Item -Path C:\jss_Data -Recurse -Force;

# Add Horizon Module
COPY --from=horizon \module\db \horizon_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\horizon_data; `
    Remove-Item -Path C:\horizon_data -Recurse -Force;