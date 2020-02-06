param(
    [string]$IPs,
    [string]$Host1,
    [string]$Host2,
    [string]$gwPath = "C:\temp\gateway.msi",
    [string]$uri = "https://go.microsoft.com/fwlink/?linkid=839822",
    [string]$ResourceGroupName,
    [string]$dataFactoryName,
    [string]$IntegrationRuntimeName,
    [string]$authenticationkey
    )
    
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $temppath = "C:\temp"
    $testpath = test-path $temppath

    if (-not $testpath) {
        mkdir c:\temp
    }
    $logpath = "c:\temp\ir.log"

    # Install Azure powershell module for connecting to Integration Runtime
    Install-PackageProvider -Name NuGet -Force
    Install-Module -Name Az -AllowClobber -Scope AllUsers -force

    # Section to add entries in the local host file
    $hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
    $hostsFile = Get-Content $hostsFilePath

    $patternToMatch1 = "$Host1"
    $patternToMatch2 = "$Host2"
    If (($hostsFile) -match $patternToMatch1)  {
        "${date} $host1 already in host file`n" | Out-File $logPath -Append
    }
    If (($hostsFile) -match $patternToMatch2)  {
        "${date} $host2 already in host file`n" | Out-File $logPath -Append
    }
    Else {
        Add-Content -Encoding UTF8  $hostsFilePath ("$host1`n")
        Add-Content -Encoding UTF8  $hostsFilePath ("$host2`n")
    }

# Section to check if Integration Runtime gateway is already installed and log to $logpath
## Requires modification to TRY/CATCH 
connect-azaccount -identity
"${date} connected to azure account with PS`n" | Out-File $logPath -Append
"${date} ResourceGroup = $ResourceGroupName`n" | Out-File $logPath -Append
"${date} datafactory = $dataFactoryName`n" | Out-File $logPath -Append
"${date} IRName = $IntegrationRuntimeName`n" | Out-File $logPath -Append

$software = "Microsoft Integration Runtime";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

If(-Not $installed) {
    Invoke-WebRequest -Uri $uri -OutFile $gwpath
    "${date} downloading gateway.msi`n" | Out-File $logPath -Append
    
    msiexec /i $gwPath /quiet /norestart
    "${date} installing gateway.msi`n" | Out-File $logPath -Append
    
    Start-Sleep -Seconds 180
    
    $authkey = Get-AzDataFactoryV2IntegrationRuntimeKey -ResourceGroupName $ResourceGroupName -DataFactoryName $dataFactoryName -Name $IntegrationRuntimeName | select authkey1 -expandproperty authkey1
    $path = "C:\Program Files\Microsoft Integration Runtime\4.0\Shared"
    cd $path
    .\Dmgcmd.exe -RegisterNewNode $authkey
    .\Dmgcmd.exe -EnableRemoteAccess
    .\Dmgcmd.exe -Stop
    .\Dmgcmd.exe -Start
} 
else {
    "${date} $software is installed`n" | Out-File $logPath -Append
}
