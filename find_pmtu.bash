#!/usr/bin/env bash

INITIAL_SIZE=1600 # Just for testing; should start at 1500
HOST=$1
MAX=$INITIAL_SIZE
MIN=1
SIZE=$MAX
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
    let DIFF=MAX-MIN
    while [[ $DIFF -ne 1 ]]
    do 
        check_ping $SIZE
        EXIT_CODE=$?
        if [[ $EXIT_CODE -ne 0 ]]; then
            let MAX=SIZE
        else
            let MIN=SIZE
        fi
        let SIZE=(MAX+MIN)/2
        let DIFF=MAX-MIN
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
