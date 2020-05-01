#!/usr/bin/env python3

import psutil
import time
from datetime import datetime
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("steps", help="Total running seconds",
                    type=int)
args = parser.parse_args()

_last_disk_io_cache = (0,0,0.0)
_last_net_io_cache = (0,0,0.0)

def disk_io_metrics():
    global _last_disk_io_cache

    disk_counters = psutil.disk_io_counters()
    tm = time.time()

    read_bytes = disk_counters.read_bytes
    write_bytes = disk_counters.write_bytes

    last_read_bytes, last_write_bytes, last_time = _last_disk_io_cache
    delta = tm - last_time
    read_speed = (read_bytes - last_read_bytes) / delta
    write_speed = (write_bytes - last_write_bytes) / delta

    _last_disk_io_cache = (read_bytes, write_bytes, tm)
    return write_speed, read_speed

def net_io_metrics():
    global _last_net_io_cache

    net_counters = psutil.net_io_counters()
    tm = time.time()

    send_bytes = net_counters.bytes_sent
    recv_bytes = net_counters.bytes_recv

    last_send_bytes, last_recv_bytes, last_time = _last_net_io_cache
    delta = tm - last_time
    recv_speed = (recv_bytes - last_recv_bytes) / delta
    send_speed = (send_bytes - last_send_bytes) / delta

    _last_net_io_meta = (send_bytes, recv_bytes, tm)
    return recv_speed, send_speed

print(f"steps\tdate\t{'RSS(MB)':8}\t{'PSS(MB)':8}\t{'USS(MB)':8}\t{'VMS(MB)':8}\t{'Total CPU Usage(%)':8}\tread bytes(/sec)\twrite bytes(/sec)\trecv bytes(/sec)\tsend bytes(/sec)")
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
    tm = time.time()
    write_speed, read_speed = disk_io_metrics()
    recv_speed, send_speed = net_io_metrics()
    first = False
    time_str = now.strftime("%Y/%m/%d %H:%M:%S")
    print(f"{steps}\t{time_str}\t{rss /1024/1024 :8}\t{pss /1024/1024 :8}\t{uss /1024/1024 :8}\t{vms /1024/1024 :8}\t{cpu:8}\t{read_speed}\t{write_speed}\t{recv_speed}\t{send_speed}")
    steps = steps + 1
    rss = 0
    pss = 0
    uss = 0
    vms = 0
    while (int(currentTime) >= int(datetime.now().strftime("%s"))):
        time.sleep(0.01)
