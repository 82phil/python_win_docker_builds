$test = Invoke-WebRequest https://www.python.org/ftp/python/
$maches = $test.Links | Foreach {$_.href} | Select-String -Pattern "([0-9]+)\.([0-9]+)\.([0-9]+)" | Foreach {$major, $minor, $build = $_.Matches[0].Groups[1..3].Value; [PSCustomObject] @{major = [int]$major; minor = [int]$minor; build = [int]$build}}
$maches = $maches | Sort-Object -Property major, minor, build
# Latest
$maches | Where-Object {$_.major -Eq 3 } | Select-Object -Last 1
$maches | Where-Object {$_.major -Eq 3 -And $_.minor -Eq 7 } | Select-Object -Last 1
$maches | Where-Object {$_.major -Eq 2 } | Select-Object -Last 1

$major, $minor, $build = $maches | Where-Object {$_major -Eq 3} | Select-Object -Last 2

$test = $maches | Where-Object {$_.major -Eq 3 -And $_.minor -Eq 7 -And $_.build -Eq 9} | Select-Object -Last 1

$python_arch = '-amd64'

$url = 'https://www.python.org/ftp/python/{0}.{1}.{2}/python-{0}.{1}.{2}{3}.exe' -f $test.major, $test.minor, $test.build, $python_arch

Invoke-WebRequest -Uri $url -OutFile 'python.exe' 

Start-Process python.exe -Wait -NoNewWindow -PassThru -ArgumentList @('/quiet', '/log install.log', 'InstallAllUsers=1', 'TargetDir=C:\Python', 'PrependPath=1', 'Shortcuts=0', 'Include_doc=0', 'Include_test=0')


# This works for nanoserver
Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet
Install-Package python -Destination C:\Python -ProviderName NuGet -Force
