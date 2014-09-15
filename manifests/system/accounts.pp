## Class: rjil::system::accounts
## Purpose is to group all system user account actions in single class

class rjil::system::accounts (
  $active_users,
  $sudo_users,
  $local_users,
) {

  ## Make sure root user doesnt have any passord set.
  ## If set, revert it.
  user { 'root':
    name     => 'root',
    ensure   => present,
    password => '*',
  }

  class { 'ssh::server':
    options => {
      'PasswordAuthentication' => 'no',
      'PermitRootLogin' => 'no',
    },
  }

  ## Add all local users which are set as active
  ## The idea is to specify details of all users and
  ## override the users in different hierarichy like
  ## environment wide, role wide etc

  create_resources('rjil::system::accounts::instance',$local_users,{active_users => $active_users})

  ## setup sudoers
  class { 'sudo':
    purge => false,
    config_file_replace => false,
  }

  ## Make an intersection of active users and sudo users,
  ##  so that sudo_users are always a subset of active_users

  $sudo_users_orig = intersection($active_users,$sudo_users)

  rjil::system::accounts::sudo_conf { $sudo_users_orig: }

}
