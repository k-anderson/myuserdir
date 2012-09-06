#!/bin/bash

cd `dirname $0`

for i in ../confs/* 
do
	echo "# ln -f $i ~/.$(basename $i)"
	ln -f $i ~/.$(basename $i)
done
