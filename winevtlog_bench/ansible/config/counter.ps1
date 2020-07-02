$instances = (Get-Counter "\Process(*)\% Processor Time" -ErrorAction SilentlyContinue).CounterSamples | select InstanceName | select-string "ruby"
$instances.Count
