.PHONY: all

all: apply provision

clean:
	terraform destroy -auto-approve

apply:
	terraform apply -auto-approve

provision: collector-provision aggregator-provision

collector-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/collector.yml

aggregator-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/aggregator.yml
