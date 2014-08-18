#!/bin/bash

do_upgrade() {
	pending_version=$1
	export http_proxy="http://10.135.121.138:3128/"
	export https_proxy="http://10.135.121.138:3128/"
	export no_proxy="127.0.0.1,localhost,10.135.127.35"
	apt-get update
	apt-get dist-upgrade -o Dpkg::Options::="--force-confnew" -y
	puppet apply /etc/puppet/manifests/site.pp
	python -m jiocloud.orchestrate local_version $pending_version
}


while true
do
	if python -m jiocloud.orchestrate pending_update
	then
		pending_version=$(python -m jiocloud.orchestrate current_version)
		do_upgrade $pending_version
	fi
	python -m jiocloud.orchestrate update_own_info
	sleep 30
done
