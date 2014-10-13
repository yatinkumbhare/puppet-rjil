require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::system::ntp' do
  let(:facts) { {:operatingsystem => 'Debian', :osfamily => 'Debian'}}
  let :hiera_data do
    {
      'ntp::servers' => ['pool.ntp.org']
    }
  end

  context 'ntp server without udlc' do
    it 'should contain ntp server without udlc' do
      should contain_file('/usr/lib/jiocloud/tests/ntp.sh')
      should contain_class('ntp').with({
        'servers'  => 'pool.ntp.org',
        'udlc'     => false,
      })
    end
  end
  context 'ntp server with udlc' do
    let :params do
    { 'udlc' => true }
      it 'should contain ntp server with udlc' do
        should contain_class('ntp').with({
          'servers'  => 'pool.ntp.org',
          'udlc'     => true,
        })
      end
    end
  end
  context 'when configured as a server' do
    let :params do
      {'server' => true}
    end
    it { should contain_rjil__jiocloud__consul__service('ntp').with({
      'port'          => 123,
      'check_command' => '/usr/lib/jiocloud/tests/ntp.sh',
    })}
  end
end
