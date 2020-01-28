$logLoc = "%TMP%/Logs"
if (! (Test-Path($logLoc)))
{
    New-Item -path $logLoc -type directory -Force
}
$logPath = "$logLoc\tracelog.log"
"Start to excute ir.ps1. `n" | Out-File $logPath

function Now-Value()
{
    return (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}


function Trace-Log([string] $msg)
{
    $now = Now-Value
    try
    {
        "$now $msg`n" | Out-File $logPath -Append
    }
    catch
    {
        #ignore any exception during trace
    }

}

function add-host([string]$entry) {
    $entry | Out-File -encoding ASCII -append $filename
}

function Download-Gateway([string] $url, [string] $gwPath)
{
    try
    {
        $ErrorActionPreference = "Stop";
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $gwPath)
        Trace-Log "Download gateway successfully. Gateway loc: $gwPath"
    }
    catch
    {
        Trace-Log "Fail to download gateway msi"
        Trace-Log $_.Exception.ToString()
        throw
    }
}

Trace-Log "Log file: $logLoc"
$uri = "https://go.microsoft.com/fwlink/?linkid=839822"
Trace-Log "Gateway download fw link: $uri"
$gwPath= "%TMP%/gateway.msi"
Trace-Log "Gateway download location: $gwPath"
$filename = "C:\Windows\System32\drivers\etc\hosts"
$hostentries = ${hosts}


foreach ($entry in $hostentries) {
    add-host -entry $entry
}

Download-Gateway $uri $gwPath
