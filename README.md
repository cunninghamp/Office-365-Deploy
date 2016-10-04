#Office 365 Client Deployment Scripts

This repository hosts PowerShell scripts that assist with the deployment of Office 365 client software.

The scripts included at this time are:

- Install-OfficeCTR.ps1

If you're looking for more complex, featured scripts you might be interested in [Microsoft's Office Deployment Scripts for IT Pros](http://officedev.github.io/Office-IT-Pro-Deployment-Scripts/).

##Install-OfficeCTR.ps1 - Office 365 CTR Install Script

This PowerShell script will install Office 365 Click-to-Run when it is run manually, or as a logon/startup script. Install-OfficeCTR.ps1 supports both the ProPlus and Business SKU for Office 365, as well as the four channels:

- Deferred
- Current
- First Release Deferred
- First Release Current

This script is designed to work with Office 2016 builds of Office 365 CTR, not Office 2013.

Before using this script you should set up an shared folder for your Office 365 CTR deployments by following the instructions at [Practical 365](https://practical365.com).

###Usage:

Install-OfficeCTR.ps1 uses the following parameters:

- **InstallRoot** - Specify the UNC path to the network share that hosts the Office 365
setup and configuration files.
- **SKU** - Specify the the Office CTR SKU to deploy (e.g. ProPlus, Business)
- **Channel** - Specify the build channel to deploy (e.g. Current, Deferred) 

The three parameters are used by the install script to locate the appropriate setup and configuration files in your install share on the network.

Example:

```
.\Install-OfficeCTR.ps1 -InstallRoot \\mgmt\Installs\OfficeCTR -SKU ProPlus -Channel Deferred
```

The example above will look for setup and configuration files in **\\\mgmt\Installs\OfficeCTR\ProPlus\Deferred**



##Credits
Written by: Paul Cunningham

Find me on:

* My Blog:	http://paulcunningham.me
* Twitter:	https://twitter.com/paulcunningham
* LinkedIn:	http://au.linkedin.com/in/cunninghamp/
* Github:	https://github.com/cunninghamp

For more Office 365 tips, tricks and news check out Practical 365.

* Website:	[http://practical365.com]()
* Twitter:	[http://twitter.com/practical365]()