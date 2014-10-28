class rjil::jiocloud::undercloud(
  $nova_db_password,
  $nova_rabbit_password,
  $nova_keystone_password,

  $glance_db_password,
  $glance_rabbit_password,
  $glance_keystone_password,

  $ironic_db_password,
  $ironic_rabbit_password,
  $ironic_keystone_password,

  $neutron_db_password,
  $neutron_rabbit_password,
  $neutron_keystone_password,

  $keystone_db_password,
  $keystone_admin_token,
  $keystone_admin_password,

  $mysql_root_password,

  $ctlplane_physical_interface = 'eth0',
  $ctlplane_address,
  $ctlplane_netmask,
  $ctlplane_network,
  $ctlplane_broadcast,
  $ctlplane_gateway,
  $ctlplane_nameservers,
  $ctlplane_domain,
  $ctlplane_cidr,
  $ctlplane_dhcp_start,
  $ctlplane_dhcp_end,

  $keystone_service_tenant     = 'services',

  $nova_rabbit_user            = 'nova',
  $nova_keystone_user          = 'nova',
  $nova_db_user                = 'nova',
  $nova_db_name                = 'nova',

  $glance_rabbit_user          = 'glance',
  $glance_keystone_user        = 'glance',
  $glance_db_user              = 'glance',
  $glance_db_name              = 'glance',

  $ironic_rabbit_user          = 'ironic',
  $ironic_keystone_user        = 'ironic',
  $ironic_db_user              = 'ironic',
  $ironic_db_name              = 'ironic',

  $neutron_rabbit_user         = 'neutron',
  $neutron_keystone_user       = 'neutron',
  $neutron_db_user             = 'neutron',
  $neutron_db_name             = 'neutron',

  $keystone_db_user            = 'keystone',
  $keystone_db_name            = 'keystone',

  $admin_email                 = 'admin@jiocloud.com',
  $region_name                 = 'R1',
  $verbose                     = false,
  $debug                       = false,
) {

  # Various infrastructure
  class { '::mysql::server':
    root_password    => $mysql_root_password,
    override_options => {
      'mysqld' => { 'bind-address' => '0.0.0.0',
                    'max_connections' => 500 }
    }
  }

  class { '::rabbitmq': }


  # OpenStack components
  class { '::nova':
    verbose            => $verbose,
    debug              => $debug,
    sql_connection     => "mysql://${nova_db_user}:${nova_db_password}@${::ipaddress}/${nova_db_name}?charset=utf8",
    rabbit_userid      => $nova_rabbit_user,
    rabbit_password    => $nova_rabbit_password,
    image_service      => 'nova.image.glance.GlanceImageService',
    glance_api_servers => "${::ipaddress}:9292",
    rabbit_host        => $::ipaddress,
    mysql_module       => 2.2,
  }

  class { '::nova::compute':
    enabled => true,
  }

  class { '::nova::conductor':
    enabled => true,
  }

  class { '::nova::scheduler':
    enabled => true,
  }

  class { '::nova::api':
    enabled        => true,
    admin_password => $nova_keystone_password,
  }

  class { '::nova::compute::ironic':
    keystone_user     => $ironic_keystone_user,
    keystone_tenant   => $keystone_service_tenant,
    keystone_password => $ironic_keystone_password,
    keystone_url      => "http://${::ipaddress}:35357/v2.0/",
  }

  class { '::nova::network::neutron':
    neutron_admin_password    => $neutron_keystone_password,
    neutron_url               => "http://${::ipaddress}:9696/",
    neutron_admin_tenant_name => $keystone_service_tenant,
    neutron_admin_auth_url    => "http://${::ipaddress}:35357/v2.0",
    neutron_region_name       => $region_name,
  }

  class { '::glance': }

  class { '::glance::api':
    verbose           => $verbose,
    debug             => $debug,
    keystone_tenant   => $keystone_service_tenant,
    keystone_user     => $glance_keystone_user,
    keystone_password => $glance_keystone_password,
    sql_connection    => "mysql://${glance_db_user}:${glance_db_password}@${::ipaddress}/${glance_db_name}",
    mysql_module      => 2.2,
  }

  class { '::glance::registry':
    verbose           => $verbose,
    debug             => $debug,
    keystone_tenant   => $keystone_service_tenant,
    keystone_user     => $glance_keystone_user,
    keystone_password => $glance_keystone_password,
    sql_connection    => "mysql://${glance_db_user}:${glance_db_password}@${::ipaddress}/${glance_db_name}",
    mysql_module      => 2.2,
  }

  class { '::glance::backend::file': }

  class { '::ironic':
    verbose             => $verbose,
    debug               => $debug,
    database_connection => "mysql://${ironic_db_user}:${ironic_db_password}@${::ipaddress}/${ironic_db_name}",
    rabbit_user         => $ironic_rabbit_user,
    rabbit_password     => $ironic_rabbit_password,
    rabbit_virtual_host => '/',
    rabbit_hosts        => ["${::ipaddress}:5672"],
#   neutron_url         => "http://${::ipaddress}:9696/",
    glance_api_servers  => "${::ipaddress}:9292",
    glance_api_insecure => true,
#    mysql_module        => 2.2,
  }

  class { '::ironic::api':
    admin_password => $ironic_keystone_password,
  }

  class { '::ironic::conductor': }

  class { '::ironic::drivers::ipmi': }

  class { '::neutron':
    enabled         => true,
    bind_host       => $::ipaddress,
    rabbit_host     => $::ipaddress,
    rabbit_user     => $neutron_rabbit_user,
    rabbit_password => $neutron_rabbit_password,
    verbose         => $verbose,
    debug           => $debug,
  }

  class { '::neutron::server':
    auth_host           => $::ipaddress,
    auth_password       => $neutron_keystone_password,
    database_connection => "mysql://${neutron_db_user}:${neutron_db_password}@${::ipaddress}/${neutron_db_name}?charset=utf8",
    mysql_module        => 2.2,
    require             => File['/etc/default/neutron-server']
  }

  class { '::neutron::agents::ovs':
    local_ip         => $::ipaddress,
    enable_tunneling => true,
  }

  class { '::neutron::plugins::ovs':
    tenant_network_type => 'vlan',
    network_vlan_ranges => 'ctlplane',
  }

  neutron_plugin_ovs {
    'OVS/bridge_mappings':   value => 'ctlplane:br-ctlplane';
  }

  class { '::neutron::agents::dhcp':
    require => File['/etc/init/neutron-plugin-openvswitch-agent.conf']
  }

  class { '::neutron::agents::l3': } # Is this needed at all? I don't think so. - Soren

  class { '::keystone':
    verbose        => $verbose,
    debug          => $debug,
    catalog_type   => 'sql',
    admin_token    => $keystone_admin_token,
    sql_connection => "mysql://${keystone_db_user}:${keystone_db_password}@${::ipaddress}/${keystone_db_name}",
    mysql_module   => 2.2,
  }

  class { '::keystone::endpoint':
    public_url       => "http://${::ipaddress}:5000/",
    admin_url        => "http://${::ipaddress}:35357/",
    internal_url     => "http://${::ipaddress}:5000/",
    region           => $region_name,
  }

  # Databases
  class { '::nova::db::mysql':
    password      => $nova_db_password,
    host          => $::ipaddress,
    allowed_hosts => '%',
    mysql_module  => 2.2,
  }

  class { '::glance::db::mysql':
    password      => $glance_db_password,
    host          => $::ipaddress,
    allowed_hosts => '%',
    mysql_module  => 2.2,
  }

  class { '::ironic::db::mysql':
    dbname        => $ironic_db_name,
    user          => $ironic_db_user,
    password      => $ironic_db_password,
    host          => $::ipaddress,
    allowed_hosts => '%',
    charset       => 'utf8',
  }

  class { '::neutron::db::mysql':
    password      => $neutron_db_password,
    host          => $::ipaddress,
    allowed_hosts => '%',
    mysql_module  => 2.2,
  }

  class { '::keystone::db::mysql':
    password      => $keystone_db_password,
    allowed_hosts => '%',
    mysql_module  => 2.2,
  }

  # Keystone service users
  class { '::nova::keystone::auth':
    password         => $nova_keystone_password,
    email            => $admin_email,
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => $region_name,
  }

  class { '::glance::keystone::auth':
    password         => $glance_keystone_password,
    email            => $admin_email,
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => $region_name,
  }

  class { '::ironic::keystone::auth':
    password         => $ironic_keystone_password,
    email            => $admin_email,
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => $region_name,
  }

  class { '::neutron::keystone::auth':
    password         => $neutron_keystone_password,
    email            => $admin_email,
    public_address   => $::ipaddress,
    admin_address    => $::ipaddress,
    internal_address => $::ipaddress,
    region           => $region_name,
  }

  # Misc. OpenStack resources
  class { '::keystone::roles::admin':
    email        => $admin_email,
    password     => $keystone_admin_password,
  }

  # Rabbit users
  rabbitmq_user { $nova_rabbit_user:
    password => $nova_rabbit_password,
  }

  rabbitmq_user { $ironic_rabbit_user:
    password => $ironic_rabbit_password,
  }

  rabbitmq_user { $neutron_rabbit_user:
    password => $neutron_rabbit_password,
  }

  # Rabbit permissions
  rabbitmq_user_permissions { 'nova@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user_permissions { 'neutron@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user_permissions { 'ironic@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  vs_bridge { 'br-ctlplane':
    ensure => present,
  } ->
  vs_port { $ctlplane_physical_interface:
    ensure => present,
    bridge => 'br-ctlplane',
  } ->
  file { '/etc/network/interfaces.new':
    content => template('rjil/undercloud_etc_network_interfaces.tmpl'),
    notify => Exec['network-down']
  } ~>
  exec { 'network-down':
    command     => '/sbin/ifdown -a',
    refreshonly => true,
  } ->
  file { '/etc/network/interfaces':
    source => '/etc/network/interfaces.new'
  } ~>
  exec { 'network-up':
    command     => '/sbin/ifup -a',
    refreshonly => true,
  }

  neutron_network { 'ctlplane':
    tenant_name               => 'openstack',
    provider_network_type     => 'flat',
    provider_physical_network => 'ctlplane'
  }

  neutron_subnet { 'ctlplane':
    cidr             => $ctlplane_cidr,
    ip_version       => '4',
    allocation_pools => ["start=${ctlplane_dhcp_start},end=${ctlplane_dhcp_end}"],
    gateway_ip       => $ctlplane_gateway,
    enable_dhcp      => true,
    host_routes      => ["destination=169.254.169.254/32,nexthop=${::ipaddress}"],
    network_name     => 'ctlplane',
    tenant_name      => 'openstack',
  }

  file { '/etc/init/neutron-plugin-openvswitch-agent.conf':
    source => 'puppet:///modules/rjil/neutron-plugin-openvswitch-agent.conf',
  }

  file { '/etc/init/nova-compute.conf':
    source => 'puppet:///modules/rjil/nova-compute.conf',
    notify => Service['nova-compute']
  }

  file { '/etc/default/neutron-server':
    source => 'puppet:///modules/rjil/neutron-server.defaults',
  }

  file { '/tftpboot':
    ensure => 'directory',
    owner  => 'ironic',
    group  => 'ironic',
  } ->
  file { '/tftpboot/pxelinx.cfg':
    ensure => 'directory',
    owner  => 'ironic',
    group  => 'ironic',
  } ->
  file { '/tftpboot/pxelinux.0':
    owner   => 'ironic',
    group   => 'ironic',
    source  => '/usr/lib/syslinux/pxelinux.0',
    require => Package['syslinux']
  } ->
  file { '/tftpboot/map-file':
    owner  => 'ironic',
    group  => 'ironic',
    source => 'puppet:///modules/rjil/tftpd.map-file',
  }


  package { 'ipmitool':
    ensure => 'present'
  }

  package { 'syslinux':
    ensure => 'present'
  }

  package { 'tftpd-hpa':
    ensure => 'present'
  } ->
  file { '/etc/default/tftpd-hpa':
    source => 'puppet:///modules/rjil/tftpd-hpa.default'
  }
  
}
