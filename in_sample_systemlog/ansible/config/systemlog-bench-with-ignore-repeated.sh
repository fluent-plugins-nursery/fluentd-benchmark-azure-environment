#!/bin/sh

while getopts s: option
do
case "${option}"
in
s) STEP=${OPTARG};;
esac
done

usage() {
    echo "available options are:"
    echo "-s STEP (for specifying monitoring interval)"
    exit 1
}

if [ -z $STEP ]; then
    echo "specify step value with -s STEP."
    usage
fi

sudo td-agent -o td-agent.log -c fluent-systemlog-ignore-repeated.conf &

sleep 3

sudo python3.6 -u /usr/local/bin/monitor $STEP | tee usage-fluent-systemlog-ignore-repeated.tsv

sudo killall -TERM td-agent
