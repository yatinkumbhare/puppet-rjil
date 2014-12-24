#
# Class rjil::apache::trust_selfsigned_cert
#

class rjil::apache::trust_selfsigned_cert (
  $ssl_cert_file                    = '/etc/apache2/certs/jiocloud.com.crt',
  $ssl_key_file                     = '/etc/apache2/certs/jiocloud.com.key',
) {

  ##
  # jiocloud-ssl-certificate package in rustedhalo has godaddy signed
  # certificate which is expired, because of which it is not usable. So
  # Created one self-signed certificate and pushing it using puppet for now
  # until we package it.
  ##

  file { $ssl_key_file:
    ensure => file,
    source => 'puppet:///modules/rjil/ssl/selfsigned_server.key',
    owner  => $::apache::params::user,
    mode   => 0640,
    notify => Service['httpd'],
  }

  file { $ssl_cert_file:
    ensure => file,
    source => 'puppet:///modules/rjil/ssl/selfsigned_server.crt',
    owner  => $::apache::params::user,
    mode   => 0640,
    notify => Service['httpd'],
  }

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
    notify      => Service['httpd'],
  }
}
