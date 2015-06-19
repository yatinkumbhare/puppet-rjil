#
# Class: rjil::nova::compute
#
# == Description: Setup nova compute
#
# == Parameters
#
# [*rbd_enabled*]
#   whether rbd is enabled or not, if rbd is enabled, ceph specific
#   configurations would be added.
#
# [*consul_check_interval*]
#   Consul service health check interval
#
# [*private_interface*]
#   Private interface on which compute listen for vncserver
#
# [*compute_driver*]
#   Which compute driver to be used, example: libvirt, ironic. Default: libvirt.
#

class rjil::nova::compute (
  $rbd_enabled           = true,
  $consul_check_interval = '120s',
  $private_address       = $::ipaddress,
  $compute_driver        = 'libvirt',
) {

  #
  # Add tests for nova compute
  ##

  include rjil::test::compute

  ensure_resource('package','python-six', { ensure => 'latest' })

  include rjil::nova::zmq_config
  include ::nova::client
  include ::nova
  include ::nova::compute
  include ::nova::network::neutron

  ##
  # call compute driver specific classes
  ##
  include "::nova::compute::${compute_driver}"

  ##
  # ironic doesnt need vif specific configurations.
  ##
  if $compute_driver != 'ironic' {
    include ::nova::compute::neutron
  }

  ##
  # if rbd is enabled, configure ceph
  ##
  if $rbd_enabled {
    include ::rjil::nova::compute::rbd
  }

  rjil::jiocloud::logrotate { 'nova-compute':
    logdir => '/var/log/nova/'
  }

  include rjil::nova::logrotate::manage

  ##
  # Remove libvirt default nated network
  ##
  exec { 'rm_virbr0':
    command => 'virsh net-destroy default && virsh net-undefine default',
    path    => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    onlyif  => 'virsh -q net-list | grep -q default' ,
  }

  rjil::jiocloud::consul::service {'nova-compute':
    port          => 0,
    check_command => "sudo nova-manage service list | grep 'nova-compute.*${::hostname}.*enabled.*:-)'",
    interval      => $consul_check_interval,
  }

  ensure_resource(package, 'ethtool')

  Package <| name == 'ethtool' |> ->
  file { '/etc/init/disable-gro.conf':
    source => 'puppet:///modules/rjil/disable-gro.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  } ~>
  exec { 'disable-gro':
    command     => 'true ; cd /sys/class/net ; for x in *; do ethtool -K $x gro off || true; done',
    path        => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    refreshonly => true
  }
}
