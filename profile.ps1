# Create an empty file
function Touch-File {
	$file = $args[0]
	if($file -eq $null) {
		throw "No Filename Supplied"
	}
	if(Test-Path $file) {
		throw "File already exists"
	} else {
		$null > $file
	}
}
Set-Alias -Name touch -Value Touch-File

# Open notepad++ (optionally pass file to open)
function Open-Notepad-Plus-Plus {
	$file = $args[0]
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
Set-Alias -Name npp -Value Open-Notepad-Plus-Plus

# Customize command prompt to be on two lines
function prompt {
	If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
		# If logged in as an Administrator
		$u = "ADMIN "
	}
	$p = $pwd."Path"
	
	Write-Host "PS " -nonewline
	Write-Host "${u}" -nonewline -ForegroundColor Red
	Write-Host "${p}`n>" -nonewline
	
	return " "
}