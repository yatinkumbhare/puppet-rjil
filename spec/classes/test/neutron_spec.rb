require 'spec_helper'

describe 'rjil::test::neutron' do

  let :hiera_data do
    {
      'openstack_extras::auth_file::admin_password' => 'pass'
    }
  end

  context 'with defaults' do
    it do 
      should contain_class('rjil::test::base')
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/neutron-service.sh') \
        .with_source('puppet:///modules/rjil/tests/neutron.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end

    it do
      should contain_file('/usr/lib/jiocloud/tests/floating_ip.sh') \
        .with_source('puppet:///modules/rjil/tests/floating_ip.sh') \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end

end
