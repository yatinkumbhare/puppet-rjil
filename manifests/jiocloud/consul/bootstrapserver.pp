class rjil::jiocloud::consul::bootstrapserver(
  $bootstrap_expect = 1
) {
  class { 'rjil::jiocloud::consul':
    config_hash => {
      'datacenter'       => "$::env",
      'data_dir'         => '/var/lib/consul',
      'log_level'        => 'INFO',
      'server'           => true,
      'bootstrap_expect' => $bootstrap_expect + 0,
    }
  }
}
