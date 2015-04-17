#!/bin/bash

set -e

function fail {
  echo "CRITICAL: $@"
  exit 2
}

osdid=`df -h | grep "/dev/<%= @disk %>[^a-z]" | awk '{print $NF}' | cut -f2 -d-`
ps -efw | grep ceph-osd | grep osd.${osdid}.pid || fail "osd failed"
