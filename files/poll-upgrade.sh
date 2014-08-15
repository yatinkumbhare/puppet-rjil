#!/bin/bash

do_upgrade() {
	pending_version=$1
	etcdctl set upgrade_running/$(hostname) true
	export http_proxy="http://10.135.121.138:3128/"
	export https_proxy="http://10.135.121.138:3128/"
	export no_proxy="127.0.0.1,localhost,10.135.127.35"
	apt-get update
	apt-get dist-upgrade -o Dpkg::Options::="--force-confnew" -y
	puppet apply /etc/puppet/manifests/site.pp
	etcdctl rm upgrade_running/$(hostname)
	etcdctl rmdir upgrade_running || true
	echo $pending_version > /etc/running_version
}

pending_version=$(etcdctl get current_version)

while true
do
	if [ ! -e /etc/running_version ]
	then
		do_upgrade $pending_version
	else
		read running_version < /etc/running_version
		if  [ ${pending_version} -gt ${running_version} ]
		then
			do_upgrade $pending_version
		fi
	fi
	read running_version < /etc/running_version
	etcdctl set running_version/${running_version} $(hostname) --ttl 60
	timeout 30 etcdctl watch current_version || true
done
