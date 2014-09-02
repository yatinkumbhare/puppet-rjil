node base {
  # install users
  include rjil
  include rjil::jiocloud
  include rjil::jiocloud::sources
  include rjil::server
  realize (
    Rjil::Localuser['jenkins'],
    Rjil::Localuser['soren'],
  )
}

node /etcd/ inherits base {
  if $::etcd_discovery_token {
    $discovery = true
  } else {
    $discovery = false
  }
  class { 'rjil::jiocloud::etcd':
    discovery       => $discovery,
    discovery_token => $::etcd_discovery_token
  }
}

node /apache/ inherits base {
  class { 'apache': }
}

node /openstackclient/ inherits base {
  class { 'openstack_extras::repo::uca':
    release => 'juno'
  }
  class { 'openstack_extras::client':
    ceilometer => false,
  }
}

node /haproxy/ {

  include rjil::haproxy
  class { 'rjil::haproxy::openstack' :
    keystone_ips => '10.0.0.1',
  }

}

## Setup databases on db node
node /db\d*/ {
  include rjil::db
}
