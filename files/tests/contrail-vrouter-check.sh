#!/bin/bash

log_file="/var/log/contrail/rjil-vrouter-restart.log"
test_cmd='curl -s -m 5 -o /dev/null http://localhost:8085/Snh_ItfReq?name='
lock_file='/var/run/contrail-vrouter-restart.err.lock'

if [ ! -f $lock_file ]
then
    flag_warning=0
    last_step='Curl'
    ${test_cmd}
    rv=$?
    if [ $rv == 28 ]
    then
        echo "[INFO] `date` `hostname` [`date +%s`] Restarting vrouter ">>${log_file}
        last_step='Agent restart'
        flag_warning=1
        service contrail-vrouter-agent restart
        sleep 5
        ${test_cmd}
        rv=$?
    fi
    if [ $rv != 0 ]
    then
        echo "[ERROR] `date` `hostname` [`date +%s`] ${last_step} failure - code ${rv}">>${log_file}
        echo "[ERROR] `date`" >>${lock_file}
        exit 2
    fi
    exit $flag_warning
else
    exit 1
fi