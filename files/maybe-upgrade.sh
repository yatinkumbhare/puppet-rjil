#!/bin/bash

# Exit codes:
# 0: Yup, there's an update
# 1: No, no updates
# 2: Could not reach etcd, so we don't know
# 3: Could not reach etcd, but we also haven't been initialised ourselves.
python -m jiocloud.orchestrate pending_update
rv=$?


export http_proxy="http://10.135.121.138:3128/"
export https_proxy="http://10.135.121.138:3128/"
export no_proxy="127.0.0.1,localhost,10.135.127.35"

run_puppet() {
	puppet apply --logdest=syslog /etc/puppet/manifests/site.pp
}

if [ $rv -eq 0 ]
then
	pending_version=$(python -m jiocloud.orchestrate current_version)
	apt-get update
	apt-get dist-upgrade -o Dpkg::Options::="--force-confnew" -y
	run_puppet
	python -m jiocloud.orchestrate local_version $pending_version
elif [ $rv -eq 1 ]
then
	:
elif [ $rv -eq 2 ]
then
	:
elif [ $rv -eq 3 ]
then
	# Maybe we're the first etcd node (or some other weirdness is going on).
	# Let's just run Puppet and see if things normalize
	run_puppet
fi
python -m jiocloud.orchestrate update_own_info
