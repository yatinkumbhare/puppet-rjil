require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::openstack_objects' do

  context 'when identity is not addressable' do
    let :params do
      {
        'identity_address' => 'address',
        'identity_ips'     => ''
      }
    end
    let :hiera_data do
      {
        'keystone::roles::admin::email'          => 'foo@bar',
        'keystone::roles::admin::password'       => 'ChangeMe',
        'keystone::roles::admin::service_tenant' => 'services',
        'rjil::keystone::test_user::password'    => 'password',
        'cinder::keystone::auth::password'       => 'pass',
        'glance::keystone::auth::password'       => 'pass',
        'nova::keystone::auth::password'         => 'pass',
        'neutron::keystone::auth::password'      => 'pass'
      }
    end
    it 'should fail at runtime' do
      should contain_runtime_fail('keystone_endpoint_not_resolvable').with({
        'fail'   => true,
        'before' => ["Class[Openstack_extras::Keystone_endpoints]", "Class[Rjil::Keystone::Test_user]", "Class[Rjil::Tempest::Provision]"]
      })
      should contain_class('openstack_extras::keystone_endpoints')
      should contain_class('rjil::keystone::test_user')
      should contain_class('rjil::keystone::test_user')
    end
  end

end
