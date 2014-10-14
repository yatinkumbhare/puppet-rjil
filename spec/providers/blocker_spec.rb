require 'spec_helper'
require 'puppet/provider/blocker'
blocker = Puppet::Provider::Blocker

describe blocker do

  instance = blocker.new

  describe 'block_until_ready'
  it 'should only run once when tried is one by default' do
    count = 0
    instance.block_until_ready(1, 1) do
      count = count + 1
      false
    end
    count.should == 1
  end

  it 'should retry and sleep' do
    count = 0
    instance.expects(:sleep).with(2).twice
    result = instance.block_until_ready(2, 2) do
      count = count + 1
      false
    end
    result.should == false
    count.should == 2
  end

  it 'should retry until passing' do
    count = 0
    instance.expects(:sleep).with(3).twice
    result = instance.block_until_ready(10, 3) do
      count = count + 1
      count > 2
    end
    result.should == true
    count.should == 3
  end

end
