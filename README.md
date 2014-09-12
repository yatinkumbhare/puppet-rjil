[![Build Status](https://travis-ci.org/JioCloud/puppet-rjil.svg?branch=master)](https://travis-ci.org/JioCloud/puppet-rjil)

Bootstrap new servers like so:

    wget -q -O - https://raw.github.com/jiocloud/puppet-rjil/master/install.sh | sudo bash

# Running build script

To run the build script, invoke


````
# customize the build number to make it unique
export BUILD\_NUMBER=`date +"%d%m%y%H%M%S"`;
# use your keyname
export env=dan;export KEY\_NAME=openstack\_ssh\_key;
# insert the name of the script that will set your env variables for auth
export env\_file=~/credentials.sh;
# set the timout command to use something besides timeout (required for mac)
export timeout\_command=gtimeout;
# run the script
bash -x build\_scripts/deploy.sh
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
