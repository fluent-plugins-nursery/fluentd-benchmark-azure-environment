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

visualize: visualize-cpu_s visualize-cpu_w visualize-private_bytes_s visualize-private_bytes_w visualize-working_set_s visualize-working_set_w visualize-sent_bytes visualize-received_bytes visualize-disk_reads visualize-disk_writes

visualize-cpu_s:
	python3 visualize/plot_pandas_Usage.py --resource cpu_s

visualize-cpu_w:
	python3 visualize/plot_pandas_Usage.py --resource cpu_w

visualize-private_bytes_s:
	python3 visualize/plot_pandas_Usage.py --resource private_bytes_s

visualize-private_bytes_w:
	python3 visualize/plot_pandas_Usage.py --resource private_bytes_w

visualize-working_set_s:
	python3 visualize/plot_pandas_Usage.py --resource working_set_s

visualize-working_set_w:
	python3 visualize/plot_pandas_Usage.py --resource working_set_w

visualize-sent_bytes:
	python3 visualize/plot_pandas_Usage.py --resource sent_bytes

visualize-received_bytes:
	python3 visualize/plot_pandas_Usage.py --resource received_bytes

visualize-disk_reads:
	python3 visualize/plot_pandas_Usage.py --resource disk_reads

visualize-disk_writes:
	python3 visualize/plot_pandas_Usage.py --resource disk_writes
