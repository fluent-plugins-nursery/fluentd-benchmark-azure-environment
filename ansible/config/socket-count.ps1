Write-Output "timestamp,total sockets,fluentd uses"
while ($true -eq $true) {
    $date=(Get-Date).ToString("yyyy/MM/dd HH:mm:ss")
    $stat=(netstat -ano | Measure-Object).Count
    $fluentd=(netstat -ano | Select-String 24224 | Measure-Object).Count
    Write-Output "$date,$stat,$fluentd"
    sleep 1
}
