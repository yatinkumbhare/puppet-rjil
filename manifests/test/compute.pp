class rjil::test::compute {

  $scripts = ['nova-compute.sh']

  rjil::test { $scripts: }

  file { "/usr/lib/jiocloud/tests/cinder-secret.sh":
    content => template('rjil/tests/cinder-secret.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
  }
}
