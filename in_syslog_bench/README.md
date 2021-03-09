# in\_syslog\_bench Scenario Benchmark

## Introduction

This benchmark scenario is aimed to execute benchmark about the following target.

* syslog-bench

In the above benchmark scenario, the following resources are monitored.

* CPU usage (supervisor)
* CPU usage (worker)
* RSS (supervisor)
* RSS (worker)
* VMS (supervisor)
* VMS (worker)
* Read Bytes
* Write Bytes
* Receive Bytes
* Send Bytes

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
* benchmarking -  `make syslog-bench`
* visualizing - `make visualize`

#### Setup

**NOTE**: Users can choose RHEL 7.x for instance SKU.
In terrafrom.tfvars:

```
environment          = "rhel"
```

should specify using RHEL for benchmarking. Otherwise, CentOS 7.5 instances will be used for benchmarking.

And then,

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

#### Visualization

```
$ make visualize
```

#### Teardown

For destroying instances:

```
$ make clean
```
