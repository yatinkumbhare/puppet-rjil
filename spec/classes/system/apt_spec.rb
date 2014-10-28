require 'spec_helper'

describe 'rjil::system::apt' do

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
    }
  end

  it { should contain_class('apt') }

  it 'should contain all repos' do
    should contain_apt__source('puppetlabs').with(
      'location' => 'http://apt.puppetlabs.com',
      'repos'    => 'main',
      'key'      => '4BD6EC30'
    )
    should contain_apt__source('ceph').with(
      'location' => 'http://ceph.com/debian',
      'repos'    => 'main',
    )

    should contain_apt__source('rustedhalo').with(
      'location' => 'http://jiocloud.rustedhalo.com/ubuntu/',
      'repos'    => 'main',
      'key'      => '85596F7A'
    )
    should contain_apt__source('trusty-updates').with(
      'location' => 'http://in.archive.ubuntu.com/ubuntu',
      'release'  => 'trusty-updates',
      'repos'    => 'main restricted universe multiverse',
    )
    should contain_apt__source('trusty').with(
      'location' => 'http://in.archive.ubuntu.com/ubuntu',
      'repos'    => 'main restricted universe multiverse',
    )

  end

  it 'should not configure a proxy' do
    should contain_file('/etc/apt/apt.conf.d/90proxy').with({
      'ensure' => 'absent'
    })
  end

  describe 'with proxy set' do
    let :params do
      {
        'proxy' => 'http://1.2.3.4:5678/'
      }
    end
    it { should contain_file('/etc/apt/apt.conf.d/90proxy').with({ 'content' => 'Acquire::Http::Proxy "http://1.2.3.4:5678/";' }) }
  end

  ['enable_ubuntu', 'enable_puppetlabs', 'enable_ceph', 'enable_rustedhalo'].each do |x|
    describe "with #{x} set to false" do
      let :params do
        {
          x => false
        }
      end
      it { should_not contain_apt__source(x.gsub(/^enable_/, '').gsub('_', '-')) }
    end
  end

end
