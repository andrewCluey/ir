param(
    [string]$DesiredIP,
    [string]$Hostname,
    [bool]$CheckHostnameOnly = $false)

# Adds entry to the hosts file.
#Requires -RunAsAdministrator
$hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
$hostsFile = Get-Content $hostsFilePath

$escapedHostname = [Regex]::Escape($Hostname)
$patternToMatch = If ($CheckHostnameOnly) { ".*\s+$escapedHostname.*" } Else { ".*$DesiredIP\s+$escapedHostname.*" }
If (($hostsFile) -match $patternToMatch)  {
    Write-Host $desiredIP.PadRight(20," ") "$Hostname - not adding; already in hosts file" -ForegroundColor DarkYellow
} 
Else {
    Write-Host $desiredIP.PadRight(20," ") "$Hostname - adding to hosts file... " -ForegroundColor Yellow -NoNewline
    Add-Content -Encoding UTF8  $hostsFilePath ("$DesiredIP".PadRight(20, " ") + "$Hostname")
    Write-Host " done"
}






$filename = "C:\Windows\System32\Drivers\etc\hosts"
$gwPath = "%TMP%/gateway.msi"
$uri = "https://go.microsoft.com/fwlink/?linkid=839822"

$ipaddress + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename

Invoke-WebRequest -Uri $uri -OutFile $gwpath

