#!/bin/bash

cd `dirname $0`

CCMD=`./eflymake "$1" "$2"`
eval $CCMD
