<#
.SYNOPSIS
Install-OfficeCTR.ps1 - Office 365 CTR Install Script

.DESCRIPTION 
This PowerShell script will install Office 365 Click-to-Run on
client computers.

This script is designed to work with Office 2016 builds of
Office 365 CTR, not Office 2013.

Before using this script you should set up an shared folder for
your Office 365 CTR deployments by following the instructions
at http://practical365.com

.PARAMETER InstallRoot
Specify the UNC path to the network share that hosts the Office 365
setup and configuration files.

.PARAMETER SKU
Specify the the Office CTR SKU to deploy (e.g. ProPlus, Business)

.PARAMETER Channel
Specify the build channel to deploy (e.g. Current, Deferred)

.EXAMPLE
.\Install-OfficeCTR.ps1 -InstallRoot \\mgmt\Installs\OfficeCTR -SKU ProPlus -Channel Deferred

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	https://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	https://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

Change Log
V1.00, 22/09/2016 - Comment
#>

#requires -version 4


[CmdletBinding()]
param (
	
	[Parameter(Mandatory=$true)]
	[string]$InstallRoot,

	[Parameter(Mandatory=$true)]
    [ValidateSet('Business','ProPlus', ignorecase=$true)]
	[string]$SKU,

    [Parameter(Mandatory=$true)]
    [ValidateSet('Current','Deferred','FirstReleaseCurrent','FirstReleaseDeferred',ignorecase=$true)]
    [string]$Channel

	)


function DoInstall {

    $ConfigurationXML = "$($InstallRoot)\$($SKU)\$($Channel)\configuration.xml"

    If (!(Test-Path $ConfigurationXML)) {
        throw "Unable to locate a configuration XML file at $($ConfigurationXML)"
    }

    $setuppath = "$($InstallRoot)\$($SKU)\$($Channel)\Setup.exe"

    if (!(Test-Path $setuppath)) {
        throw "Unable to locate a Setup.exe file at $($setuppath)"
    }

    Write-Host "Attempting to install Office 365 $($SKU) $($Channel)"

    try {
        $process = Start-Process -FilePath "$($InstallRoot)\$($SKU)\$($Channel)\Setup.exe" -ArgumentList "/Configure $($InstallRoot)\$($SKU)\$($Channel)\configuration.xml" -Wait -PassThru -ErrorAction STOP

        if ($process.ExitCode -eq 0)
        {
            Write-Host -ForegroundColor Green "Office setup started without error."
        }
        else
        {
            Write-Warning "Installer exit code  $($process.ExitCode)."
        }
    }
    catch {
        Write-Warning $_.Exception.Message
    }

}

#Check if Office is already installed, as indicated by presence of registry key
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Office\16.0\ClickToRunStore\Packages\{9AC08E99-230B-47e8-9721-4577B7F124EA}'

if (Test-Path $RegistryPath) {
    #Check for children

    $Item = Get-ItemProperty -Path $RegistryPath

    if (!($Item.'(default)' -eq $null)) {
        #Office is installed, according to registry key. Nothing further to do.
        EXIT
    }
    else {
        #Registry key exists but default value is empty, install needed
        DoInstall
    }
}
else {
    #Registry key doesn't exist, install needed
    DoInstall
}





