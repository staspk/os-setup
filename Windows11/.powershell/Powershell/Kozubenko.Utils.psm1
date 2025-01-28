function WriteRed($msg, $noNewLine = $false)      {  if($noNewLine) { Write-Host $msg -ForegroundColor Red -NoNewline } else { Write-Host $msg -ForegroundColor Red }  }
function WriteDarkRed($msg, $noNewLine = $false)  {  if($noNewLine) { Write-Host $msg -ForegroundColor DarkRed -NoNewline } else { Write-Host $msg -ForegroundColor DarkRed }  }
function WriteYellow($msg, $noNewLine = $false)   {  if($noNewLine) { Write-Host $msg -ForegroundColor Yellow -NoNewline } else { Write-Host $msg -ForegroundColor Yellow }  }
function WriteCyan($msg, $noNewLine)              {  if($noNewLine) { Write-Host $msg -ForegroundColor Cyan -NoNewline } else { Write-Host $msg -ForegroundColor Cyan }  }
function WriteGreen($msg, $noNewLine)             {  if($noNewLine) { Write-Host $msg -ForegroundColor Green -NoNewline } else { Write-Host $msg -ForegroundColor Green }  }
function WriteDarkGreen($msg, $noNewLine = $false){  if($noNewLine) { Write-Host $msg -ForegroundColor DarkGreen -NoNewline } else { Write-Host $msg -ForegroundColor DarkGreen }  }
function WriteGray($msg, $noNewLine = $false)     {  if($noNewLine) { Write-Host $msg -ForegroundColor Gray -NoNewline } else { Write-Host $msg -ForegroundColor Gray }  }
function WriteWhite($msg, $noNewLine = $false)    {  if($noNewLine) { Write-Host $msg -ForegroundColor White -NoNewline } else { Write-Host $msg -ForegroundColor White }  }

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

function SetAliases($function, [Array]$aliases) {   # Includes functionality for overriding aliases currently in use by the pwsh standard library
    if ($function -eq $null -or $aliases -eq $null) {  return  }

    $ErrorActionPreference = "Stop"     # Needs to be set so the possible error throws

    foreach($alias in $aliases) {
        try {
            Set-Alias -Name $alias -Value $function -Scope Global -Option Constant,AllScope -Force
            # Set-Alias -Name $alias -Value $function -Scope Global -Option Constant,AllScope -Force
        }
        catch {
            writered #
            WriteDarkRed "If you see this message, please fix Kozubenko.Utils:SetAliases(). Currently using a simpler but experimental version - not every use case may be covered. Still: I suspect it covers more use cases than the last version. I'll still leave it commented out."
        }

        # try {
        #     $ErrorActionPreference = "Stop"     # Needs to be set so the possible error throws
        #     Set-Alias -Name $alias -Value $function -Scope Global -Option Constant,AllScope -Force
        #     # $isAnAlias = $(Get-Alias $alias -ErrorAction SilentlyContinue)
            
        #     # Set-Alias -Name $alias -Value $function -Scope Global -Option ReadOnly
        #     # Set-Alias -Name $alias -Value $function -Scope Global -Option 'Constant','AllScope'
        # }
        # catch {
        #     WriteRed $_.FullyQualifiedErrorId $true
        # }
        # finally {  $ErrorActionPreference = "Continue"  }
    }
    # if()
    # WriteDarkRed "When you see this message, please delete "
}