#
# Define: rjil::jiocloud::dhcp::pool
#  To
#
define rjil::jiocloud::dhcp::pool (
  $network,
  $mask,
  $range            = undef,
  $gateway          = undef,
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

}
