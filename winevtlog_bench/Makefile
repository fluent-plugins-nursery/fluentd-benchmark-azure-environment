.PHONY: all

all: apply provision

clean:
	terraform destroy -auto-approve

apply:
	terraform apply -auto-approve

plan:
	terraform plan

provision: windows-provision aggregator-provision

windows-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/windows.yml

aggregator-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/aggregator.yml

windows-bench:
	ansible-playbook -i ./ansible/hosts ./ansible/windows-bench.yml
