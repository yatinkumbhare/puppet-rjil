#!/bin/bash -xe

. $(dirname $0)/common.sh

# If these aren't yet set (from credentials file, typically),
if [ -z "${consul_discovery_token}" ]
then
    consul_discovery_token=$(curl http://consuldiscovery.linux2go.dk/new)
fi

. $(dirname $0)/make_userdata.sh

time python -m jiocloud.apply_resources apply ${EXTRA_APPLY_RESOURCES_OPTS} --key_name=${KEY_NAME:-soren} --project_tag=${project_tag} ${mappings_arg} environment/${layout}.yaml userdata.txt

time $timeout 1200 bash -c 'while ! bash -c "ip=$(python -m jiocloud.utils get_ip_of_node ${consul_bootstrap_node:-etcd1}_${project_tag});ssh -o ServerAliveInterval=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \${ssh_user:-jenkins}@\${ip} python -m jiocloud.orchestrate ping"; do sleep 5; done'

ip=$(python -m jiocloud.utils get_ip_of_node ${consul_bootstrap_node:-etcd1}_${project_tag})

time $timeout 600 bash -c "while ! ssh -o ServerAliveInterval=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${ssh_user:-jenkins}@${ip} python -m jiocloud.orchestrate trigger_update ${BUILD_NUMBER}; do sleep 5; done"

time $timeout 3000 bash -c "while ! python -m jiocloud.apply_resources list --project_tag=${project_tag} environment/${layout}.yaml | sed -e 's/_/-/g' | ssh -o ServerAliveInterval=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${ssh_user:-jenkins}@${ip} python -m jiocloud.orchestrate verify_hosts ${BUILD_NUMBER} ; do sleep 5; done"
time $timeout 2400 bash -c "while ! ssh -o ServerAliveInterval=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${ssh_user:-jenkins}@${ip} python -m jiocloud.orchestrate check_single_version -v ${BUILD_NUMBER} ; do sleep 5; done"
time $timeout 600 bash -c "while ! ssh -o ServerAliveInterval=30 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${ssh_user:-jenkins}@${ip} python -m jiocloud.orchestrate get_failures --hosts; do sleep 5; done"
