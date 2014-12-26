## Class: jiocloud::openstack::apache
class rjil::apache (
  $ssl                              = false,
  $ssl_secrets_package_name         = 'jiocloud-ssl-certificate',
  $jiocloud_ssl_cert_package_ensure = 'present',
  $manage_ssl_cert                  = false,
) {

  include ::apache
  include apache::mod::rewrite
  include apache::mod::proxy
  include apache::mod::proxy_http
  include ::apache::mod::headers
  ::apache::mod { 'proxy_wstunnel': }
  if $ssl {
    Package[$ssl_secrets_package_name] -> Class['::apache']

    ensure_packages($ssl_secrets_package_name, {ensure => $jiocloud_ssl_cert_package_ensure})

    include apache::mod::ssl

    if $manage_ssl_cert {
      include rjil::apache::install_ssl_cert
    }
  }

}
