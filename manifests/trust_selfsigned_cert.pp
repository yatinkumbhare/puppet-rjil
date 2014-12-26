#
# Class rjil::trust_selfsigned_cert
#

class rjil::trust_selfsigned_cert {

  ##
  # Trust this self signed certificate, without this code openstack clients
  # will throw ssl errors while connecting.
  ##
  package { 'ca-certificates':
    ensure => installed,
  }

  file { '/usr/share/ca-certificates/selfsigned_server.crt':
    ensure  => file,
    source  => 'puppet:///modules/rjil/ssl/selfsigned_server.crt',
    require => Package['ca-certificates'],
  }

  file_line { 'add_selfsigned_server.crt':
    path    => '/etc/ca-certificates.conf',
    line    => 'selfsigned_server.crt',
    require => File['/usr/share/ca-certificates/selfsigned_server.crt'],
    notify  => Exec['update-cacerts'],
  }

  exec { 'update-cacerts':
    command     => 'update-ca-certificates --fresh',
    refreshonly => true,
  }

}
