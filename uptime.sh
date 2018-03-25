#!/bin/sh
#
#     Uptime Monitor
#     uptime.sh @ Version 1.0.0.0
#     CmdrSharp
#

IP=$1
INTERVAL=$2
COUNT=$3

if [ -z "$1" ]; then
    echo "Usage: $0 <Public IP> <INTERVAL in SECONDS> <ICMP Count>"
    exit 1
elif [ -z "$2" ]; then
    echo "Usage: $0 <Public IP> <INTERVAL in SECONDS> <ICMP Count>"
    exit 1
elif ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 <IP> <INTERVAL in SECONDS> <ICMP Count>"
    exit 1
elif ! [[ $2 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <IP> <INTERVAL in SECONDS> <ICMP Count>"
    exit 1
elif ! [[ $3 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <IP> <INTERVAL in SECONDS> <ICMP Count>"
    exit 1
fi


TIMESTAMP () {
sed -e "s/^/$(date "+%b %d %H:%M:%S") /"
}

# Loop the test with desired interval
echo "## Starting ICMP Monitor with interval ${INTERVAL} seconds ## (exit with Ctrl+C)"

while sleep $INTERVAL ; do

        RESULT=$(ping -c $COUNT $IP | grep 'rtt\|loss')

        if [ ! -e ~/$1.monitor.out ] ; then
            echo "## ~/$1.out doesn't exist. Creating it. ##"
            touch ~/$1.monitor.out
        fi

        if [ ! -w ~/$1.monitor.out ] ; then
            echo "## Cannot write to ~/$1.monitor.out. Aborting. ##"
            exit 1
        fi

        echo "$RESULT" | TIMESTAMP | tee -a $1.monitor.out
        sleep 2
done
