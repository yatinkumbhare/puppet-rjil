class rjil::test::glance(
  $api_address  = '127.0.0.1',
  $registry_address = '127.0.0.1',
) {

  include openstack_extras::auth_file

  include rjil::test::base

  file { "/usr/lib/jiocloud/tests/glance-api.sh":
    source => "puppet:///modules/rjil/tests/glance-api.sh",
    owner  => 'root',
    group  => 'root',
    mode   => '755',
  }

  file { "/usr/lib/jiocloud/tests/glance-registry.sh":
    source => "puppet:///modules/rjil/tests/glance-registry.sh",
    owner  => 'root',
    group  => 'root',
    mode   => '755',
  }

}
