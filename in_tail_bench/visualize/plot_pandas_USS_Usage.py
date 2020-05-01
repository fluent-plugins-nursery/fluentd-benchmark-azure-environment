#!/usr/bin/env python3

import os
import numpy as  np
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns

from ansible.parsing.dataloader import DataLoader
from ansible.inventory.manager import InventoryManager

inventory_file_name = 'ansible/hosts'
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

base_path = os.path.join("ansible", "output", collector, "home", username)
print(base_path)

rate_500 = pd.read_csv(os.path.join(base_path, 'usage-500.tsv'), sep='\t', na_values='.')
rate_1000 = pd.read_csv(os.path.join(base_path, 'usage-1000.tsv'), sep='\t', na_values='.')
rate_2000 = pd.read_csv(os.path.join(base_path, 'usage-2000.tsv'), sep='\t', na_values='.')
rate_5000 = pd.read_csv(os.path.join(base_path, 'usage-5000.tsv'), sep='\t', na_values='.')

df = pd.DataFrame({
    500: rate_500["USS(MB) "],
    1000: rate_1000["USS(MB) "],
    2000: rate_2000["USS(MB) "],
    5000: rate_5000["USS(MB) "],
})

medians = {500: np.round(df[500].median(), 2),
           1000: np.round(df[1000].median(), 2),
           2000: np.round(df[2000].median(), 2),
           5000: np.round(df[5000].median(), 2),
}
median_labels = [str(np.round(s, 2)) for s in medians]

print(medians)
df_melt = pd.melt(df)
print(df_melt.head())

fig = plt.figure()
plt.title('USS Usage')
ax = fig.add_subplot(1, 1, 1)
ax.set_ylim(0, 120)
plot = sns.boxplot(x='variable', y='value', data=df_melt, showfliers=False, ax=ax, showmeans=True)
plot.set(
    xlabel='flow rate (lines/second)',
    ylabel='USS Usage (MB)'
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
    xlabel='flow rate (lines/second)',
    ylabel='USS Usage (MB)'
)

plt.savefig('USS_usage.png')
