class rjil::server() {
  include rjil
  include ssh::server

  package { "mosh": }

  ssh::server::configline { "PasswordAuthentication":
    ensure => present,
    value => "no"
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
