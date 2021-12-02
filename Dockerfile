FROM mcr.microsoft.com/powershell:lts-nanoserver-2004 AS build
# Note if you want the latest release use 3.99.99, or 3.8.99 for the latest release for 3.8
# TODO: Code to allow just specifying 3 for latest Python 3, or 3.8 for latest 3.8
ARG PYTHON_VERSION=3.99.99
ENV PYTHON_VERSION $PYTHON_VERSION
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
# Install the Python nuget package. The full installer will not work with Nano Server
# https://docs.python.org/3/using/windows.html#the-nuget-org-packages
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet; \
    Install-Package python -MaximumVersion $env:PYTHON_VERSION -ProviderName NuGet -Scope CurrentUser -Force; \
    $pkg_path = (Get-Package).Source; \
    mkdir /Python; \
    cp -r (Join-Path (Split-Path $pkg_path) tools/*) /Python; \
    C:\Python\python -m pip install --upgrade pip;

# Nano Server by itself is stripped of PowerShell and so it is smaller
FROM mcr.microsoft.com/windows/nanoserver:2004
COPY --from=build /Python /Python
RUN setx PATH '%PATH%;C:\Python;C:\Python\Scripts;'
