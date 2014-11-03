require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::nova::compute' do

  let :facts do
    {
      :operatingsystem  => 'Debian',
      :osfamily         => 'Debian',
      :concat_basedir   => '/tmp',
      :hostname         => 'node1',
    }
  end

  let :params do
    {
      'ceph_mon_key' => 'secret',
      'cinder_rbd_secret_uuid' => 'secret2'
    }
  end

  let :hiera_data do
    {
      'rjil::ceph::mon_config::mon_config'             => 'foo',
      'nova::network::neutron::neutron_admin_password' => 'pw',
      'ceph::conf::fsid'                                     => 'fsid',
    }
  end

  it 'should deploy defaults' do
    should contain_file('/usr/lib/jiocloud/tests/nova-compute.sh').with({
      'source' => 'puppet:///modules/rjil/tests/nova-compute.sh',
    })
    should contain_package('python-six').with_ensure('latest')
    should contain_rjil__service_blocker('stmon')
    [
      'rjil::ceph::mon_config',
      'rjil::nova::zmq_config',
      'nova::client',
      'nova',
      'nova::compute',
      'nova::compute::libvirt',
      'nova::compute::neutron',
      'nova::network::neutron'
    ].each do |x|
      should contain_class(x)
    end

    should contain_ceph__auth('cinder_volume')

    should contain_ceph__conf__clients('cinder_volume')

  end

end
