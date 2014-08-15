class rjil::jiocloud::etcd() {
  class { '::etcd':
    addr           => "${::ipaddress}:4001",
    bind_addr      => "0.0.0.0:4001",
    peer_addr      => "${::ipaddress}:7001",
    peer_bind_addr => "0.0.0.0:7001",
  } ->
  package { 'etcdctl': }
}
