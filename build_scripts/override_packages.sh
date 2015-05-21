#!/bin/bash
set -e

#
# if the repoconf_repo_source and/or repoconf_source_branch
# variables are set, it downloads the default.xml file from
# that remote/branch and uses it to create a package repo
# called new_repo.tgz. This was written to be integrated
# with jenkins to archive this repo for uses with jobs
# that can use that package archive with deploy.sh
#
if [ -n "${repoconf_repo_source}" ]; then
  repo_dir=`pwd`/'pkg_build'
  mkdir -p $repo_dir
  git config --global color.ui false
  pushd $repo_dir
  if [ -n "${repoconf_source_branch}" ]; then
    repo init -u $repoconf_repo_source -b $repoconf_source_branch
  else
    repo init -u $repoconf_repo_source
  fi
  repo sync
  # run majic autobuild command to create a pkg repo called foofil
  bash -x ./debian/sync-repo.sh build
  popd
  sbuild -n -d trusty -A *.dsc
  mkdir new_repo
  cp *.deb new_repo/
  pushd new_repo
  apt-ftparchive packages . > Packages
  tar -cvzf ../new_repo.tgz *
  popd
fi

create_gpg_key() {
  echo '
    Key-Type: 1
    Key-Length: 4096
    Subkey-Type: ELG-E
    Subkey-Length: 4096
    Name-Real: foo repository
    Expire-Date: 0
    %%commit
' > foo
  gpg --batch --gen-key foo
  key_id=`gpg --list-keys | grep pub | awk '{print $2}' | awk -F'/' '{print $2}'`
  gpg --output keyFile --armor --export $key_id
}
