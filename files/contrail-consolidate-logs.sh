#!/bin/bash

contrail_logs=('contrail-api'
		'contrail-schema'
		'contrail-vrouter'
		'contrail-discovery'
		'vnc_openstack.err'
		'svc-monitor.err'
		'schema.err'
		'api-0-zk'
		'schema-zk'
		)

log_dir='/var/log/contrail/'
for log in ${contrail_logs[@]} 
do 
file="${log_dir}${log}"
file_log="${file}.log.1"
file_daily="${file}-daily.log"

if [[ "$log" =~ "err" ]]
then
    file_log="${file}.1"
    file_daily="${log_dir}contrail-${log}-daily.log"
fi
 
if [[ "$log" =~ "zk" ]]
then
    file_daily="${log_dir}contrail-${log}-daily.log"
fi

if [ -f "${file_log}" ]
then
	cat $file_log >> $file_daily
	rm  $file_log
fi

done