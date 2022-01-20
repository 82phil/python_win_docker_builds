# Python Image based on Windows Nano Server

This project allows you to build an image that provides Python based on _Windows Nano
Server_.  [Python provides images](https://hub.docker.com/_/python?tab=tags&page=1&name=windows)
based on _Windows Server Core_. The difference between them is that Nano Server is a much more
stripped down container image.

```bash
REPOSITORY   TAG                          IMAGE ID       CREATED          SIZE
python       3.9.9-windowsservercore      b2a3ac00cbf7   2 weeks ago      5.86GB
python       3.9-windowsnanoserver-1809   c0f263c70cf3   11 seconds ago   304MB
```

## Building an Image

```bash
# For the latest release
docker build -t pythonnano .

# If you want the latest 3.9 release
docker build --build-arg PYTHON_VERSION=3.9.99 -t python:3.9-windowsnanoserver-1809 .

# Check out your hard work!
docker run -it --rm python:3.9-windowsnanoserver-1809
```

In addition there are arguments to specify the OS version to use for the build
and final image. This can be useful for [process isolation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/hyperv-container#isolation-examples).

# Limitations

Because _Windows Nano Server_ is heavily stripped down, it is possible that
Python packages will fail to install or work properly. As I evaluate it further
I will update this section.

## PyInstaller

The 'BeginUpdateResource' in the Win32 API is missing from Nano Server.
PyInstaller uses this API to update metadata in the PE such as the icon for the
executable. Since Windows Server Core provides this API, I would recommend using
it instead.

That said ... there are some ways around this issue.

For releases later >= 4.2, PyInstaller appears to always use that API for
--onefile (just an .exe) builds. If you don't need a single executable, run
--PyInstaller and specify to not assign an executable icon.

```
pyinstaller -i=NONE --console .\your_app.py
```

I found that PyInstaller < 4.2 will work by default. The bootloader in those
releases contains a default icon already in the executable, so it won't attempt
to update the icon resource. It will also work to build a single executable.

https://github.com/dotnet/runtime/blob/57bfe474518ab5b7cfe6bf7424a79ce3af9d6657/src/installer/managed/Microsoft.NET.HostModel/ResourceUpdater.cs#L196-L198

https://github.com/hdf/pyinstaller/commit/8e16a3ae45050e9f318923babbb06874cf3345ee#diff

