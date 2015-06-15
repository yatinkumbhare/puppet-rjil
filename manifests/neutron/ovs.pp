#
# Class: rjil::neutron::ovs
#

class rjil::neutron::ovs(
  $ctlplane_network_name       = 'ctlplane',
  $ctlplane_physical_interface = 'eth0',
  $ctlplane_nameservers        = '8.8.8.8',
  $ctlplane_domain             = 'undercloud.local',
  $l3_agent_enabled            = false,
) {

  include ::rjil::neutron

  contain ::neutron::plugins::ovs

  contain ::neutron::agents::ml2::ovs

  neutron_plugin_ovs {
    'OVS/bridge_mappings':   value => "${ctlplane_network_name}:br-${ctlplane_network_name}";
  }

  class { '::neutron::agents::dhcp':
    require => File['/etc/init/neutron-plugin-openvswitch-agent.conf']
  }


  ##
  # Undercloud will not need l3 agent.
  ##
  if $l3_agent_enabled {
    contain ::neutron::agents::l3
  }

  vs_bridge { "br-${ctlplane_network_name}":
    ensure => present,
  } ->
  vs_port { $ctlplane_physical_interface:
    ensure => present,
    bridge => "br-${ctlplane_network_name}",
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

  file { '/etc/init/neutron-plugin-openvswitch-agent.conf':
    source => 'puppet:///modules/rjil/neutron-plugin-openvswitch-agent.conf',
  }

}
