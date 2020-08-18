#!/bin/sh

while getopts s:l:r: option
do
case "${option}"
in
s) STEP=${OPTARG};;
l) LENGTH=${OPTARG};;
r) RATE=${OPTARG};;
esac
done

usage() {
    echo "available options are:"
    echo "-s STEP (for specifying monitoring interval)"
    echo "-l LENGTH (for specifying message length)"
    echo "-r RATE (for specifying message generation rate)"
    exit 1
}

if [ -z $STEP ]; then
    echo "specify step value with -s STEP."
    usage
fi

if [ -z $LENGTH ]; then
    echo "specify length value with -l LENGTH."
    usage
fi

if [ -z $RATE ]; then
    echo "specify rate value with -s RATE."
    usage
fi

cat <<EOF > fluent-systemlog.conf
<source>
  @type sample_systemlog
  @id sample_systemlog
  @log_level info
  size ${LENGTH}
  rate ${RATE}
</source>

<label @FLUENT_LOG>
  <match **>
    @type null
  </match>
</label>

<match **>
  @type null
</match>
EOF

sudo td-agent -o td-agent.log -c fluent-systemlog.conf &

sleep 3

sudo python3.6 -u /usr/local/bin/monitor $STEP | tee usage-fluent-systemlog.tsv

sudo killall -TERM td-agent
