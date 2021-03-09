# in\_tail Scenario Benchmark

## Introduction

This benchmark scenario is aimed to execute benchmark about the following target.

* tail-bench

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
* benchmarking -  `make tail-bench`
* visualizing - `make visualize`

#### Setup

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

#### Execute Benchmarks

```
$ make tail-bench
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
