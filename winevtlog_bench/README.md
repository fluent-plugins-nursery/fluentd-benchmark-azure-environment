# Windows EventLog Scenario Benchmark

## Introduction

This benchmark scenario is aimed to execute benchmark about the following targets.

* windows-bench (It takes around 40 minutes)
* windows-bench-with-tailing (It takes around 5.5 hours)

In the above benchmark scenario, the following resources are monitored.

* Bytes Received usage
* Bytes Sent usage
* CPU usage (supervisor)
* CPU usage (worker)
* Disk read usage
* Disk write usage
* Private Bytes usage (supervisor)
* Private Bytes usage (worker)
* Working Set usage (supervisor)
* Working Set usage (worker)

## Directory layout

* ansible/*
  * Ansible scripts
* config/*
  * Collection of customize Windows.
* visualize/
  * Collection of plot script from *.csv

After executing benchmark, the result is collected under `ansible/output/*`.

## Execute benchmark


There are 3 steps to execute benchmark scenario.

* provisioning -  `make`
* benchmarking -  `make windows-bench` or `make windows-bench-with-tailing`
* visualizing - `make visualize` or `make visualize-tailing`

### Setup

For creating instances:

```
$ make
```

Or, only creating instances:

```
$ make apply
```

And apply provisioning playbook:

```
$ make provision
```

#### Execute Windows EventLog Benchmarks

```
$ make windows-bench
```

#### Windows EventLog benchmark result Visualization

```
$ make visualize
```

#### Execute Windows EventLog with flat file tailing Benchmarks

```
$ make windows-bench-with-tailing
```

#### Windows EventLog benchmark result Visualization

```
$ make visualize-tailing
```

#### Teardown

For destroying instances:

```
$ make clean
```

## FAQ

### How to regenerate visualized images from existing *.csv?

Use `--base-path` option for `visualize/plot_pandas_tailing_Usage.py` or `visualize/plot_pandas_Usage.py`.

### How to use modified version of installer?

Set `FLUENTD_LOCAL_PACKAGE` environment variable.
For example, if you want to use `ansible/config/td-agent-4.0.50-x64.msi`, export `FLUENTD_LOCAL_PACKAGE=./config/td-agent-4.0.50-x64.msi`

### How to adjust vertical maximum scale limit in visualized image?

Adjust `ylimit` in plot script.

