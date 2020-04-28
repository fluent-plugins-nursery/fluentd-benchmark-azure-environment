Param(
    [string]$workdir = "C:\tools",
    [parameter(mandatory=$true)][int32]$Length,
    [int32]$Total = 120000
)

$ENV:PATH="C:\opt\td-agent\embedded\bin;" + $ENV:PATH

cd $workdir

Start-Process fluentd -ArgumentList "-c", "C:\opt\td-agent\fluent-collector.conf", "-o", "C:\opt\td-agent\message-$Length-bytes.log" -NoNewWindow -PassThru

Start-Sleep 5

Start-Process typeperf -ArgumentList "-cf", "counters.txt", "-sc", "2400", "-si", "1" -PassThru -RedirectStandardOutput C:\tools\${Length}-resource-usage.csv

$socket_count_job = Start-Process powershell -ArgumentList "-ExecutionPolicy", "RemoteSigned", C:\tools\socket-count.ps1 -PassThru -NoNewWindow -RedirectStandardOutput C:\tools\${Length}-socket-usage.csv

Start-Process C:\tools\EventLogBencher\EventLogBencher.exe -ArgumentList "-w", "50", "-t", "$Total", "-l", "$Length" -Wait -NoNewWindow

Stop-Process -Id $socket_count_job.Id
taskkill /F /IM ruby.exe
taskkill /F /IM typeperf.exe
