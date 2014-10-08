class rjil::jiocloud::consul::bootstrapserver(
  $bootstrap_expect = 1,
  $bind_addr        = '0.0.0.0',
) {
  class { 'rjil::jiocloud::consul':
    config_hash => {
      'bind_addr'        => $bind_addr,
      'datacenter'       => "$::env",
      'data_dir'         => '/var/lib/consul',
      'log_level'        => 'INFO',
      'server'           => true,
      'bootstrap_expect' => $bootstrap_expect + 0,
    }
  }
}
