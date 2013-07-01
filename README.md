badass
======
a very nice windows powershell profile

version v1.0

features
========

1. AutoInstalls a powershell profile
2. Ensures autoload of configurable profiles

install
========
$branch = "release"
(new-object Net.WebClient).DownloadString("https://raw.github.com/appetiteoven/badass/$($branch)/Install-BadAss.ps1") | iex

module
========
To import the module:

    import-module badass
    
