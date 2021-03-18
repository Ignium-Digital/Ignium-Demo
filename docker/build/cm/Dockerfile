# escape=`

ARG BASE_IMAGE
ARG HEADLESS_SERVICES_IMAGE
ARG TOOLING_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${HEADLESS_SERVICES_IMAGE} as headless
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy development tools and entrypoint
COPY --from=tools \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add JSS module
COPY --from=headless \module\cm\content .\
COPY --from=headless \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Allow configurable JSS Import User
COPY .\config .\App_Config\Include\

# Copy solution website files
COPY --from=solution /artifacts/platform/ ./