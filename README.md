# python_win_docker_builds
Builds Windows images with Python installed

Had an idea about what I might want this to be...

Basically I want a way to script building docker images for Python

So build-py 2.7 would grab the latest 2.7 release and make an image for it

build-py 3.9 would do the same for the 3.9 release

 Select-String -InputObject "3.7" -Pattern "^([0-9]+)(\.[0-9]+)?(\.[0-9]+)?$"

(Select-String -InputObject "3.7.1" -Pattern "^([0-9]+)(?:\.([0-9]+))?(?:\.([0-9]+))?$").Matches[0].Groups[1..3].Value

