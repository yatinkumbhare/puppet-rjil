#
# Base class that sets up tests
#
class rjil::test::base {

  File {
    owner => 'root',
    group => 'root',
  }

  package { 'nagios-plugins':
    ensure => present,
  }

  file { '/usr/lib/jiocloud':
    ensure => directory,
  }

  file { '/usr/lib/jiocloud/tests':
    ensure => directory,
  }

}
