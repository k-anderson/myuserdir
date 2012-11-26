#!/bin/bash
# HashKnownHosts yes
ssh-keygen -H -f ~/.ssh/known_hosts
rm /home/kanderson/.ssh/known_hosts.old
