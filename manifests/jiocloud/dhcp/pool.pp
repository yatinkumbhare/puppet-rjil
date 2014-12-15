#
# Define: rjil::jiocloud::dhcp::pool
#  To
#
define rjil::jiocloud::dhcp::pool (
  $network,
  $mask,
  $range            = undef,
  $gateway          = undef,
  $oncommit_script  = undef,
  $onrelease_script = undef,
  $onexpiry_script  = undef,
  $oncommit         = undef,
  $onrelease        = undef,
  $onexpiry         = undef,
) {


  ::dhcp::pool{ $name:                              
    network   => $network,                        
    mask      => $mask,                      
    range     => $range,
    gateway   => $gateway,                        
    oncommit  => $oncommit,
    onrelease => $onrelease,
    onexpiry  => $onexpiry,
  }

  ensure_resource('file','/etc/apparmor.d/local/usr.sbin.dhcpd', {'ensure' => 'present'})

  if $oncommit {
    if ! $oncommit_script {
      fail('oncommit_script Parameter is required if oncommit is set')
    } else {
      ensure_resource('file_line',$oncommit_script, {
          line => "${oncommit_script} rwix,",
          path => '/etc/apparmor.d/local/usr.sbin.dhcpd',
          notify  => Exec['reload-apparmor-dhcpd'],
        })
    }
  }

  if $onrelease {
    if ! $onrelease_script {
      fail('onrelease_script Parameter is required if onrelease is set')
    } else {
      file_line {$onrelease_script:                     
        line => "${onrelease_script} rwix,",            
        path => '/etc/apparmor.d/local/usr.sbin.dhcpd',
        notify  => Exec['reload-apparmor-dhcpd'],            
      }
    }
  }

  if $onexpiry {
    if ! $onexpiry_script {
      fail('onexpiry_script Parameter is required if onexpiry is set')
    } else {
      file_line {$onexpiry_script:                     
        line => "${onexpiry_script} rwix,",            
        path => '/etc/apparmor.d/local/usr.sbin.dhcpd',
        notify  => Exec['reload-apparmor-dhcpd'],            
      }
    }
  }
 
  ensure_resource(exec,'reload-apparmor-dhcpd',{
      command     => '/sbin/apparmor_parser -r -T -W /etc/apparmor.d/usr.sbin.dhcpd',
      refreshonly => true
    })
}
