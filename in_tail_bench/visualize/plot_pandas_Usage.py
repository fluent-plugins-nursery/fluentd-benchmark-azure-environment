#!/usr/bin/env python3

import os
import numpy as  np
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns
import argparse

from ansible.parsing.dataloader import DataLoader
from ansible.inventory.manager import InventoryManager

parser = argparse.ArgumentParser(description='Visualize data as plot')
parser.add_argument('--resource',
                    choices=['cpu', 'pss', 'uss', 'rss', 'vms', 'read_bytes', 'write_bytes',
                             'recv_bytes', 'send_bytes'],
                    default='cpu')
args = parser.parse_args()

if args.resource == 'cpu':
    resource_key = "Total CPU Usage(%)"
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'CPU Usage (%)'
    ylimit = 100
    fig_title = 'CPU Usage'
    fig_name = 'CPU_usage.png'
    divide_base = -1
elif args.resource == 'pss':
    resource_key = "PSS(MB) "
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'PSS Usage (MB)'
    ylimit = 100
    fig_title = 'PSS Usage'
    fig_name = 'PSS_usage.png'
    divide_base = -1
elif args.resource == 'uss':
    resource_key = "USS(MB) "
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'USS Usage (MB)'
    ylimit = 100
    fig_title = 'USS Usage'
    fig_name = 'USS_usage.png'
    divide_base = -1
elif args.resource == 'rss':
    resource_key = "RSS(MB) "
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'RSS Usage (MB)'
    ylimit = 100
    fig_title = 'RSS Usage'
    fig_name = 'RSS_usage.png'
    divide_base = -1
elif args.resource == 'vms':
    resource_key = "VMS(MB) "
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'VMS Usage (MB)'
    ylimit = 1200
    fig_title = 'VMS Usage'
    fig_name = 'VMS_usage.png'
    divide_base = -1
elif args.resource == 'read_bytes':
    resource_key = "read bytes(/sec)"
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'Disk Read Usage (bytes)'
    ylimit = 1200
    fig_title = 'Disk Read Usage'
    fig_name = 'Disk_Read_usage.png'
    divide_base = -1
elif args.resource == 'write_bytes':
    resource_key = "write bytes(/sec)"
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'Disk Write Usage (KiB)'
    ylimit = 1200
    fig_title = 'Disk Write Usage'
    fig_name = 'Disk_Write_usage.png'
    divide_base = 1024
elif args.resource == 'recv_bytes':
    resource_key = "recv bytes(/sec)"
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'Receive Usage'
    ylimit = 10
    fig_title = 'Receive Bytes Usage'
    fig_name = 'Receive_Bytes_usage.png'
    divide_base = -1
elif args.resource == 'send_bytes':
    resource_key = "send bytes(/sec)"
    xlabel_message = 'flow rate (lines/second)'
    ylabel_message = 'Send Usage'
    ylimit = 10
    fig_title = 'Send Bytes Usage'
    fig_name = 'Send_Bytes_usage.png'
    divide_base = -1

pwd = os.path.dirname(os.path.realpath(__file__))
inventory_file_name = os.path.join(pwd, '..', 'ansible/hosts')
data_loader = DataLoader()
inventory = InventoryManager(loader=data_loader,
                             sources=[inventory_file_name])

collector = inventory.get_groups_dict()['collector'][0]

tfvars = {}
with open("terraform.tfvars") as tfvarfile:
    for line in tfvarfile:
        name, var = line.partition("=")[::2]
        tfvars[name.strip()] = var

print(tfvars)
username = tfvars["collector-username"].strip(" \"\n")
print(collector)

sns.set()
sns.set_style('whitegrid')
sns.set_palette('Set3')

base_path = os.path.join(pwd, '..', "ansible", "output", collector, "home", username)
print(base_path)

rate_500 = pd.read_csv(os.path.join(base_path, 'usage-500.tsv'), sep='\t', na_values='.')
rate_1000 = pd.read_csv(os.path.join(base_path, 'usage-1000.tsv'), sep='\t', na_values='.')
rate_2000 = pd.read_csv(os.path.join(base_path, 'usage-2000.tsv'), sep='\t', na_values='.')
rate_5000 = pd.read_csv(os.path.join(base_path, 'usage-5000.tsv'), sep='\t', na_values='.')

df = pd.DataFrame({
    500: rate_500[resource_key],
    1000: rate_1000[resource_key],
    2000: rate_2000[resource_key],
    5000: rate_5000[resource_key],
})
if divide_base > 1:
    df = df.divide(divide_base)

medians = {500: np.round(df[500].median(), 2),
           1000: np.round(df[1000].median(), 2),
           2000: np.round(df[2000].median(), 2),
           5000: np.round(df[5000].median(), 2)}
median_labels = [str(np.round(s, 2)) for s in medians]

print(medians)
df_melt = pd.melt(df)
print(df_melt.head())

fig = plt.figure()
plt.title(fig_title)
ax = fig.add_subplot(1, 1, 1)
ax.set_ylim(0, ylimit)
plot = sns.boxplot(x='variable', y='value', data=df_melt, showfliers=False, ax=ax, showmeans=True)
plot.set(
    xlabel=xlabel_message,
    ylabel=ylabel_message
)

pos = range(len(medians))
data_range = [500, 1000, 2000, 5000]
tick = 0
for item in data_range:
    plot.text(tick+0.1, medians[item], medians[item],
              color='w', weight='semibold', size=10, bbox=dict(facecolor='#445A64'))
    tick = tick + 1
sns.stripplot(x='variable', y='value', data=df_melt, jitter=False, color='black', ax=ax
).set(
    xlabel=xlabel_message,
    ylabel=ylabel_message
)

plt.savefig(fig_name)
