#!/bin/bash

cd `dirname $0`

for i in $PWD/*
do
	if [ "$(basename $i)" != "$(basename $0)" ]
	then
		echo "# ln -fs $i ~/.$(basename $i)"
		ln -fs $i ~/.$(basename $i)
	fi
done
