class rjil::server() {
  include rjil
  class { ssh::server:
    options => {
      "PasswordAuthentication" => 'no',
      "PermitRootLogin" => 'no',
    },
  }

  file { '/etc/sudoers':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => 'puppet:///modules/rjil/sudoers',
    replace => true,
  }

  realize (
    Rjil::Localuser['soren'],
  )
}
