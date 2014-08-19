class rjil::jiocloud {
  file { '/usr/local/bin/jiocloud-update.sh':
    source => 'puppet:///modules/rjil/update.sh',
    mode => '0755',
    owner => 'root',
    group => 'root'
  }

  package { 'python-jiocloud': }

  file { '/usr/local/bin/poll-upgrade.sh':
    ensure => absent
  }

  file { '/etc/init/poll-upgrade.conf':
    ensure => absent
  }

  service { 'poll-upgrade':
    ensure   => 'stopped',
    enable   => false,
    provider => 'upstart',
  }

  file { '/usr/local/bin/maybe-upgrade.sh':
    source => 'puppet:///modules/rjil/maybe-upgrade.sh',
    mode => '0755',
    owner => 'root',
    group => 'root'
  }
  cron { 'maybe-upgrade':
    command => '/usr/local/bin/maybe-upgrade.sh',
	user => 'root',
  }
}
