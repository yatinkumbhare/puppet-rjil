require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::glance' do
  let(:facts) { {:operatingsystem => 'Debian', :osfamily => 'Debian'}}
  let :hiera_data do
    {
      'glance::api::registry_host'       => '10.1.1.100',
      'glance::api::auth_host'           => '10.1.1.10',
      'glance::api::keystone_password'   => 'pass',
      'glance::registry::keystone_password'   => 'pass',
      'glance::registry::auth_host'           => '10.1.1.10',
      'glance::api::mysql_module'        => '2.3',
      'rjil::glance::backend' => 'file',
      'glance::backend::swift::swift_store_user' => 'swiftuser',
      'glance::backend::swift::swift_store_key' => 'swiftuser_key',
      'openstack_extras::auth_file::admin_password' => 'pw',
    }
  end

  context 'http with File backend' do
    it 'should contain http with file backend' do
      should contain_file('/usr/lib/jiocloud/tests/glance-api.sh')
      should contain_file('/usr/lib/jiocloud/tests/glance-registry.sh')
      should contain_class('glance::api').with({
        'registry_host'     => '10.1.1.100',
        'registry_port'     => '9191',
        'auth_host'         => '10.1.1.10',
        'keystone_password' => 'pass',
      })
      should contain_class('glance::registry').with({
        'auth_host'         => '10.1.1.10',
        'keystone_password' => 'pass',
      })
      should contain_class('glance::backend::file')
    end
  end

  context 'http with swift backend' do
    let :params do {
        'backend' => 'swift'
    } end
    it 'should contain swift backend' do
      should contain_class('glance::backend::swift')
    end
  end

   context 'http with cinder backend' do
    let :params do {
        'backend' => 'cinder'
    } end
    it 'should contain swift backend' do
      should contain_class('glance::backend::cinder')
    end
  end
end
