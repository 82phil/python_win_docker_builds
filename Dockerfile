FROM mcr.microsoft.com/powershell:lts-nanoserver-2004 AS build
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet; \
    Install-Package python -RequiredVersion 3.7.9 -ProviderName NuGet -Scope CurrentUser -Force; \
    $pkg_path = (Get-Package).Source; \
    mkdir /Python; \
    cp -r (Join-Path (Split-Path $pkg_path) tools/*) /Python; \
    C:\Python\python -m pip install --upgrade pip;

FROM mcr.microsoft.com/windows/nanoserver:2004
COPY --from=build /Python /Python
RUN setx PATH '%PATH%;C:\Python;C:\Python\Scripts;'
