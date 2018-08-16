# PowerShellProfile

## Setup

Step 1: `git clone https://github.com/RyanMillerC/env`

Step 2: `cd env\Windows`

Step 3: `.\run.ps1`


#### *For environments that require signed PowerShell scripts:*

Step 1: `git clone https://github.com/RyanMillerC/env`

Step 2: `cd env\Windows`

Step 3: `$cert = $(Get-ChildItem Cert:\CurrentUser\My\ -CodeSigningCert)`

Step 4: `Set-AuthenticodeSignature .\run.ps1 -Certificate ${cert}`

Step 5: `.\run.ps1`

Step 6: `Set-AuthenticodeSignature ${env:USERPROFILE}\Documents\WindowsPowerShell\profile.ps1 -Certificate ${cert}`


## Update

Step 1: `git pull`

Step 2: `.\run.ps1`

Step 3: `sign $POWERSHELL_PROFILE`
