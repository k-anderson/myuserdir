#!/bin/bash

trap "kill %1; killall play" EXIT

set -e

if `echo -n $1 | grep -qE "(RECOVERY|ACKNOWLEDGEMENT)"`; then
  exit 0
fi

while [ -z "`pgrep -f 'play /home/kanderson/media/audio/extreme_alert.wav'`" ]; do 
  aplay /home/kanderson/media/audio/extreme_alert.wav &
done 

zenity --question --text "Received new alert:\n$1\nAcknowledge?"

if [ $? == 0 ]; then
  /usr/bin/mail -s "test ack RE: $1" -r "karl@2600hz.com" "$2" <<EOF
EOF
fi

exit 0
