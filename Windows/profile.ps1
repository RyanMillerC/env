$POWERSHELL_PROFILE = "${env:USERPROFILE}\Documents\WindowsPowerShell\profile.ps1"


#
# Create an empty file
#
function Touch-File {
	$file = ${args}[0]
	if($file -eq $null) {
		throw "No Filename Supplied"
	}
	if(Test-Path $file) {
		throw "File already exists"
	} else {
		"" > $file
	}
}
Set-Alias -Name touch -Value Touch-File


#
# Open notepad++ (optionally pass file to open)
#
function Open-Notepad-Plus-Plus {
	$file = ${args}[0]
	$program = "C:\Program Files (x86)\Notepad++\notepad++.exe"

	if($file -eq $null) {
		& $program
	} else {
		if(-Not (Test-Path $file)) {
			Touch-File $file
		}
		& $program $file
	}
}
Set-Alias -Name edit -Value Open-Notepad-Plus-Plus


#
# Sign a PowerShell script with signing certificate
#
function Sign-PowerShell-Script {
	if(${args}[0] -eq $null) {
		Throw "No script file provided as argument"
	}
	$cert = $(Get-ChildItem Cert:\CurrentUser\My\ -CodeSigningCert)
	Foreach (${file} in ${args}) {
		Set-AuthenticodeSignature ${file} -Certificate ${cert} > $null
	}
}
Set-Alias -Name sign -Value Sign-PowerShell-Script


#
# Sign and then run a PowerShell script
#
function Sign-And-Run-PowerShell-Script {
	$file = ${args}[0]
	if($file -eq $null) {
		Throw "No script file provided as argument"
	}
	Sign-PowerShell-Script ${file}
	Invoke-Expression -Command ${file}
}
Set-Alias -Name run -Value Sign-And-Run-PowerShell-Script


#
# Activate a Python 2 Virtual Environment
#
function Activate-Virtualenv {
	$file = '.venv\Scripts\activate.ps1'
	Sign-And-Run-PowerShell-Script ${file}
}
Set-Alias -Name venv -Value Activate-Virtualenv


#
# Activate a Python 3 Virtual Environment
#
function Activate-Virtualenv3 {
	$file = '.venv3\Scripts\activate.ps1'
	Sign-And-Run-PowerShell-Script ${file}
}
Set-Alias -Name venv3 -Value Activate-Virtualenv3


# Git Prompt - Assuming it is installed in C:/Users/{USER}/Applications/
Import-Module "${env:USERPROFILE}\Applications\posh-git\src\posh-git.psd1"
$GitPromptSettings.BeforeStatus.ForegroundColor = 'White'
$GitPromptSettings.AfterStatus.ForegroundColor = 'White'
$GitPromptSettings.DelimStatus.ForegroundColor = 'White'
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Gray'
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'


# Super useful - Sign all PowerShell scripts recursively in current directory
# Get-ChildItem . -Recurse | where {$_.extension -eq ".ps1"} | % { sign $_.FullName }
