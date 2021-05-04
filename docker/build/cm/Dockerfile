# escape=`

ARG BASE_IMAGE
ARG HEADLESS_SERVICES_IMAGE
ARG TOOLING_IMAGE
ARG HRZ_IMAGE
ARG SMS_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${HEADLESS_SERVICES_IMAGE} as headless
FROM ${HRZ_IMAGE} as horizon
FROM ${SMS_IMAGE} as management
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Enable WebSockets
RUN powershell -Command Add-WindowsFeature Web-WebSockets

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add JSS module
COPY --from=headless \module\cm\content .\
COPY --from=headless \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Allow configurable JSS Import User
#COPY .\config .\App_Config\Include\

# Add Horizon Module
COPY --from=horizon \module\cm\content .\

# Add Sitecore Management Services
COPY --from=management \module\cm\content .\

# Copy solution website files
COPY --from=solution /artifacts/platform/ ./