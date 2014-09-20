require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::rabbitmq' do

  let :hiera_data do
    {
      'rabbitmq::manage_repos' => false,
      'rabbitmq::admin_enable' => false,
    }
  end

  let :facts do
    {
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :lsbdistid       => 'ubuntu',
    }
  end

  context 'with defaults' do
    it do
      should contain_file('/usr/lib/jiocloud/tests/check_rabbitmq.sh')
      should contain_class('rabbitmq').with({
        'manage_repos' => false,
        'admin_enable' => false
      })
    end
  end

end
