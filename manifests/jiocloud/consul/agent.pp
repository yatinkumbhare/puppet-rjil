class rjil::jiocloud::consul::agent {
  if ($::consul_discovery_token) {
    $join_address = "${::consul_discovery_token}.service.consuldiscovery.linux2go.dk"
  } else {
    $join_address = ''
  }

  class { 'rjil::jiocloud::consul':
    config_hash => {
      'start_join'       => [$join_address],
      'datacenter'       => "$::env",
      'data_dir'         => '/var/lib/consul',
      'log_level'        => 'INFO',
      'server'           => false,
    }
  }
}
