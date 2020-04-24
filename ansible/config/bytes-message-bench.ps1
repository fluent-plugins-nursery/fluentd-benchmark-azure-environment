Param(
    [int32]$msg_length   # 数値
)

$ENV:PATH="C:\opt\td-agent\embedded\bin;" + $ENV:PATH

$fluentd_job = Start-Process fluentd -ArgumentList "-c", "C:\opt\td-agent\fluent-collector.conf", "-o", "C:\opt\td-agent\message-$msg_length-bytes.log" -NoNewWindow -PassThru

Start-Sleep 5

$type_perf_job = Start-Process typeperf -ArgumentList "-cf", "counters.txt", "-sc", "2400", "-si", "1" -PassThru -RedirectStandardOutput C:\tools\${msg_length}-resource-usage.txt

C:\tools\EventLogBencher\EventLogBencher.exe -w 50 -t 120000 -l $msg_length

Stop-Process -Id $fluentd_job.Id
Stop-Process -Id $type_perf_job.Id
