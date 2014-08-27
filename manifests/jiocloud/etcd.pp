class rjil::jiocloud::etcd(
  $discovery = false,
  $discovery_token = '',
  $discovery_endpoint = '',
 ) {
  class { '::etcd':
    addr               => "${::ipaddress}:4001",
    bind_addr          => "0.0.0.0:4001",
    peer_addr          => "${::ipaddress}:7001",
    peer_bind_addr     => "0.0.0.0:7001",
    discovery          => $discovery,
    discovery_token    => $discovery_token,
    discovery_endpoint => $discovery_endpoint,
  } ->
  package { 'etcdctl':
    require => Exec['apt_update']
  }
}
