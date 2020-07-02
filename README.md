Fluentd Benchmark Azure Environment with Terraform
===

[![Build Status](https://travis-ci.com/fluent-plugins-nursery/fluentd-benchmark-azure-environment.svg?branch=master)](https://travis-ci.com/fluent-plugins-nursery/fluentd-benchmark-azure-environment)

## Prerequisites

* Terraform 0.12+
* Ansible 2.9+
* make

## Setup

 1. Prepare RSA public key and put it into `azure_key/id_rsa_azure.pub`.
 2. Prepare env.sh and fill `ARM_` prefixed environment variables with your credentials.
 3. Run `env.sh`
 4. Change directory to target environments(winevtlog_bench/in_tail_bench).
 5. Specify user-defined variables in `terraform.tfvars` which can be copied from `terraform.tfvars.sample` and fill them for each environment (winevtlog\_bench, in\_tail\_bench).

## Usage

### Windows EventLog Scenario Benchmark

#### Setup

```
$ cd winevtlog_bench
```

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

### in\_tail Scenario Benchmark

#### Setup

```
$ cd in_tail_bench
```

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

### in\_syslog Scenario Benchmark

#### Setup

```
$ cd in_syslog_bench
```

---

**NOTE**: Users can choose RHEL 7.x for instance SKU.
In terrafrom.tfvars:

```
environment          = "rhel"
```

should specify using RHEL for benchmarking. Otherwise, CentOS 7.5 instances will be used for benchmarking.

---

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

## License

[MIT](LICENSE).
