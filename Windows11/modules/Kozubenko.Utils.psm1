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
function WriteGreen($string) {
    Write-Host $string -ForegroundColor Green
}
function WriteRed($string) {
    Write-Host $string -ForegroundColor Red
}
function WriteDarkRed($string) {
    Write-Host $string -ForegroundColor DarkRed
}
function WriteYellow($string) {
    Write-Host $string -ForegroundColor Yellow
}
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
    
    If (-not($returnPath)) { return $exists }
    Else {
        if (-not($exists)) {  return $null  }
        return $dirPath
    }
}

function IfNotExistCreateFile($filePath) {
    if(-not(TestPathSilently($filePath))) {
        New-Item -Path $filePath -ItemType File | Out-Null
    }
}

function SafeCreateDirectory($dirPath) {
    Write-Host "We were in SafeCreateDirectory"
    if (-not (TestPathSilently($dirPath))) {
        mkdir $dirPath
	}
}

function GetRegistryPropertyValue($path, $propertyName) {     # Returns either property value or $false if not exist  # UNFINISHED!!!
    $exists =  If ((Get-Item $path).property -match $propertyName) {"true"}
}

function CheckIfGivenStringIsPotentialFilePath([string] $potentialPath) {   # Returns bool
    $invalidChars = [System.IO.Path]::InvalidPathChars
    
    if ($potentialPath.IndexOfAny($invalidChars) -eq -1) {
        return $true
    }
    return $false
}






Export-ModuleMember -Function WriteObj, WriteGreen, WriteRed, WriteDarkRed, WriteYellow, WriteErrorExit,
NumberOfItemsInDir, NumberOfFoldersInDir, NumberOfFilesInDir, SafeCreateDirectory, TestPathSilently, IfNotExistCreateFile, GetRegistryPropertyValue
