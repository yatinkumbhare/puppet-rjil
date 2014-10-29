#!/bin/bash

if [ -z "${env}" ]
then
    echo '$env must be defined'
    exit 1
fi

# Load credentials (openrc style)
. ${env_file:-/var/lib/jenkins/cloud.${env}.env}

# Load map from generic image, flavor and network names to
# cloud specific ids
if [ -n "${mapping}" ]
then
	mappings_arg="--mappings=${mapping}"
elif [ -e "environment/${env}.map.yaml" ]
then
	mappings_arg="--mappings=environment/${env}.map.yaml"
else
	mappings_arg=""
fi

project_tag=${project_tag:-test${BUILD_NUMBER}}

if ! [ -e venv ]
then
    virtualenv venv
    . venv/bin/activate
    # This can go away with the next release of Pip (which will include a
    # version of python-requests newer than 2.4.0.)
    pip install -e git+http://github.com/pypa/pip#egg=pip

    # This speeds the whole process up *a lot*
    pip install pip-accel
    pip-accel install -e git+https://github.com/JioCloud/python-jiocloud#egg=jiocloud
    deactivate
fi

. venv/bin/activate

# this is here to allow a user to override the command used for
# the timeout function just incase it happens to be gtimeout
timeout=${timeout_command:-timeout}

