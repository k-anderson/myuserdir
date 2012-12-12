#!/bin/bash

pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/ { if ( $3 != "base" && $3 != "base-devel" ) { print name } }' > ~/myuserdir/docs/$(hostname)-explicitly-installed-$(date +%s).txt
