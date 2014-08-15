class rjil::jiocloud::etcd() {
  class { '::etcd':
    addr           => "${::ipaddress}:4001",
    bind_addr      => "${::ipaddress}:4001",
    peer_addr      => "${::ipaddress}:7001",
    peer_bind_addr => "${::ipaddress}:7001",

  }
}
