#
# Class: rjil::test::cinder
#   Adding tests for cinder services
#

define rjil::test::http_check(
  $port,
  $address = '127.0.0.1',
  $ssl     = false,
) {

  include rjil::test::base

  file { "/usr/lib/jiocloud/tests/${name}.sh":
    content => template('rjil/tests/http_check.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
