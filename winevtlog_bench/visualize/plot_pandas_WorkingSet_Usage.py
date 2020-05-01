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

collector = inventory.get_groups_dict()['windows'][0]
print(collector)

sns.set()
sns.set_style('whitegrid')
sns.set_palette('Set3')

base_path = os.path.join("ansible", "output", collector, "C:", "tools")
print(base_path)

length_512 = pd.read_csv(os.path.join(base_path, '512-resource-usage.csv'), sep=',', na_values='.')
length_1024 = pd.read_csv(os.path.join(base_path, '1024-resource-usage.csv'), sep=',', na_values='.')
length_2048 = pd.read_csv(os.path.join(base_path, '1024-resource-usage.csv'), sep=',', na_values='.')

df = pd.DataFrame({
    512: length_512['\\\\fluentd-windows\\Process(ruby#1)\\Working Set'],
    1024: length_1024['\\\\fluentd-windows\\Process(ruby#1)\\Working Set'],
    2048: length_2048['\\\\fluentd-windows\\Process(ruby#1)\\Working Set'],
})
df = df.divide(1024*1024)

medians = {512: np.round(df[512].median(), 2),
           1024: np.round(df[1024].median(), 2),
           2048: np.round(df[2048].median(), 2),
}
median_labels = [str(np.round(s, 2)) for s in medians]

print(medians)
df_melt = pd.melt(df)
print(df_melt.head())

fig = plt.figure()
plt.title('Working Set Usage')
ax = fig.add_subplot(1, 1, 1)
ax.set_ylim(0, 100)
plot = sns.boxplot(x='variable', y='value', data=df_melt, showfliers=False, ax=ax, showmeans=True)
plot.set(
    xlabel='message length (bytes)',
    ylabel='Working Set (MB)'
)

pos = range(len(medians))
data_range = [512, 1024, 2048]
tick = 0
for item in data_range:
    plot.text(tick+0.1, medians[item], medians[item],
              color='w', weight='semibold', size=10, bbox=dict(facecolor='#445A64'))
    tick = tick + 1
sns.stripplot(x='variable', y='value', data=df_melt, jitter=False, color='black', ax=ax
).set(
    xlabel='message length (bytes)',
    ylabel='Weorking Set (MB)'
)

plt.savefig('Working_Set_usage.png')
