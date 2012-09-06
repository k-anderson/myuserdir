#!/bin/bash

FIND="$1"

FILE="/var/log/opensips.log"
[ -z "$2" ] || FILE="$2"

for i in `grep $FIND $FILE | cut -d' ' -f 6 | cut -d'|' -f 1 | uniq`; do echo -e "\n\n$i\n"; grep $i $FILE; done
