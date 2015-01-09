#
# Class rjil::trust_selfsigned_cert
#

class rjil::trust_selfsigned_cert(
  $cert = "/etc/ssl/certs/jiocloud.com.crt"
) {

  ##
  # Trust this self signed certificate, without this code openstack clients
  # will throw ssl errors while connecting.
  ##
  package { 'ca-certificates':
    ensure => installed,
  }

  file { '/usr/local/share/ca-certificates/selfsigned.crt':
    ensure  => link,
    source  => $cert,
    require => Package['ca-certificates'],
    notify  => Exec['update-cacerts'],
  }

  exec { 'update-cacerts':
    command     => 'update-ca-certificates --fresh',
    refreshonly => true,
  }

}
