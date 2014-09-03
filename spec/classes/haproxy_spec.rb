require 'spec_helper'

describe 'rjil::haproxy' do

  let :facts do
    {
      :osfamily       => 'Debian',
      :concat_basedir => '/tmp'
    }
  end


  it 'should install haproxy' do

    should contain_rjil__test('haproxy.sh')

  end

end
