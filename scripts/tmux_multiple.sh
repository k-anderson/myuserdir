#!/bin/bash

cd `dirname $0`
./tmuxlogin.sh -t tmux_multiple -w servers $@
