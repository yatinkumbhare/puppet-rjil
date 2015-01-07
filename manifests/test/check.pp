#
# Class: rjil::test::cinder
#   Adding tests for cinder services
#

define rjil::test::check(
  $port,
  $address = '127.0.0.1',
  $ssl     = false,
  $type    = 'http',
) {

  include rjil::test::base

  file { "/usr/lib/jiocloud/tests/${name}.sh":
    content => template("rjil/tests/${type}_check.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
