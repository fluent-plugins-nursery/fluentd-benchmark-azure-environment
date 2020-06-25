#!/bin/sh

while getopts s:r: option
do
case "${option}"
in
s) STEP=${OPTARG};;
r) RATE=${OPTARG};;
esac
done

usage() {
    echo "available options are:"
    echo "-s STEP (for set up total step(s))"
    echo "-r RATE (for set up generating line rate/sec)"
    exit 1
}

if [ -z $STEP ]; then
    echo "specify step with value -s VALUE."
    usage
fi

if [ -z $RATE ]; then
    echo "specify rate value with -r VALUE."
    usage
fi

td-agent -c ${HOME}/td-agent.conf -o td-agent.log &

sleep 3

if [ $RATE -gt 0 ]; then
    dummer -c ${HOME}/dummer/dummer.conf -r $RATE &
fi

python3 -u `which monitor` $STEP | tee usage-$RATE.tsv

killall -TERM dummer
killall -TERM ruby
killall -TERM td-agent
