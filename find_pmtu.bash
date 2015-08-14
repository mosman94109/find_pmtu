#!/usr/bin/env bash

INITIAL_SIZE=1600 # Just for testing; should start at 1500
HOST=$1

function check_ping () {
    SIZE=$1
    ping -s $SIZE -c 1 -M do $HOST >& /dev/null
    EXIT_CODE=$?
    return $EXIT_CODE
}

MAX=$INITIAL_SIZE
MIN=1
SIZE=$MAX
COUNT=0

let DIFF=MAX-MIN
while [[ $DIFF -ne 1 ]]
do 
    check_ping $SIZE
    EXIT_CODE=$?
    if [[ $EXIT_CODE -ne 0 ]]; then
        let MAX=SIZE
        let SIZE=(MAX+MIN)/2
        let DIFF=MAX-MIN
        let COUNT=COUNT+1
    else
        let MIN=SIZE
        let SIZE=(MAX+MIN)/2
        let DIFF=MAX-MIN
        let COUNT=COUNT+1
    fi
done

echo "MTU to $HOST: $SIZE"

# To do: add usage function
