## Define rjil::system::accounts::instance
## Purpose: to add active local users 

define rjil::system::accounts::instance (
  $active_users,
  $realname = '',
  $sshkeys = '',
  $password = '*',
  $shell = '/bin/bash'
) {
  if member($active_users,$name) {
    ::account::localuser { $name:
      realname => $realname,
      sshkeys => $sshkeys,
      password => $password,
      shell => $shell,
    }
  }
}

