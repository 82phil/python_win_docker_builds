FROM mcr.microsoft.com/powershell:lts-nanoserver-2004 AS build

WORKDIR C:/temp

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

# USER ContainerAdmnistrator

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet; \
    Install-Package python -RequiredVersion 3.7.9 -ProviderName NuGet -Scope CurrentUser -Force; \
    $pkg_path = (Get-Package).Source; \
    mkdir /Python; \
    cp -r (Join-Path (Split-Path $pkg_path) tools/*) /Python; 


ENV PYTHONPATH C:\\Python;C:\\Python\\Scripts
RUN $PATH = $env:PATH + 'C:\Python;C:\Python\Scripts;'; \
    [System.Environment]::SetEnvironmentVariable('Path', $PATH, [System.EnvironmentVariableTarget]::User)

RUN Write-Output ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)

RUN Write-Output $env:PATH

RUN C:\Python\python -m pip install --upgrade --force pip

COPY ./test .

RUN C:\python\python -m venv venv

# Where I left off. First, PyInstaller 4.2 on up is broken for icons. If you set icon=None then it will
# build the executable with the latest (4.5.1). For some reason UppdateResourceCreate Win32 API call
# fails, but I have not figured that one out enough.

# https://github.com/hdf/pyinstaller/commit/8e16a3ae45050e9f318923babbb06874cf3345ee#diff-77f3027aa50add6bcb8d022102e224d08e87c44216d1028ca76039fc2746a025

# Also there are Python 2.7 and Python 2.7 x86 releases that we could potentially use to
# lighten the builds. Might be worth trying at least to see if anything else would break the
# build process
