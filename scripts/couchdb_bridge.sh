#!/bin/bash

HOST=$1
SSH_PORT=22223
[ -z "$2" ] || SSH_PORT=$2

LOCAL_PORT=15984
[ -z "$3" ] || LOCAL_PORT=$3

REMOTE_PORT=5984
[ -z "$4" ] || REMOTE_PORT=$4

ETH_IP="`ssh -p ${SSH_PORT} ${HOST} /sbin/ifconfig eth1 2>/dev/null | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`"
[ -z $ETH_IP ] && ETH_IP="`ssh -p ${SSH_PORT} ${HOST} /sbin/ifconfig eth0 2>/dev/null | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`"

echo "# ssh -p ${SSH_PORT} -L ${LOCAL_PORT}:${ETH_IP}:${REMOTE_PORT} ${HOST} -N"
ssh -p ${SSH_PORT} -L ${LOCAL_PORT}:${ETH_IP}:${REMOTE_PORT} ${HOST} -N
