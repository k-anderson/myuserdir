#!/bin/bash
x11vnc -viewonly -nopw -shared -forever -clip 1292x600 -noclipboard -nosetclipboard -display :0 -connect "$1" $@
