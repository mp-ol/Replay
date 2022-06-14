
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][int]$count
)

# Use "now" as an initial timestamp
[datetime]$ts = get-date 
for ($idx = 0; $idx -lt $count; $idx++) {
    # Create a file with some content and a timestamp in its name
    $tsStr = $ts.ToString("yyyyMMdd-HHmmss-fff")
    Write-Output hello world > input-$tsStr.txt
    # Get a random interval in milliseconds, but favor short wait times
    $waitRandom = Get-Random -Minimum 10 -Maximum 1000
    $waitFactor = 1, 1, 1, 1, 1, 2, 2, 3, 5, 8 | Get-Random
    $wait = $waitRandom * $waitFactor
    $ts = $ts.AddMilliseconds($wait)
}

