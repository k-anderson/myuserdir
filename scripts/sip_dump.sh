#!/bin/bash
tcpdump -i eth0 -n -A -t -s 0 port 5060
