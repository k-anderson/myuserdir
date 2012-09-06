#!/bin/bash

CALLID=$1

FILE="/var/log/freeswitch/debug.log"
[ -z "$2" ] || FILE="$2"

LINES=`grep -n $CALLID $FILE | cut -d':' -f 1`

[ -z "$LINES" ] && echo "not found" && exit 1

FIRST=`echo "$LINES" | head -1`
LAST=`echo "$LINES" | tail -1`

echo "# sed -n \"$((FIRST - 10)),$((LAST + 10))p\" $FILE"
sed -n "$((FIRST - 10)),$((LAST + 10))p" $FILE
