#!/bin/bash

# Add the following to your sudo file
# %eng ALL=(ALL) ALL, NOPASSWD: /usr/sbin/tcpdump

FIFO="/tmp/wireshark_fifo_$(date +%s).pcap"

mkfifo $FIFO

ssh $1 "sudo /usr/sbin/tcpdump -s 0 -U -n -w - -i eth0 host 208.90.213.228 and port not 22223" > $FIFO &

trap "{ kill %1; rm -f $FIFO; }" EXIT

wireshark -k -i $FIFO
