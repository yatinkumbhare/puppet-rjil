Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/","/usr/local/sbin/" ] }

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
  include rjil::system
}

node /etcd/ {
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


node /openstackclient\d*/  {
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

## Setup memcache on mc node
node /mc\d*/ {
  include rjil::memcached
}

node /apache\d*/ {
  ## Configure apache reverse proxy
  include rjil::apache
  apache::vhost { 'nova-api':
    servername      => $::ipaddress_eth1,
    serveradmin     => 'root@localhost',
    port            => 80,
    ssl             => false,
    docroot         => '/var/www',
    error_log_file  => 'test.error.log',
    access_log_file => 'test.access.log',
    logroot         => '/var/log/httpd',
   #proxy_pass => [ { path => '/', url => "http://localhost:${nova_osapi_compute_listen_port}/"  } ],
  }

}
