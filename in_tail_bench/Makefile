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

visualize: visualize-cpu visualize-pss visualize-rss visualize-uss visualize-vms

visualize-cpu:
	python3 visualize/plot_pandas_Usage.py --resource cpu

visualize-pss:
	python3 visualize/plot_pandas_Usage.py --resource pss

visualize-rss:
	python3 visualize/plot_pandas_Usage.py --resource rss

visualize-uss:
	python3 visualize/plot_pandas_Usage.py --resource uss

visualize-vms:
	python3 visualize/plot_pandas_Usage.py --resource vms
