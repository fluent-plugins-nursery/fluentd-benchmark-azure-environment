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

tail-bench:
	ansible-playbook -i ./ansible/hosts ./ansible/tail-bench.yml
