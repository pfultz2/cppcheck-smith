#!/bin/bash

set -e
LOOP=$(seq `nproc`)
while [ true ]
do
    for i in $LOOP
    do
        ./build.sh &
    done
    wait
done
