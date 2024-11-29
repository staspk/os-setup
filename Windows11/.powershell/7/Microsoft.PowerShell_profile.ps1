Set-Location C:\Users\stasp\Desktop\OS-Setup\Windows11
function Restart { wt.exe; exit }
function Open($path) {
    if($path) {  ii  $([System.IO.Path]::GetDirectoryName($path))  }
    else {  ii .  } 
}

function CustomizeConsole {
    $hosttime = (Get-ChildItem -Path $PSHOME\PowerShell.exe).CreationTime
    $hostversion="$($Host.Version.Major)`.$($Host.Version.Minor)"
}

CustomizeConsole
Clear-Host