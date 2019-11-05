#!/bin/bash

## HOW TO USE: 
##      ./reverse_scan <FIRST_PART_IP> <LAST_PART_IP_LIST>
##      ./reverse_scan XXX.XXX.XXX YYY,ZZZ,WWW
##          EX. 
##              ./reverse_scan  8.8.8  8,4,2,12

BASE_IP=$1"."
IP_SCAN=$2
END=254

IFS=',' read -r -a array <<< "$IP_SCAN"

for IP in $(seq 1 $END); do
    IP_RESOLVE=${BASE_IP}$IP
    OUTPUT=$(dig +noall +answer -x "${IP_RESOLVE}")

    if [ -z "$OUTPUT" ]; then
        echo $IP_RESOLVE"> NONE"
    else
        echo $IP_RESOLVE"> $OUTPUT"
    fi

    if [[ " ${array[*]} " =~ " ${IP} " ]]; then
        for port in {1..65535}; do
            OUTPUT_PORT=$( (echo >/dev/tcp/${IP_RESOLVE}/$port) 2> /dev/null && echo "\t$port => open" || echo "$port => close")
            if [ ! -z "$OUTPUT_PORT" ]; then 
                echo -e "\t\t$OUTPUT_PORT"
            fi
        done
    fi
done