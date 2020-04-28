Write-Output "timestamp,fluentd uses"
while ($true -eq $true) {
    $date=(Get-Date).ToString("yyyy/MM/dd HH:mm:ss")
    $fluentd=(netstat -ano | Select-String 24224 | Measure-Object).Count
    Write-Output "$date,$fluentd"
    sleep 1
}
