#!/usr/bin/env python3

import psutil
import time
from datetime import datetime
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("steps", help="Total running seconds",
                    type=int)
args = parser.parse_args()

print(f"steps\tdate\t{'RSS(MB)':8}\t{'PSS(MB)':8}\t{'USS(MB)':8}\t{'VMS(MB)':8}\t{'Total CPU Usage(%)':8}")
steps = 1
RUBY = "ruby"
rss = 0
pss = 0
uss = 0
vms = 0

while steps <= args.steps:
    now = datetime.now()
    currentTime = now.strftime("%s")
    for proc in psutil.process_iter():
        if proc.name() == RUBY:
            meminfo = proc.memory_full_info()
            rss = meminfo.rss + rss
            pss = meminfo.pss + pss
            uss = meminfo.pss + pss
            vms = meminfo.vms + vms
    cpu = psutil.cpu_percent(interval=1)
    time = now.strftime("%Y/%m/%d %H:%M:%S")
    print(f"{steps}\t{time}\t{rss /1024/1024 :8}\t{pss /1024/1024 :8}\t{uss /1024/1024 :8}\t{vms /1024/1024 :8}\t{cpu:8}")
    steps = steps + 1
    rss = 0
    pss = 0
    uss = 0
    vms = 0
    while (int(currentTime) >= int(datetime.now().strftime("%s"))):
        time.sleep(0.01)
