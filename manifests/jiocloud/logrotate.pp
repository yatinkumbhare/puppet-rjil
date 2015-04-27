class rjil::jiocloud::logrotate {
  include logrotate
  package { logrotate:
    ensure => installed
  }
  file { '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/rjil/logrotate-default.conf';
  }
}
