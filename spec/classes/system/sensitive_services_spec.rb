require 'spec_helper'

describe 'rjil::system::sensitive_services' do

  context 'with defaults' do

    it 'should have default objects' do
      should contain_file('/usr/sbin/policy-rc.d').with({
        'tag'    => 'package',
        'source' => 'puppet:///modules/rjil/package_start_policy.sh'
      })
      should contain_file('/etc/sensitive_services').with({
        'content' => "# managed by puppet\n# a list of services that should not be started\n# from package based actions. This file is called\n# from policy-rc.d\nzookeeper\ncassandra\ncontrail-api\ncontrail-schema\n",
        'replace' => false,
      })
      ['zookeeper', 'cassandra', 'contrail-api', 'contrail-schema'].each do |x|
        should contain_file_line("sensitive_service_#{x}").with({
          'ensure' => 'absent',
          'path'   => '/etc/sensitive_services',
          'line'   => x,
        })
      end
    end
  end
end
