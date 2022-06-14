<# .SYNOPSIS #>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
        [string]$Destination ## Destination folder, mandatory
    ,[Parameter(Mandatory=$false)]
        [string]$Source = "." ## Source folder, defaults to current working directory
    ,[Parameter(Mandatory=$false)]
        [string]$FilenamePattern = "input-(2022[0-9]{4}-[0-9]{6}-[0-9]{3}).txt" ## Regular expression that all files should match, *must* include a capturing group for the timestamp; default: input-(2022[0-9]{4}-[0-9]{6}-[0-9]{3}).txt
    ,[Parameter(Mandatory=$false)]
        [string]$TimestampFormat = "yyyyMMdd-HHmmss-fff" ## Format specifier for date and time in the Microsoft .NET Framework format; default: yyyyMMdd-HHmmss-fff
)

# doing our own parameter validation here, because [ValidatePattern("(?<!\\)\(.*(?<!\\)\)")] results in an unreadable error and custom error messages require Powershell 6 or higher
if (!($FilenamePattern | Select-String -Pattern "(?<!\\)\(.*(?<!\\)\)")) {
    Write-Warning "FilenamePattern does not have a capturing group to capture a timestamp; surround the timestamp part of the pattern with (). Stopping."
    return
}

Get-ChildItem $Source | Sort-Object -Property CreationTime | 
ForEach-Object {
    $currentFile = $_
    $filenameMatch = $currentFile.Name | Select-String -Pattern $FilenamePattern
    if (!$filenameMatch) {
        Write-Warning "$currentFile does not match '$FilenamePattern' and is skipped"
        return
    }
    $filenameTimestamp = $null
    try {
        $filenameTimestamp = [datetime]::parseexact($filenameMatch.Matches.Groups[1].Value, $TimestampFormat, $null)
    }
    catch {
        Write-Warning ("filename part '"+$filenameMatch.Matches.Groups[1].Value+"' does not match timestamp format '$TimestampFormat', file $currentFile is skipped")
        return
    }
    if (!$lastFilenameTimestamp) {
        $lastFilenameTimestamp = $filenameTimestamp
    }
    $waitTimeSpan = ($filenameTimestamp - $lastFilenameTimestamp)
    Write-Information ("Waiting "+$waitTimeSpan.TotalMilliseconds+"ms to copy "+$currentFile.Name) -InformationAction Continue
    Start-Sleep -Milliseconds $waitTimeSpan.TotalMilliseconds
    Copy-Item $currentFile.FullName -Destination $Destination
    $lastFilenameTimestamp = $filenameTimestamp
}