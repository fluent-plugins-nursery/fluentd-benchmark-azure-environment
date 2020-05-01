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
	python3 visualize/plot_pandas_CPU_Usage.py

visualize-pss:
	python3 visualize/plot_pandas_PSS_Usage.py

visualize-rss:
	python3 visualize/plot_pandas_RSS_Usage.py

visualize-uss:
	python3 visualize/plot_pandas_USS_Usage.py

visualize-vms:
	python3 visualize/plot_pandas_VMS_Usage.py
