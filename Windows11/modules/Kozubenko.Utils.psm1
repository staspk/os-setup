function WriteObjBackup($varName, $obj) {
    Write-Host
    Write-Host "`$$varName" -ForegroundColor Yellow -NoNewline; Write-Host " {" -ForegroundColor DarkYellow
    foreach ($_ in $obj | Select-Object) {
        Write-Host "  type:" -ForegroundColor DarkYellow -NoNewline;  Write-Host "$($_.GetType())"  -NoNewline -ForegroundColor Yellow
        Write-Host "  value: " -ForegroundColor DarkYellow -NoNewline;  Write-Host $_ -ForegroundColor Yellow;

    }
    Write-Host "}" -ForegroundColor DarkYellow
    Write-Host
}
function WriteObj($varName, $obj) {
    Write-Host
    Write-Host "--------------------------------------------------" -ForegroundColor DarkYellow
    Write-Host "`$$varName" -ForegroundColor Yellow;
    Write-Host "`$$varName.getType() == " -ForegroundColor DarkYellow -NoNewline; Write-Host $obj.GetType() -ForegroundColor Yellow -NoNewline; Write-Host " {" -ForegroundColor DarkYellow
    foreach ($_ in $obj | Select-Object) {
        Write-Host "  type:" -ForegroundColor DarkYellow -NoNewline;  Write-Host "$($_.GetType())"  -NoNewline -ForegroundColor Yellow
        Write-Host "  value: " -ForegroundColor DarkYellow -NoNewline;  Write-Host $_ -ForegroundColor Yellow;

    }
    Write-Host "}" -ForegroundColor DarkYellow
    Write-Host "--------------------------------------------------" -ForegroundColor DarkYellow
    Write-Host
}

ffunction WriteRed($msg, $newLine = $true)      {  if($newLine) { Write-Host $msg -ForegroundColor Red }      else { Write-Host $msg -ForegroundColor Red -NoNewline }        }
function WriteDarkRed($msg, $newLine = $true)  {  if($newLine) { Write-Host $msg -ForegroundColor DarkRed }   else { Write-Host $msg -ForegroundColor DarkRed -NoNewline }    }
function WriteYellow($msg, $newLine = $true)   {  if($newLine) { Write-Host $msg -ForegroundColor Yellow }    else { Write-Host $msg -ForegroundColor Yellow -NoNewline }     }
function WriteCyan($msg, $newLine = $true)     {  if($newLine) { Write-Host $msg -ForegroundColor Cyan }      else { Write-Host $msg -ForegroundColor Cyan -NoNewline }       }
function WriteGreen($msg, $newLine = $true)    {  if($newLine) { Write-Host $msg -ForegroundColor Green }     else { Write-Host $msg -ForegroundColor Green -NoNewline }      }
function WriteDarkGreen($msg, $newLine = $true){  if($newLine) { Write-Host $msg -ForegroundColor DarkGreen } else { Write-Host $msg -ForegroundColor DarkGreen -NoNewline }  }
function WriteGray($msg, $newLine = $true)     {  if($newLine) { Write-Host $msg -ForegroundColor Gray }      else { Write-Host $msg -ForegroundColor Gray -NoNewline }       }
function WriteWhite($msg, $newLine = $true)    {  if($newLine) { Write-Host $msg -ForegroundColor White }    else { Write-Host $msg -ForegroundColor White -NoNewline }      }
function WriteErrorExit([string]$errorMsg) {
    Write-Host $errorMsg -ForegroundColor DarkRed
    Write-Host "Exiting Script..." -ForegroundColor DarkRed
    exit
}

function NumberOfItemsInDir($pathToDir, $isRecursive = $false) {
    if($isRecursive) {
        return (Get-ChildItem -Path $pathToDir -Recurse).Count  }
    else {
        return (Get-ChildItem -Path $pathToDir).Count
    }
}
function NumberOfFoldersInDir($pathToDir, $isRecursive = $false) {
    if($isRecursive) {
        return (Get-ChildItem -Path $pathToDir -Directory -Recurse).Count  }
    else {
        return (Get-ChildItem -Path $pathToDir -Directory).Count
    }
}
function NumberOfFilesInDir($pathToDir) {
    $itemsCount = NumberOfItemsInDir($pathToDir)
    $foldersCount = NumberOfFoldersInDir($pathToDir)
    return $($itemsCount - $foldersCount)
}

function TestPathSilently($dirPath, $returnPath = $false) { 
    $exists = Test-Path $dirPath -ErrorAction SilentlyContinue
    
    If (-not($returnPath)) {  return $exists }
    if (-not($exists))     {  return $null   }
    
    return $dirPath
}

function CheckIfGivenStringIsPotentialFilePath([string] $potentialPath) {   # Returns bool
    $invalidChars = [System.IO.Path]::InvalidPathChars
    
    if ($potentialPath.IndexOfAny($invalidChars) -eq -1) {
        return $true
    }
    return $false
}

function RemoveFromEnvironmentPath($toRemove) {     # example $toRemove: %USERPROFILE%\AppData\Local\Microsoft\WindowsApps
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    $curArray = $currentPath.Split(";")

    $newPath = ""
    for ($i = 0; $i -lt $curArray.Count; $i++) {
        if ($curArray[$i] -ne $toRemove -and $i -eq 0) {
            $newPath = $newPath + $curArray[$i]
        }
        elseif ($curArray[$i] -ne $toRemove -and $i -gt 0) {
            $newPath = $newPath + ";" + $curArray[$i]
        }
    }
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
}



Export-ModuleMember -Function WriteObj, WriteCyan, WriteGreen, WriteDarkGreen, WriteRed, WriteDarkRed, WriteYellow, WriteGray, WriteWhite, WriteErrorExit,
NumberOfItemsInDir, NumberOfFoldersInDir, NumberOfFilesInDir, TestPathSilently, RemoveFromEnvironmentPath
