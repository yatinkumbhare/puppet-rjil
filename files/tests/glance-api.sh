#!/bin/bash
set -e
test -f /root/openrc
source /root/openrc
/usr/lib/nagios/plugins/check_http -H 127.0.0.1 -p 9292
glance image-list
