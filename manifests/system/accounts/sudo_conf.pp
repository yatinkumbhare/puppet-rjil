## Define rjil::system::accounts::sudo_conf
## Purpose
## Generates sudoers files under /etc/sudoers.d/, one per user

define rjil::system::accounts::sudo_conf {
  ::sudo::conf { $name:
    content  => "#Managed By Puppet\n$name ALL=(ALL) NOPASSWD: ALL",
  }
}
