# PowerShellProfile

## Setup

```powershell
git clone "https://github.com/RyanMillerC/env"
cd env\Windows
.\run.ps1
```

#### *For environments that require signed PowerShell scripts*

```powershell
git clone "https://github.com/RyanMillerC/env"
cd env\Windows
$cert = $(Get-ChildItem Cert:\CurrentUser\My\ -CodeSigningCert)
Set-AuthenticodeSignature .\run.ps1 -Certificate ${cert}
.\run.ps1
Set-AuthenticodeSignature ${env:USERPROFILE}\Documents\WindowsPowerShell\profile.ps1 -Certificate ${cert}
```

## Update

```
git pull
.\run.ps1
```

#### *For environments that require signed PowerShell scripts*

```
git pull
.\run.ps1
sign $POWERSHELL_PROFILE
```
