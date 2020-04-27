Param(
    [string]$workdir = "C:\tools",
    [parameter(mandatory=$true)][int32]$Length,
    [int32]$Total = 120000
)

$ENV:PATH="C:\opt\td-agent\embedded\bin;" + $ENV:PATH

cd $workdir

$fluentd_job = Start-Process fluentd -ArgumentList "-c", "C:\opt\td-agent\fluent-collector.conf", "-o", "C:\opt\td-agent\message-$Length-bytes.log" -NoNewWindow -PassThru

Start-Sleep 5

$type_perf_job = Start-Process typeperf -ArgumentList "-cf", "counters.txt", "-sc", "2400", "-si", "1" -PassThru -RedirectStandardOutput C:\tools\${Length}-resource-usage.txt

Start-Process C:\tools\EventLogBencher\EventLogBencher.exe -ArgumentList "-w", "50", "-t", "$Total", "-l", "$Length" -Wait -NoNewWindow

Stop-Process -Id $fluentd_job.Id
Stop-Process -Id $type_perf_job.Id
