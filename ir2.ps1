param (
    $hostname, 
    $ipaddress
    )


$filename = "C:\Windows\System32\Drivers\etc\hosts"
$gwPath = "%TMP%/gateway.msi"
$uri = "https://go.microsoft.com/fwlink/?linkid=839822"

$ipaddress + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename

$client = New-Object System.Net.WebClient
$client.DownloadFile($uri, $gwPath)
