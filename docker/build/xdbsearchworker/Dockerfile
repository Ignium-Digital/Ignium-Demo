# escape=`

ARG BASE_IMAGE
ARG HEADLESS_SERVICES_IMAGE

FROM ${HEADLESS_SERVICES_IMAGE} as headless
FROM ${BASE_IMAGE}

# Add Headless (JSS) Module
COPY --from=headless C:\module\cm\content c:\inetpub\wwwroot
COPY --from=headless C:\module\tools c:\module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath C:\inetpub\wwwroot; `
    Remove-Item -Path c:\module -Recurse -Force