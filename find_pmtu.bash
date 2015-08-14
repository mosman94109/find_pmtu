#!/usr/bin/env bash

INITIAL_SIZE=1600 # Just for testing; should start at 1500
HOST=$1
UPPER_BOUND=$INITIAL_SIZE
LOWER_BOUND=1
SIZE=$UPPER_BOUND
COUNT=0

function show_usage {
    echo "Usage: $0 HOST"
    exit 1
}

function check_ping () {
    SIZE=$1
    ping -s $SIZE -c 1 -M do $HOST >& /dev/null
    EXIT_CODE=$?
    return $EXIT_CODE
}

function find_mtu() {
    let DIFF=UPPER_BOUND-LOWER_BOUND
    while [[ $DIFF -ne 1 ]]
    do 
        check_ping $SIZE
        EXIT_CODE=$?
        if [[ $EXIT_CODE -ne 0 ]]; then
            let UPPER_BOUND=SIZE
        else
            let LOWER_BOUND=SIZE
        fi
        let SIZE=(UPPER_BOUND+LOWER_BOUND)/2
        let DIFF=UPPER_BOUND-LOWER_BOUND
        let COUNT=COUNT+1
    done
}

if [[ $# -ne 1 ]]; then
    show_usage
fi

find_mtu
echo "MTU to $HOST: $SIZE"
#echo "$COUNT attempts"

# To do: get a list of hosts from a file
