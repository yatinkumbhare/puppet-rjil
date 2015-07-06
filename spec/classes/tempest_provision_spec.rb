require 'spec_helper'

describe 'rjil::tempest::provision' do

  let :facts do
    {
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :lsbdistid       => 'ubuntu',
    }
  end

  context 'with defaults' do
    it do
      should contain_file('/etc/neutron').with_ensure('directory')

      should contain_file('/etc/neutron/neutron.conf') \
        .with_ensure('file') \
        .that_requires('File[/etc/neutron]')

      {
        'keystone_authtoken/auth_host'         => 'identity.jiocloud.com',
        'keystone_authtoken/auth_port'         => 5000,
        'keystone_authtoken/auth_protocol'     => 'https',
        'keystone_authtoken/admin_tenant_name' => 'services',
        'keystone_authtoken/admin_user'        => 'neutron',
        'keystone_authtoken/admin_password'    => 'neutron'
      }.each do | k, v|
        should contain_neutron_config(k).with_value(v)
      end
      
      should contain_class('tempest::provision')
    end
  end

  context 'with configure_neutron false' do
    let :params do
      {
        :configure_neutron => false,
      }
    end

    it do
      should_not contain_file('/etc/neutron')

      should_not contain_file('/etc/neutron/neutron.conf')

      should_not contain_neutron_config
    end
  end  

end
