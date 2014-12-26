#
# Class rjil::apache::install_ssl_cert
#

class rjil::apache::install_ssl_cert (
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

}
