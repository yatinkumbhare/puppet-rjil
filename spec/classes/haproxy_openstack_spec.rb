require 'spec_helper'

describe 'rjil::haproxy::openstack' do

  let :hiera_data do
    {
      'openstack_extras::auth_file::admin_password' => 'pass'
    }
  end


  let :service_list do
    {
      'horizon' => '80',
      'horizon-https' => '443',
      'novncproxy' => '6080',
      'keystone' => '5000',
      'keystone-admin' => '35357',
      'glance' => '9292',
      'glance-registry' => '9191',
      'cinder' => '8776',
      'nova' => '8774',
      'metadata' => '8775',
      'nova-ec2' => '8773',
    }
  end

  describe 'with default parameters' do

    it 'should build default load balancing rules' do
      service_list.each do |name, port|
        should contain_rjil__haproxy_service(name).with(
          {
            'balancer_ports'    => port,
            'cluster_addresses' => [],
          }
        )
      end

      should contain_rjil__haproxy_service('horizon').with_listen_options(
        {
          'tcpka'        => '',
          'abortonclose' => '',
          'balance'      => 'source',
        }
      )
      should contain_rjil__haproxy_service('metadata').with_listen_options(
        {
          'tcpka'        => '',
          'abortonclose' => '',
          'balance'      => 'roundrobin',
          'option'       => 'ssl-hello-chk',
        }
      )

    end

  end

end
