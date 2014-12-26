#
# Class rjil::ceph::radosgw
# Purpose: Configure ceph radosgw
#
# == Parameters
#

class rjil::ceph::radosgw (
  $manage_ssl_cert                  = false,
  $ssl_secrets_package_name         = 'jiocloud-ssl-certificate',
  $jiocloud_ssl_cert_package_ensure = 'present',
  $ssl                              = false,
  $port                             = 80,
) {

  include ::ceph::conf
  include ::ceph::radosgw

  ensure_packages($ssl_secrets_package_name, {ensure => $jiocloud_ssl_cert_package_ensure})

  if $manage_ssl_cert {
    include rjil::apache::install_ssl_cert
  }

  ##
  # Validation tests
  ##
  class {'rjil::test::ceph_radosgw':
    ssl  => $ssl,
    port => $port,
  }

  if $ssl {
    rjil::jiocloud::consul::service { 'radosgw':
      tags          => ['real'],
      port          => $port,
      check_command => "/usr/lib/nagios/plugins/check_http -S -H localhost -p $port",
    }
  } else {
    rjil::jiocloud::consul::service { 'radosgw':
      tags          => ['real'],
      port          => $port,
      check_command => "/usr/lib/nagios/plugins/check_http -H localhost -p $port",
    }
  }

}
