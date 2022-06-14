
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$destination,
    [Parameter(Mandatory=$false)]
    [string]$source = ".",
    [Parameter(Mandatory=$false)]
    [string]$filenamePattern = "input-(2022[0-9]{4}-[0-9]{6}-[0-9]{3}).txt",
    [Parameter(Mandatory=$false)]
    [string]$tsFormat = "yyyyMMdd-HHmmss-fff"
)

Get-ChildItem $source | Sort-Object -Property CreationTime |
ForEach-Object {
    $filenameMatch = $_.Name | Select-String -Pattern $filenamePattern
    $filenameTimestamp = [datetime]::parseexact($filenameMatch.Matches.Groups[1].Value, $tsFormat, $null)
    if (!$lastFilenameTimestamp) {
        $lastFilenameTimestamp = $filenameTimestamp
    }
    $waitTimeSpan = $filenameTimestamp - $lastFilenameTimestamp
    Write-Information ("Waiting "+$waitTimeSpan.TotalMilliseconds+"ms to copy "+$_.Name) -InformationAction Continue
    # Note: the Write-Progress output looks very nice, but seems to add significant time
    # Write-Progress ("Waiting "+$waitTimeSpan.TotalMilliseconds+"ms") -Status "Waiting" -CurrentOperation "Copying $_"
    Start-Sleep -TotalMilliseconds $waitTimeSpan.TotalMilliseconds
    # Write-Progress ("Waited  "+$waitTimeSpan.TotalMilliseconds+"ms") -Status "Copying" -CurrentOperation "Copying $_"
    Copy-Item $_ -Destination $destination
    # Write-Progress ("Waited  "+$waitTimeSpan.TotalMilliseconds+"ms") -Status "Done" -CurrentOperation "Copying $_"
    $lastFilenameTimestamp = $filenameTimestamp
}