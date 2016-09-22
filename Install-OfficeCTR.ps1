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

.PARAMETER OfficeVersion
Specify the Office CTR version to deploy (e.g. 2013, or 2016)

.PARAMETER SKU
Specify the the Office CTR SKU to deploy (e.g. ProPlus, Business)

.PARAMETER 

.EXAMPLE
.\Verb-NounsAndThings.ps1
What does this example do...

.NOTES
Written by: Paul Cunningham

Find me on:

* My Blog:	http://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	http://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

For more Office 365 tips, tricks and news
check out Practical365.

* Website:	http://practical365.com
* Twitter:	http://twitter.com/practical365

Change Log
V1.00, 22/09/2016 - Comment
#>

#requires -version 4


[CmdletBinding()]
param (
	
	[Parameter(Mandatory=$true)]
	[switch]$InstallRoot,

	[Parameter(Mandatory=$true)]
    [ValidateSet('Business','ProPlus', ignorecase=$False)]
	[string]$SKU,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Current','Deferred','FirstReleaseCurrent','FirstReleaseDeferred',ignorecase=$False)]
    [string]$Channel

	)


$ConfigurationXML = "$($InstallRoot)\$($SKU)\$($Channel)\configuration.xml"

try {
    Test-Path $ConfigurationXML -ErrorAction STOP
}
catch {
    throw "Unable to locate a configuration XML file at $($ConfigurationXML)"
}

$setuppath = "$($InstallRoot)\$($SKU)\$($Channel)\Setup.exe"
try {

}
catch {
    throw "Unable to locate a Setup.exe file at $($setuppath)"
}

Write-Host "Attempting to install Office 365 $($SKU) $($Channel)"
$process = Start-Process -FilePath "$($InstallRoot)\$($SKU)\$($Channel)\Setup.exe" -ArgumentList "/Configure $($InstallRoot)\$($SKU)\$($Channel)\configuration.xml" -Wait -PassThru
if ($process.ExitCode -eq 0)
{
    Write-Host -ForegroundColor Green "Office setup started without error."
}
else
{
    Write-Warning "Installer exit code  $($process.ExitCode)."
}
