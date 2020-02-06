param(
    [string]$IPs,
    [string]$Hostnames,
    [string]$entries,
    [string]$gwPath = "C:\temp\gateway.msi",
    [string]$uri = "https://go.microsoft.com/fwlink/?linkid=839822",
    [string]$authenticationkey
    )


$fileContent = Import-csv $file -header "ip", "host"
$newRow = New-Object PsObject -Property @{ IP = 'Text4' ; Description = 'Text5' }
$fileContent += $newRow