Import-Module ".\modules\Kozubenko.Git.psm1" -Force

function Restart { wt.exe; exit }
function Open($path) {
    if($path) {  ii  $([System.IO.Path]::GetDirectoryName($path))  }
    else {  ii .  } 
}
function LoadInGlobals() {
    $path = $([System.IO.Path]::GetDirectoryName($PROFILE))
    $path = $path + "\globals"

    foreach($line in [System.IO.File]::ReadLines($path)) {
        $array = $line.Split("=")
        New-Variable -Name $array[0] -Value $array[1] -Scope Global
        # Write-Host "Global Variable Added: $($array[0])=$($array[1])"
    }
    New-Variable -Name "pathToGlobals" -Value $path -Scope Global
}
function SetLocation($path) {
    if($path -eq $null) {
        $openedTo = $PWD.Path
        if ($openedTo -eq $null -or $openedTo -eq "") { break; }
        if ($openedTo -eq "$env:userprofile" -or $openedTo -eq "C:\WINDOWS\system32") { Set-Location $startLocation }
    }
    elseif (Test-Path($path)) {
        Set-Location $startLocation
    }    
}
function NewLocation($path) {
    $lines = Get-Content -Path "$([System.IO.Path]::GetDirectoryName($PROFILE))\globals"
    if(Test-Path $path) {
        $lines[0] = "startLocation=$path"
        $lines | Set-Content -Path "$([System.IO.Path]::GetDirectoryName($PROFILE))\globals"
        SetLocation($path)
    }
}

Clear-Host
LoadInGlobals
Set-Location $startLocation