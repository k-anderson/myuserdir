#!/bin/sh

host="dev.andersonkarl.net"
notify="$HOME/system/scripts/irssi-notify.sh"

set -e

socat -u tcp4-listen:12000,reuseaddr,fork,bind=127.0.0.1 exec:$notify &

# If you only have one remote screen session
#autossh $host -p $port -R 12000:localhost:12000 -t 'screen -r -D'

# Attaches to 'irc' session
ssh $host -R 12000:localhost:12000

kill %1
