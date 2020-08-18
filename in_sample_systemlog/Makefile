.PHONY: all

all: apply provision

clean:
	terraform destroy -auto-approve

apply:
	terraform apply -auto-approve

provision: collector-provision aggregator-provision

plan:
	terraform plan

provison: collector-provision

collector-provision:
	ansible-playbook -i ./ansible/hosts ./ansible/collector.yml

systemlog-bench:
	ansible-playbook -i ./ansible/hosts ./ansible/systemlog-bench.yml

visualize: visualize-cpu_s visualize-rss_s visualize-vms_s visualize-cpu_w visualize-rss_w visualize-vms_w visualize-read_bytes visualize-write_bytes visualize-recv_bytes visualize-send_bytes

visualize-cpu_s:
	python3 visualize/plot_pandas_Usage.py --resource cpu_s

visualize-rss_s:
	python3 visualize/plot_pandas_Usage.py --resource rss_s

visualize-vms_s:
	python3 visualize/plot_pandas_Usage.py --resource vms_s

visualize-cpu_w:
	python3 visualize/plot_pandas_Usage.py --resource cpu_w

visualize-rss_w:
	python3 visualize/plot_pandas_Usage.py --resource rss_w

visualize-vms_w:
	python3 visualize/plot_pandas_Usage.py --resource vms_w

visualize-read_bytes:
	python3 visualize/plot_pandas_Usage.py --resource read_bytes

visualize-write_bytes:
	python3 visualize/plot_pandas_Usage.py --resource write_bytes

visualize-recv_bytes:
	python3 visualize/plot_pandas_Usage.py --resource recv_bytes

visualize-send_bytes:
	python3 visualize/plot_pandas_Usage.py --resource send_bytes
