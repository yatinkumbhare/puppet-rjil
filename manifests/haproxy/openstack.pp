class rjil::haproxy::openstack(
  $horizon_ips           = [],
  $keystone_ips          = [],
  $keystone_internal_ips = [],
  $glance_ips            = [],
  $cinder_ips            = [],
  $nova_ips              = [],
) {

  class { 'rjil::test::haproxy_openstack':
    horizon_ips           => $horizon_ips,
    keystone_ips          => $keystone_ips,
    keystone_internal_ips => $keystone_internal_ips,
    glance_ips            => $glance_ips,
    cinder_ips            => $cinder_ips,
    nova_ips              => $nova_ips,
  }

  rjil::haproxy_service { 'horizon':
    balancer_ports    => '80',
    cluster_addresses => $horizon_ips,
    listen_options   =>  {
      'tcpka'        => '',
      'abortonclose' => '',
      'balance'      => 'source',
    },
  }

  rjil::haproxy_service { 'horizon-https':
    balancer_ports    => '443',
    cluster_addresses => $horizon_ips,
  }

  rjil::haproxy_service { 'novncproxy':
    balancer_ports    => '6080',
    cluster_addresses => $nova_ips,
  }

  rjil::haproxy_service { 'keystone':
    balancer_ports    => '5000',
    cluster_addresses => $keystone_ips,
  }

  rjil::haproxy_service { 'keystone-admin':
    balancer_ports    => '35357',
    cluster_addresses => $keystone_internal_ips,
  }

  rjil::haproxy_service { 'glance':
    balancer_ports    => '9292',
    cluster_addresses => $glance_ips,
  }

  rjil::haproxy_service { 'glance-registry':
    balancer_ports    => '9191',
    cluster_addresses => $glance_ips,
  }

  rjil::haproxy_service { 'cinder':
    balancer_ports    => '8776',
    cluster_addresses => $cinder_ips,
  }

  rjil::haproxy_service { 'nova':
    balancer_ports    => '8774',
    cluster_addresses => $nova_ips,
  }

  rjil::haproxy_service { 'metadata':
    balancer_ports    => '8775',
    cluster_addresses => $nova_ips,
    listen_options   =>  {
      'tcpka'        => '',
      'abortonclose' => '',
      'balance'      => 'roundrobin',
      'option'       => 'ssl-hello-chk',
    },
  }

  rjil::haproxy_service { 'nova-ec2':
    balancer_ports    => '8773',
    cluster_addresses => $nova_ips,
  }

}
