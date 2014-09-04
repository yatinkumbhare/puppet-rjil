## Class: jiocloud::openstack::apache
class rjil::apache (
  $ssl_enabled = false,
  $ssl_cert_file = '/etc/apache2/certs/jiocloud.com.crt',
  $ssl_key_file = '/etc/apache2/certs/jiocloud.com.key',
  $ssl_ca_file = '/etc/apache2/certs/gd_bundle-g2-g1.crt',
  $ssl_secrets_packge_name = 'jiocloud-ssl-certificate',
) {

  if $ssl_enabled {
    class {'::apache':
      server_signature => 'Off',
      default_ssl_chain => $ssl_ca_file,
      default_ssl_cert => $ssl_cert_file,
      default_ssl_key => $ssl_key_file,
      default_vhost => false,
      apache_version => '2.4',
      require => Package[$ssl_secrets_packge_name],
    }
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::proxy
    include apache::mod::proxy_http
    ## this is required to proxy novncproxy
    ::apache::mod { 'proxy_wstunnel': }
    package { 'jiocloud-ssl-certificate':
      ensure => $jiocloud_ssl_cert_package_version,
    }
  } else {
    class {'::apache':
      server_signature => 'Off',
      default_vhost => false,
      mod_dir => '/etc/apache2/mods',
    }
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::proxy
    include apache::mod::proxy_http
  }

}
