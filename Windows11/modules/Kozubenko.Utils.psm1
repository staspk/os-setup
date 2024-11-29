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



function SafeCreateDirectory($dirPath) {
    Write-Host "We were in SafeCreateDirectory"
    if (-not (Test-Path $dirPath)) {
        mkdir $dirPath
	}
}

function TestPathSilently($dirPath, $returnPath = $false) { 
    $exists = Test-Path $dirPath -ErrorAction SilentlyContinue
    
    If (-not($returnPath)) { return $exists }
    Else {
        if (-not($exists)) {  return $null  }
        return $dirPath
    }
}

function GetRegistryPropertyValue($path, $propertyName) {     # Returns either property value or $false if not exist  # UNFINISHED!!!
    $exists =  If ((Get-Item $path).property -match $propertyName) {"true"}
}

function WriteErrorExit([string]$errorMsg) {
    Write-Host $errorMsg -ForegroundColor DarkRed
    Write-Host "Exiting Script..." -ForegroundColor DarkRed
    exit
}

function CheckIfGivenStringIsPotentialFilePath([string] $potentialPath) {   # Returns bool
    $invalidChars = [System.IO.Path]::InvalidPathChars
    
    if ($potentialPath.IndexOfAny($invalidChars) -eq -1) {
        return $true
    }
    return $false
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

function SearchRecursivelyForFile($path, $fileName, $isRecursive) {
    
}

function DoFoldersInPathExist($pathToFolder, $excludeFolderWithName = $null) {     # Returns either false or # of subfolders. Test-Path before passing as param
    Write-Host "In DoFoldersInPathExist" -ForegroundColor Red
    Write-Host "pathToFolder == $pathToFolder, excludeFolderWithName = $excludeFolderWithName"
    if($excludeFolderWithName) {
        $numberOfFolders = Get-ChildItem $pathToFolder -Recurse -Directory
        
        WriteObj numberOfFolders $numberOfFolders
        WriteObj excludeFolderWithName $excludeFolderWithName
        
        If ($numberOfFolders -eq 0) { return $false } Else { return $numberOfFolders }
    }
    else {
        $numberOfFolders = Get-ChildItem $pathToFolder -Recurse -Directory | Measure-Object | select -Expand Count
        If ($numberOfFolders -eq 0) { return $false } Else { return $numberOfFolders }
    }
}

function FindFileRecursively($startFromPath, $fileName) {
    if ($pathToFolder) {
        Test-Path $startFromPath
    }
    return (Get-ChildItem -Path $startFromPath -Filter $fileName -Recurse -ErrorAction SilentlyContinue -Force)
}

function ReadLineLoop([string]$message, [ScriptBlock]$condition) {
    do {
        $consoleInput = Read-Host "$message (or 'exit'): "
        if($consoleInput -eq "exit") { exit }
    } while ($condition.Invoke())
}


Export-ModuleMember -Function SafeCreateDirectory, GetRegistryPropertyValue, WriteErrorExit, TestPathSilently, DoFoldersInPathExist, FindFileRecursively, WriteObj, ReadLineLoop, NumberOfItemsInDir, CheckIfGivenStringIsPotentialFilePath, NumberOfFoldersInDir, NumberOfFilesInDir, WriteGreen, WriteRed, WriteDarkRed, WriteYellow