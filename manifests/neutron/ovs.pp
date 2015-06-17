#
# Class: rjil::neutron::ovs
#

class rjil::neutron::ovs(
  $gateway,
  $br_address            = undef,
  $br_netmask            = undef,
  $br_network            = undef,
  $br_name               = 'br-ctlplane',
  $br_physical_interface = 'eth0',
  $nameservers           = undef,
  $domain                = 'openstack.local',
  $l3_agent_enabled      = false,
  $swap_macs             = false,
) {

  $br_name_for_facter = regsubst($br_name,'-','_','G')

  if ! $br_address {
    $ipaddr_phy_iface = inline_template("<%= scope.lookupvar('ipaddress_' + @br_physical_interface) %>")
    $ipaddr_br_iface  = inline_template("<%= scope.lookupvar('ipaddress_' + @br_name_for_facter) %>")

    if $ipaddr_br_iface {
      $br_address_orig = $ipaddr_br_iface
    } elsif $ipaddr_phy_iface {
      $br_address_orig = $ipaddr_phy_iface
    }
  } else {
    $br_address_orig = $br_address
  }

  if ! $br_netmask {
    $netmask_phy_iface = inline_template("<%= scope.lookupvar('netmask_' + @br_physical_interface) %>")
    $netmask_br_iface  = inline_template("<%= scope.lookupvar('netmask_' + @br_name_for_facter) %>")

    if $netmask_br_iface {
      $br_netmask_orig = $netmask_br_iface
    } elsif $netmask_phy_iface {
      $br_netmask_orig = $netmask_phy_iface
    }
  } else {
    $br_netmask_orig = $br_netmask
  }


  if ! $br_network {
    $network_phy_iface = inline_template("<%= scope.lookupvar('network_' + @br_physical_interface) %>")
    $network_br_iface  = inline_template("<%= scope.lookupvar('network_' + @br_name_for_facter) %>")

    if $network_br_iface {
      $br_network_orig = $network_br_iface
    } elsif $network_phy_iface {
      $br_network_orig = $network_phy_iface
    }
  } else {
    $br_network_orig = $br_network
  }

  contain ::rjil::neutron

  contain ::neutron::plugins::ml2

  contain ::neutron::agents::ml2::ovs

  contain ::neutron::agents::dhcp

  ##
  # Undercloud will not need l3 agent.
  ##
  if $l3_agent_enabled {
    contain ::neutron::agents::l3
  }

  ##
  # gate/virtual environments may need to swap the mac address between
  # physical and the bridge interface, as neutron will not allow to send packets
  # to different mac address.
  ##
  if $swap_macs {
    if inline_template("<%= scope.lookupvar('ipaddress_' + @br_physical_interface) %>") {
      $br_mac = inline_template("<%= scope.lookupvar('macaddress_' + @br_physical_interface) %>")
      $physical_mac = inline_template("<%= scope.lookupvar('macaddress_' + @br_name_for_facter) %>")
    } elsif inline_template("<%= scope.lookupvar('ipaddress_' + @br_name_for_facter) %>") {
      $br_mac = inline_template("<%= scope.lookupvar('macaddress_' + @br_name_for_facter) %>")
      $physical_mac = inline_template("<%= scope.lookupvar('macaddress_' + @br_physical_interface) %>")
    }
  }

  file { '/etc/network/interfaces.new':
    content => template('rjil/undercloud_etc_network_interfaces.erb'),
    notify => Exec['network-down']
    require   => [ Vs_bridge[$br_name],
                     Vs_port[$br_physical_interface],
                   ],
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

}
