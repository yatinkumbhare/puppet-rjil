#
# Class rjil::ceph::radosgw
# Purpose: Configure ceph radosgw
#
# == Parameters
#

class rjil::ceph::radosgw (
  $self_signed_cert                 = false,
  $ssl_secrets_package_name         = 'jiocloud-ssl-certificate',
  $jiocloud_ssl_cert_package_ensure = 'present',
) {

  include ::ceph::conf
  include ::ceph::radosgw

  ensure_packages($ssl_secrets_package_name, {ensure => $jiocloud_ssl_cert_package_ensure})

  if $self_signed_cert {
    Package[$ssl_secrets_package_name] ->
    Class['rjil::apache::trust_selfsigned_cert']

    include rjil::apache::trust_selfsigned_cert
  }

  ##
  # Validation tests
  ##
  include rjil::test::ceph_radosgw

  rjil::jiocloud::consul::service { 'radosgw':
    tags          => ['real'],
    port          => 80,
    check_command => '/usr/lib/nagios/plugins/check_http -H localhost',
  }

}
