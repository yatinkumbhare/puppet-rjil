require 'spec_helper'

describe 'rjil::test::compute' do
  context "Rjil Compute tests" do
    it do
      should contain_rjil__test('nova-compute.sh')
    end
    
    it do
      should contain_file('/usr/lib/jiocloud/tests/cinder-secret.sh') \
        .with_content(/virsh -q secret-get-value/)
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end
end
