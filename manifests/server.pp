class rjil::server() {
  include rjil
  include ssh::server

  package { "mosh": }

  ssh::server::configline { "PasswordAuthentication":
    ensure => present,
    value => "no"
  }

  realize (
    Rjil::Localuser['soren'],
  )
}
