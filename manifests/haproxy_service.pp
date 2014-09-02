define rjil::haproxy_service(
  $vip = '0.0.0.0',
  $balancer_ports = [],
  $cluster_addresses = [],
  $listen_options   =  {
    'option'  => 'tcpka',
    'option'  => 'abortonclose',
    'balance' => 'roundrobin',
  },
  $listen_mode      = 'tcp',
  $balancer_options = 'check inter 10s rise 2 fall 3',
  $balancer_cookie  = undef,
  $bind_options     = undef,
) {

  if $cluster_addresses != [] {

    haproxy::listen { $name:
      ipaddress        => $vip,
      ports            => $balancer_ports,
      mode             => $listen_mode,
      collect_exported => false,
      options          => $listen_options,
      bind_options     => $bind_options
    }

    haproxy::balancermember { $name:
      listening_service => $name,
      ports             => $balancer_ports,
      server_names      => $cluster_addresses,
      ipaddresses       => $cluster_addresses,
      options           => $balancer_options,
      define_cookies    => $balancer_cookie
    }
  }
}
