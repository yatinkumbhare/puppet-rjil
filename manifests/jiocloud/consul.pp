# Class: rjil::jiocloud::consul
#
class rjil::jiocloud::consul($config_hash) {
  include dnsmasq

  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }

  class { '::consul':
    install_method    => 'package',
    ui_package_name   => 'consul-web-ui',
    ui_package_ensure => 'absent',
    bin_dir           => '/usr/bin',
    config_hash       => $config_hash,
    purge_config_dir  => true,
  }
  exec { "reload-consul":
    command     => "/usr/bin/consul reload",
    refreshonly => true,
    subscribe   => Service['consul'],
  }
  File['/etc/consul'] ~> Exec['reload-consul']

##
# Adding log folder for using with checks as required
# Cannot use the respective service directory as consul user cannot
# write to them
##

  file { '/var/log/consul':
    ensure => directory,
    owner  => 'consul',
    require => [ User['consul'] ],
  }

}
