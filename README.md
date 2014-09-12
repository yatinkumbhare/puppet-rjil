[![Build Status](https://travis-ci.org/JioCloud/puppet-rjil.svg?branch=master)](https://travis-ci.org/JioCloud/puppet-rjil)

Bootstrap new servers like so:

    wget -q -O - https://raw.github.com/jiocloud/puppet-rjil/master/install.sh | sudo bash

# Running build script

To run the build script, invoke

````
bash -x build\_scripts/deploy.sh
````

The script can be configured using the following environment variables:


### BUILD\_NUMBER (required)

Used to attach a unique identifier to all vms created as a part of a test deployment.
This is useful for distinguishing between separate sets of machines that may be
on the same network.

If you are going to be performing multiple deployments for testing purposes, it is recommended
to use a timestamp to make the build number unique per invocation:

````
export BUILD\_NUMBER=`date +"%d%m%y%H%M%S"`;
````

### KEY\_NAME (required)

The name of the keypair that will used assigned to the VM.

````
export KEY\_NAME=openstack\_ssh\_key
````

### env\_file (optional)

File that contains the following environment variables used to configuration access
and authentication against your openstack environment.

This argument is optional provided that you manually provide those environment variables.

````
export env\_file=~/credentials.sh
````

### timeout (optional)

Name of the command that provides the timeout capability. You should only even have to
set this if you are using the script from a Mac (or other Unix system).

````
export timeout\_command=gtimeout
````

### puppet\_modules\_source (optional)

Location of source repository for puppet-rjil. This is required if you want to test against
a branch instead of against the puppet-rjil contents that are packaged. This is very
handy for pre-validating some configuration before running tests.

````
export puppet\_modules\_source\_repo=https://github.com/bodepd/puppet-rjil
````

### puppet\_modules\_source\_branch (optional, only makes sense together with puppet\_modules\_source)

Branch that should be used from the provided puppet-rjil repo.

````
export puppet\_modules\_source\_branch=origin/deploy\_script
````

### ssh\_user

User to that build process should use to ssh into etcd server.

````
ssh\_user=ubuntu
````

## Example of a full invocation

This is what I used for testing:

````
export BUILD\_NUMBER=test\_`date +"%d%m%y%H%M%S"`;export env=dan;export KEY\_NAME=openstack\_ssh\_key; export env\_file=~/credentials.sh;export timeout\_command=gtimeout; export puppet\_modules\_source\_repo=https://github.com/bodepd/puppet-rjil;export puppet\_modules\_source\_branch=origin/deploy\_script;export ssh\_user=ubuntu;bash -x build\_scripts/deploy.sh
````

## dependencies on mac

The first time this script runs (or when it needs to update the version of jiocloud
install), there are a few deps that need to be manually installed on Mac.

````
brew install python
pip install virtualenv
brew install libffi
brew install libyaml
brew install coreutils
alias timeout=gtimeout
````


It is possible that you will also have to manually update the include path to ensure
that libffi is available:

````
export CFLAGS="-I/usr/local/opt/libffi/lib/libffi-3.0.13/include/"
````
