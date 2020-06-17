.PHONY: all

all: apply provision

clean:
	terraform destroy -auto-approve

apply:
	terraform apply -auto-approve

provision: collector-provision aggregator-provision

plan:
	terraform plan

collector-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/collector.yml

aggregator-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/aggregator.yml

syslog-bench:
	ansible-playbook -i ./ansible/hosts ./ansible/syslog-bench.yml

certs:
	bundle exec fluent-ca-generate ansible/config/certs fluentd
