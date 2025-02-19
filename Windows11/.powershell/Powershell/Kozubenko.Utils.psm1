function WriteRed($msg, $newLine = $true)      {  if($newLine) { Write-Host $msg -ForegroundColor Red }      else { Write-Host $msg -ForegroundColor Red -NoNewline }        }
function WriteDarkRed($msg, $newLine = $true)  {  if($newLine) { Write-Host $msg -ForegroundColor DarkRed }   else { Write-Host $msg -ForegroundColor DarkRed -NoNewline }    }
function WriteYellow($msg, $newLine = $true)   {  if($newLine) { Write-Host $msg -ForegroundColor Yellow }    else { Write-Host $msg -ForegroundColor Yellow -NoNewline }     }
function WriteCyan($msg, $newLine = $true)     {  if($newLine) { Write-Host $msg -ForegroundColor Cyan }      else { Write-Host $msg -ForegroundColor Cyan -NoNewline }       }
function WriteGreen($msg, $newLine = $true)    {  if($newLine) { Write-Host $msg -ForegroundColor Green }     else { Write-Host $msg -ForegroundColor Green -NoNewline }      }
function WriteDarkGreen($msg, $newLine = $true){  if($newLine) { Write-Host $msg -ForegroundColor DarkGreen } else { Write-Host $msg -ForegroundColor DarkGreen -NoNewline }  }
function WriteGray($msg, $newLine = $true)     {  if($newLine) { Write-Host $msg -ForegroundColor Gray }      else { Write-Host $msg -ForegroundColor Gray -NoNewline }       }
function WriteWhite($msg, $newLine = $true)    {  if($newLine) { Write-Host $msg -ForegroundColor White }    else { Write-Host $msg -ForegroundColor White -NoNewline }      }

function TestPathSilently($dirPath, $returnPath = $false) { 
    $exists = Test-Path $dirPath -ErrorAction SilentlyContinue
    
    If (-not($returnPath)) { return $exists }
    if (-not($exists)) {  return $null  }
    
    return $dirPath
}
function IsFile($path) {
    if ([string]::IsNullOrEmpty($path) -OR -not(Test-Path $path -ErrorAction SilentlyContinue)) {
        Write-Host "Kozubenko.Utils:IsFile(`$path) has hit sanity check. `$path: $path"
        return $false
    }

    if (Test-Path -Path $path -PathType Leaf) {  return $true;  }
    else {
        return $false
    }
}
function IsDirectory($path) {
    if ([string]::IsNullOrEmpty($path) -OR -not(Test-Path $path -ErrorAction SilentlyContinue)) {
        Write-Host "Kozubenko.Utils:IsDirectory(`$path) has hit sanity check. `$path: $path"
        return $false
    }

    if (Test-Path -Path $path -PathType Container) {  return $true  }
    else {
        return $false
    }
}
function WriteErrorExit([string]$errorMsg) {
    WriteDarkRed $errorMsg
    WriteDarkRed "Exiting Script..."
    exit
}

function SetAliases($function, [Array]$aliases) {   # Throws exception if you try to call twice on same alias
    if ($function -eq $null -or $aliases -eq $null) {  return  }

    $ErrorActionPreference = "Stop"     # A relic of a past implementation. Want everything that can be thrown, thrown. Can likely remove in the future.
    foreach ($alias in $aliases) {
        Set-Alias -Name $alias -Value $function -Scope Global -Option Constant,AllScope -Force
    }
    $ErrorActionPreference = "Continue"
}

function DisplayFolderSizes {
    $colItems = Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    foreach ($i in $colItems)
    {
        $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
        WriteGreen "$($i.Name)" $false; WriteGray " --> " $false; WriteDarkRed "$("{0:N2}" -f ($subFolderItems.sum / 1MB))MB"
    }
}