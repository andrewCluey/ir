$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logpath = "$PWD/log.log"
$host1 = "test1.local"

"${date} $host1 already in host file`n" | Out-File $logPath -Append