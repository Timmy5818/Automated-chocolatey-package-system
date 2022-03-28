# The encoding used by this program is Big-5
# 建立Chocolatey私有套件自動化上傳私有伺服器程式
# 第4~9行為此程式將以系統管理員執行
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

$name = "xampp_test"
Set-Location "C:\tools"

choco new $name -Force


$pkg_name = "xampp_test"
$pkg_version = "7.4.28"

# 覆寫nuspec檔案，填入需要的參數軟體包名稱以及版本
$nuspec_file = @”
<?xml version="1.0" encoding="utf-8"?>
<!-- Read this before creating packages: https://docs.chocolatey.org/en-us/create/create-packages -->
<!-- It is especially important to read the above link to understand additional requirements when publishing packages to the community feed aka dot org (https://community.chocolatey.org/packages). -->

<!-- Test your packages in a test environment: https://github.com/chocolatey/chocolatey-test-environment -->

<!--
This is a nuspec. It mostly adheres to https://docs.nuget.org/create/Nuspec-Reference. Chocolatey uses a special version of NuGet.Core that allows us to do more than was initially possible. As such there are certain things to be aware of:

* the package xmlns schema url may cause issues with nuget.exe
* Any of the following elements can ONLY be used by choco tools - projectSourceUrl, docsUrl, mailingListUrl, bugTrackerUrl, packageSourceUrl, provides, conflicts, replaces
* nuget.exe can still install packages with those elements but they are ignored. Any authoring tools or commands will error on those elements
-->

<!-- You can embed software files directly into packages, as long as you are not bound by distribution rights. -->
<!-- * If you are an organization making private packages, you probably have no issues here -->
<!-- * If you are releasing to the community feed, you need to consider distribution rights. -->
<!-- Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one. -->
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <!-- == PACKAGE SPECIFIC SECTION == -->
    <!-- This section is about this package, although id and version have ties back to the software -->
    <!-- id is lowercase and if you want a good separator for words, use '-', not '.'. Dots are only acceptable as suffixes for certain types of packages, e.g. .install, .portable, .extension, .template -->
    <!-- If the software is cross-platform, attempt to use the same id as the debian/rpm package(s) if possible. -->
    <id>$pkg_name</id>
    <!-- version should MATCH as closely as possible with the underlying software -->
    <!-- Is the version a prerelease of a version? https://docs.nuget.org/create/versioning#creating-prerelease-packages -->
    <!-- Note that unstable versions like 0.0.1 can be considered a released version, but it's possible that one can release a 0.0.1-beta before you release a 0.0.1 version. If the version number is final, that is considered a released version and not a prerelease. -->
    <version>$pkg_version</version>
    <!-- <packageSourceUrl>Where is this Chocolatey package located (think GitHub)? packageSourceUrl is highly recommended for the community feed</packageSourceUrl>-->
    <!-- owners is a poor name for maintainers of the package. It sticks around by this name for compatibility reasons. It basically means you. -->
    <!--<owners>__REPLACE_YOUR_NAME__</owners>-->
    <!-- ============================== -->

    <!-- == SOFTWARE SPECIFIC SECTION == -->
    <!-- This section is about the software itself -->
    <title>xampp_test (Install)</title>
    <authors>__REPLACE_AUTHORS_OF_SOFTWARE_COMMA_SEPARATED__</authors>
    <!-- projectUrl is required for the community feed -->
    <projectUrl>https://_Software_Location_REMOVE_OR_FILL_OUT_</projectUrl>
    <!-- There are a number of CDN Services that can be used for hosting the Icon for a package. More information can be found here: https://docs.chocolatey.org/en-us/create/create-packages#package-icon-guidelines -->
    <!-- Here is an example using Githack -->
    <!--<iconUrl>http://rawcdn.githack.com/__REPLACE_YOUR_REPO__/master/icons/xampp_test.png</iconUrl>-->
    <!-- <copyright>Year Software Vendor</copyright> -->
    <!-- If there is a license Url available, it is required for the community feed -->
    <!-- <licenseUrl>Software License Location __REMOVE_OR_FILL_OUT__</licenseUrl>
    <requireLicenseAcceptance>true</requireLicenseAcceptance>-->
    <!--<projectSourceUrl>Software Source Location - is the software FOSS somewhere? Link to it with this</projectSourceUrl>-->
    <!--<docsUrl>At what url are the software docs located?</docsUrl>-->
    <!--<mailingListUrl></mailingListUrl>-->
    <!--<bugTrackerUrl></bugTrackerUrl>-->
    <tags>xampp_test SPACE_SEPARATED</tags>
    <summary>__REPLACE__</summary>
    <description>__REPLACE__MarkDown_Okay </description>
    <!-- <releaseNotes>__REPLACE_OR_REMOVE__MarkDown_Okay</releaseNotes> -->
    <!-- =============================== -->

    <!-- Specifying dependencies and version ranges? https://docs.nuget.org/create/versioning#specifying-version-ranges-in-.nuspec-files -->
    <!--<dependencies>
      <dependency id="" version="__MINIMUM_VERSION__" />
      <dependency id="" version="[__EXACT_VERSION__]" />
      <dependency id="" version="[_MIN_VERSION_INCLUSIVE, MAX_VERSION_INCLUSIVE]" />
      <dependency id="" version="[_MIN_VERSION_INCLUSIVE, MAX_VERSION_EXCLUSIVE)" />
      <dependency id="" />
      <dependency id="chocolatey-core.extension" version="1.1.0" />
    </dependencies>-->
    <!-- chocolatey-core.extension - https://community.chocolatey.org/packages/chocolatey-core.extension
         - You want to use Get-UninstallRegistryKey on less than 0.9.10 (in chocolateyUninstall.ps1)
         - You want to use Get-PackageParameters and on less than 0.11.0
         - You want to take advantage of other functions in the core community maintainer's team extension package
    -->

    <!--<provides>NOT YET IMPLEMENTED</provides>-->
    <!--<conflicts>NOT YET IMPLEMENTED</conflicts>-->
    <!--<replaces>NOT YET IMPLEMENTED</replaces>-->
  </metadata>
  <files>
    <!-- this section controls what actually gets packaged into the Chocolatey package -->
    <file src="tools\**" target="tools" />
  </files>
</package>
“@

# 覆寫<name>/tools/chocolateyinstall.ps1檔案
# 因下列chocolateyinstall.ps1檔案$會判別為變數，將其改成文字字串，請勿更動$url,$url64,$packageArgs,$env:ChocolateyPackageName,$toolsDir,$fileLocation變數
$url = @'
$url
'@
$url64 = @'
$ur164
'@
$packageArgs = @'
$packageArgs
'@
$env:ChocolateyPackageName = @'
$env:ChocolateyPackageName
'@
$toolsDir = @'
$toolsDir
'@
$fileLocation =@'
$fileLocation
'@

# 請在此處更改URL的下載連結
$url_tmp = 'https://www.apachefriends.org/xampp-files/7.4.28/xampp-windows-x64-7.4.28-0-VC15-installer.exe'

# 請輸入檔案類型，只能是EXE,MSI,MSU
$fileType = "EXE"

# 請輸入軟體名稱(只能是小寫)
$softwareName ="xampp_test"

$install_1 = @'
# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# 1. See the _TODO.md that is generated top level and read through that
# 2. Follow the documentation below to learn how to create a package for the package type you are creating.
# 3. In Chocolatey scripts, ALWAYS use absolute paths - $toolsDir gets you to the package's tools directory.
$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Internal packages (organizations) or software that has redistribution rights (community repo)
# - Use `Install-ChocolateyInstallPackage` instead of `Install-ChocolateyPackage`
#   and put the binaries directly into the tools folder (we call it embedding)
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
# If embedding binaries increase total nupkg size to over 1GB, use share location or download from urls
#$fileLocation = '\\SHARE_LOCATION\to\INSTALLER_FILE'
# Community Repo: Use official urls for non-redist binaries or redist where total package size is over 200MB
# Internal/Organization: Download from internal location (internet sources are unreliable)
'@

$install_2 = @"
$url        = '$url_tmp' # download url, HTTPS preferred
$url64      = '$url_tmp' # 64bit URL here (HTTPS preferred) or remove - if installer contains both (very rare)
"@

$install_3 = @"
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = '$fileType' #only one of these: exe, msi, msu
  url           = $url
  url64bit      = $url64
  #file         = $fileLocation

  softwareName  = '$softwareName*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
"@

$install_4 = @'
  # Checksums are now required as of 0.10.0.
  # To determine checksums, you can get that from the original site if provided.
  # You can also use checksum.exe (choco install checksum) and use it
  # e.g. checksum -t sha256 -f path\to\file
  checksum      = ''
  checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
  checksum64    = ''
  checksumType64= 'sha256' #default is checksumType

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
  # OTHERS
  # Uncomment matching EXE type (sorted by most to least common)
  #silentArgs   = '/S'           # NSIS
  #silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  #silentArgs   = '/s'           # InstallShield
  #silentArgs   = '/s /v"/qn"'   # InstallShield with MSI
  #silentArgs   = '/s'           # Wise InstallMaster
  #silentArgs   = '-s'           # Squirrel
  #silentArgs   = '-q'           # Install4j
  #silentArgs   = '-s'           # Ghost
  # Note that some installers, in addition to the silentArgs above, may also need assistance of AHK to achieve silence.
  #silentArgs   = ''             # none; make silent with input macro script like AutoHotKey (AHK)
                                 #       https://community.chocolatey.org/packages/autohotkey.portable
  #validExitCodes= @(0) #please insert other valid exit codes here
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
#Install-ChocolateyZipPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage
## If you are making your own internal packages (organizations), you can embed the installer or
## put on internal file share and use the following instead (you'll need to add $file to the above)
#Install-ChocolateyInstallPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyinstallpackage

## Main helper functions - these have error handling tucked into them already
## see https://docs.chocolatey.org/en-us/create/functions

## Install an application, will assert administrative rights
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyinstallpackage
## add additional optional arguments as necessary
##Install-ChocolateyPackage $packageName $fileType $silentArgs $url [$url64 -validExitCodes $validExitCodes -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]

## Download and unpack a zip file - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage
##Install-ChocolateyZipPackage $packageName $url $toolsDir [$url64 -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]

## Install Visual Studio Package - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyvsixpackage
#Install-ChocolateyVsixPackage $packageName $url [$vsVersion] [-checksum $checksum -checksumType $checksumType]
#Install-ChocolateyVsixPackage @packageArgs

## see the full list at https://docs.chocolatey.org/en-us/create/functions

## downloader that the main helpers use to download items
## if removing $url64, please remove from here
## - https://docs.chocolatey.org/en-us/create/functions/get-chocolateywebfile
#Get-ChocolateyWebFile $packageName 'DOWNLOAD_TO_FILE_FULL_PATH' $url $url64

## Installer, will assert administrative rights - used by Install-ChocolateyPackage
## use this for embedding installers in the package when not going to community feed or when you have distribution rights
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyinstallpackage
#Install-ChocolateyInstallPackage $packageName $fileType $silentArgs '_FULLFILEPATH_' -validExitCodes $validExitCodes

## Unzips a file to the specified location - auto overwrites existing content
## - https://docs.chocolatey.org/en-us/create/functions/get-chocolateyunzipp
#Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" $toolsDir

## Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
## - https://docs.chocolatey.org/en-us/create/functions/start-chocolateyprocessasadmin
#Start-ChocolateyProcessAsAdmin 'STATEMENTS_TO_RUN' 'Optional_Application_If_Not_PowerShell' -validExitCodes $validExitCodes

## To avoid quoting issues, you can also assemble your -Statements in another variable and pass it in
#$appPath = "$env:ProgramFiles\appname"
##Will resolve to C:\Program Files\appname
#$statementsToRun = "/C `"$appPath\bin\installservice.bat`""
#Start-ChocolateyProcessAsAdmin $statementsToRun cmd -validExitCodes $validExitCodes

## add specific folders to the path - any executables found in the chocolatey package
## folder will already be on the path. This is used in addition to that or for cases
## when a native installer doesn't add things to the path.
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateypath
#Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights

## Add specific files as shortcuts to the desktop
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyshortcut
#$target = Join-Path $toolsDir "$($packageName).exe"
# Install-ChocolateyShortcut -shortcutFilePath "<path>" -targetPath "<path>" [-workDirectory "C:\" -arguments "C:\test.txt" -iconLocation "C:\test.ico" -description "This is the description"]

## Outputs the bitness of the OS (either "32" or "64")
## - https://docs.chocolatey.org/en-us/create/functions/get-osarchitecturewidth
#$osBitness = Get-ProcessorBits

## Set persistent Environment variables
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyenvironmentvariable
#Install-ChocolateyEnvironmentVariable -variableName "SOMEVAR" -variableValue "value" [-variableType = 'Machine' #Defaults to 'User']

## Set up a file association
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyfileassociation
#Install-ChocolateyFileAssociation

## Adding a shim when not automatically found - Cocolatey automatically shims exe files found in package directory.
## - https://docs.chocolatey.org/en-us/create/functions/install-binfile
## - https://docs.chocolatey.org/en-us/create/create-packages#how-do-i-exclude-executables-from-getting-shims
#Install-BinFile

##PORTABLE EXAMPLE
#$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
#Install-ChocolateyZipPackage $packageName $url $toolsDir $url64
## END PORTABLE EXAMPLE

## [DEPRECATING] PORTABLE EXAMPLE
#$binRoot = Get-BinRoot
#$installDir = Join-Path $binRoot "$packageName"
#Write-Host "Adding `'$installDir`' to the path and the current shell path"
#Install-ChocolateyPath "$installDir"
#$env:Path = "$($env:Path);$installDir"

# if removing $url64, please remove from here
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
#Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"
## END PORTABLE EXAMPLE
'@

# 建立nuspec檔案，並覆蓋原本的nuspec檔案
$nuspec_file | Out-File C:\tools\$name\$name.nuspec

# 建立ps1檔案，並覆蓋原本的chocolateyinsyall.ps1檔案
$install_ps1 = $install_1 ,$install_2 , $install_3 , $install_4
$install_ps1 | Out-File C:\tools\$name\tools\chocolateyinstall.ps1

# 建立上傳需要的nupkg檔案
Set-Location C:\tools\$name
choco pack

# 上傳到私有伺服器
Set-Location C:\tools\$name
choco push --source "'http://127.0.0.1/chocolatey'" -k="chocolateyrocks" --force
Write-Host "成功上傳套件"
# 顯示本次上傳的套件
choco search $name

# 顯示本機可以安裝的套件
Write-Host "此私人伺服器可供安裝的套件"
choco list --source http://127.0.0.1/chocolatey

pause