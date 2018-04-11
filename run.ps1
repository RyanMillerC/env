$windir = "${env:USERPROFILE}\Documents\WindowsPowerShell"
$file = "${windir}\profile.ps1"

if(-Not (Test-Path $windir)) {
	Write-Host "$windir does not exist, creating..."
	(mkdir $windir) | Out-Null
}

if(-Not (Test-Path $file)) {
	Write-Host "Copying profile.ps1 to $file"
	cp profile.ps1 $file
} else {
	throw "$file already exists! Please delete file."
}

Write-Host "Done!"
