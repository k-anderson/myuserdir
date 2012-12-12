#!/bin/bash
tail -n0 -f $1>/tmp/cnt_per_sec.log & sleep 10; kill $! ; wc -l /tmp/cnt_per_sec.log
rm /tmp/cnt_per_sec.log
