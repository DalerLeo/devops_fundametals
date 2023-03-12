#!/usr/bin/bash

THRESHOLD=20
used_space_in_percent=$(df -h / | awk 'NR==2 {print substr($5,0,2)}')
freespace_in_percent=$(( 100 - $used_space_in_percent ))

if [[ -z $1 ]]
then
    threshold=$THRESHOLD
else
    threshold=$1
fi

if(( $freespace_in_percent < $threshold ))
then
    echo "RUNNING OUT FREE SPACE, only $freespace_in_percent% available"
else
    echo "I am OK, Free space is $freespace_in_percent%"
fi
