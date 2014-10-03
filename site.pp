Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/","/usr/local/sbin/" ] }

node /etcd/ {
  include rjil::base
  include rjil::jiocloud::consul::bootstrapserver
  include rjil::jiocloud::consul::cron

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

node /openstackclient\d*/ {
  include rjil::base
  include rjil::jiocloud::consul::agent
  class { 'openstack_extras::repo::uca':
    release => 'juno'
  }
  class { 'openstack_extras::client':
    ceilometer => false,
  }
}

node /haproxy/ {
  include rjil::base
  include rjil::haproxy
  include rjil::haproxy::openstack
  include rjil::jiocloud::consul::agent
}

## Setup databases on db node
node /^db\d*/ {
  include rjil::base
  include rjil::db
  include rjil::jiocloud::consul::server
}

## Setup memcache on mc node
node /mc\d*/ {
  include rjil::base
  include rjil::memcached
  include rjil::jiocloud::consul::agent
}

## Setup ceph base config on oc, and cp nodes
node /^(oc|cp)\d+/ {
  include rjil::base
  include rjil::ceph
}

## setup ceph configuration and osds on st nodes
node /st\d+/ {
  include rjil::base
  include rjil::ceph
  include rjil::ceph::osd
}

## setup ceph osd and mon configuration on ceph
## Mon nodes.
## Note: This node list can be derived from hiera - rjil::ceph::mon_config

node 'st1','st2','st3' {
  include rjil::base
  include rjil::ceph
  include rjil::ceph::mon
  include rjil::ceph::osd
}

node /apache\d*/ {
  include rjil::base
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
  include rjil::jiocloud::consul::agent
}

##
## Setup contrail nodes
##
node /^ct\d+/ {
  include rjil::base
  include rjil::redis
  include rjil::cassandra
  include rjil::rabbitmq
  include rjil::zookeeper
  include rjil::haproxy
  include rjil::haproxy::contrail
  include rjil::jiocloud::consul::agent
}


##
## oc is openstack controller node which will have all
## openstack controller applications
##

node /^ocdb\d+/ {
  include rjil::base
  include rjil::memcached
  include rjil::db
  include rjil::keystone
  include rjil::glance
  include openstack_extras::keystone_endpoints
  include rjil::keystone::test_user
  include rjil::jiocloud::consul::agent
}
node /^oc\d+/ {
  include rjil::base
  include rjil::memcached
  include rjil::keystone
  include rjil::glance
  include rjil::jiocloud::consul::agent
}

node /^oclb\d+/ {
  include rjil::base
  include rjil::memcached
  include rjil::db
  include rjil::keystone
  include rjil::glance
  include openstack_extras::keystone_endpoints
  include rjil::keystone::test_user
  include rjil::haproxy
  include rjil::haproxy::openstack
  include rjil::jiocloud::consul::agent
}

node /keystonewithdb\d+/ {
  include rjil::base
  include rjil::memcached
  include rjil::db
  include rjil::keystone
  include rjil::jiocloud::consul::agent
}

node /keystone\d+/ {
  include rjil::base
  include rjil::memcached
  include rjil::keystone
  include openstack_extras::keystone_endpoints
  include rjil::keystone::test_user
  include rjil::jiocloud::consul::agent
}
